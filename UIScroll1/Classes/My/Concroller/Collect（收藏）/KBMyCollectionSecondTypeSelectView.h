//
//  KBMyCollectionSecondTypeSelectView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

//收藏筛选出现的view
#import <UIKit/UIKit.h>

@protocol KBMyCollectionSecondTypeSelectViewDelegate <NSObject>

-(void)showAll;

@end

@interface KBMyCollectionSecondTypeSelectView : UIView
/**
 *  右侧的view
 */
@property (nonatomic,strong) UIView *selectView;

/**
 *  全部button
 */
@property (nonatomic,strong) UIButton *allBtn;

/**
 *  全部button的label
 */
@property (nonatomic,strong) UILabel * btnLabel;

/**
 *  收藏的总数
 */
@property (nonatomic,assign) int allcount;



@property (nonatomic,weak) id<KBMyCollectionSecondTypeSelectViewDelegate>delegate;

@end
