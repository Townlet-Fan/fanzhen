//
//  KBLogoAndBackView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/18.
//  Copyright © 2015年 Test. All rights reserved.

//logo图标和返回按钮

#import <UIKit/UIKit.h>

@protocol KBLogoAndBackViewDelegte <NSObject>

//返回按钮
- (void)popToSuperNavigation:(NSInteger)buttonTag;

@end

@interface KBLogoAndBackView : UIView

@property(nonatomic,weak) id<KBLogoAndBackViewDelegte> delegate;

//设置返回按钮tag和logo
- (void)setBackButtonTag:(NSInteger)buttonTag andLogoImage:(NSString*)string;
@end
