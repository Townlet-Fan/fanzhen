//
//  KBHomeArcticleView.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

//首页文章的view

#import <UIKit/UIKit.h>

@class KBHomeArticleModel;

@interface KBHomeArcticleView : UIView

/**
 *  文章的标题
 */
@property(nonatomic,strong) UILabel *arcticleLabel;

/**
 *  根据模型设置文章的view
 *
 *  @param model 文章的模型
 */
- (void)setViewWithartModel:(KBHomeArticleModel *)model;

@end
