//
//  AboutKuiBuViewController.h
//  UIScroll1
//
//  Created by kuibu technology on 15/11/17.
//  Copyright © 2015年 Test. All rights reserved.
//

//关于我们

#import <UIKit/UIKit.h>

@interface KBAboutKuiBuViewController : UIViewController
/**
 *  导航栏控制器的代理
 */
@property (nonatomic,strong) id NavigationController;

/**
 *  root的代理
 */
@property (nonatomic,strong)id rootDelegate;
@end
