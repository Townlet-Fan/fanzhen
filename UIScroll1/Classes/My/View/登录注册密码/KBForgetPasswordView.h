//
//  KBForgetPasswordView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.

//忘记密码 验证手机号

#import <UIKit/UIKit.h>

@class KB_RegisterAndLoginViewController,KBCustomTextField;
@protocol KBForgetPasswordDelegte <NSObject>

//textField开始编辑事件代理
- (void)startEdit:(float)bottomOffsetY;

//textField结束编辑
- (void)endEdit;

//获取验证码
-(void)getIdentifyCode:(NSString*)userTel;

//忘记密码下一步的判断
-(void)nextStep:(NSString * )userTel withIdentifyCode:(NSString *)identifyCode;

@end

@interface KBForgetPasswordView : UIView

/**
 *  验证码
 */
@property (nonatomic,strong) KBCustomTextField * identifyingCode;

@property(nonatomic,weak) id<KBForgetPasswordDelegte> delegate;


- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC;

@end
