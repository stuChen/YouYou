//
//  PhotoPickerViewController.m
//  YouYou
//
//  Created by Chen on 15/6/29.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "PhotoPickerViewController.h"

@interface PhotoPickerViewController ()<ZSYPopoverListDatasource,ZSYPopoverListDelegate>
{
    NSArray *_selectArrray;
}
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *TakePhoto;
@property (weak, nonatomic) IBOutlet UIButton *Upload;
@property (weak, nonatomic) IBOutlet UIButton *choosePic;
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayout;
@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (strong) NSIndexPath *selectedIndexPath1;
@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBack];
    [self setTitle:@"照片采集"];
    if (self.isChoosePic)
    {
        _leftLayout.constant = 8;
        _withLayout.constant = ScreenWidth / 3;
    }
    
    UIImage *image2 = [UIImage imageNamed:@"select_a_bg.9"];
    image2 = [image2 stretchableImageWithLeftCapWidth:floorf(image2.size.width/2) topCapHeight:floorf(image2.size.height/2)];
    [_selectBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    
    [self btnStatus:_TakePhoto];
    [self btnStatus:_Upload];
    [self btnStatus:_choosePic];
//    CGRect frame = self.choosePic.frame;
//    self.choosePic.bounds = CGRectMake(0, 0, 100, frame.size.height);
    [self.view needsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];

}
- (IBAction)showCustom:(id)sender {
    if ([Data Share].CustomArray) {
        
        _selectArrray = [Data Share].CustomArray;
    }
    NSInteger count = _selectArrray.count;
    if ((ScreenHeight - 80) / 44 < count) {
        count = (ScreenHeight - 80) / 44;
    }
    ZSYPopoverListView *listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, count * 44 + 32)];
    listView.titleName.text = @"客户/门店";
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
- (IBAction)choosePic:(id)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate                 = self;
    picker.allowsEditing            = YES;
    picker.sourceType               = sourceType;
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}
- (IBAction)tokePhoto:(id)sender {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate                 = self;
    picker.allowsEditing            = YES;
    picker.sourceType               = sourceType;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (IBAction)upload:(id)sender {
    
    if (_selectedIndexPath1 && _pic.image) {
        [SVProgressHUD showWithStatus:@"正在上传..."];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateformatter stringFromDate:[NSDate date]];
        
        NSDictionary *dic = @{@"username":[Data Share].username,
                              @"token":[Data Share].token,
                              @"collect_date":dateStr,
                              @"is_time_col":self.picType,
                              @"pic_type":self.info[@"key"],
                              @"cust_id":[Data Share].CustomArray[self.selectedIndexPath1.row][@"cust_id"],
                              @"cust_code":[Data Share].CustomArray[self.selectedIndexPath1.row][@"cust_code"],
                              @"cust_name":[Data Share].CustomArray[self.selectedIndexPath1.row][@"cust_name"],
                              @"remark":_text.text,
                              @"addr_info":[Data Share].CustomArray[self.selectedIndexPath1.row][@"cust_addr"]};
        NSData *data = UIImageJPEGRepresentation(self.pic.image, 0.5);
        DLog(@"%@",dic);
        
        [RequestManager PostImageDic:dic imageData:data response:^(id response) {
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
        [SVProgressHUD showErrorWithStatus:@"当前信息有误！请确认!"];
    }
    


}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image  = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.pic.image = image;
    self.imageHeightLayout.constant = self.pic.bounds.size.width;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

    
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
    
    
    //    if ( self.selectedIndexPath1 && NSOrderedSame == [self.selectedIndexPath1 compare:indexPath])
    //    {
    //        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    //    }
    //    else
    //    {
    //        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    //    }
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _selectArrray[indexPath.row][@"cust_name"];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    DLog(@"deselect:%ld", (long)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    

        [self.selectBtn setTitle:[NSString stringWithFormat:@"  %@",_selectArrray[indexPath.row][@"cust_name"]] forState:UIControlStateNormal];

        self.selectedIndexPath1 = indexPath;
    
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
