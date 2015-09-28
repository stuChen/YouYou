//
//  MianViewController.m
//  YouYou
//
//  Created by Chen on 15/6/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "MianViewController.h"
#import "YY_Button.h"
#import "LocationSignInViewController.h"
#import "AttendanceRecordViewController.h"
#import "DailyWorkViewController.h"
#import "PhotoCollectViewController.h"
#import "AskToLeaveViewController.h"
#import "NewClientViewController.h"
#import "NoticeViewController.h"
#import "LocationCollectViewController.h"
#import "PhoneBookViewController.h"
#import "ReadWorkPlanViewController.h"
#import "APService.h"


@interface MianViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>

@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    [self setTitle:@"优幼销售管理系统"];
    
    
    UIScrollView *_scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scroll.delegate = self;
    _scroll.backgroundColor = BACK_COLOR;
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    
    NSArray *array = @[@"我的公告",@"位置签到",@"位置签退",@"出勤记录",@"坐标采集",@"工作日报",@"工作周报",@"照片采集",@"日报批阅",@"周报批阅",@"请假申请查询",@"请假单批阅",@"潜在客户上报",@"通讯录查询"];
    NSArray *ImageArray = @[@"a_1",@"a_5",@"a_6",@"a_16",@"a_17",@"a_8",@"a_7",@"a_11",@"a_9",@"a_9",@"a_22",@"a_18",@"a_21",@"a_19"];
    
    for (int i = 0; i < 14; i++) {
        YY_Button *btn = [[YY_Button alloc]initWithFrame:CGRectMake(ScreenWidth/3 * (i % 3), ScreenWidth/3 * (i / 3),ScreenWidth / 3 , ScreenWidth / 3)image:ImageArray[i] title:array[i]];
        [_scroll addSubview:btn];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_scroll setContentSize:CGSizeMake(ScreenWidth, 5 * ScreenWidth / 3)];
    
    //获取门店数据
    [[Data Share]initCustomData];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"btn_back_out-1"];
    button.frame = CGRectMake(0, 0, 98 * 0.6, 47 * 0.6);
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    //开启定时上传坐标
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startUplocationTracker" object:nil];
    [self setTags];
}
//设置标签
- (void)setTags {
    NSString *alias = [NSString stringWithFormat:@"YY_IOS_%@",[UserData keyForUser:@"username"]];
    [APService setTags:[NSSet set]
                 alias:alias
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                target:self];
}
static int try = 0;
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     tags, alias];
    if (iResCode != 0 && alias.length > 0 && try < 3) {
        try++;
        [self setTags];
    }
    else {
        try = 0;
    }
    NSLog(@"TagsAlias回调:%@", callbackString);
    
}

- (void)signOut
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告！"
                                                   message:@"是否确认退出？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];

}

- (void)clickBtn:(UIButton *)btn
{
    
    switch (btn.tag) {
        case 1000:
        {
            NoticeViewController *vc = [[NoticeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1001:
        {
            LocationSignInViewController *vc = [[LocationSignInViewController alloc]init];
            vc.signIn = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

            break;
        case 1002:
        {
            LocationSignInViewController *vc = [[LocationSignInViewController alloc]init];
            vc.signIn = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1003:
        {
            AttendanceRecordViewController *vc = [[AttendanceRecordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1004:
        {
            LocationCollectViewController *vc = [[LocationCollectViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1005:
        {
            DailyWorkViewController *vc = [[DailyWorkViewController alloc]init];
            vc.isPlan = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1006:
        {
            DailyWorkViewController *vc = [[DailyWorkViewController alloc]init];
            vc.isPlan = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1007:
        {
            PhotoCollectViewController *vc = [[PhotoCollectViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1008:
        {
            ReadWorkPlanViewController *vc = [[ReadWorkPlanViewController alloc]init];
            vc.showType = ReadTypeWorkLog;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1009:
        {
            ReadWorkPlanViewController *vc = [[ReadWorkPlanViewController alloc]init];
            vc.showType = ReadTypeWorkPlan;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1010:
        {
            AskToLeaveViewController *vc = [[AskToLeaveViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1011:
        {
            ReadWorkPlanViewController *vc = [[ReadWorkPlanViewController alloc]init];
            vc.showType = ReadTypeLeave;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1012:
        {
            NewClientViewController *vc = [[NewClientViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1013:
        {
            PhoneBookViewController *vc = [[PhoneBookViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        default:
            break;
    }
}


#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //取消设置标签
        [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
        //结束定时上传坐标
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUplocationTracker" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    }
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
