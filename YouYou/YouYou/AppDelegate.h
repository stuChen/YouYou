//
//  AppDelegate.h
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_mapManager;
    //定位信息
    NSDictionary *_responseTimerInfo;
    
}

@property (strong, nonatomic) UIWindow *window;

- (void)changeRootViewController;

//开始定时上传坐标
- (void)startTimer:(NSDictionary *)dic;
@end

