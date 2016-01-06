//
//  KBRegisterAndLoginView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.

//注册登录 主视图

#import <UIKit/UIKit.h>

@class KB_RegisterAndLoginViewController;

@protocol KBRegisterAndLoginDelegte <NSObject>

@end

@interface KBRegisterAndLoginView : UIView

@property(nonatomic,weak) id<KBRegisterAndLoginDelegte> delegate;

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC;

@end
