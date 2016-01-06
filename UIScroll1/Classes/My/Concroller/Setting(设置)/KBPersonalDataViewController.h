//
//  PersonalDataViewController.h
//  UIScroll1
//
//  Created by eddie on 15-4-12.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//个人信息页面

#import <UIKit/UIKit.h>

@interface KBPersonalDataViewController : UIViewController

//压缩图片
-(UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size;
/**
 *  root的代理
 */
@property (nonatomic,strong)id rootDelegate;
/**
 *  用户登录的时候点击Menu的头像进入个人信息
 */
@property (nonatomic,strong) UIButton *pushBtn;

@end
