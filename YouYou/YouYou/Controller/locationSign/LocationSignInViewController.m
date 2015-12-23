//
//  LocationSignInViewController.m
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "LocationSignInViewController.h"

@interface LocationSignInViewController () <BMKGeoCodeSearchDelegate,ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *_selectArrray;
    CLLocationCoordinate2D currentLocation;
    BMKGeoCodeSearch *search;
}
@property (weak, nonatomic) IBOutlet UIButton *Select;
@property (strong) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *Location;
@property (weak, nonatomic) IBOutlet UIButton *Sure;
@property (weak, nonatomic) IBOutlet UITextField *LocationText;

@end

@implementation LocationSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.signIn ? [self setTitle:@"位置签到"] : [self setTitle:@"位置签退"];
    [self initBackBtn];
    
    UIImage *image2 = [UIImage imageNamed:@"select_a_bg.9"];
    image2 = [image2 stretchableImageWithLeftCapWidth:floorf(image2.size.width/2) topCapHeight:floorf(image2.size.height/2)];
    [_Select setBackgroundImage:image2 forState:UIControlStateNormal];
    
    
    
    [self btnStatus:_Location];
    [self btnStatus:_Sure];
    
    
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    if (!_locationService) {
        //初始化BMKLocationService
        
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    [_locationService startUserLocationService];
    
    [self StartLocation:nil];
    
    
}
-(void)initBackBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"btn_back_on"];
    button.frame = CGRectMake(0, 0, 98 * 0.6, 47 * 0.6);
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}
- (void)goback
{
    _locationService.delegate = nil;
    _locationService = nil;
    search.delegate = nil;
    search = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (IBAction)ChooseCustom:(id)sender {
    if ([Data Share].CustomArray) {
        
        _selectArrray = [Data Share].CustomArray;
        NSInteger count = _selectArrray.count;
        if ((ScreenHeight - 80) / 44 < count) {
            count = (ScreenHeight - 80) / 44;
        }
        ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, count * 44 + 32)];
        listView.titleName.text = @"客户/门店";
        listView.datasource = self;
        listView.delegate = self;
        //    [listView setCancelButtonTitle:@"Cancel" block:^{
        //        DLog(@"cancel");
        //    }];
        //    [listView setDoneButtonWithTitle:@"OK" block:^{
        //        DLog(@"Ok%d", [listView indexPathForSelectedRow].row);
        //    }];
        [listView show];
    }
}
//定位
- (IBAction)StartLocation:(id)sender {
    if ([CLLocationManager locationServicesEnabled]) {
        [SVProgressHUD showWithStatus:@"定位中..."];
        [_locationService startUserLocationService];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请打开定位功能并重试！"];
    }

}


//
- (IBAction)SureClick:(id)sender {
    
    if (currentLocation.latitude > 0 && currentLocation.longitude > 0 && _LocationText.text.length > 0) {
        NSDictionary *dic = @{@"username":[Data Share].username,
                              @"token":[Data Share].token,
                              @"sign_type":self.signIn ? @"in" : @"out",
                              @"point_x":[NSString stringWithFormat:@"%f",currentLocation.longitude],
                              @"point_y":[NSString stringWithFormat:@"%f",currentLocation.latitude],
                              @"addr_info":_LocationText.text};
        
        [RequestManager PostUrl:[RequestUrl Sign] loding:@"Loading..." dic:dic response:^(id response) {
            if (response) {
                if ([response[@"status_code"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                    [self goback];
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
    else {
        [SVProgressHUD showErrorWithStatus:@"当前信息有误！请确认!"];
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
    [_locationService stopUserLocationService];
    search = [[BMKGeoCodeSearch alloc]init];
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = userLocation.location.coordinate;
    //
    currentLocation = userLocation.location.coordinate;
    //
    search.delegate = self;
    [search reverseGeoCode:option];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locationService stopUserLocationService];
    [SVProgressHUD showErrorWithStatus:@"定位失败..请重试！"];
    _LocationText.text = @"地理位置获取失败，请重试！";
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error==0) {
        _LocationText.text = result.address;
        [SVProgressHUD showSuccessWithStatus:@"定位成功！"];
    }
    else
    {
        _LocationText.text = @"地理位置获取失败，请重试！";
        [SVProgressHUD showErrorWithStatus:@"地理位置获取失败，请重试！"];
    }
    
    searcher.delegate = nil;
    searcher = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[GetLocation share] stop];
    search.delegate = nil;
    search = nil;
}

- (void)dealloc
{
    search.delegate = nil;
    search = nil;
    DLog(@"");
}
#pragma mark -
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectArrray ? _selectArrray.count : 0;
    
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _selectArrray[indexPath.row][@"cust_name"];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
//    DLog(@"deselect:%ld", (long)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    [self.Select setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row][@"cust_name"]] forState:UIControlStateNormal];
    self.LocationText.text = [NSString stringWithFormat:@"%@",_selectArrray[indexPath.row][@"cust_addr"]];
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
