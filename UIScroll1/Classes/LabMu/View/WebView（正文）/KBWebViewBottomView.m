//
//  ViewUnderWeb.m
//  UIScroll1
//
//  Created by xiaoxuehui on 15/9/15.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBWebViewBottomView.h"
#import "UIView+ITTAdditions.h"
#import "KBWebViewFeedBackView.h"
#import "KBWebViewReferenceView.h"
#import "KBColor.h"
#import "KBConstant.h"
#import "KBWebviewOtherInfoModel.h"
#import "YYWebImage.h"
#import "KBWebviewInfoModel.h"
#import "KBLoginSingle.h"
#import "KBThreeSortModel.h"
#import "KBHomeArticleModel.h"
#include "KBProgressHUD.h"
//距离上边的距离
#define  MARGIN_HEIGHT 20
//button的之间的间距
#define MARGIN_BTNS 10
//button距离左边的距离
#define MARGIN_BINSS 35
@implementation KBWebViewBottomView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//20+30+20+0.25*(self.view.frame.size.width-2*MARGIN_BINSS-3*MARGIN_BTNS)+200+337
-(instancetype)init{
    self=[super init];
    if (self) {
        //好文点击的button
        self.thumUpBtn=[[UIButton alloc]initWithFrame:CGRectMake(MARGIN_BINSS*2, MARGIN_HEIGHT, 0.5*(self.view.width-4*(MARGIN_BINSS)-MARGIN_BTNS), 30)];
        [self.thumUpBtn setBackgroundColor:[UIColor whiteColor]];
        [self.thumUpBtn setTitleColor:KColor_102 forState:UIControlStateNormal];
        [self.thumUpBtn setTitle:@"好文 0" forState:UIControlStateNormal];
        self.thumUpBtn.layer.borderColor=KColor_102.CGColor;
        self.thumUpBtn.layer.cornerRadius=5;
        self.thumUpBtn.layer.borderWidth=1;
        [self.view addSubview:self.thumUpBtn];
        
       //水文点击的button
        self.footDownBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.thumUpBtn.right+20, MARGIN_HEIGHT, self.thumUpBtn.width, 30)];
        [self.footDownBtn setBackgroundColor:[UIColor whiteColor]];
        [self.footDownBtn setTitleColor:KColor_102  forState:UIControlStateNormal];
        [self.footDownBtn setTitle:@"水文 0" forState:UIControlStateNormal];
        self.footDownBtn.layer.borderColor=KColor_102.CGColor;
        self.footDownBtn.layer.cornerRadius=5;
        self.footDownBtn.layer.borderWidth=1;
        [self.view addSubview:self.footDownBtn];
        
        
        //微信分享
        self.wxShareBtn=[[UIButton alloc]initWithFrame:CGRectMake(MARGIN_BINSS, self.footDownBtn.bottom+20, 0.25*(self.view.width-2*MARGIN_BINSS-3*MARGIN_BTNS), 0.25*(self.view.width-2*MARGIN_BINSS-3*MARGIN_BTNS))];
        //[wxShareBtn setBackgroundColor:[UIColor blueColor]];
        //[wxShareBtn setTitle:@"微信" forState:UIControlStateNormal];
        
        [self.wxShareBtn setBackgroundImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        
        [self.view addSubview:self.wxShareBtn];
        
        //新浪分享
        self.sinaShareBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.wxShareBtn.right+MARGIN_BTNS    ,self.wxShareBtn.top  ,self.wxShareBtn.width    ,self.wxShareBtn.height )];
        //    [sinaShareBtn setTitle:@"新浪" forState:UIControlStateNormal];
        //    sinaShareBtn.backgroundColor=[UIColor blueColor];
        [self.sinaShareBtn setBackgroundImage:[UIImage imageNamed:@"微博1"] forState:UIControlStateNormal];
        [self.view addSubview:self.sinaShareBtn];
        
        //QQ空间分享
        self.qZoneShareBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.sinaShareBtn.right+MARGIN_BTNS, self.sinaShareBtn.frame.origin.y, self.sinaShareBtn.frame.size.width, self.sinaShareBtn.frame.size.height)];
        [self.qZoneShareBtn setBackgroundImage:[UIImage imageNamed:@"QQ空间1"] forState:UIControlStateNormal];
        [self.view addSubview:self.qZoneShareBtn];
        
        //反馈
        self.feedBackBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.qZoneShareBtn.right+MARGIN_BTNS, self.qZoneShareBtn.top, self.qZoneShareBtn.width, self.qZoneShareBtn.height)];
        [self.feedBackBtn setBackgroundImage:[UIImage imageNamed:@"正文反馈"] forState:UIControlStateNormal];
        [self.view addSubview:self.feedBackBtn];
        
        //反馈的view
        self.feedBackView=[[KBWebViewFeedBackView alloc]init];
        
        [self.feedBackView setFrame:CGRectMake(10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  , self.wxShareBtn.bottom+10, self.view.width-18, self.feedBackView.height)];
        [self.view addSubview:self.feedBackView];
        
        //相关推荐的view
        self.referenceView=[[KBWebViewReferenceView alloc]initWithFrame:CGRectMake(10 ,self.feedBackView.top   ,self.view.width-18,337)];
        [self.view addSubview:self.referenceView];

    }
    return self;
}




@end
