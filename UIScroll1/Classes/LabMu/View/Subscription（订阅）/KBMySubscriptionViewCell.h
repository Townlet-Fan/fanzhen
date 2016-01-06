//
//  InterestedCollectionViewCell.h
//  UIScroll1
//
//  Created by 樊振 on 15/10/14.
//  Copyright © 2015年 Test. All rights reserved.
//

//我的订阅cell

#import <UIKit/UIKit.h>

@class KBThreeSortModel,KBColumnSortButton;

@protocol KBMySubscriptionViewDelegate <NSObject>

//长按cell的代理
- (void)mySubscriptionViewLongPressActionWithIndexPath:(NSIndexPath *)indexPath;

//点击删除图标的代理
- (void)mySubscriptionCellDelete:(NSIndexPath*)indexPath;

@end

@interface KBMySubscriptionViewCell : UICollectionViewCell

@property(nonatomic,strong) id<KBMySubscriptionViewDelegate> delegate;

//用Model创建view
- (void)setMySubscriptionViewWithModel:(KBThreeSortModel*)model andIndexPath:(NSIndexPath*)indexPath;

- (void)setDeleteButtonHidden:(BOOL)hidden;

@end
