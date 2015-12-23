//
//  GetLocation.m
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "GetLocation.h"

@implementation GetLocation

+ (GetLocation *)share
{
    static GetLocation *showView = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        
        showView = [[GetLocation alloc]init];
    });
    return showView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        

    }
    return self;
}

- (void)start
{
    if (!_locationService) {
        //初始化BMKLocationService
        
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    [_locationService startUserLocationService];
}
- (void)stop
{
    [_locationService stopUserLocationService];
    _locationService.delegate = nil;
    _locationService = nil;
}
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
    _locationBlock(userLocation);
    [_locationService stopUserLocationService];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    _locationBlock(nil);
    [_locationService stopUserLocationService];
}


@end
