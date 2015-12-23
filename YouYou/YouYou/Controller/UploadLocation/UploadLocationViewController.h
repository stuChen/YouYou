//
//  UploadLocationViewController.h
//  YouYou
//
//  Created by Chen on 15/7/5.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadLocationViewController : BaseViewController<BMKLocationServiceDelegate>
{
    BMKLocationService *_locationService;
}
@property (strong) NSDictionary *cus_Info;

@end
