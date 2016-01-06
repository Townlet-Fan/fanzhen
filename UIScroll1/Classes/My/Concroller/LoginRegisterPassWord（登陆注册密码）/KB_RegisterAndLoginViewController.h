//
//  KB_RegisterAndLoginViewController.h
//  UIScroll1
//
//  Created by kuibu on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//登录注册 控制器

#import <UIKit/UIKit.h>

@interface KB_RegisterAndLoginViewController : UIViewController
/**
 *  root的代理
 */
@property (nonatomic,weak) id rootDelegate;

//滑动视图
@property(nonatomic,strong)UIScrollView* scrollView;

@end
