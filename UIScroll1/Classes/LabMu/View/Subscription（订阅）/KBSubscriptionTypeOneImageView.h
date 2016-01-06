//
//  KBSubscriptionTypeOneImageView.h
//  UIScroll1
//
//  Created by kuibu on 15/12/15.
//  Copyright © 2015年 Test. All rights reserved.
//订阅主视图 一级分类按钮 切换

#import <UIKit/UIKit.h>

@protocol KBSubscriptionTypeOneDelegate <NSObject>

- (void)changeOffset:(NSInteger)tag;

@end

@interface KBSubscriptionTypeOneImageView : UIImageView

@property(nonatomic,strong) id<KBSubscriptionTypeOneDelegate> delegate;

//设置图片
- (void)setImageViewWithTag:(NSInteger)tag andImageString:(NSString*)string andColor:(UIColor *)color;

@end
