//
//  BtnWithIndex.h
//  UIScroll1
//
//  Created by xiaoxuehui on 15/10/7.
//  Copyright (c) 2015年 Test. All rights reserved.

//点赞button

#import <UIKit/UIKit.h>

@interface KBThumpButton : UIButton
/**
 *  点赞的行数
 */
@property (nonatomic,strong ) NSIndexPath *indexPath;
/**
 *  点赞数
 */
@property (nonatomic,assign) int count;



@end
