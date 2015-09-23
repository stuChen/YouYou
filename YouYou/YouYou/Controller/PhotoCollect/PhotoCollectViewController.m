//
//  PhotoCollectViewController.m
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "PhotoCollectViewController.h"
#import "PhotoPickerViewController.h"

@interface PhotoCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_HeaderTitle;
    NSArray *_FirstSectionTitle;
    NSArray *_secondSectionTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation PhotoCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBack];
    [self setTitle:@"照片采集"];
    _table.backgroundColor = BACK_COLOR;
    _HeaderTitle = @[@"实时照片",@"非实时照片"];
//    _FirstSectionTitle    = @[@"分销产品位置",@"门店陈列",@"广宣/促销活动"];
//    _secondSectionTitle = @[@"门店自行组织",@"竞品新产品促销活动",@"消费者活动",@"订货会活动",@"群英会活动",@"工作状态",@"消费者参与活动"];
    if([Data Share].PicType1Array){
        _FirstSectionTitle  = [Data Share].PicType1Array;
        _secondSectionTitle = [Data Share].PicType2Array;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _FirstSectionTitle ? _FirstSectionTitle.count : 0;
    }
    else if (section == 1)
    {
        return _secondSectionTitle ? _secondSectionTitle.count : 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellDeque = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDeque];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDeque];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = _FirstSectionTitle[indexPath.row][@"value"];
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = _secondSectionTitle[indexPath.row][@"value"];
    }
    cell.backgroundColor = BACK_COLOR;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 20)];
    label.center = CGPointMake(115, 20);
    label.text = _HeaderTitle[section];
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoPickerViewController *vc = [[PhotoPickerViewController alloc]init];
    if (indexPath.section == 0) {
        vc.isChoosePic = NO;
        vc.info        = _FirstSectionTitle[indexPath.row];
        vc.picType = @"1";
    }
    else {
        vc.isChoosePic = YES;
        vc.info        = _secondSectionTitle[indexPath.row];
        vc.picType = @"0";
    }
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
