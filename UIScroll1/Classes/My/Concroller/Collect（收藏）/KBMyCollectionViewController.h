//
//  NewCollectionVC.h
//  UIScroll1
//
//  Created by xiaoxuehui on 15/7/31.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//收藏页面

#import <UIKit/UIKit.h>

@interface KBMyCollectionViewController : UIViewController
/**
 *  root的代理
 */
@property (nonatomic,strong)id rootDelegate;
/**
 *  tableview
 */
@property (nonatomic,strong) UITableView *tableView;

//取消收藏
-(void)CancelCollect:(NSIndexPath * )indexpath;
@end
