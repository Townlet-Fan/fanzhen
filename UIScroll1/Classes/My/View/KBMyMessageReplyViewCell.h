//
//  MessageCell.h
//  UIScroll1
//
//  Created by eddie on 15-4-25.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//消息里回复的cell

#import <UIKit/UIKit.h>

@class KBMyMessagReplyModel;

@interface KBMyMessageReplyViewCell : UITableViewCell


/**
 *  根据模型设置消息回复的cell
 *
 *  @param myMessageModel  消息回复cell的模型
 */
-(void)setMessageReplyCellWithModel:(KBMyMessagReplyModel *)myMessageModel;

@end
