//
//  KBComFilterTopicsViewCell.h
//  UIScroll1
//
//  Created by 樊振 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//画三角形：1，单独画，呈正方形颜色有问题 2，在cell类画，三角形被图覆盖显示不出来

#import <UIKit/UIKit.h>
@protocol UMComClickActionDelegate;

@class UMComTopic,UMComImageView;

@protocol UMComFilterTopicsViewCellDelegate <NSObject>

- (void)showLoginView;

@end
@interface UMComFilterTopicsViewCell : UITableViewCell<UIGestureRecognizerDelegate>
/**
 *  话题背景图
 */
@property (nonatomic,strong) UMComImageView *backgroundImageView;
/**
 *  话题名称
 */
@property (nonatomic,strong) UILabel *labelName;
/**
 *  话题描述
 */
@property (nonatomic,strong) UILabel *labelDesc;
/**
 *  关注button
 */
//@property (nonatomic,strong) UIButton *butFocuse;
/**
 *  话题对象
 */
@property (nonatomic,strong) UMComTopic *topic;
/**
 *  话题图标
 */
//@property (nonatomic,strong) UMComImageView *topicIcon;

@property (nonatomic,assign) BOOL isRecommendTopic;

@property (nonatomic, copy) void (^clickOnTopic)(UMComTopic *topic);

@property (nonatomic,weak) id<UMComClickActionDelegate,UMComFilterTopicsViewCellDelegate>delegate;

- (void)setWithTopic:(UMComTopic *)topic;

- (void)setFocused:(BOOL)focused;
@end
