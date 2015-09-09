//
//  CustomDetailViewController.m
//  YouYou
//
//  Created by Chen on 15/7/5.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "CustomDetailViewController.h"

@interface CustomDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *LevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *BackBtn;

@end

@implementation CustomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self btnStatus:self.callBtn];
    [self btnStatus:self.BackBtn];
    if (self.info) {
        [self setTitle:[NSString stringWithFormat:@"%@",self.info[@"rtn1"]]];
        
        self.NameLabel.text = [NSString stringWithFormat:@"%@",self.info[@"rtn1"]];
        self.companyLabel.text = [NSString stringWithFormat:@"%@",self.info[@"rtn2"]];
        self.departmentLabel.text = [NSString stringWithFormat:@"%@",self.info[@"rtn3"]];
        self.LevelLabel.text = [NSString stringWithFormat:@"%@",self.info[@"rtn4"]];
        self.telLabel.text = [NSString stringWithFormat:@"%@",self.info[@"rtn7"]];
        self.mobileLabel.text = [NSString stringWithFormat:@"%@",self.info[@"rtn6"]];
    }
}
- (IBAction)call:(id)sender {
    if (![[NSString stringWithFormat:@"%@",self.info[@"rtn6"]] isEqualToString:@"<null>"])
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.info[@"rtn6"]];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
    else if(![[NSString stringWithFormat:@"%@",self.info[@"rtn7"]] isEqualToString:@"<null>"])
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.info[@"rtn7"]];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];

    }
    else {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"6855"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
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
