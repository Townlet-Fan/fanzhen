//
//  ViewUnderWeb.h
//  UIScroll1
//
//  Created by xiaoxuehui on 15/9/15.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//WebView下的 第二个Cell里的view

#import <UIKit/UIKit.h>


@class KBWebViewReferenceView,KBWebViewFeedBackView;

@interface KBWebViewBottomView : UIViewController
/**
 *  好文的点击button
 */
@property (nonatomic,strong) UIButton *thumUpBtn;
/**
 *  水文的点击button
 */
@property (nonatomic,strong) UIButton *footDownBtn;
/**
 *  新浪分享的button
 */
@property (nonatomic,strong) UIButton *sinaShareBtn;
/**
 *  QQ空间分享的button
 */
@property (nonatomic,strong) UIButton *qZoneShareBtn;
/**
 *  微信朋友圈分享的button
 */
@property (nonatomic,strong) UIButton *wxShareBtn;
/**
 *  反馈的button
 */
@property (nonatomic,strong) UIButton *feedBackBtn;
/**
 *  相关推荐的view
 */
@property (nonatomic,strong) KBWebViewReferenceView *referenceView;
/**
 *  反馈的view
 */
@property (nonatomic,strong) KBWebViewFeedBackView *feedBackView;


@end
