//
//  DatePickerBtn.m
//  YouYou
//
//  Created by Chen on 15/7/13.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "DatePickerBtn.h"


@implementation DatePickerBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self statustitle:@""];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         [self statustitle:@""];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self statustitle:title];
    }
    return self;
}
- (void)statustitle:(NSString *)title
{
    

    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    UIImage *image2 = [UIImage imageNamed:@"input_bg"];
    image2 = [image2 stretchableImageWithLeftCapWidth:floorf(image2.size.width/2) topCapHeight:floorf(image2.size.height/2)];
    [self setBackgroundImage:image2 forState:UIControlStateNormal];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 33.5)];
    imageView.image = [UIImage imageNamed:@"datePic"];
    imageView.center = CGPointMake(ScreenWidth  - 34, height / 2);
    [self addSubview:imageView];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10 * height / 200, width, 20)];
//    label.text = title;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:label];
    
    [self setTitle:title forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(selected) forControlEvents:UIControlEventTouchUpInside];

}
- (void)selected
{

    
    if (_datePicker) {
        [_datePicker removeFromSuperview];
        _datePicker = nil;
    }
    _datePicker = [[NSBundle mainBundle] loadNibNamed:@"SelectDatePicker" owner:nil options:nil].firstObject;
    _datePicker.frame = [UIScreen mainScreen].bounds;
    [_datePicker showStatus];
    [self.superview addSubview:_datePicker];
    
    __weak DatePickerBtn *button = self;
    _datePicker.dateBLock = ^(NSDate *date)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        [button setTitle:[NSString stringWithFormat:@"  %@",[dateFormatter stringFromDate:date]] forState:UIControlStateNormal];
    };

    
}


@end
