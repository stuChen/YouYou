//
//  ReplyWorkPlanViewController.m
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ReplyWorkPlanViewController.h"

@interface ReplyWorkPlanViewController ()<ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *_selectArrray;
}
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *planType;
@property (weak, nonatomic) IBOutlet UILabel *cus_name;
@property (weak, nonatomic) IBOutlet UILabel *planTime;
@property (weak, nonatomic) IBOutlet UILabel *planContent;
@property (weak, nonatomic) IBOutlet UITextView *replyContent;

@property (weak, nonatomic) IBOutlet UIButton *planFinish;
@property (weak, nonatomic) IBOutlet UIButton *sure;

@property (strong) NSIndexPath *selectedIndexPath;

//显示

@property (weak, nonatomic) IBOutlet UILabel *planName;
@property (weak, nonatomic) IBOutlet UILabel *LeaveEnd;
@property (weak, nonatomic) IBOutlet UILabel *LeaveTime;
@property (weak, nonatomic) IBOutlet UILabel *LeaveDetail;
@property (weak, nonatomic) IBOutlet UILabel *ReplyStatus;

@end

@implementation ReplyWorkPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    if (_showtypeIn == ShowTypeLog) {
        [self setTitle:@"日报批阅"];
        
        //
        _LeaveDetail.text = @"工作成果:";
        
        self.username.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"user_name"]];
        self.planType.text = [[Data Share] ChooseInfo:self.cus_Info key:@"LogType" array:[Data Share].LogTypeArray];
        self.cus_name.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"cust_name"]];
        self.planTime.text = [[Data Share] ChooseInfo:self.cus_Info key:@"LogFinishTime" array:[Data Share].LogFinishTimeArray];
        self.planContent.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"log_achieve"]];
        
        NSArray *array =[Data Share].CompleteStatusArray;
        if (array) {
            _selectArrray = array;
        }
    }
    else if(_showtypeIn == ShowTypeLeave)
    {
        [self setTitle:@"请假单批阅"];
        self.planName.text    = @"请假开始:";
        self.LeaveEnd.text    = @"请假结束:";
        self.LeaveTime.text   = @"休假天数:";
        self.LeaveDetail.text = @"事由说明:";
        self.ReplyStatus.text = @"批阅状态:";
        
        
        self.username.text    = [NSString stringWithFormat:@"%@",self.cus_Info[@"user_name"]];
        self.planType.text    = [NSString stringWithFormat:@"%@",self.cus_Info[@"begin_date"]];
        self.cus_name.text    = [NSString stringWithFormat:@"%@",self.cus_Info[@"end_date"]];
        self.planTime.text    = [NSString stringWithFormat:@"%@",self.cus_Info[@"day_count"]];
        self.planContent.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"remark"]];
        
        
        NSArray *array =[Data Share].OffStatusArray;
        if (array) {
            _selectArrray = array;
        }
    }
    else {
        [self setTitle:@"周报工作项目批阅"];
        NSArray *array =[Data Share].CompleteStatusArray;
        if (array) {
            _selectArrray = array;
        }
        
        
        self.username.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"user_name"]];
        self.planType.text = [[Data Share] ChooseInfo:self.cus_Info key:@"PlayType" array:[Data Share].PlayTypeArray];
        self.cus_name.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"cust_name"]];
        self.planTime.text = [[Data Share] ChooseInfo:self.cus_Info key:@"PlanFinishTime" array:[Data Share].PlanFinishTimeArray];
        self.planContent.text = [NSString stringWithFormat:@"%@",self.cus_Info[@"plan_contant"]];
    }
    
    
    [self status:self.planFinish];
    [self btnStatus:self.sure];
    

}
- (IBAction)selectFinish:(id)sender {
    

    NSInteger count = _selectArrray.count;
    if ((ScreenHeight - 80) / 44 < count) {
        count = (ScreenHeight - 80) / 44;
    }
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, count * 44 + 32)];
    listView.titleName.text = @"";
    listView.datasource = self;
    listView.delegate = self;
    //    [listView setCancelButtonTitle:@"Cancel" block:^{
    //        DLog(@"cancel");
    //    }];
    //    [listView setDoneButtonWithTitle:@"OK" block:^{
    //        DLog(@"Ok%d", [listView indexPathForSelectedRow].row);
    //    }];
    [listView show];

}
- (IBAction)sure:(id)sender {
    
    if (_selectedIndexPath) {
        
        NSString *url;
        NSDictionary *dic;
        if (self.showtypeIn == ShowTypeLog) {
            url = [RequestUrl WorkLogSendAudit];
            dic = @{@"username":[Data Share].username,
                    @"token":[Data Share].token,
                    @"logaudit_remark":_replyContent.text,
                    @"log_id":self.cus_Info[@"log_id"],
                    @"log_finish":_selectArrray[_selectedIndexPath.row][@"key"]};
        }
        else if (self.showtypeIn == ShowTypeLeave) {
            url = [RequestUrl DayOffToAuditSend];
            dic = @{@"username":[Data Share].username,
                    @"token":[Data Share].token,
                    @"audit_remark":_replyContent.text,
                    @"day_off_id":self.cus_Info[@"day_off_id"],
                    @"off_status":_selectArrray[_selectedIndexPath.row][@"key"]};
        }
        else if (self.showtypeIn == ShowTypePlan) {
            url = [RequestUrl WorkPlanSendAudit];
            dic = @{@"username":[Data Share].username,
                    @"token":[Data Share].token,
                    @"audit_remark":_replyContent.text,
                    @"plan_id":self.cus_Info[@"plan_id"],
                    @"plan_finish":_selectArrray[_selectedIndexPath.row][@"key"]};
        }
        
        [RequestManager PostUrl:url loding:@"上传中..." dic:dic response:^(id response) {
            if (response) {
                if ([response[@"status_code"] integerValue] == 0) {
                    
                    [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadReadWorkData" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
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
    else {
        [SVProgressHUD showErrorWithStatus:@"请补充完信息！"];
    }
}
#pragma mark -
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectArrray ? _selectArrray.count : 0;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _selectArrray[indexPath.row][@"value"];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    DLog(@"deselect:%ld", (long)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    [self.planFinish setTitle:[NSString stringWithFormat:@"    %@",_selectArrray[indexPath.row][@"value"]] forState:UIControlStateNormal];
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
