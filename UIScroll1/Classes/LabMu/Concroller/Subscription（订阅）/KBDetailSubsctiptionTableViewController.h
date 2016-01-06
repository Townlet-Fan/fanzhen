//
//  NewFindTableViewController.h
//  UIScroll1
//
//  Created by 樊振 on 15/10/11.
//  Copyright © 2015年 Test. All rights reserved.
//

//具体订阅的标签

#import <UIKit/UIKit.h>

@interface KBDetailSubsctiptionTableViewController : UIViewController

/**
 *  一级分类（共四个）
 */
@property  NSMutableArray  *typeOneArray1;

/**
 *  关注的三级分类
 */
@property   NSMutableArray *interestOneArray;

/**
 *  二级分类
 */
@property   NSMutableArray *typeOneInterestStructArray;

/**
 *  是否发生变化
 */
@property BOOL isChanged;

/**
 *  右边的表
 */
@property UITableView *rightTableView;

@end
