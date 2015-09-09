//
//  ReplyWorkPlanViewController.h
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//
typedef NS_ENUM(NSInteger, ShowType) {
    ShowTypePlan,	// 工作计划
    ShowTypeLog,//工作日志
    ShowTypeLeave  //请假单
};
#import "BaseViewController.h"

@interface ReplyWorkPlanViewController : BaseViewController

@property (strong) NSDictionary *cus_Info;


@property (assign) ShowType showtypeIn;
@end
