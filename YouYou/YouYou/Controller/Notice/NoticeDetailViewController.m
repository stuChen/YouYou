//
//  NoticeDetailViewController.m
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *User;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleTwo;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *mark;

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:@"站内消息"];
    [self btnStatus:_mark];
    if (_data) {
        _TitleLabel.text = [NSString stringWithFormat:@"%@",_data[@"msg_title"]];
        _User.text = [NSString stringWithFormat:@"发布人: %@",_data[@"creator_name"]];
        _dateLabel.text = [NSString stringWithFormat:@"%@",_data[@"send_date"]];
        _TitleTwo.text = [NSString stringWithFormat:@"%@",_data[@"msg_body"]];
        _content.text = [NSString stringWithFormat:@"%@",_data[@"msg_file_url"]];
    }
}
- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (IBAction)markClick:(id)sender {
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
