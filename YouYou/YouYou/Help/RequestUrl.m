//
//  RequestUrl.m
//  Sahara
//
//  Created by Chen on 15/6/18.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "RequestUrl.h"

@implementation RequestUrl

+ (NSString *)Login
{
    return [USER_APPURL stringByAppendingString:@"/mobile/login.do"];
}
+ (NSString *)Sign
{
    return [USER_APPURL stringByAppendingString:@"/mobile/Sign.do"];
}
+ (NSString *)MyMsgQuery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/MyMsgQuery.do"];
}
+ (NSString *)WorkLogStatusquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkLogStatusquery.do"];
}
+ (NSString *)WorkPlanStatusquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkPlanStatusquery.do"];
}
+ (NSString *)WorkLogquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkLogquery.do"];
}
+ (NSString *)WorkPlanquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkPlanquery.do"];
}
+ (NSString *)Signquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/Signquery.do"];
}
+ (NSString *)getenum
{
    return [USER_APPURL stringByAppendingString:@"/mobile/getenum.do"];
}
+ (NSString *)queryCust
{
    return [USER_APPURL stringByAppendingString:@"/mobile/queryCust.do"];
}
+ (NSString *)SendStoreLoc
{
    return [USER_APPURL stringByAppendingString:@"/mobile/SendStoreLoc.do"];
}
+ (NSString *)PhoneBookQuery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/PhoneBookQuery.do"];
}
+ (NSString *)SendWorkLog
{
    return [USER_APPURL stringByAppendingString:@"/mobile/SendWorkLog.do"];
}
+ (NSString *)SendWorkPlan
{
    return [USER_APPURL stringByAppendingString:@"/mobile/SendWorkPlan.do"];
}
+ (NSString *)SendImage
{
    return [USER_APPURL stringByAppendingString:@"/mobile/SendImage.do"];
}
+ (NSString *)queryEmployee
{
    return [USER_APPURL stringByAppendingString:@"/mobile/queryEmployee.do"];
}
+ (NSString *)queryLogEmployee
{
    return [USER_APPURL stringByAppendingString:@"/mobile/queryLogEmployee.do"];
}
+ (NSString *)WorkPlanToAuditquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkPlanToAuditquery.do"];
}
+ (NSString *)WorkLogToAuditquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkLogToAuditquery.do"];
}
+ (NSString *)DayOffQuery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/DayOffQuery.do"];
}
+ (NSString *)queryDayOffEmployee
{
    return [USER_APPURL stringByAppendingString:@"/mobile/queryDayOffEmployee.do"];
}
+ (NSString *)DayOffToAuditquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/DayOffToAuditquery.do"];
}
+ (NSString *)DayOffToAuditSend
{
    return [USER_APPURL stringByAppendingString:@"/mobile/DayOffToAuditSend.do"];
}
+ (NSString *)SendDayOff
{
    return [USER_APPURL stringByAppendingString:@"/mobile/SendDayOff.do"];
}
+ (NSString *)orgadefquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/orgadefquery.do"];
}
+ (NSString *)salesareaquery
{
    return [USER_APPURL stringByAppendingString:@"/mobile/salesareaquery.do"];
}
+ (NSString *)TempDealerSend
{
    return [USER_APPURL stringByAppendingString:@"/mobile/TempDealerSend.do"];
}
+ (NSString *)WorkLogSendAudit
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkLogSendAudit.do"];
}
+ (NSString *)WorkPlanSendAudit
{
    return [USER_APPURL stringByAppendingString:@"/mobile/WorkPlanSendAudit.do"];
}
+ (NSString *)SendLoc
{
    return [USER_APPURL stringByAppendingString:@"/mobile/SendLoc.do"];
}

+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    
    return [phoneTest evaluateWithObject:mobile];

}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
