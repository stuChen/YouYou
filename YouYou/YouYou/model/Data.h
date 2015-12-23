//
//  Data.h
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
+ (Data *)Share;
//获取客户/门店数据
- (void)initCustomData;
- (void)initData:(NSDictionary *)dic;
//用户信息
@property (strong) NSString *username;
@property (strong) NSString *token;



//门店数据
@property (strong) NSArray *CustomArray;


//枚举数据类型
@property(strong) NSMutableArray *PriorityTypeArray;
@property(strong) NSMutableArray *MsgReadStatusArray;
@property(strong) NSMutableArray *EmplTypeArray;
@property(strong) NSMutableArray *OffStatusArray;
@property(strong) NSMutableArray *OffTypeArray;
@property(strong) NSMutableArray *AttTypeInArray;
@property(strong) NSMutableArray *AttTypeOutArray;
@property(strong) NSMutableArray *FromModuleArray;
@property(strong) NSMutableArray *PicType2Array;
@property(strong) NSMutableArray *LogAuditArray;
@property(strong) NSMutableArray *GetLocArray;
@property(strong) NSMutableArray *StoreLevelArray;
@property(strong) NSMutableArray *PicType1Array;
@property(strong) NSMutableArray *PlayTypeArray;
@property(strong) NSMutableArray *LogTypeArray;
@property(strong) NSMutableArray *WorkStatusArray;
@property(strong) NSMutableArray *CompleteStatusArray;
@property(strong) NSMutableArray *PlanAuditArray;
@property(strong) NSMutableArray *PlanFinishTimeArray;
@property(strong) NSMutableArray *LogFinishTimeArray;
@property(strong) NSMutableArray *DayTypeArray;
@property(strong) NSMutableArray *AttTypeArray;

/**
 获取销售组织
 */
- (void)initOrgadefquery;
//
@property(strong)NSArray *orgadefquery;

- (NSString *)ChooseInfo:(NSDictionary *)dic key:(NSString *)key array:(NSArray *)array;
@end
