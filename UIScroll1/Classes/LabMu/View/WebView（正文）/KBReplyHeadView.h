//
//  KBReplyHeadView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/31.
//  Copyright © 2015年 Test. All rights reserved.
//

//回复的头部View
#import <UIKit/UIKit.h>

@protocol KBReplyHeadViewDelegate <NSObject>

-(void)popToHot;

@end

@interface KBReplyHeadView : UIView

/**
 *  相关回复label
 */
@property (nonatomic,strong)UILabel * refrenceReplyLabel;

/**
 *  分割View
 */
@property (nonatomic,strong)UIView * separatorView;


@property (nonatomic,weak)id<KBReplyHeadViewDelegate>delegate;

//设置回复头部的数据
-(void)setReplyHeadData:(NSString * )replyHeadUrl withComment:(NSString *)comment withReplyCount:(int)replyCount;

@end
