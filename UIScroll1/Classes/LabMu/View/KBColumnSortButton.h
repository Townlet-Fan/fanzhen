//
//  ButtonCell.h
//  UIScroll1
//
//  Created by eddie on 15-4-6.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//栏目cell 里的 三级分类的点击button

#import <UIKit/UIKit.h>

@interface KBColumnSortButton : UIButton
/**
 * cell的代理
 */
@property (nonatomic,strong)id cellDelegate;
/**
 *  二级分类的代理
 */
@property (nonatomic,strong)id findType_2Delegate;
/**
 *  三级分类的代理
 */
@property (nonatomic,strong)id findType_3Delegate;
/**
 *  选中的IndexPath
 */
@property (nonatomic,strong)NSIndexPath *indexPath;
/**
 *  选中的section
 */
@property (nonatomic,assign)NSInteger section;
@end
