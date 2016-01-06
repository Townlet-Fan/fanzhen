//
//  InterestedCollectionViewController.h
//  UIScroll1
//
//  Created by 樊振 on 15/10/13.
//  Copyright © 2015年 Test. All rights reserved.
//

//我的订阅主要视图

#import <UIKit/UIKit.h>


@interface KBMySubcriptionViewController : UICollectionViewController

/**
 *  二级分类
 */
@property   NSMutableArray *typeOneInterestStruct;

/**
 *  一级分类的Id
 */
@property   int itemNumber;

/**
 *  关注的三级分类（所有关注的三级标签构成这个数组）
 */
@property NSMutableArray *typeThreeInterestedStruct;//关注的三级分类

/**
 *  是否发生变化
 */
@property BOOL isChanged;

@end
