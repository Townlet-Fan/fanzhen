//
//  ThumbUpCell.h
//  UIScroll1
//
//  Created by kuibu technology on 15/7/31.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//点赞的cell

#import <UIKit/UIKit.h>

@class KBMyMessagePraiseModel;

@interface KBMyMessageThumbUpViewCell : UITableViewCell

/**
 *  根据模型设置消息点赞的cell
 *
 *  @param myMessagePraiseModel  消息点赞cell的模型
 */
-(void)setMessagePraiseCellWithModel:(KBMyMessagePraiseModel *)myMessagePraiseModel;
@end
