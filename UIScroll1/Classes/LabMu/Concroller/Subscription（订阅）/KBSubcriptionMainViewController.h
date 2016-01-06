//
//  FindViewController.h
//  UIScroll1
//
//  Created by eddie on 15-4-2.
//  Copyright (c) 2015年 Test. All rights reserved.

//订阅的主要视图

#import <UIKit/UIKit.h>

@interface KBSubcriptionMainViewController : UIViewController

/**
 *  root的代理
 */
@property  id  rootDelegate;

/**
 *  一级分类的Id
 */
@property NSInteger TypeOneInteger;

/**
 *  tableView
 */
@property UITableView *tableview;

/**
 *  所有的三级分类的数组
 */
@property NSMutableArray *allType3Array;

/**
 *  所有三级分类名字的数组
 */
@property NSMutableArray *allType3StringArray;




@end