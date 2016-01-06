//
//  KBPersonInfoSetView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.

//个人信息界面设置

#import <UIKit/UIKit.h>
@class KB_RegisterAndLoginViewController;

@protocol KBPersonInfoSetDelegte <NSObject>

//textField开始编辑事件代理
- (void)startEdit:(float)bottomOffsetY;

//textField结束编辑
- (void)endEdit;

//选择头像
-(void)choosePhoto;

//注册完善用户信息
-(void)pushMainView:(NSString *)userName withUserSchool:(NSString *)userSchool withUserSex:(NSString *)userSex;

@end

@interface KBPersonInfoSetView : UIView

/**
 *  <#Description#>
 */
@property (nonatomic,strong) UIButton* logoImageButton;//用户选择头像button
@property(nonatomic,weak) id<KBPersonInfoSetDelegte> delegate;

//初始化
- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC
;

@end
