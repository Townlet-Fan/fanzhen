//
//  KBMyCollectBottomView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

//收藏下的UIView 删除和筛选
#import <UIKit/UIKit.h>

@protocol KBMyCollentBottomViewDelegate <NSObject>

-(void)beginDelete;//删除收藏
-(void)beginSelect;//筛选收藏

@end

@interface KBMyCollectBottomView : UIView

/**
 *  收藏下的UIView
 */
@property (nonatomic,strong) UIView * underCollectView;
/**
 *  删除的button
 */
@property (nonatomic,strong)UIButton * deleteButton;
/**
 *  删除的label
 */
@property (nonatomic,strong) UILabel * deleteLabel;
/**
 *  删除的Image
 */
@property (nonatomic,strong) UIImageView * deleteImageView;

/**
 *  筛选的button
 */
@property (nonatomic,strong) UIButton * selectButton;

/**
 *  筛选的label
 */
@property (nonatomic,strong) UILabel * selectLabel;

/**
 *  筛选的Image
 */
@property (nonatomic,strong) UIImageView * selectImageView;

@property (nonatomic,weak) id<KBMyCollentBottomViewDelegate>delegate;

@end
