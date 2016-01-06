//
//  MyFooterTVC.h
//  UIScroll1
//
//  Created by eddie on 15-5-3.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//足迹页面

#import <UIKit/UIKit.h>

@interface KBMyFooterViewController : UIViewController
/**
 *  main的delegate
 */
@property (nonatomic,strong) id mainDelegate;
/**
 *  root的delegate
 */
@property (nonatomic,strong) id rootDelegate;
/**
 *  tabelview
 */
@property (nonatomic,strong) UITableView * tableView;
@end
