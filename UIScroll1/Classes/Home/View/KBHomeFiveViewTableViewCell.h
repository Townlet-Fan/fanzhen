//
//  recommendTableViewCell1.h
//  UIScroll1
//
//  Created by kuibu technology on 15/10/30.
//  Copyright © 2015年 Test. All rights reserved.

//首页 五个view的cell

#import <UIKit/UIKit.h>
@class KBHomeArticleModel;
@protocol RecommendFiveDelegate <NSObject>

//文章view的点击 代理  传模型出去
- (void)fiveViewTapActionWithartModel:(KBHomeArticleModel *)fiveModel;

@end

@interface KBHomeFiveViewTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RecommendFiveDelegate> delegate;


//用数组创建 view
- (void)setFiveViewWithArray:(NSArray *)Fivearray;
@end
