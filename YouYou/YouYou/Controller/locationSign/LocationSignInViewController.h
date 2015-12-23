//
//  LocationSignInViewController.h
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface LocationSignInViewController : BaseViewController<BMKLocationServiceDelegate>
{
    BMKLocationService *_locationService;
}

@property (assign) BOOL signIn;

@end
