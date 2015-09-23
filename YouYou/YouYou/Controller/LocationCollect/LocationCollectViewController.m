//
//  LocationCollectViewController.m
//  YouYou
//
//  Created by Chen on 15/7/5.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "LocationCollectViewController.h"
#import "UploadLocationViewController.h"

@interface LocationCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation LocationCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:@"坐标采集"];
    [self initData];
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
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
    return 38;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDeque = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDeque];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellDeque];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"cust_name"]];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.minimumScaleFactor = 0.2;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    NSString *string = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"GetLoc"]];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor redColor];
    if ([string isEqualToString:@"1"]) {
        cell.detailTextLabel.text = @"已经采集";
    }
    else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UploadLocationViewController *vc = [[UploadLocationViewController alloc]init];
    vc.cus_Info = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)initData
{
    NSDictionary *dic = @{@"username":[Data Share].username,
            @"token":[Data Share].token,
            @"is_store":@"1",
            @"is_get_loc":_selectBtn.selected ? @"0" : @""};

    
    [RequestManager PostUrl:[RequestUrl queryCust] loding:@"Loading..." dic:dic response:^(id response) {
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
