//
//  SearchViewController.h
//  UIScroll1
//
//  Created by xiaoxuehui on 15/8/23.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//搜索视图


#import <UIKit/UIKit.h>

@interface KBSearchViewController : UIViewController
/**
 *  所有的三级分类的名字的数组
 */
@property (nonatomic,strong) NSMutableArray *allType3StringArray;

/**
 *  所有三级分类的数组
 */
@property (nonatomic,strong) NSMutableArray *allType3Array;
/**
 *  搜素的代理
 */
@property (nonatomic,strong) id searchdelegate;
@end
