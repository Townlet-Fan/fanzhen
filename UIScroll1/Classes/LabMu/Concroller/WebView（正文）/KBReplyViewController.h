//
//  replyViewController.h
//  UIScroll1
//
//  Created by kuibu technology on 15/11/23.
//  Copyright © 2015年 Test. All rights reserved.

//评论回复页面

#import <UIKit/UIKit.h>
#import "KBThumpButton.h"
@interface KBReplyViewController : UIViewController
/**
 *  回复的代理
 */
@property id replyDelegate;
/**
 *  某条评论的text
 */
@property NSString *discussTextL;
/**
 *  回复的textView
 */
@property (nonatomic,strong) UITextView *textView;

/**
 *  默认输入的字符串
 */
@property (nonatomic,strong)  NSString *placeHolderStr;
/**
 *  默认输入的Label
 */
@property (nonatomic,strong) UILabel *placeHolderLable;
/**
 *  评论的Id
 */
@property (nonatomic,assign) NSInteger commentId;
/**
 *  文章 pageId
 */
@property (nonatomic,assign) NSInteger pageId;
/**
 *  toolbar
 */
@property (nonatomic,strong) UIView *toolBar;

/**
 *  选择哪条评论
 */
@property (nonatomic,assign)NSIndexPath * discussSelectedIndex;

/**
 * 保存评论的数组
 */
@property NSMutableArray * discuss_reply_Array;
@end

