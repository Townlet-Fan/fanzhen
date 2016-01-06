//
//  MessageTableVC.h
//  UIScroll1
//
//  Created by eddie on 15-4-25.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//我里面的 消息回复页面


#import <UIKit/UIKit.h>

@interface KBMyMessageReplyViewController : UITableViewController
/**
 *  消息的代理
 */
@property (nonatomic,strong ) id parentVCDelegate;

/**
 *  当有新消息的时候 刷新回复列表
 */
-(void)myMessageReplyInit;
@end
