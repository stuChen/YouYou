//
//  DailyDetailViewController.m
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "DailyDetailViewController.h"
#import "DailyTableViewCell.h"
#import "DailyLogDetailViewController.h"
#import "NewWorkViewController.h"

@interface DailyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
    NSDate *nowDate;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation DailyDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    self.isPlan ? [self setTitle:@"周报列表"] : [self setTitle:@"日报列表"];
    if (self.isPlan) {
        [self.sureBtn setTitle:@"新建计划工作项目" forState:UIControlStateNormal];
    }
    self.table.tableHeaderView = nil;
    self.table.tableFooterView = nil;
    self.table.contentInset    = UIEdgeInsetsMake(-34, 0, 0, 0);
    self.table.backgroundColor = [UIColor clearColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date                   = [dateFormatter dateFromString:self.today];
    nowDate                        = date;
    if (fabs([date timeIntervalSinceDate:[NSDate date]]) <= 10*3600*24) {
        
        [self btnStatus:_sureBtn];
    }
    else {
        self.sureBtn.hidden = YES;
    }
    [self initData];
    
    //刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"refreshWorkLog" object:nil];
}

- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (IBAction)sureBtnClick:(id)sender {
    NewWorkViewController *vc = [[NewWorkViewController alloc]init];
    vc.isPlan                 = self.isPlan;
    vc.date                   = nowDate;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray ? _dataArray.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idefier = @"dailyTable";
    DailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idefier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DailyTableViewCell" owner:nil options:nil].firstObject;
    }
    [cell initData:_dataArray[indexPath.row] type:self.isPlan];
    return cell;
}




- (void)initData
{
    NSDictionary *dic;
    if (!self.isPlan) {
        dic = @{@"username":[Data Share].username,
                @"token":[Data Share].token,
                @"log_date":self.today};
    }
    else {
        dic = @{@"username":[Data Share].username,
                @"token":[Data Share].token,
                @"plan_date":self.today};
    }
    NSString *url;
    self.isPlan ? (url = [RequestUrl WorkPlanquery]) : (url = [RequestUrl WorkLogquery]);
    [RequestManager PostUrl:url loding:@"Loading..." dic:dic response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                _dataArray = response[@"body"];
                [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                [self.table reloadData];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DailyLogDetailViewController *vc = [[DailyLogDetailViewController alloc]init];
    vc.isPlan = self.isPlan;
    vc.data = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
