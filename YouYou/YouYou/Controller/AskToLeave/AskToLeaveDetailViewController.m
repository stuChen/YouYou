//
//  AskToLeaveDetailViewController.m
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "AskToLeaveDetailViewController.h"
#import "AskToLeaveTableViewCell.h"

@interface AskToLeaveDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) AskToLeaveTableViewCell *prototypeCell;


@end
static NSString *dequeString = @"group";
@implementation AskToLeaveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:@"请假申请查询结果"];
    
    [self.table registerNib:[UINib nibWithNibName:@"AskToLeaveTableViewCell" bundle:nil] forCellReuseIdentifier:dequeString];
    self.prototypeCell = [self.table dequeueReusableCellWithIdentifier:dequeString];
    [self initData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray ? _dataArray.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UILabel *NeedResizeLabel = (UILabel *)[self.prototypeCell.contentView viewWithTag:10001];
        [NeedResizeLabel setText:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"remark"]]];
        
        [self.prototypeCell setNeedsUpdateConstraints];
        [self.prototypeCell updateConstraintsIfNeeded];
        
        CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height + 1;

//    return 117;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskToLeaveTableViewCell *cell = (AskToLeaveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:dequeString];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AskToLeaveTableViewCell" owner:nil options:nil].lastObject;
    }
    [cell initData:_dataArray[indexPath.row]];
    return cell;    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)initData
{
    [RequestManager PostUrl:[RequestUrl DayOffQuery] loding:@"Loading..." dic:self.info response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                _dataArray = response[@"body"];
                [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
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
