//
//  ReadWorkPlanViewController.h
//  YouYou
//
//  Created by Chen on 15/7/10.
//  Copyright (c) 2015年 Chen. All rights reserved.
//
typedef NS_ENUM(NSInteger, ReadType) {
    ReadTypeWorkPlan,	// 工作计划
    ReadTypeWorkLog,//工作日志
    ReadTypeLeave  //请假单
};

#import "BaseViewController.h"

@interface ReadWorkPlanViewController : BaseViewController

@property (assign) ReadType showType;

@end
