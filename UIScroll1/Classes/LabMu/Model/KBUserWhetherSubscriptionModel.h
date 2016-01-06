//
//  KBLoginUserWhetherSubscriptionModel.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/14.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBUserWhetherSubscriptionModel : NSObject

/**
 *  判断登录用户是否订阅了分类
 */
+(BOOL)loginUserWhetherSubscription:(NSInteger)itemNumber;

/**
 *  判断未登录用户是否订阅了分类
 */
+(BOOL)noLoginUserWhetherSubscription:(NSInteger)itemNumber;
@end
