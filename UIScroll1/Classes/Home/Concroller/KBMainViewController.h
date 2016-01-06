//
//  mainViewController.h
//  UIScroll1
//
//  Created by eddie on 15-3-21.
//  Copyright (c) 2015年 Test. All rights reserved.

//主页

#import <UIKit/UIKit.h>


@interface KBMainViewController : UIViewController
<UIScrollViewAccessibilityDelegate>

/**
 *  主页的scrollView
 */
@property  UIScrollView *scrol;
/**
 *  滑动的点击button 滑图上面的那一栏
 */
@property UIButton *oldButton;
/**
 *  主页的导航栏代理
 */
@property id navdelegate;

@end
