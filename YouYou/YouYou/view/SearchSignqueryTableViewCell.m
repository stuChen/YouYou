//
//  SearchSignqueryTableViewCell.m
//  YouYou
//
//  Created by Chen on 15/7/4.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "SearchSignqueryTableViewCell.h"

@implementation SearchSignqueryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initData:(NSDictionary *)data
{
    self.DateLabe.text = [NSString stringWithFormat:@"%@",data[@"sign_date"]];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dataFormatter dateFromString:data[@"sign_date"]];
    [dataFormatter setDateFormat:@"EEEE"];
    self.WeekDayLabel.text = [dataFormatter stringFromDate:date];
    
    __block NSString *DayType;
    [[Data Share].DayTypeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"key"] integerValue] == [data[@"DayType"] integerValue]) {
            DayType = [NSString stringWithFormat:@"%@",obj[@"value"]];
        }
    }];
    if (DayType) {
        self.dayTypeLabel.text = DayType;
    }
    
    self.signInLabel.text = [NSString stringWithFormat:@"%@",data[@"signin_addr"]];
    self.SignInTImeLabel.text = [NSString stringWithFormat:@"%@",data[@"signin_time"]];
    self.SignOutLabel.text = [NSString stringWithFormat:@"%@",data[@"signout_addr"]];
    self.SignOutTImeLabel.text = [NSString stringWithFormat:@"%@",data[@"signout_time"]];
    
    __block NSString *AttType;
    if (![data[@"AttType"] isKindOfClass:[NSNull class]]) {
        [[Data Share].AttTypeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"key"] integerValue] == [data[@"AttType"] integerValue]) {
                AttType = [NSString stringWithFormat:@"%@",obj[@"value"]];
                *stop = YES;
            }
        }];
    }
    if (!AttType) {
        AttType = @"未知";
    }
    __block NSString *AttTypeIn;
    if (![data[@"AttTypeIn"] isKindOfClass:[NSNull class]]) {
        [[Data Share].AttTypeInArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"key"] integerValue] == [data[@"AttTypeIn"] integerValue]) {
                AttTypeIn = [NSString stringWithFormat:@"%@",obj[@"value"]];
                *stop = YES;
            }
        }];
    }

    if (!AttTypeIn) {
        AttTypeIn = @"未知";
    }
    
    __block NSString *AttTypeOut;
    if (![data[@"AttTypeOut"] isKindOfClass:[NSNull class]]) {
        [[Data Share].AttTypeOutArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"key"] integerValue] == [data[@"AttTypeOut"] integerValue]) {
                AttTypeOut = [NSString stringWithFormat:@"%@",obj[@"value"]];
                *stop = YES;
            }
        }];
    }

    if (!AttTypeOut) {
        AttTypeOut = @"未知";
    }
    self.StatusLabel.text = [NSString stringWithFormat:@"%@/%@/%@",AttType,AttTypeIn,AttTypeOut];
    
    
//    self.StatusLabel.text = [NSString stringWithFormat:@"%@",data[@"AttType"]];

}

@end
