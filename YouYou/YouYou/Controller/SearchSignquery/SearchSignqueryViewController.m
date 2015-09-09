//
//  SearchSignqueryViewController.m
//  YouYou
//
//  Created by Chen on 15/7/4.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "SearchSignqueryViewController.h"
#import "SearchSignqueryTableViewCell.h"

@interface SearchSignqueryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation SearchSignqueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:@"出勤记录查询结果"];
    
    
    
    [self initData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return dataArray ? dataArray.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 153;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDeque = @"cell1";
    SearchSignqueryTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellDeque];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SearchSignqueryTableViewCell" owner:nil options:nil].firstObject;
    }
    [cell initData:dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)initData
{
    [RequestManager PostUrl:[RequestUrl Signquery] loding:@"Loading..." dic:_dict response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                dataArray = response[@"body"];
                //仅显示异常
                if (self.Show_exp) {
                    [self resetData];
                }
                [self.table reloadData];
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
- (void)resetData
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj[@"AttType"] isKindOfClass:[NSNull class]]) {
            if ([obj[@"AttType"] integerValue] == 1) {
                [array addObject:obj];
            }
        }
    }];
    dataArray = array;
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
