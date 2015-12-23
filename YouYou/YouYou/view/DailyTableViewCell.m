//
//  DailyTableViewCell.m
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "DailyTableViewCell.h"

@implementation DailyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}
- (void)initData:(NSDictionary *)dic type:(BOOL)isPlan
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if (!isPlan) {
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dic[@"log_date"]]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        if (!dateStr) {
            dateStr = @"未知日期";
        }
        self.DateLabel.text = dateStr;

        NSString *logType = [self ChooseInfo:dic key:@"LogType" array:[Data Share].LogTypeArray];
        NSString *custom = [NSString stringWithFormat:@"%@",dic[@"cust_name"]];
        if (custom.length == 0) {
            custom = @"未知";
        }
        self.TypeLabel.text = [NSString stringWithFormat:@"%@    %@",logType,custom];
        
        
        //完成时间
        NSString *planFinishTime  = [self ChooseInfo:dic key:@"LogFinishTime" array:[Data Share].LogFinishTimeArray];
        self.Plan.text = planFinishTime;
        
        //完成状态
        NSString *WorkStatus = [self ChooseInfo:dic key:@"WorkStatus" array:[Data Share].WorkStatusArray];
        NSString *CompleteStatus = [self ChooseInfo:dic key:@"CompleteStatus" array:[Data Share].CompleteStatusArray];

        self.Status.text = [NSString stringWithFormat:@"%@/%@",WorkStatus,CompleteStatus];
    }
    else {
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dic[@"plan_date"]]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        if (!dateStr) {
            dateStr = @"未知日期";
        }
        self.DateLabel.text = dateStr;
        
        NSString *logType = [self ChooseInfo:dic key:@"PlayType" array:[Data Share].PlayTypeArray];
        NSString *custom = [NSString stringWithFormat:@"%@",dic[@"cust_name"]];
        if (custom.length == 0) {
            custom = @"未知";
        }
        self.TypeLabel.text = [NSString stringWithFormat:@"%@    %@",logType,custom];
        
        
        //完成时间
        NSString *planFinishTime  = [self ChooseInfo:dic key:@"PlanFinishTime" array:[Data Share].PlanFinishTimeArray];
        self.Plan.text = planFinishTime;
        
        //完成状态
        NSString *WorkStatus = [self ChooseInfo:dic key:@"WorkStatus" array:[Data Share].WorkStatusArray];
        NSString *PlanAudit = [self ChooseInfo:dic key:@"PlanAudit" array:[Data Share].PlanAuditArray];
        NSString *CompleteStatus = [self ChooseInfo:dic key:@"CompleteStatus" array:[Data Share].CompleteStatusArray];
        
        self.Status.text = [NSString stringWithFormat:@"%@/%@/%@",WorkStatus,PlanAudit,CompleteStatus];
    }
}
- (NSString *)ChooseInfo:(NSDictionary *)dic key:(NSString *)key array:(NSArray *)array;
{
    NSString *CompleteStatus = [NSString stringWithFormat:@"%@",dic[key]];
    if (CompleteStatus.length == 0) {
        CompleteStatus = @"未知";
    }
    else {
        if (array) {
            
            BOOL isHave = NO;
            for (NSDictionary *dic in array) {
                if ([dic[@"key"] integerValue] == [CompleteStatus integerValue]) {
                    CompleteStatus = dic[@"value"];
                    isHave = YES;
                    break;
                }
            }
            if (!isHave) {
                CompleteStatus = @"未知";
            }
        }
        else {
            CompleteStatus = @"未知";
        }
    }
    return CompleteStatus;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
