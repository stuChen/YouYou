//
//  RequestUrl.h
//  Sahara
//
//  Created by Chen on 15/6/18.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#define APPURL @"http://test.useedsh.cn"
#define USER_APPURL [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_SER_ADDRESS"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_SER_ADDRESS"] : @"http://erp.useedsh.cn"
//@"http://test.useedsh.cn/"
#import <Foundation/Foundation.h>

@interface RequestUrl : NSObject

+ (NSString *)Login;
+ (NSString *)Sign;
+ (NSString *)MyMsgQuery;
+ (NSString *)WorkLogStatusquery;
+ (NSString *)WorkPlanStatusquery;
+ (NSString *)WorkLogquery;
+ (NSString *)WorkPlanquery;
+ (NSString *)Signquery;
+ (NSString *)getenum;
+ (NSString *)queryCust;
+ (NSString *)SendStoreLoc;
+ (NSString *)PhoneBookQuery;
+ (NSString *)SendWorkLog;
+ (NSString *)SendWorkPlan;
+ (NSString *)SendImage;
+ (NSString *)queryEmployee;
+ (NSString *)queryLogEmployee;
+ (NSString *)WorkLogToAuditquery;
+ (NSString *)WorkPlanToAuditquery;
+ (NSString *)DayOffQuery;
+ (NSString *)queryDayOffEmployee;
+ (NSString *)DayOffToAuditquery;
+ (NSString *)DayOffToAuditSend;
+ (NSString *)SendDayOff;
+ (NSString *)orgadefquery;
+ (NSString *)salesareaquery;
+ (NSString *)TempDealerSend;
+ (NSString *)WorkLogSendAudit;
+ (NSString *)WorkPlanSendAudit;
+ (NSString *)SendLoc;
+(BOOL) isValidateMobile:(NSString *)mobile;
//+ (BOOL)isMobileNumber:(NSString *)mobileNum;
@end
