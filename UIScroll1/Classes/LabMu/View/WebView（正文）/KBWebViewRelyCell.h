//
//  relyCell.h
//  UIScroll1
//
//  Created by kuibu technology on 15/11/23.
//  Copyright © 2015年 Test. All rights reserved.
//

//回复的cell

#import <UIKit/UIKit.h>

@class KBCommentModel;

@interface KBWebViewRelyCell : UITableViewCell

/**
 *  根据模型设置回复的cell
 *
 *  @param commentModel  回复cell的模型
 */

-(void)setReplyCellWithModel:(KBCommentModel *)commentModel;
@end
