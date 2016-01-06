//
//  KBCustomButton.h
//  UIScroll1
//
//  Created by kuibu on 15/12/18.
//  Copyright © 2015年 Test. All rights reserved.

//自定义button，将各种属性设置集中，书写方便

#import <UIKit/UIKit.h>

@interface KBCustomButton : UIButton

- (void)setButtonWithBackgroundColor:(UIColor*)color andTitle:(NSString*)string andBorderWidth:(NSInteger)width andBorderColor:(UIColor*)borderColor andFont:(UIFont*)font andImageString:(NSString*)imageString;

@end
