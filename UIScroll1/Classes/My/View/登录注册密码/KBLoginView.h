//
//  KBLoginView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.
//登录view

#import <UIKit/UIKit.h>
@class KB_RegisterAndLoginViewController,KBCustomTextField;

@protocol KBLoginDelegte <NSObject>

//textField开始编辑事件代理
- (void)startEdit:(float)bottomOffsetY;

//textField结束编辑
- (void)endEdit;

//登录
-(void)loginJugde:(NSString * )userTel withPassWord:(NSString *)passWord;

@end

@interface KBLoginView : UIView

/**
 *  //手机号
 */
@property (nonatomic,strong) KBCustomTextField* userName;

/**
 *  密码
 */
@property (nonatomic,strong) KBCustomTextField* password;


@property(nonatomic,weak) id<KBLoginDelegte> delegate;

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC;
/**
 *  <#Description#>
 */
@end
