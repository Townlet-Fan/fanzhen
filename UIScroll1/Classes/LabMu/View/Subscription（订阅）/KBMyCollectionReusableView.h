//
//  KBMyCollectionReusableView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/14.
//  Copyright © 2015年 Test. All rights reserved.
//

//我的订阅 viewForSupplementary（每个section头尾视图）
#import <UIKit/UIKit.h>
@class KBTwoSortModel;

@interface KBMyCollectionReusableView : UICollectionReusableView

//设置数据
- (void)setReusableViewWithModel:(KBTwoSortModel*)model andIsSectionHeader:(BOOL)isSectionHeader;

//画边界线
- (void)setBorderView;

@end
