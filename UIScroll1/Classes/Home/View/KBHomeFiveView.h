//
//  KBHomeFiveView.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

// 首页五个  cell的视图
#import <UIKit/UIKit.h>

@class KBHomeArticleModel;
@interface KBHomeFiveView : UIView


/**
 *  五个的文章的标题
 */
@property(nonatomic,strong)UILabel * FiveImageLabel;
/**
 *  根据模型设置四个文章的view
 *
 *  @param model 五个的模型
 */
- (void)setViewWithFourViewModel:(KBHomeArticleModel *)model;
/**
 *  根据模型设置四个文章的view
 *
 *  @param model 五个的模型
 */
-(void)setViewWithTopViewModel:(KBHomeArticleModel *)model;


@end
