//
//  AskToLeaveViewController.m
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "AskToLeaveViewController.h"
#import "ZSYPopoverListView.h"
#import "SelectDatePicker.h"
#import "AskToLeaveDetailViewController.h"
#import "ApplyLeaveViewController.h"

@interface AskToLeaveViewController ()<ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *_selectArrray;
    SelectDatePicker *_datePicker;
}
@property (weak, nonatomic) IBOutlet UIButton *StartDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *EndDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *StatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *NewBtn;
@property (strong) NSIndexPath *selectedIndexPath;
@end

@implementation AskToLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBack];
    [self setTitle:@"请假申请查询"];
    
    UIImage *image2 = [UIImage imageNamed:@"select_a_bg.9"];
    image2 = [image2 stretchableImageWithLeftCapWidth:floorf(image2.size.width/2) topCapHeight:floorf(image2.size.height/2)];
//    [_StartDateBtn setBackgroundImage:image2 forState:UIControlStateNormal];
//    [_EndDateBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    [_StatusBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    
    [self btnStatus:_SearchBtn];
    [self btnStatus:_NewBtn];
    
    _selectArrray = [Data Share].OffStatusArray;
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
}
- (IBAction)showSelect:(id)sender {
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * 2 / 3, 3 * 44 + 32)];
    listView.titleName.text = @"批阅状态";
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
- (IBAction)ChooseDate:(UIButton *)sender {
//    if (_datePicker) {
//        [_datePicker removeFromSuperview];
//        _datePicker = nil;
//    }
//    _datePicker = [[NSBundle mainBundle] loadNibNamed:@"SelectDatePicker" owner:nil options:nil].firstObject;
//    _datePicker.frame = [UIScreen mainScreen].bounds;
//    [_datePicker showStatus];
//    [self.view addSubview:_datePicker];
//    
//    __weak UIButton *button = sender;
//    _datePicker.dateBLock = ^(NSDate *date)
//    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        
//        [button setTitle:[NSString stringWithFormat:@"  %@",[dateFormatter stringFromDate:date]] forState:UIControlStateNormal];
//    };

}
- (IBAction)Search:(id)sender {
    NSDictionary *dic = @{@"username":[Data Share].username,
                          @"token":[Data Share].token,
                          @"apply_date_from":self.StartDateBtn.titleLabel.text ? self.StartDateBtn.titleLabel.text : @"",
                          @"apply_date_to":self.EndDateBtn.titleLabel.text ? self.EndDateBtn.titleLabel.text : @"",
                          @"off_status":_selectArrray[_selectedIndexPath.row][@"key"]};
    AskToLeaveDetailViewController *vc = [[AskToLeaveDetailViewController alloc]init];
    vc.info = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)createNew:(id)sender {
    ApplyLeaveViewController *vc = [[ApplyLeaveViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectArrray.count;
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
    cell.textLabel.text = _selectArrray[indexPath.row][@"value"];//[NSString stringWithFormat:@"-dsds---%ld------", (long)indexPath.row];
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
    [_StatusBtn setTitle:[NSString stringWithFormat:@"    %@",_selectArrray[indexPath.row][@"value"]] forState:UIControlStateNormal];
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
