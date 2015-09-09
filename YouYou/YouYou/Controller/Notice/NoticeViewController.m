//
//  NoticeViewController.m
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NoticeDetailViewController.h"

@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *messageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:@"我的公告"];
    messageArray = [[NSMutableArray alloc]init];
    [self initData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequene = @"notice";
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequene];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:nil options:nil].firstObject;
    }
    [cell initData:messageArray[indexPath.row]];
    return cell;
}



- (void)initData
{
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"page_size":@"999999",
                          @"page_no":@"1",
                          @"total_pages":@"0",
                          @"last_time":@""};

    [RequestManager PostUrl:[RequestUrl MyMsgQuery] loding:@"获取中..." dic:dic response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                
                [messageArray addObjectsFromArray:response[@"body"]];  [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeDetailViewController *vc = [[NoticeDetailViewController alloc]init];
    vc.data = messageArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
