//
//  PhotoPickerViewController.h
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoPickerViewController : BaseViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (assign) BOOL isChoosePic;

@property (strong) NSString *picType;
@property (strong) NSDictionary *info;

@end
