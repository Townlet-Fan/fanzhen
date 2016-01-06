//
//  KBHTTPTool.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.

//封装了 HTTP请求

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface KBHTTPTool : NSObject

typedef void (^HttpSuccessBlock)(id responseObject);
typedef void (^HttpFailureBlock)(NSError *error);



// 直接返回JSON数据的请求
+ (void)getRequestWithUrlStr:(NSString *)urlStr parameters:(id)parameters completionHandr:(HttpSuccessBlock)sucess error:(HttpFailureBlock)failed;

//
+ (void)postRequestWithUrlStr:(NSString *)urlStr parameters:(id)parameters completionHandr:(HttpSuccessBlock)sucess error:(HttpFailureBlock)failed;


@end
