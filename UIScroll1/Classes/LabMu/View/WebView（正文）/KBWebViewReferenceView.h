//
//  ReferenceView.h
//  UIScroll1
//
//  Created by xiaoxuehui on 15/10/7.
//  Copyright (c) 2015年 Test. All rights reserved.


//WebView下面的相关推荐

#import <UIKit/UIKit.h>

@interface KBWebViewReferenceView : UIView
/**
 *  广告位的ImageView
 */
@property (nonatomic,strong) UIImageView *advertView;

/**
 *  相关推荐的label
 */
@property (nonatomic,strong) UILabel * recommendLabel;

/**
 *  该文章所属的三级分类的名字
 */
@property (nonatomic,strong) UILabel *typeThreeLable;

/**
 *  该文章所属的三级分类的Icon
 */
@property (nonatomic,strong) UIImageView *typeThreeImageView;

/**
 *  三级分类的可点button (现在不可点)
 */
@property (nonatomic,strong) UIButton *typeThreeButton;
/**
 *  三级分类的的整个view 包括typeThreeButton typeThreeImageView  typeThreeLabel
 */
@property (nonatomic,strong) UIView *typeThreeView;


/**
 *  订阅的button
 */
@property (nonatomic,strong)UIButton *subscriptionButton;

/**
 *  该文章评论数的label
 */
@property (nonatomic,strong) UILabel * commentCountLabel;

/**
 *  评论数
 */
@property int commentCount;


/**
 *  相关推荐文章的View
 */
@property (nonatomic,strong) UIView * recommendView;




@end
