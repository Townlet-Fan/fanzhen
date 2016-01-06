//
//  KBMyView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/24.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KBMyViewDelegate <NSObject>

-(void)pushFooter;//点击足迹的方法
-(void)pushCollection;//点击收藏的方法

@end
//Menu的上面的view

@interface KBMyView : UIView

/**
 *  头像的headImageView
 */
@property (nonatomic,strong) UIImageView * headImageView;

/**
 * 头像的button
 */
@property (nonatomic,strong) UIButton * headViewButton;

/**
 *  用户的昵称的button;
 */
@property (nonatomic,strong) UIButton * userNameLabelButton;

/**
 *  足迹Button
 */
@property (nonatomic,strong) UIButton * footerButton;

/**
 *  收藏Button
 */
@property (nonatomic,strong)UIButton * collectButton;

@property (nonatomic,weak)id<KBMyViewDelegate>delegate;
@end
