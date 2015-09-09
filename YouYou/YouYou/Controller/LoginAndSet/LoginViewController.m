//
//  LoginViewController.m
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "LoginViewController.h"
#import "SetServiceViewController.h"
#import "AppDelegate.h"
#import "MianViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *remName;
@property (weak, nonatomic) IBOutlet UIButton *remPassword;

@end

@implementation LoginViewController









- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"用户登录"];
    [self btnStatus:_loginBtn];
    
    
    if ([UserData keyForUser:@"password"] || [UserData keyForUser:@"username"]) {
        _nameText.text = [UserData keyForUser:@"username"];
        _remName.selected = YES;
    }
    if ([UserData keyForUser:@"password"]) {
        _passwordText.text = [UserData keyForUser:@"password"];
        _remPassword.selected = YES;
        [self login:nil];
    }
    

}

- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (IBAction)remName:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}
- (IBAction)login:(id)sender {
    if (_nameText.text.length == 0 || _passwordText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入登录账号和密码!"];
    }
    else {
        [_loginBtn setTitle:@"登录中" forState:UIControlStateNormal];
        [RequestManager PostUrl:[RequestUrl Login] loding:@"登录中..." dic:@{@"username":_nameText.text,
                                                                          @"password":_passwordText.text,
                                                                          @"imei":@"ios"}
                       response:^(id response) {
            if (response) {
                if ([response[@"status_code"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                    if (response[@"token"]) {
                        [UserData Value:response[@"token"] forKey:@"token"];
                    }
                    [self setLoginInfo:response[@"token"]];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:response[@"tip_msg"]];
                }
                
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"网络连接失败！"];
            }
            [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        }];
    }
}

- (void)setLoginInfo:(NSString *)token
{
    [UserData Value:_nameText.text forKey:@"username"];
    
    if (_remPassword.selected) {
        [UserData Value:_passwordText.text forKey:@"password"];
    }
    else {
        [UserData Deletekey:@"password"];
    }
    if (_remName.selected || _remPassword.selected) {
        [UserData Value:@"1" forKey:@"remberName"];
    }
    else {
        [UserData Deletekey:@"username"];
    }
    //将信息放在单例。
    [Data Share].username = _nameText.text;
    [Data Share].token = token;
    //
    [[Data Share] initData:@{@"username":[Data Share].username,
                             @"token":[Data Share].token}];
    [[Data Share] initOrgadefquery];
    
    
    MianViewController *vc = [[MianViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)EditAddress:(id)sender {
    SetServiceViewController *vc = [[SetServiceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
