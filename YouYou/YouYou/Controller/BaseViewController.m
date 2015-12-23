//
//  BaseViewController.m
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = MAINCOLOR;
    self.view.backgroundColor = BACK_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBack
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"btn_back_on"];
    button.frame = CGRectMake(0, 0, 98 * 0.6, 47 * 0.6);
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationItem.titleView      = titleLabel;
}
- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (void)status:(UIButton *)btn
{
    UIImage *image2 = [UIImage imageNamed:@"select_a_bg.png"];
    image2 = [image2 stretchableImageWithLeftCapWidth:floorf(image2.size.width/2) topCapHeight:floorf(image2.size.height/2)];
    [btn setBackgroundImage:image2 forState:UIControlStateNormal];
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
