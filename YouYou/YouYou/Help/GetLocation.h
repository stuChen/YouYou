//
//  GetLocation.h
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface GetLocation : NSObject<BMKLocationServiceDelegate>
{
    BMKLocationService *_locationService;
}
+ (GetLocation *)share;
- (void)start;
- (void)stop;
@property (copy) void(^ locationBlock)(BMKUserLocation *location);

@end
