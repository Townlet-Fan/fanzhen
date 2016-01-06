//
//  KBHomeHeadView.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/10.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KBHomeArticleModel;

@protocol KBHomeHeadViewDelegate <NSObject>

-(void)headViewTapActionWithartModel:(KBHomeArticleModel *)headViewModel;

@end

@interface KBHomeHeadView : UIView

/**
 * section的head的Label
 */
@property(nonatomic,strong) UILabel * sectionHeadLabel;

- (instancetype)initWithFrame:(CGRect)frame;

- (CGFloat)setSectionImageWith:(KBHomeArticleModel *)model andSection:(NSInteger)indexPath withBreakArray:(NSArray *)breakArray withKbHomeHeadView:(KBHomeHeadView *)homeHeadView;

@property (nonatomic,weak)id<KBHomeHeadViewDelegate>delegate;
@end
