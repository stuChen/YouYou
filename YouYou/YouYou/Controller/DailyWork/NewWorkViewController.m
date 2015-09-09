//
//  NewWorkViewController.m
//  YouYou
//
//  Created by Chen on 15/7/7.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NewWorkViewController.h"

@interface NewWorkViewController ()<ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *_selectArrray;
    NSDateFormatter *dateFormatter;
}
@property (weak, nonatomic) IBOutlet UITextField *NowDateText;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UIButton *Cus_btn;
@property (weak, nonatomic) IBOutlet UIButton *FinishBtn;
@property (weak, nonatomic) IBOutlet UIButton *UploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *status;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *contentType;
@property (weak, nonatomic) IBOutlet UILabel *plan_time;
@property (weak, nonatomic) IBOutlet UILabel *workContent;

@property (strong) NSIndexPath *selectedIndexPath1;
@property (strong) NSIndexPath *selectedIndexPath2;
@property (strong) NSIndexPath *selectedIndexPath3;
@property (strong) NSIndexPath *selectedIndexPath4;

@end

@implementation NewWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    self.isPlan ? [self setTitle:@"计划填报"] : [self setTitle:@"日志填报"];
    [self status:self.contentBtn];
    [self status:self.Cus_btn];
    [self status:self.FinishBtn];
    [self status:self.status];
    [self btnStatus:self.UploadBtn];
    //
    if (self.isPlan) {
        self.contentType.text = @"任务类型:";
        self.plan_time.text   = @"计划完成时间:";
        self.workContent.text = @"工作内容:";
    }
    //
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
    self.NowDateText.text = [dateFormatter stringFromDate:self.date];
}

- (IBAction)chooseType:(UIButton *)sender {
    if (sender.tag == 100) {
        
        NSArray *array = self.isPlan ? [Data Share].PlayTypeArray : [Data Share].LogTypeArray;
        if (array) {
            _selectArrray = array;
        }
    }
    else if (sender.tag == 101) {
        if ([Data Share].CustomArray) {
            
            _selectArrray = [Data Share].CustomArray;
        }
    }
    else if (sender.tag == 102) {
        NSArray *array = self.isPlan ? [Data Share].PlanFinishTimeArray : [Data Share].LogFinishTimeArray;
        if (array) {
            _selectArrray = array;
        }
    }
    else if (sender.tag == 103) {
        if ([Data Share].CompleteStatusArray) {
            
            _selectArrray = [Data Share].CompleteStatusArray;
        }
    }
    NSInteger count = _selectArrray.count;
    if ((ScreenHeight - 80) / 44 < count) {
        count = (ScreenHeight - 80) / 44;
    }
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, count * 44 + 32)];
    listView.titleName.text = @"";
    listView.datasource = self;
    listView.delegate = self;
    listView.tag = sender.tag;
    //    [listView setCancelButtonTitle:@"Cancel" block:^{
    //        DLog(@"cancel");
    //    }];
    //    [listView setDoneButtonWithTitle:@"OK" block:^{
    //        DLog(@"Ok%d", [listView indexPathForSelectedRow].row);
    //    }];
    [listView show];
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
    
    
//    if ( self.selectedIndexPath1 && NSOrderedSame == [self.selectedIndexPath1 compare:indexPath])
//    {
//        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
//    }
//    else
//    {
//        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
//    }
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (tableView.tag == 100 || tableView.tag == 102 || tableView.tag == 103) {
        cell.textLabel.text = _selectArrray[indexPath.row][@"value"];
    }
     else if (tableView.tag == 101) {
        cell.textLabel.text = _selectArrray[indexPath.row][@"cust_name"];
    }
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
//    DLog(@"deselect:%ld", (long)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:tableView.tag];
    if (tableView.tag == 100 || tableView.tag == 102 || tableView.tag == 103) {
            [btn setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row][@"value"]] forState:UIControlStateNormal];
    }
    else if (tableView.tag == 101) {
        [btn setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row][@"cust_name"]] forState:UIControlStateNormal];
        self.selectedIndexPath2 = indexPath;
    }
    
    if (tableView.tag == 100) {
        self.selectedIndexPath1 = indexPath;
    }
    else if (tableView.tag == 102) {
        self.selectedIndexPath3 = indexPath;
    }
    else if (tableView.tag == 103) {
        self.selectedIndexPath4 = indexPath;
    }

}


- (IBAction)uploadWorkLog:(id)sender
{
    if (self.selectedIndexPath1 && self.selectedIndexPath2 && self.selectedIndexPath3 && self.selectedIndexPath4 && self.textView.text.length > 0) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDictionary *dic;
        if (!self.isPlan) {
            dic = @{@"username":[Data Share].username,
                    @"token":[Data Share].token,
                    @"log_date":[dateFormatter stringFromDate:self.date],
                    @"log_type":[Data Share].LogTypeArray[self.selectedIndexPath1.row][@"key"],
                    @"cust_id":[Data Share].CustomArray[self.selectedIndexPath2.row][@"cust_id"],
                    @"cust_code":[Data Share].CustomArray[self.selectedIndexPath2.row][@"cust_code"],
                    @"cust_name":[Data Share].CustomArray[self.selectedIndexPath2.row][@"cust_name"],
                    @"log_achieve":self.textView.text,
                    @"finish_time":[Data Share].LogFinishTimeArray[self.selectedIndexPath3.row][@"key"],
                    @"plan_finish":[Data Share].CompleteStatusArray[self.selectedIndexPath4.row][@"key"]};
        }
        else {
            dic = @{@"username":[Data Share].username,
                    @"token":[Data Share].token,
                    @"plan_date":[dateFormatter stringFromDate:self.date],
                    @"play_type":[Data Share].PlayTypeArray[self.selectedIndexPath1.row][@"key"],
                    @"cust_id":[Data Share].CustomArray[self.selectedIndexPath2.row][@"cust_id"],
                    @"cust_code":[Data Share].CustomArray[self.selectedIndexPath2.row][@"cust_code"],
                    @"cust_name":[Data Share].CustomArray[self.selectedIndexPath2.row][@"cust_name"],
                    @"plan_contant":self.textView.text,
                    @"finish_time":[Data Share].PlanFinishTimeArray[self.selectedIndexPath3.row][@"key"],
                    @"plan_finish":[Data Share].CompleteStatusArray[self.selectedIndexPath4.row][@"key"]};
        }
        NSString *url;
        self.isPlan ? (url = [RequestUrl SendWorkPlan]) : (url = [RequestUrl SendWorkLog]);
        [RequestManager PostUrl:url loding:@"Loading..." dic:dic response:^(id response) {
            if (response) {
                if ([response[@"status_code"] integerValue] == 0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWorkLog" object:nil];
                    
                    [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                    //返回
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
        [SVProgressHUD showErrorWithStatus:@"请填写完整信息！"];
    }
    
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
