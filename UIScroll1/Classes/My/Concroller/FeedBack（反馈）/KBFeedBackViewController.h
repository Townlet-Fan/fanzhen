//
//  FeedBackTVC.h
//  UIScroll1
//
//  Created by eddie on 15-6-14.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//反馈页面里的具体内容

#import <UIKit/UIKit.h>

@interface KBFeedBackViewController : UITableViewController
/**
 *  反馈问题的标题
 */
@property (nonatomic,strong)NSString *proTypeStr;
/**
 *  反馈的类型
 */
@property (nonatomic,assign)int feedbackType;

/**
 *  反馈内容默认的输入
 */
@property (nonatomic,strong)  NSString *placeHolderStr;
/**
 *  反馈内容的默认输入的Label
 */
@property (nonatomic,strong) UILabel *placeHolderLable;

@end
