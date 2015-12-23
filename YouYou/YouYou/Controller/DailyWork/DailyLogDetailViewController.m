//
//  DailyLogDetailViewController.m
//  YouYou
//
//  Created by Chen on 15/7/3.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "DailyLogDetailViewController.h"

@interface DailyLogDetailViewController ()

@end

@implementation DailyLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isPlan ? [self setTitle:@"计划详情"]: [self setTitle:@"日志详情"];
    [self initBack];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *WorkStatus = [self ChooseInfo:self.data key:@"WorkStatus" array:[Data Share].WorkStatusArray];
    NSString *CompleteStatus = [self ChooseInfo:self.data key:@"CompleteStatus" array:[Data Share].CompleteStatusArray];
    if (!self.isPlan) {
        
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.data[@"log_date"]]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        if (!dateStr) {
            dateStr = @"未知日期";
        }
        self.dateLabel.text = dateStr;
        self.typelabel.text = [self ChooseInfo:self.data key:@"LogType" array:[Data Share].LogTypeArray];
        self.cust_name.text = [NSString stringWithFormat:@"%@",self.data[@"cust_name"]];
        self.Content.text = [NSString stringWithFormat:@"%@",self.data[@"log_achieve"]];
        self.completeTime.text = [self ChooseInfo:self.data key:@"LogFinishTime" array:[Data Share].LogFinishTimeArray];
        self.ComStatus.text = [NSString stringWithFormat:@"%@/%@",WorkStatus,CompleteStatus];
    }
    else {
        
        
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.data[@"plan_date"]]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        if (!dateStr) {
            dateStr = @"未知日期";
        }
        self.typelabel.text = [self ChooseInfo:self.data key:@"PlayType" array:[Data Share].PlayTypeArray];
        self.dateLabel.text = dateStr;
        self.cust_name.text = [NSString stringWithFormat:@"%@",self.data[@"cust_name"]];
        self.Content.text = [NSString stringWithFormat:@"%@",self.data[@"plan_contant"]];
        self.completeTime.text = [self ChooseInfo:self.data key:@"PlanFinishTime" array:[Data Share].PlanFinishTimeArray];
        NSString *PlanAudit = [self ChooseInfo:self.data key:@"PlanAudit" array:[Data Share].PlanAuditArray];
        self.ComStatus.text = [NSString stringWithFormat:@"%@/%@/%@",WorkStatus,PlanAudit,CompleteStatus];
        
        self.dateType.text     = @"计划日期:";
        self.contentType.text  = @"计划类型:";
        self.workResult.text   = @"任务内容:";
        self.audit_remark.text = @"批阅意见:";
        self.audit_remarkDetail.text = [NSString stringWithFormat:@"%@",self.data[@"audit_remark"]];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
