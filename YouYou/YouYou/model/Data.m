//
//  Data.m
//  YouYou
//
//  Created by Chen on 15/7/2.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "Data.h"

@implementation Data
+ (Data *)Share
{
    static Data *data = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        
        data = [[Data alloc]init];
    });
    return data;
}


//获取客户/门店数据
- (void)initCustomData
{
    NSDictionary *dic = @{@"username":self.username,
                          @"token":self.token,
                          @"is_store":@"1",
                          @"is_get_loc":@""};
    
    [RequestManager PostUrl:[RequestUrl queryCust] loding:nil dic:dic response:^(id response) {
        if (response) {
            if ([response[@"status_code"] integerValue] == 0) {
                self.CustomArray = response[@"body"];
            }
            else {

            }
            
        }
        else {

        }
        
    }];

}
/**
 获取销售组织
 */
- (void)initOrgadefquery
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"orgadefquery"]) {
        self.orgadefquery = [[NSUserDefaults standardUserDefaults]objectForKey:@"orgadefquery"];
    }
    
    else {
        NSDictionary *dic = @{@"username":self.username,
                              @"token":self.token,
                              @"page_size":@"999999",
                              @"page_no":@""};
        
        [RequestManager PostUrl:[RequestUrl orgadefquery] loding:nil dic:dic response:^(id response) {
            if (response) {
                if ([response[@"status_code"] integerValue] == 0) {
                    self.orgadefquery = response[@"body"];
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"orgadefquery"];
                    [[NSUserDefaults standardUserDefaults] setObject:response[@"body"] forKey:@"orgadefquery"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else {
                    
                }
                
            }
            else {
                
            }
            
        }];
    }
    
}


//获取枚举类型
- (void)initData:(NSDictionary *)dic
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"enumArray"]) {
        [self initDataType:[[NSUserDefaults standardUserDefaults] objectForKey:@"enumArray"]];
    }
    else {
        [RequestManager PostUrl:[RequestUrl getenum]
                         loding:nil
                            dic:dic
                       response:^(id response) {
                           if ([response[@"status_code"] integerValue] == 0) {
                               [self initDataType:response[@"body"]];
                               [[NSUserDefaults standardUserDefaults] setObject:response[@"body"] forKey:@"enumArray"];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                           }
                       }];
    }
    
}
- (void)initDataType:(NSArray *)array
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        NSString *string = dic[@"type"];
        if (![arr containsObject:string]) {
            [arr addObject:string];
        }
    }
    for (NSString *str in arr) {
        NSMutableArray *array1 = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in array) {
            if ([str isEqualToString:dic[@"type"]]) {
                [array1 addObject:dic[@"model"]];
            }
        }
        [self setValue:array1 forKey:[str stringByAppendingString:@"Array"]];
    }
}
//获取值
- (NSString *)ChooseInfo:(NSDictionary *)dic key:(NSString *)key array:(NSArray *)array
{
    NSString *CompleteStatus = [NSString stringWithFormat:@"%@",dic[key]];
    if (CompleteStatus.length == 0) {
        CompleteStatus = @"未知";
    }
    else {
        if (array) {
            
            BOOL isHave = NO;
            for (NSDictionary *dic in array) {
                if ([dic[@"key"] integerValue] == [CompleteStatus integerValue]) {
                    CompleteStatus = dic[@"value"];
                    isHave = YES;
                    break;
                }
            }
            if (!isHave) {
                CompleteStatus = @"未知";
            }
        }
        else {
            CompleteStatus = @"未知";
        }
    }
    return CompleteStatus;
}

@end
