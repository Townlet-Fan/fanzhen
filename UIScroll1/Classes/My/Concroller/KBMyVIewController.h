//
//  menuViewController.h
//  UIScroll1
//
//  Created by eddie on 15-3-21.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//我的主页面

#import <UIKit/UIKit.h>

@interface KBMyVIewController : UIViewController
/**
 *  menuTableView
 */
@property (nonatomic,strong )UITableView *menuTableView;
/**
 *  root的代理
 */
@property (nonatomic,strong )id rootDelegate;
@end
