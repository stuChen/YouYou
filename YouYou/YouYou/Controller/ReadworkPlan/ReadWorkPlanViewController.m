//
//  ReadWorkPlanViewController.m
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ReadWorkPlanViewController.h"
#import "ReadWorkPlanDetailViewController.h"
#import "ReplyLeaveViewController.h"

@interface ReadWorkPlanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ReadWorkPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    if (_showType == ReadTypeLeave) {
        [self setTitle:@"请假单批阅"];
    }
    else if(_showType == ReadTypeWorkLog) {
        [self setTitle:@"日报批阅"];
    }
    else {
        [self setTitle:@"周报批阅"];
    }
    [self initData];
}
- (IBAction)Select:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self initData];
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
    return 38;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDeque = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellDeque];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellDeque];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"user_name"]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.minimumScaleFactor = 0.2;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_showType == ReadTypeWorkLog) {
        ReadWorkPlanDetailViewController *vc = [[ReadWorkPlanDetailViewController alloc]init];
        vc.userInfo                          = _dataArray[indexPath.row];
        vc.isLog = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_showType == ReadTypeWorkPlan) {
        ReadWorkPlanDetailViewController *vc = [[ReadWorkPlanDetailViewController alloc]init];
        vc.userInfo                          = _dataArray[indexPath.row];
        vc.isLog = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_showType == ReadTypeLeave) {
        ReplyLeaveViewController *vc = [[ReplyLeaveViewController alloc]init];
        vc.info                          = _dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)initData
{
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"need_audit":_selectBtn.selected ? @"0" : @"1",
                          @"directsub":@"0",
                          @"page_size":@"999999",
                          @"page_no":@""};
    NSString *url;
    if (_showType == ReadTypeWorkLog) {
        url = [RequestUrl queryLogEmployee];
    }
    else if (_showType == ReadTypeWorkPlan) {
        url = [RequestUrl queryEmployee];
    }
    else if (_showType == ReadTypeLeave)
    {
        url = [RequestUrl queryDayOffEmployee];
    }
    [RequestManager PostUrl:url loding:@"正在加载下级员工信息" dic:dic response:^(id response) {
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
