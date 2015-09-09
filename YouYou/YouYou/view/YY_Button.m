//
//  YY_Button.m
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "YY_Button.h"

@implementation YY_Button

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self status:image title:title];
    }
    return self;
}
- (void)status:(NSString *)image title:(NSString *)title
{
    
    self.backgroundColor = BACK_COLOR;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
    imageView.image = [UIImage imageNamed:image];
    imageView.center = CGPointMake(width / 2, height * 0.4);
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10 * height / 200, width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    [self setBackgroundImage:[self imageWithColor:MAINCOLOR] forState:UIControlStateHighlighted];
    //    [self setBackgroundImage:[self imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
    [self setBackgroundImage:[self imageWithColor:BACK_COLOR] forState:UIControlStateNormal];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
