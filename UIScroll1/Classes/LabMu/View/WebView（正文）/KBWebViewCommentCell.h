//
//  DiscussCell.h
//  UIScroll1
//
//  Created by eddie on 15-4-19.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//WebView下面评论的Cell

#import <UIKit/UIKit.h>

@class KBCommentModel,KBThumpButton;

@interface KBWebViewCommentCell : UITableViewCell

/**
 *  点赞的button
 */
@property (nonatomic,strong) KBThumpButton *thumbUp;

/**
 *  根据模型设置评论的cell
 *
 *  @param commentModel  评论cell的模型
 */
-(void)setCommentCellWithModel:(KBCommentModel *)commentModel;
@end