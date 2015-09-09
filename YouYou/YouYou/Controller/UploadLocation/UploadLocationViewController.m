//
//  UploadLocationViewController.m
//  YouYou
//
//  Created by Chen on 15/7/5.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "UploadLocationViewController.h"

@interface UploadLocationViewController ()
{
    NSString *lat;
    NSString *lon;
}
@property (weak, nonatomic) IBOutlet UILabel *CustomName;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *LocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *UploadBtn;

@end

@implementation UploadLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"上传门店坐标"];
    [self initBack];
    [self btnStatus:self.LocationBtn];
    [self btnStatus:self.UploadBtn];
    
    if (_cus_Info) {
        self.CustomName.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"cust_name"]];
    }
    
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    if (!_locationService) {
        //初始化BMKLocationService
        
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    
    
    [self locationClick:nil];
}

- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}

- (IBAction)locationClick:(id)sender {
    [SVProgressHUD showWithStatus:@"定位中..."];
    [_locationService startUserLocationService];
    
}
- (IBAction)UploadClick:(id)sender {
    if (lat && lon) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        NSDate *date = [NSDate date];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        
        NSDictionary *dic = @{@"username":[Data Share].username,
                              @"token":[Data Share].token,
                              @"collec_date":dateStr,
                              @"lot":lon,
                              @"lat":lat,
                              @"cust_id":self.cus_Info[@"cust_id"],
                              @"cust_code":self.cus_Info[@"cust_code"],
                              @"cust_name":self.cus_Info[@"cust_name"]};
        
        [RequestManager PostUrl:[RequestUrl SendStoreLoc] loding:@"正在上传..." dic:dic response:^(id response) {
            if (response) {
                if ([response[@"status_code"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:response[@"tip_msg"]];
                }
                
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"网络请求失败!"];
            }
            
        }];

    }
}


#pragma mark - 定位信息
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [SVProgressHUD showSuccessWithStatus:@"定位成功!"];
    [_locationService stopUserLocationService];
    self.LocationLabel.text = [NSString stringWithFormat:@"位置: (%f,%f)",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
    lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locationService stopUserLocationService];
    [SVProgressHUD showErrorWithStatus:@"定位失败..请重试！"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
