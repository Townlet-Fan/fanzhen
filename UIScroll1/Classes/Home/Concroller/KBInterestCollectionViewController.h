//
//  KBInterestCollectionViewController.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

//主界面的兴趣
#import <UIKit/UIKit.h>

@interface KBInterestCollectionViewController : UICollectionViewController

/**
 *  一级分类的标号
 */
@property (nonatomic,assign) NSInteger  itemNumber;

/**
 *  第一次加入tableViewController时，加入动画
 */
@property (nonatomic,assign) BOOL isFirstAddTable;

//刷新分类
-(void)updateFocus;

@end
