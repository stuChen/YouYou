//
//  RichStyleLabel.m
//  RichStyleLabel
//
//  Created by liaojinxing on 14-6-1.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import "RichStyleLabel.h"

@implementation RichStyleLabel

#pragma mark - Link

- (void)setLinkAttributedText:(NSString *)text
{
  [self setLinkAttributedText:text linkAttributes:nil];
}

- (void)setLinkAttributedText:(NSString *)text linkAttributes:(NSDictionary *)attributesDict
{
  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                             error:nil];
  [self setAttributedText:text withRegularExpression:detector attributes:attributesDict];
}

#pragma mark - Regualr Expression

- (void)setAttributedText:(NSString *)text
       withRegularPattern:(NSString *)pattern
               attributes:(NSDictionary *)attributesDict
{
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                         options:0
                                                                           error:nil];
  [self setAttributedText:text withRegularExpression:regex attributes:attributesDict];
}

- (void)setAttributedText:(NSString *)text
    withRegularExpression:(NSRegularExpression *)expression
               attributes:(NSDictionary *)attributesDict
{
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

  [expression enumerateMatchesInString:text
                               options:0
                                 range:NSMakeRange(0, [text length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
     NSRange matchRange = [result range];
     if (attributesDict) {
       [attributedString addAttributes:attributesDict range:matchRange];
     }

     if ([result resultType] == NSTextCheckingTypeLink) {
       NSURL *url = [result URL];
       [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
     }
   }];
  [self setAttributedText:attributedString];
}

- (void)setAttributedText:(NSString *)text withPatternAttributeDictionary:(NSDictionary *)dictionary
{
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

  [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
     if ([obj isKindOfClass:[NSDictionary class]]) {
       NSRegularExpression *expression;
       NSDictionary *attributesDict = (NSDictionary *)obj;

       if ([key isKindOfClass:[NSRegularExpression class]]) {
         expression = (NSRegularExpression *)key;
       } else if ([key isKindOfClass:[NSString class]]) {
         expression = [NSRegularExpression regularExpressionWithPattern:key
                                                                options:0
                                                                  error:nil];
       }

       [expression enumerateMatchesInString:text
                                    options:0
                                      range:NSMakeRange(0, [text length])
                                 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
          NSRange matchRange = [result range];
          if (attributesDict) {
            [attributedString addAttributes:attributesDict range:matchRange];
          }
        }];
     }
   }];
  [self setAttributedText:attributedString];
}
// 点击该label的时候, 来个高亮显示
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:[UIColor whiteColor]];
}
// 还原label颜色,获取手指离开屏幕时的坐标点, 在label范围内的话就可以触发自定义的操作
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:[UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:1]];
//    UITouch *touch = [touches anyObject];
//    CGPoint points = [touch locationInView:self];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.text]];
    
//    if (points.x >= self.frame.origin.x && points.y >= self.frame.origin.x && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.text]];
//    }
}

@end
