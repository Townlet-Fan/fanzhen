//
//  AppDelegate.h
//  UIScroll1
//
//  Created by eddie on 15-3-20.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
/**
 *  导航栏的控制器的代理
 */
@property id NavigationController;
/**
 *  窗口
 */
@property (strong, nonatomic) UIWindow *window;
/**
 *  通知的数据的集合
 */
@property (strong, nonatomic) NSDictionary *userInfo;
/**
 *  http请求
 */
@property AFHTTPRequestOperationManager *manager;


/**
 *  网络状态
 */
@property (strong, nonatomic) Reachability *reach;

@end

