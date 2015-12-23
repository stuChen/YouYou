//
//  UserData.m
//  Sahara
//
//  Created by Chen on 15/6/30.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "UserData.h"

@implementation UserData
+ (BOOL)UserLoginState
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_dic"])
    {
        return YES;
    }
    else return NO;
}

+ (void)cleanUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_dic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)WriteUserInfo:(id)dic
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_dic"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];//[dic dataUsingEncoding:NSUTF8StringEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_dic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
    /*
     {
     HeadPic = "<null>";
     NickName = "<null>";
     UserId = 7;
     }

*/

+ (void)Value:(NSString *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)Deletekey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)keyForUser:(NSString *)key
{
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return string;
}

@end
