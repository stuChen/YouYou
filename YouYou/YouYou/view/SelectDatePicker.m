//
//  SelectDatePicker.m
//  YouYou
//
//  Created by Chen on 15/7/4.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "SelectDatePicker.h"

@implementation SelectDatePicker


- (void)showStatus
{
    [self btnStatus:self.sureBtn];
    [self btnStatus:self.cancleBtn];
    [self.datePiker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)dateChange:(UIDatePicker *)piker
{
    DLog(@"%@",piker);
}
- (IBAction)sureBtnClick:(id)sender {
    self.dateBLock(self.datePiker.date);
    [self removeFromSuperview];
}
- (IBAction)cancleBtnClick:(id)sender {
    [self removeFromSuperview];
}

- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
- (void)dealloc
{
    DLog(@"");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
