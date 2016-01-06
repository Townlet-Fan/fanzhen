//
//  KBHTTPTool.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHTTPTool.h"

@implementation KBHTTPTool

+ (void)getRequestWithUrlStr:(NSString *)urlStr parameters:(id)parameters completionHandr:(HttpSuccessBlock)sucess error:(HttpFailureBlock)failed
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest: [[AFJSONRequestSerializer serializer] requestWithMethod: @"GET" URLString: urlStr parameters: parameters error: nil] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failed(error);
        } else {
            sucess(responseObject);
         }
    }];
    
    [dataTask resume];
}

+ (void)postRequestWithUrlStr:(NSString *)urlStr parameters:(id)parameters completionHandr:(HttpSuccessBlock)sucess error:(HttpFailureBlock)failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST: urlStr parameters: parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error) {
           // NSLog(@"error:%@",error);
            failed(error);
        }
    }];
}


@end
