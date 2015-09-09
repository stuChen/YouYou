//
//  RequestManager.m
//  Sahara
//
//  Created by Chen on 15/6/12.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

+ (void)setCookies
{
    NSMutableDictionary * cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"username" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"rainbird" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    //    [cookieProperties setObject:@"99798522F2EF914167CAB59CEEF41F7EB9992BCCE33EB25D4ACB3663257F346985E34D36D9FECF65EDE57B88BB949A9A996443B7D34397AD04029226A926B6878B5CA7BB5F5694660936B2DD813BA97B8BA55115B24B0C2DD7369E5772E09BCE" forKey:@".ASPXAUTH"];
    NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

    //1.管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //3.请求
    [manager GET:@"http://211.149.223.24:4866/App/BasicInfo/SetCookie" parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = [NSHTTPCookie cookiesWithResponseHeaderFields:operation.response.allHeaderFields forURL:[NSURL URLWithString:@"http://211.149.223.24:4866/App/BasicInfo/SetCookie"]];
        NSHTTPCookie *cookie = [array firstObject];
        [cookieProperties setObject:cookie.value forKey:@".ASPXAUTH"];
//        [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"cookie"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [RequestManager requsetA];

    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"%@", error);
    }];

}
+ (void)requsetA
{
    [[AFHTTPRequestOperationManager manager] POST:@"http://211.149.223.24:4866/App/Run/StartRunning" parameters:@{@"userId":@"4"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@",responseObject);
//        [RequestManager requsetB:[NSString stringWithFormat:@"%@",responseObject[@"runningId"]]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"runningId"]] forKey:@"runningId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
//    [[AFHTTPRequestOperationManager manager] GET:@"http://211.149.223.24:4866/App/BasicInfo/GetAuth" parameters:@{@"userId":@"4"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        DLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}
+ (void)requsetB:(NSArray *)array
{

    
    NSString *DataStr = [RequestManager JsonStr:@[@{@"DateTime":@"2015-5-1 12:02:56",@"LatLngs":array}]];
    
    NSDictionary *dic = @{@"Id":[[NSUserDefaults standardUserDefaults] objectForKey:@"runningId"],
                          @"Name":@"1",
                          @"Tag":@"1",
                          @"Record":@"1",
                          @"Distance":@"1",
                          @"TimeSpan":@"",
                          @"SpeedPaces":@"1"
                          };
    
    
    [[AFHTTPRequestOperationManager manager] POST:@"http://211.149.223.24:4866/App/Run/SaveRunning" parameters:@{@"data":[RequestManager JsonStr:dic],@"coordinates":DataStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@",responseObject);
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"上传失败!"];
    }];
}


+ (void)PostUrl:(NSString *)url loding:(NSString *)loding dic:(NSDictionary *)dic response:(void (^)(id))response
{
    if (loding) {
        [SVProgressHUD showWithStatus:loding];
    }
    [[AFHTTPRequestOperationManager manager] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        response(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        response(nil);
    }];

}
//上传图片
+ (void)PostImageDic:(NSDictionary *)dic imageData:(NSData *)data response:(void (^)(id response))callback{
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[RequestUrl SendImage] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        //        if ([type integerValue] == 0)
//        //        {∫
//        [formData appendPartWithFileData:data name:@"collect_jpg" fileName:@"avatar.png" mimeType:@"image/jpeg"];
//        //        }
//        //        else if([type integerValue] == 1)
//        //        {
//        //            [formData appendPartWithFileData:data name:@"pic" fileName:@"voice" mimeType:@"audio/x-aiff"];
//        //        }
//        //        else
//        //        {
//        //            [formData appendPartWithFileData:data name:@"pic" fileName:@"voice" mimeType:@"multipart/form-data"];
//        //        }
//    } error:nil];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];    
//    NSProgress *progress = nil;
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        
//        if (error)
//        {
//            callback(nil);
//            
//        } else
//        {
//            callback(responseObject);
//        }
//        
//    }];
//    [uploadTask resume];
    
    
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    [manager1 POST:[RequestUrl SendImage] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"collect_jpg" fileName:@"avatar.png" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil);
    }];
}


+ (NSString *)JsonStr:(id)obj
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


@end
