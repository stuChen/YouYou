//
//  DailyWorkViewController.m
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "DailyWorkViewController.h"
#import "NSDate+FSExtension.h"
#import "DailyDetailViewController.h"

@interface DailyWorkViewController ()
{
    NSArray *_dataArray;
    NSMutableArray *_dateArray;
    NSDateFormatter *formatter;
}
@end

@implementation DailyWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.isPlan ? [self setTitle:@"工作周报"] : [self setTitle:@"工作日报"];
    [self initBack];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    NSDate *date = [NSDate date];
    calendar.selectedDate = [NSDate fs_dateWithYear:date.fs_year month:date.fs_month day:date.fs_day];
    [self.view addSubview:calendar];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.eventColor = [UIColor redColor];
    calendar.flow = FSCalendarFlowHorizontal;

    self.calendar = calendar;
    
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    _dateArray = [[NSMutableArray alloc]init];
    
    [self initData];
    //刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"refreshWorkLog" object:nil];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
//    DLog(@"did select date %@",[date fs_stringWithFormat:@"yyyy/MM/dd"]);
    DailyDetailViewController *vc = [[DailyDetailViewController alloc]init];
    vc.today                      = [formatter stringFromDate:date];
    vc.isPlan                     = self.isPlan;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar
{
//    DLog(@"did change to month %@",[calendar.currentMonth fs_stringWithFormat:@"MMMM yyyy"]);
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    if (_dateArray) {
        __block BOOL isToday = NO;
        [_dateArray enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL *stop) {
            if (date.fs_month == obj.fs_month && date.fs_day == obj.fs_day && date.fs_year == obj.fs_year) {
                
                isToday = YES;
                *stop = YES;
            }
        }];
        return isToday;
    }

    return NO;//date.fs_month == 6 && date.fs_day == 2;
}
- (UIColor *)calendar:(FSCalendar *)calendar hasEventColorForDate:(NSDate *)date
{
    
    if (_dateArray) {
        __block NSInteger index = 100000;
        [_dateArray enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL *stop) {
            if (date.fs_month == obj.fs_month && date.fs_day == obj.fs_day && date.fs_year == obj.fs_year) {
                
                index = idx;
                *stop = YES;
            }
        }];
        if (index != 100000) {
//            NSString *string = [NSString stringWithFormat:@"%@",_dataArray[index][@"PlanAudit"]];
////            return [string intValue] == 1 ? [UIColor greenColor] : [UIColor redColor];
//            if ([string isEqualToString:@"1"]) {
//                return [UIColor greenColor];
//            }
        }
    }
    
    return [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"begin_date":@"",
                          @"end_date":@""};
    NSString *url;
    self.isPlan ? (url = [RequestUrl WorkPlanStatusquery]) : (url = [RequestUrl WorkLogStatusquery]);
    [RequestManager PostUrl:url loding:@"Loading..." dic:dic response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                _dataArray = response[@"body"];
                [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                [self getDate];
                [self.calendar reloadData];
            }
            else {
                [SVProgressHUD showErrorWithStatus:response[@"tip_msg"]];
            }
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络请求失败!"];
        }
        
    }];
    

}
- (void)getDate
{
    for (NSDictionary *dic in _dataArray) {
        NSString *sting = self.isPlan ? dic[@"plan_date"] : dic[@"log_date"];
        NSDate *date = [formatter dateFromString:sting];
//        DLog(@"%@",date);
        [_dateArray addObject:date];
    }
}

- (void)dealloc
{
    DLog(@"");
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
