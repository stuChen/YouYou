//
//  AppDelegate.m
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "MianViewController.h"
#import "IQKeyboardManager.h"
#import "LoginViewController.h"
#import "SFHFKeychainUtils.h"
#define SERVICE_NAME @"com.bode.YouYou"
//后台上传
#import "LocationTracker.h"
#import "NSDate+FSExtension.h"
#import "MobClick.h"
#import "APService.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

@interface AppDelegate ()
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    // 设置用户反馈界面激活方式为摇一摇
    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeShake];
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"6735f0996cb2b76c3c9c037726aaff40"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"6735f0996cb2b76c3c9c037726aaff40"];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    [_mapManager start:@"FrGbEVt2dB0GVULh72Lp0vkF" generalDelegate:nil];

//      [self changeRootViewController];
    LoginViewController *vc = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    NSString *passWord =  [SFHFKeychainUtils getPasswordForUsername:@"dd" andServiceName:SERVICE_NAME error:nil];
//    [SFHFKeychainUtils storeUsername:@"dd" andPassword:@"aa" forServiceName:SERVICE_NAME updateExisting:1 error:nil];
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        [MobClick startWithAppkey:@"55f05409e0f55a70a20051d8" reportPolicy:BATCH   channelId:@"Web"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        [MobClick setLogEnabled:YES];
        [MobClick setCrashReportEnabled:YES];
        [MobClick setBackgroundTaskEnabled:YES];
    });

//    NSLog(@"后台任务%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundtask"]);
    
    //接受开启定位服务通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initTrack) name:@"startInitlocationTracker" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpLocationTraker) name:@"startUplocationTracker" object:nil];
    //接收定位服务关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTracker) name:@"stopUplocationTracker" object:nil];
    
    //极光
    // Override point for customization after application launch.
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];

    
    return YES;
}



- (void)changeRootViewController
{
    MianViewController *vc = [[MianViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
}



#pragma mark - 
//
- (void)initTrack {
    if (!self.locationTracker) {
        self.locationTracker = [[LocationTracker alloc]init];
    }
    
    [self.locationTracker startLocationTracking];
}
-(void)setUpLocationTraker{
    
    if (self.locationTracker.shareModel.myLocationArray.count > 0 && [UserData keyForUser:@"token"]) {
        [self updateLocation];
    }
//    [self performSelector:@selector(updateLocation) withObject:nil afterDelay:2];
}
//第一次请求完成
- (void)startTimer:(NSDictionary *)dic {
    
    if (self.locationUpdateTimer) {
        [self.locationUpdateTimer invalidate];
        self.locationUpdateTimer = nil;
    }
        _responseTimerInfo = dic;
        //设定向服务器发送位置信息的时间间隔
        NSTimeInterval time = 20 * 60;
        if (dic) {
            if (dic[@"sep_min"]) {
                time = [dic[@"sep_min"] integerValue] * 60;
            }
            
        }
        //开启计时器
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.locationUpdateTimer forMode:NSDefaultRunLoopMode];
}


- (void)stopTracker {
    
    [self.locationUpdateTimer invalidate];
    self.locationUpdateTimer = nil;
    [self.locationTracker stopLocationTracking];
}
-(void)updateLocation {
    
    NSInteger startTime = 0;
    NSInteger stopTime = 24;
    NSDate *date = [NSDate date];
    if (_responseTimerInfo) {
        
        startTime = [_responseTimerInfo[@"begin_hour"] integerValue];
        stopTime  = [_responseTimerInfo[@"end_hour"] integerValue];
        //起始时间为整数
        if ([[NSString stringWithFormat:@"%@",_responseTimerInfo[@"begin_hour"]] length] <= 2) {
            //结束时间为整数
            if ([[NSString stringWithFormat:@"%@",_responseTimerInfo[@"end_hour"]] length] <= 2) {
                
                if (date.fs_hour >= startTime && date.fs_hour < stopTime) {
                    NSLog(@"开始获取定位信息...");
                    //向服务器发送位置信息
                    [self.locationTracker updateLocationToServer];
                }
            }
            else {
                //结束时间不为整数
                
                if (date.fs_hour >= startTime && date.fs_hour <= stopTime) {
                    NSLog(@"开始获取定位信息...");
                    if (date.fs_hour == stopTime) {
                        if (date.fs_minute <= 30) {
                            [self.locationTracker updateLocationToServer];
                        }
                    }
                    else {
                        NSLog(@"开始获取定位信息...");
                        //向服务器发送位置信息
                        [self.locationTracker updateLocationToServer];
                    }
                }
            }
        }
        else {
            //结束时间为整数
            if ([[NSString stringWithFormat:@"%@",_responseTimerInfo[@"end_hour"]] length] <= 2) {
                
                if (date.fs_hour >= startTime && date.fs_hour < stopTime) {
                    NSLog(@"开始获取定位信息...");
                    if (date.fs_hour == startTime) {
                        if (date.fs_minute >= 30) {
                            //向服务器发送位置信息
                            [self.locationTracker updateLocationToServer];
                        }
                    }
                    else {
                        //向服务器发送位置信息
                        [self.locationTracker updateLocationToServer];
                    }
                }
            }
            else {
                //结束时间不为整数
                
                if (date.fs_hour >= startTime && date.fs_hour <= stopTime) {
                    NSLog(@"开始获取定位信息...");
                    if (date.fs_hour == startTime) {
                        if (date.fs_minute >= 30) {
                            //向服务器发送位置信息
                            [self.locationTracker updateLocationToServer];
                        }
                    }
                    else if (date.fs_hour == stopTime) {
                        if (date.fs_minute <= 30) {
                            //向服务器发送位置信息
                            [self.locationTracker updateLocationToServer];
                        }
                    }
                    else {
                        //向服务器发送位置信息
                        [self.locationTracker updateLocationToServer];
                    }
                }
            }
        }
    }
    else {
        if (date.fs_hour >= startTime && date.fs_hour < stopTime) {
            NSLog(@"开始获取定位信息...");
            //向服务器发送位置信息
            [self.locationTracker updateLocationToServer];
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    if (pushToken.length > 16) {
        pushToken = [pushToken substringToIndex:16];
    }
    if (![UserData keyForUser:@"pushToken"]) {
        [UserData Value:pushToken forKey:@"pushToken"];
    }
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

@end
