//
//  RightTableViewCell.h
//  UIScroll1
//
//  Created by 樊振 on 15/10/11.
//  Copyright © 2015年 Test. All rights reserved.
//

//订阅三级标签cell

#import <UIKit/UIKit.h>
@class KBTwoSortModel,KBThreeSortModel,KBColumnSortButton;

@protocol KBthreeSortSubscriptionDelegate <NSObject>

//加关注
- (void)addInterestCell:(KBColumnSortButton*)button;

//取消关注
- (void)removecell:(KBColumnSortButton*)button;

@end

@interface KBThreeSortSubscriptionViewCell : UITableViewCell

@property id delegate;

//设置cell数据
- (void)setThreeSortSubscriptionWithModel:(KBThreeSortModel*)model andTwoSortModel:(KBTwoSortModel*)twoSortModel;

@end
