//
//  SubView.m
//  SubView
//
//  Created by 樊振 on 15/9/17.
//  Copyright (c) 2015年 樊振. All rights reserved.
//

#import "KBWebViewFeedBackView.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
//反馈View的高度
#define FeedBackViewHeight 200
@interface KBWebViewFeedBackView ()<UITextFieldDelegate>
@end

@implementation KBWebViewFeedBackView

-(KBWebViewFeedBackView *)init
{
    self=[super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, FeedBackViewHeight)];
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderColor=KColor_191.CGColor;
        self.layer.borderWidth=1;
        //反馈的标题
        self.feedBackLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.1*kWindowSize.width, 0.05*FeedBackViewHeight, 0.25*kWindowSize.width, 0.1*FeedBackViewHeight)];
        self.feedBackLabel.text=@"跬步";
        self.feedBackLabel.font=[UIFont systemFontOfSize:self.feedBackLabel.height];
        self.feedBackLabel.textColor=[UIColor grayColor];
        [self addSubview:self.feedBackLabel];
        
        //To编辑:的label
        UILabel *feedBackLabel1=[[UILabel alloc] initWithFrame:CGRectMake(self.feedBackLabel.left, self.feedBackLabel.bottom+0.05*FeedBackViewHeight, 0.6*kWindowSize.width, 0.8*self.feedBackLabel.height)];
        feedBackLabel1.text=@"To编辑:";
        feedBackLabel1.textColor=KColor_51;
        feedBackLabel1.font=[UIFont systemFontOfSize:feedBackLabel1.height];
        [self addSubview:feedBackLabel1];
        
        //我希望看到什么类型的信息 textField
        self.textField=[[UITextField alloc] initWithFrame:CGRectMake(feedBackLabel1.left, feedBackLabel1.bottom+0.05*FeedBackViewHeight, 0.8*kWindowSize.width, 0.15*FeedBackViewHeight)];
        self.textField.placeholder=@"我希望看到什么类型的信息";
        self.textField.textColor=[UIColor grayColor];
        self.textField.backgroundColor=KColor_240;
        [self addSubview:self.textField];
        
        //我有好货来推荐 label
        UILabel *feedBackLabel2=[[UILabel alloc] initWithFrame:CGRectMake(self.textField.left, self.textField.bottom+0.05*FeedBackViewHeight,feedBackLabel1.width, feedBackLabel1.height)];
        feedBackLabel2.text=@"我有好货来推荐";
        feedBackLabel2.font=[UIFont systemFontOfSize:feedBackLabel2.frame.size.height];
        feedBackLabel2.textColor=KColor_51;
        [self addSubview:feedBackLabel2];
        
        //网址链接or网站/公众号/信息名称 textField
        self.textField1=[[UITextField alloc] initWithFrame:CGRectMake(feedBackLabel2.left, feedBackLabel2.bottom+0.05*FeedBackViewHeight,self.textField.width, self.textField.height)];
        self.textField1.placeholder=@"网址链接or网站/公众号/信息名称";
        self.textField1.textColor=[UIColor grayColor];
        self.textField1.backgroundColor=KColor_240;
        [self addSubview:self.textField1];
        
        //提交反馈的button
        self.feedBackButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.feedBackButton.frame=CGRectMake(self.textField1.right-0.2*kWindowSize.width, self.textField1.bottom+0.03*FeedBackViewHeight, 0.2*kWindowSize.width, 0.12*FeedBackViewHeight);
        [self.feedBackButton setTitle:@"提交反馈" forState:UIControlStateNormal];
        self.feedBackButton.titleLabel.font=[UIFont systemFontOfSize:self.feedBackButton.width*0.18];
        [self.feedBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.feedBackButton.layer.cornerRadius=self.feedBackButton.height*0.2;//设置圆角
        self.feedBackButton.layer.borderWidth=1;
        self.feedBackButton.layer.borderColor=KColor_15_86_192.CGColor;
        self.feedBackButton.backgroundColor=KColor_15_86_192;
        [self addSubview:self.feedBackButton];
    }
    return self;
}

- (KBWebViewFeedBackView *)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
