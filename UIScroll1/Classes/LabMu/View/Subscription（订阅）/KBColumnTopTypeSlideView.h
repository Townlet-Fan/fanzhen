//
//  TypeNavView.h
//  UIScroll1
//
//  Created by kuibu technology on 15/5/30.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//栏目顶部的分类滑动视图

#import <UIKit/UIKit.h>



@interface KBColumnTopTypeSlideView : UIView
/**
 *  点击button 的集合数组
 */
@property (nonatomic,strong) NSMutableArray *buttonArray;
/**
 *  选中的点击button
 */
@property (nonatomic,strong) UIButton *selectedBtn;

/**
 *  订阅的代理
 */
@property (nonatomic,strong)id findVCDelegate;

@end
