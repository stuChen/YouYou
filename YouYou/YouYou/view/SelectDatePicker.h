//
//  SelectDatePicker.h
//  YouYou
//
//  Created by Chen on 15/7/4.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectDatePicker : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *datePiker;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;


- (void)showStatus;

@property (copy) void (^ dateBLock)(NSDate *date);

@end
