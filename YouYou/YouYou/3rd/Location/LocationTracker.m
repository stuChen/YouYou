//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "AppDelegate.h"

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            _locationManager.pausesLocationUpdatesAutomatically = NO; //该模式是抵抗ios在后台杀死程序设置，iOS会根据当前手机使用状况会自动关闭某些应用程序的后台刷新，该语句申明不能够被暂停，但是不一定,iOS系统在性能不佳的情况下强制结束应用刷新
            //??这样的顺序，将导致bug：第一次启动程序后，系统将只请求?的权限，?的权限系统不会请求，只会在下一次启动应用时请求?
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
                //[_locationManager requestWhenInUseAuthorization];//?只在前台开启定位
                [_locationManager requestAlwaysAuthorization];//?在后台也可定位
            }
            // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
                _locationManager.allowsBackgroundLocationUpdates = YES; 
            }
		}
	}
	return _locationManager;
}

- (id)init {
	if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	return self;
}

-(void)applicationEnterBackground{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void) restartLocationUpdates
{
    NSLog(@"restartLocationUpdates");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}


- (void)startLocationTracking {
    NSLog(@"startLocationTracking");

	if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[servicesDisabledAlert show];
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            
            if(IS_OS_8_OR_LATER) {
              [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
	}
}


- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
	CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
	[locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations");
    
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 30.0)
        {
            continue;
        }
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy= theAccuracy;
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            [self.shareModel.myLocationArray addObject:dict];
            
            
            //开始更新
            static dispatch_once_t disOnce;
            dispatch_once(&disOnce,  ^ {
                // 该干嘛就干嘛
                //开启定时上传坐标
                [[NSNotificationCenter defaultCenter] postNotificationName:@"startUplocationTracker" object:nil];
            });
        }
    }
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                    userInfo:nil
                                                     repeats:NO];

}


//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
    NSLog(@"locationManager stop Updating after 10 seconds");
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
   // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


//Send the location to Server
- (void)updateLocationToServer {
    
    NSLog(@"updateLocationToServer");
    
    // Find the best location from the array based on accuracy
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    
    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
        NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
    NSLog(@"My Best location:%@",myBestLocation);
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.shareModel.myLocationArray.count==0)
    {
        NSLog(@"Unable to get location, use the last known location");

        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
        
    }else{
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
    }
    
    NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
    
    //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
    
    //开始上传
    [self getAddressInfo];

    //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
}
- (void)getAddressInfo {
    //转换为百度坐标
    NSDictionary *dict = BMKConvertBaiduCoorFrom(self.myLocation, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D cll = BMKCoorDictionaryDecode(dict);
    
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = cll;
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc]init];
        _geoCode.delegate = self;
    }
    // 调用反地址编码方法，让其在代理方法中输出
    [_geoCode reverseGeoCode:option];
}
#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@ - %@", result.address, result.addressDetail.streetNumber);
    [self postAddress:result.address];
}

#pragma mark 代理方法返回地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@", result.address);
    [self postAddress:result.address];
}
- (void)postAddress:(NSString *)address {
    
    //转换为百度坐标
    NSDictionary *dict = BMKConvertBaiduCoorFrom(self.myLocation, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D cll = BMKCoorDictionaryDecode(dict);
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }

    
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"collec_date":[_dateFormatter stringFromDate:[NSDate date]],
                          @"lot":[NSString stringWithFormat:@"%f",cll.longitude],
                          @"lat":[NSString stringWithFormat:@"%f",cll.latitude],
                          @"addr_info":address};
    
    [RequestManager PostUrl:[RequestUrl SendLoc] loding:nil dic:dic response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
//                [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                if (response[@"begin_hour"]) {
                    [[NSUserDefaults standardUserDefaults] setInteger:[response[@"begin_hour"] integerValue] forKey:@"begin_hour"];
                }
                if (response[@"end_hour"]) {
                    [[NSUserDefaults standardUserDefaults] setInteger:[response[@"end_hour"] integerValue] forKey:@"end_hour"];
                }
                if (response[@"sep_min"]) {
                    [[NSUserDefaults standardUserDefaults] setInteger:[response[@"sep_min"] integerValue] forKey:@"sep_min"];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"定时上报位置成功！");
                
            }
            else {
//                [SVProgressHUD showErrorWithStatus:response[@"tip_msg"]];
            }
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络请求失败!"];
        }
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app startTimer:response];
    }];
}



@end
