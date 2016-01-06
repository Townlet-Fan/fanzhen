//
//  KBRegisterAndLoginView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBRegisterAndLoginView.h"
#import "KBLogoAndBackView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBCustomButton.h"
#import "KB_RegisterAndLoginViewController.h"

#define registerWidth 100

@interface KBRegisterAndLoginView ()<UITextFieldDelegate>

@end

@implementation KBRegisterAndLoginView

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC
{
    self = [super initWithFrame:frame];
    if (self) {
        //logo和返回按钮
        KBLogoAndBackView *logoAndBackView = [[KBLogoAndBackView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 0.2*kWindowSize.height + 100)];
        [logoAndBackView setBackButtonTag:2 andLogoImage:@"340logow"];
        logoAndBackView.delegate = registerAndLoginVC;
        [self addSubview:logoAndBackView];
        
        //logo标签
        UILabel *logoTitle = [[UILabel alloc] initWithFrame:CGRectMake(logoAndBackView.left, logoAndBackView.bottom + 10, logoAndBackView.width, 30)];
        logoTitle.text = @"跬  步";
        logoTitle.textAlignment = NSTextAlignmentCenter;
        logoTitle.font = [UIFont systemFontOfSize:25];
        [logoTitle setTextColor:[UIColor whiteColor]];
        [self addSubview:logoTitle];
        
        //注册按钮
        KBCustomButton *registerButton = [[KBCustomButton alloc] initWithFrame:CGRectMake(0.5*kWindowSize.width - registerWidth - 20, 0.65*kWindowSize.height, registerWidth, 40)];
        registerButton.tag = 22;
        [registerButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"注   册" andBorderWidth:1 andBorderColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:20] andImageString:nil];
        [registerButton addTarget:registerAndLoginVC action:@selector(pushToOtherView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerButton];
        
        //登录按钮
        KBCustomButton *loginButton = [[KBCustomButton alloc]initWithFrame:CGRectMake(registerButton.right +40, registerButton.top, registerButton.width, registerButton.height)];
        loginButton.tag = 23;
        [loginButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"登   录" andBorderWidth:1 andBorderColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:20] andImageString:nil];
        [loginButton addTarget:registerAndLoginVC action:@selector(pushToOtherView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        //QQ登录
        UIButton *QQLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(registerButton.left, registerButton.bottom + 50, 0.5*registerButton.width, 0.5*registerButton.width)];
        QQLoginButton.layer.cornerRadius = 0.5*QQLoginButton.width;
        [QQLoginButton setBackgroundImage:[UIImage imageNamed:@"QQ空间1"] forState:UIControlStateNormal];
        //[self addSubview:QQLoginButton];
        
        //微信登录
        UIButton *WeChatLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, QQLoginButton.width, QQLoginButton.height)];
        WeChatLoginButton.center = CGPointMake(0.5*kWindowSize.width, QQLoginButton.center.y);
        WeChatLoginButton.layer.cornerRadius = 0.5*WeChatLoginButton.frame.size.width;
        [WeChatLoginButton setBackgroundImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        //[self addSubview:WeChatLoginButton];
        
        //微博登录
        UIButton *WeiBoLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, QQLoginButton.width, QQLoginButton.height)];
        WeiBoLoginButton.center = CGPointMake(WeChatLoginButton.center.x*2-QQLoginButton.center.x, QQLoginButton.center.y);
        WeiBoLoginButton.layer.cornerRadius = 0.5*WeiBoLoginButton.width;
        [WeiBoLoginButton setBackgroundImage:[UIImage imageNamed:@"微博1"] forState:UIControlStateNormal];
        //[self addSubview:WeiBoLoginButton];
    }
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
