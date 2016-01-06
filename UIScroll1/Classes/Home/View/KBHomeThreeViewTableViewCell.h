//
//  RecommendTableViewCell.h
//  UIScroll1
//
//  Created by kuibu technology on 15/9/23.
//  Copyright © 2015年 Test. All rights reserved.

//首页顶部 三个cell视图

#import <UIKit/UIKit.h>

@class KBHomeArticleModel;

@protocol RecommendThreeDelegate <NSObject>


//文章view的点击 代理  传模型出去
- (void)artViewTapActionWithartModel:(KBHomeArticleModel *)artModel;

@end

@interface KBHomeThreeViewTableViewCell : UITableViewCell

@property (nonatomic,weak) id<RecommendThreeDelegate> delegate;



//用数组创建 view
- (void)setAcrticleViewWithArray:(NSArray *)array;

@end


