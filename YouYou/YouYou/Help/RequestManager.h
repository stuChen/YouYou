//
//  RequestManager.h
//  Sahara
//
//  Created by Chen on 15/6/12.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject
+ (void)setCookies;
+ (void)requsetA;
+ (void)requsetB:(NSArray *)array;

+ (void)PostUrl:(NSString *)url loding:(NSString *)loding dic:(NSDictionary *)dic response:(void(^)(id response))response;
//上传图片
+ (void)PostImageDic:(NSDictionary *)dic imageData:(NSData *)data response:(void (^)(id response))callback;
+ (NSString *)JsonStr:(id)obj;
@end
