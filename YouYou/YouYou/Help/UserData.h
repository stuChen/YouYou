//
//  UserData.h
//  Sahara
//
//  Created by Chen on 15/6/30.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+ (BOOL)UserLoginState;
+ (void)WriteUserInfo:(id)dic;

+ (void)Value:(NSString *)value forKey:(NSString *)key;
+ (void)Deletekey:(NSString *)key;
+ (NSString *)keyForUser:(NSString *)key;
@end
