//
//  NewClientViewController.m
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NewClientViewController.h"

@interface NewClientViewController ()<ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *_selectArrray;
    //记录组织
    NSArray *AreaArray;
}
@property (weak, nonatomic) IBOutlet UIButton *SaleOrganizationBtn;
@property (weak, nonatomic) IBOutlet UIButton *SaleAreaBtn;
@property (weak, nonatomic) IBOutlet UIButton *UpLoadBtn;
@property (weak, nonatomic) IBOutlet UIButton *CancleBtn;
@property (strong) NSIndexPath *selectedIndexPath;
@property (strong) NSIndexPath *selectedIndexPath1;

@property (weak, nonatomic) IBOutlet UITextField *dealerName;
@property (weak, nonatomic) IBOutlet UITextField *abbr;
@property (weak, nonatomic) IBOutlet UITextField *contactor;
@property (weak, nonatomic) IBOutlet UITextField *telephone;
@property (weak, nonatomic) IBOutlet UITextField *registerAddress;
@property (weak, nonatomic) IBOutlet UITextView *remark;


@end

@implementation NewClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:@"潜在客户上报"];
    
    UIImage *image2 = [UIImage imageNamed:@"select_a_bg.9"];
    image2 = [image2 stretchableImageWithLeftCapWidth:floorf(image2.size.width/2) topCapHeight:floorf(image2.size.height/2)];
    [_SaleOrganizationBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    [_SaleAreaBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    [self btnStatus:_UpLoadBtn];
    [self btnStatus:_CancleBtn];
}
- (IBAction)organization:(UIButton *)sender {
    
    if (sender.tag == 100) {
        _selectArrray = [Data Share].orgadefquery;
    }
    else {
        _selectArrray = AreaArray;
    }
    
    NSInteger count = _selectArrray.count;
    if ((ScreenHeight - 80) / 44 < count) {
        count = (ScreenHeight - 80) / 44;
    }
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, count * 44 + 32)];
    listView.titleName.text = @"";
    listView.datasource = self;
    listView.delegate = self;
    listView.tag = sender.tag;
    //    [listView setCancelButtonTitle:@"Cancel" block:^{
    //        DLog(@"cancel");
    //    }];
    //    [listView setDoneButtonWithTitle:@"OK" block:^{
    //        DLog(@"Ok%d", [listView indexPathForSelectedRow].row);
    //    }];
    [listView show];
}

- (IBAction)upload:(id)sender {
    if (_dealerName.text.length > 0 && _abbr.text.length > 0 && _selectedIndexPath && _selectedIndexPath1 && _contactor.text.length > 0 && _telephone.text.length > 0 && _registerAddress.text.length > 0) {
        NSDictionary *dic = @{@"username":[Data Share].username,
                              @"token":[Data Share].token,
                              @"dealer_name":_dealerName.text,
                              @"abbr":_abbr.text,
                              @"cust_type":@"0",
                              @"orga_id":[Data Share].orgadefquery[_selectedIndexPath.row][@"orga_id"],
                              @"sales_orga_id":AreaArray ? AreaArray[_selectedIndexPath1.row][@"area_id"] : @"",
                              @"parent_id":@"",
                              @"contactor":_contactor.text,
                              @"telephone":_telephone.text,
                              @"register_address":_registerAddress.text,
                              @"sales_rep_id":@"",
                              @"remark":_remark.text};
        [RequestManager PostUrl:[RequestUrl TempDealerSend] loding:@"正在上传..." dic:dic response:^(id response) {
            if (response) {
                if ([response[@"status_code"] integerValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
                    [self.navigationController popViewControllerAnimated:YES];
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
    else {
        [SVProgressHUD showErrorWithStatus:@"请补全客户信息."];
    }
    
}
- (IBAction)returnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectArrray ? _selectArrray.count : 0;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (tableView.tag == 100) {
        cell.textLabel.text = _selectArrray[indexPath.row][@"orga_name"];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
        if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
        {
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
        }
    }
    else {
        cell.textLabel.text = _selectArrray[indexPath.row][@"area_name"];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
        if ( self.selectedIndexPath1 && NSOrderedSame == [self.selectedIndexPath1 compare:indexPath])
        {
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
        }
    }
    
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
    
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    if (tableView.tag == 100) {
        self.selectedIndexPath = indexPath;
        [self.SaleOrganizationBtn setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row][@"orga_name"]] forState:UIControlStateNormal];
        [self getArea:[Data Share].orgadefquery[indexPath.row]];
    }
    else {
        self.selectedIndexPath1 = indexPath;
        [self.SaleAreaBtn setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row][@"area_name"]] forState:UIControlStateNormal];
    }
    
}
//获取销售区域
- (void)getArea:(NSDictionary *)dict
{
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"page_size":@"999999",
                          @"page_no":@"",
                          @"orga_code":dict[@"orga_code"],
                          @"orga_id":dict[@"orga_id"]};
    [RequestManager PostUrl:[RequestUrl salesareaquery] loding:@"正在获取数据..." dic:dic response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                AreaArray = response[@"body"];
                
                //显示第一条
                [self.SaleAreaBtn setTitle:[NSString stringWithFormat:@"  %@",AreaArray[0][@"area_name"]] forState:UIControlStateNormal];
                _selectedIndexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
                [SVProgressHUD showSuccessWithStatus:response[@"tip_msg"]];
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
