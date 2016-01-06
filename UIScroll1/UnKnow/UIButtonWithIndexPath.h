//
//  UIButtonWithIndexPath.h
//  UIScroll1
//
//  Created by kuibu technology on 15/6/23.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonWithIndexPath : UIButton
/**
 *  button所处的indexPath
 */
@property (nonatomic,assign)NSIndexPath *indexPath;

/**
 *  代理
 */
@property (nonatomic,weak)id delegate;

/**
 *  是否置顶
 */
@property (nonatomic,assign)BOOL whetherTotTop;

@end
