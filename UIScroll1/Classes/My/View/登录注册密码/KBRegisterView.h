//
//  KBRegisterView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.

//注册界面

#import <UIKit/UIKit.h>
@class KB_RegisterAndLoginViewController;

@protocol KBRegisterDelegte <NSObject>

//textField开始编辑事件代理
- (void)startEdit:(float)bottomOffsetY;

//textField结束编辑
- (void)endEdit;

//获取验证码
-(void)getIdentifyCode:(NSString*)userTel;

//注册
-(void)registerJudge:(NSString * )userTel withPassWord:(NSString *)passWord withIdentifyCode:(NSString *)identifyCode;
@end

@interface KBRegisterView : UIView

@property(nonatomic,weak) id<KBRegisterDelegte> delegate;

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC;

@end
