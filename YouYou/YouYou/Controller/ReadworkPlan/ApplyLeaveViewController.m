//
//  ApplyLeaveViewController.m
//  YouYou
//
//  Created by Chen on 15/7/13.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ApplyLeaveViewController.h"
#import "DatePickerBtn.h"

@interface ApplyLeaveViewController ()<ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *_selectArrray;
}
@property (weak, nonatomic) IBOutlet DatePickerBtn *StartTime;
@property (weak, nonatomic) IBOutlet DatePickerBtn *stopTime;
@property (weak, nonatomic) IBOutlet UIButton *LeaveDay;
@property (weak, nonatomic) IBOutlet UIButton *LeaveType;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIButton *Back;
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (strong) NSIndexPath *selectedIndexPath;
@end

@implementation ApplyLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBack];
    [self setTitle:@"请假申请"];
    
    [self btnStatus:self.submit];
    [self btnStatus:self.Back];
    
    [self status:self.LeaveDay];
    [self status:self.LeaveType];
    
    //设置开始时间
    _StartTime.datePicker.datePiker.minimumDate = [NSDate date];
    _stopTime.datePicker.datePiker.minimumDate  = [NSDate date];
    
}
- (IBAction)Day:(UIButton *)sender {
    
    if (sender.tag == 100) {
        if (self.StartTime.titleLabel.text.length > 0 && self.stopTime.titleLabel.text.length > 0) {
            NSString *string1 = [self.StartTime.titleLabel.text stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
            NSString *string2 = [self.stopTime.titleLabel.text stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date1 = [dateFormatter dateFromString:string1];
            NSDate *date2 = [dateFormatter dateFromString:string2];
            NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
            if (time >= 0) {
                NSInteger dayCount = (fabs(time) / 3600 / 24) + 1;
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (int i = 1; i <= dayCount * 2; i++) {
                    NSString *string = i % 2 ? [NSString stringWithFormat:@"%.1f", i * 0.5] : [NSString stringWithFormat:@"%.f", i * 0.5];
                    [array addObject:string];
                }
                 _selectArrray = array;
            }
            else {
                _selectArrray = @[@"0"];
            }
        }
        else {
            _selectArrray = @[@"0"];
        }
    }
    else if (sender.tag == 101)
    {
        NSArray *array =[Data Share].OffTypeArray;
        if (array) {
            _selectArrray = array;
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
- (IBAction)submit:(id)sender {
    
    if (self.StartTime.titleLabel.text.length > 0 && self.stopTime.titleLabel.text.length > 0 && self.selectedIndexPath) {
        
        NSString *string1 = [self.StartTime.titleLabel.text stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        NSString *string2 = [self.stopTime.titleLabel.text stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date1 = [dateFormatter dateFromString:string1];
        NSDate *date2 = [dateFormatter dateFromString:string2];
        
        //与当前时间对比
        NSDate *date = [NSDate date];
        NSString *str = [dateFormatter stringFromDate:date];
        date = [dateFormatter dateFromString:str];
        NSTimeInterval time1 = [date1 timeIntervalSinceDate:date];
        if (time1 >= 0) {
            
            //
            NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
            if (time >= 0) {
                NSDictionary *dic = @{@"username":[Data Share].username,
                                      @"token":[Data Share].token,
                                      @"begin_date":string1,
                                      @"end_date":string2,
                                      @"day_count":[self.LeaveDay.titleLabel.text stringByReplacingOccurrencesOfString:@"  " withString:@""],
                                      @"off_type":[Data Share].OffTypeArray[self.selectedIndexPath.row][@"key"],
                                      @"remark":self.text.text};
                [RequestManager PostUrl:[RequestUrl SendDayOff] loding:@"正在上传..." dic:dic response:^(id response) {
                    if (response) {
                        if ([response[@"status_code"] integerValue] == 0) {
                            
                            [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
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
                [SVProgressHUD showErrorWithStatus:@"开始时间不能小于结束时间"];
            }

        }
        else {
            [SVProgressHUD showErrorWithStatus:@"请假开始时间必须大于今天时间"];
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请填写必要信息"];
    }
}
- (IBAction)returnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    if (tableView.tag == 100) {
            cell.textLabel.text = _selectArrray[indexPath.row];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
    }
    else {
            cell.textLabel.text = _selectArrray[indexPath.row][@"value"];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
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
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    if (tableView.tag == 100) {
            [self.LeaveDay setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row]] forState:UIControlStateNormal];
    }
    else {
            [self.LeaveType setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row][@"value"]] forState:UIControlStateNormal];
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
