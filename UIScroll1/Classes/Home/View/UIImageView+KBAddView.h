//
//  UIImageView+KBAddView.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/10.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (KBAddView)

- (void)addImageViewWithImageName:(NSString *)imageName toView:(UIView *)view;

+ (void)addDimImageViewWithImageName:(NSString *)imageName toView:(UIView *)view;

@end
