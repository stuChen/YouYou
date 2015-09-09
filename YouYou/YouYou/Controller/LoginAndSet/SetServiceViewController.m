//
//  SetServiceViewController.m
//  YouYou
//
//  Created by Chen on 15/6/30.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "SetServiceViewController.h"

@interface SetServiceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation SetServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"设置"];
    [self initBack];
    _addressText.text = USER_APPURL;
    [self btnStatus:_sureBtn];
}
- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (IBAction)Sure:(id)sender {
    if (_addressText.text.length > 0) {
        [UserData Value:_addressText.text forKey:@"APP_SER_ADDRESS"];
        [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请输入服务器地址!"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
