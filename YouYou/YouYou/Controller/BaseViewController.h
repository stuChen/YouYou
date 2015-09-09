//
//  BaseViewController.h
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(void)setTitle:(NSString *)title;
-(void)initBack;
- (void)btnStatus:(UIButton *)btn;
- (void)status:(UIButton *)btn;
@end
