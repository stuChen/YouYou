//
//  ReadWorkPlanDetailViewController.m
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ReadWorkPlanDetailViewController.h"
#import "ReplyWorkPlanViewController.h"

@interface ReadWorkPlanDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ReadWorkPlanDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:self.userInfo[@"user_name"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"reloadReadWorkData" object:nil];
    
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
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDeque = @"workPlanRead";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDeque];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellDeque];
    }
    
    NSString *dateStr;
    if (_isLog) {
        dateStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"log_date"]];
    }
    else {
        dateStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"plan_date"]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
    
    cell.textLabel.text = [dateFormatter stringFromDate:date];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = MAINCOLOR;
    cell.textLabel.minimumScaleFactor = 0.2;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    NSString *string;
    if (_isLog) {
        string  = [self ChooseInfo:_dataArray[indexPath.row] key:@"LogType" array:[Data Share].LogTypeArray];
    }
    else {
        string = [self ChooseInfo:_dataArray[indexPath.row] key:@"PlayType" array:[Data Share].PlayTypeArray];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",string,_dataArray[indexPath.row][@"cust_name"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //

    ReplyWorkPlanViewController *vc = [[ReplyWorkPlanViewController alloc]init];
    vc.cus_Info                     = _dataArray[indexPath.row];
    vc.showtypeIn = _isLog ? ShowTypeLog : ShowTypePlan;
        [self.navigationController pushViewController:vc animated:YES];
}
- (void)initData
{
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"need_audit":@"0",
                          @"page_size":@"999999",
                          @"page_no":@"",
                          @"user_id":self.userInfo[@"user_id"],
                          @"end_date":@"",
                          @"begin_date":@""};
    
    NSString *url = _isLog ? [RequestUrl WorkLogToAuditquery] : [RequestUrl WorkPlanToAuditquery];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
