//
//  PhoneBookViewController.m
//  YouYou
//
//  Created by Chen on 15/7/5.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "PhoneBookViewController.h"
#import "ZSYPopoverListView.h"
#import "CustomDetailViewController.h"

@interface PhoneBookViewController ()<ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *array;
    NSArray *_selectArrray;
}
@property (weak, nonatomic) IBOutlet UIButton *cusTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *NothingLabel;
@property (strong) NSIndexPath *selectedIndexPath;
@end

@implementation PhoneBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"通讯录查询"];
    [self initBack];
    [self btnStatus:self.cusTypeBtn];
    [self btnStatus:self.SearchBtn];
    _selectArrray = @[@"客户",@"员工"];
}
- (IBAction)cusTypeClick:(id)sender {
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * 2 / 3, 2 * 44 + 32)];
    listView.titleName.text = @"员工/客户";
    listView.datasource = self;
    listView.delegate = self;
    //    [listView setCancelButtonTitle:@"Cancel" block:^{
    //        DLog(@"cancel");
    //    }];
    //    [listView setDoneButtonWithTitle:@"OK" block:^{
    //        DLog(@"Ok%d", [listView indexPathForSelectedRow].row);
    //    }];
    [listView show];
}
- (void)btnStatus:(UIButton *)btn
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.shadowColor = RGBA(202, 202, 202, 1).CGColor;
    btn.layer.cornerRadius = 8;
}
- (IBAction)SearchClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *type = @"1";
    if (_selectedIndexPath) {
        if (_selectedIndexPath.row == 0) {
            type = @"0";
        }
    }
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"query_type":type,
                          @"query_key":_searchText.text,
                          @"page_size":@"999999",
                          @"page_no":@""};
    
    [RequestManager PostUrl:[RequestUrl PhoneBookQuery] loding:@"正在查询..." dic:dic response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                array = response[@"body"];
                [self reloadData];
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

- (void)reloadData
{
    if (array.count == 0) {
        self.table.hidden = YES;
        self.NothingLabel.hidden = NO;
    }
    else {
        self.table.hidden = NO;
        self.NothingLabel.hidden = YES;
        [self.table reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array ? 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return array ? array.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDeque = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDeque];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellDeque];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",array[indexPath.row][@"rtn1"]];
//    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.minimumScaleFactor = 0.2;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    NSString *string = [NSString stringWithFormat:@"%@",array[indexPath.row][@"rtn4"]];
    cell.detailTextLabel.text = string;
    
    UILabel *label;
    if (![cell.contentView viewWithTag:200]) {
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(60, 20, ScreenWidth - 68, 16);
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
    }
    else {
        label = (UILabel *)[cell.contentView viewWithTag:200];
    }
    label.text = [NSString stringWithFormat:@"%@",array[indexPath.row][@"rtn6"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomDetailViewController *vc = [[CustomDetailViewController alloc]init];
    vc.info = array[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark -
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    cell.textLabel.text = _selectArrray[indexPath.row];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
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
    [self.cusTypeBtn setTitle:[NSString stringWithFormat:@"%@",_selectArrray[indexPath.row]] forState:UIControlStateNormal];
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
