//
//  KBSetNewPasswordView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.

//设置新密码

#import <UIKit/UIKit.h>
@class KB_RegisterAndLoginViewController;
@protocol KBSetNewPasswordDelegte <NSObject>

//textField开始编辑事件代理
- (void)startEdit:(float)bottomOffsetY;

//textField结束编辑
- (void)endEdit;

//确认密码修改的代理
-(void)setPasswordSuccess:(NSString * )newPassWord withConfirmPassWord:(NSString *)confirmPassWord;
@end

@interface KBSetNewPasswordView : UIView

@property(nonatomic,weak) id<KBSetNewPasswordDelegte> delegate;

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC;

@end
