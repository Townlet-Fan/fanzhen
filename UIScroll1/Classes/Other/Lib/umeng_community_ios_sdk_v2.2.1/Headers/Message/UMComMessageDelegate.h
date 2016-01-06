//
//  UMComMessageDelegate.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UMComMessageDelegate <NSObject>

- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 *  添加别名
 
 */
- (void)addAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;

/**
 *  删除别名
 
 */
- (void)removeAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;

@end
