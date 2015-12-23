//
//  AttendanceRecordViewController.m
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "AttendanceRecordViewController.h"
#import "SelectDatePicker.h"
#import "SearchSignqueryViewController.h"

@interface AttendanceRecordViewController ()
{
    NSDateFormatter *formatter;
    SelectDatePicker *_datePicker;
}
@property (weak, nonatomic) IBOutlet UIButton *StartTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *StopTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *Sure;
@property (weak, nonatomic) IBOutlet UIButton *SelectBtn;

@end

@implementation AttendanceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"出勤记录"];
    [self initBack];
//    [self status:_StartTimeBtn];
//    [self status:_StopTimeBtn];
    _Sure.layer.borderWidth = 0.5;
    _Sure.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    _Sure.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    _Sure.layer.cornerRadius = 8;
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
}

- (IBAction)SelectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;

}
- (IBAction)SelectDate:(UIButton *)sender {
    
//    if (_datePicker) {
//        [_datePicker removeFromSuperview];
//        _datePicker = nil;
//    }
//    _datePicker = [[NSBundle mainBundle] loadNibNamed:@"SelectDatePicker" owner:nil options:nil].firstObject;
//    _datePicker.frame = [UIScreen mainScreen].bounds;
//    [_datePicker showStatus];
//    [self.view addSubview:_datePicker];
//    
//    __weak UIButton *button = sender;
//    _datePicker.dateBLock = ^(NSDate *date)
//    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        
//        [button setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
//    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureBtnClick:(id)sender {
    if (_StartTimeBtn.titleLabel.text.length == 0 || _StopTimeBtn.titleLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择日期！"];
        return;
    }
    
    
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"begin_date": _StartTimeBtn.titleLabel.text,
                          @"end_date":_StopTimeBtn.titleLabel.text,
                          @"is_exp":[NSNumber numberWithBool:_SelectBtn.selected],
                          @"page_size":@"999999",
                          @"page_no":@""};
    SearchSignqueryViewController *vc = [[SearchSignqueryViewController alloc]init];
    vc.dict = dic;
    vc.Show_exp = _SelectBtn.selected;
    [self.navigationController pushViewController:vc animated:YES];
//    [RequestManager PostUrl:[RequestUrl Signquery] loding:@"Loading..." dic:dic response:^(id response) {
//        if (response) {
//            if ([response[@"status_code"] integerValue] == 0) {
//                [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
//
//            }
//            else {
//                [SVProgressHUD showErrorWithStatus:response[@"tip_msg"]];
//            }
//            
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:@"网络请求失败!"];
//        }
//        
//    }];
    
    
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
