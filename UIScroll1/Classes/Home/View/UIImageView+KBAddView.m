//
//  UIImageView+KBAddView.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/10.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "UIImageView+KBAddView.h"
#import "UIView+ITTAdditions.h"
@implementation UIImageView (KBAddView)

- (void)addImageViewWithImageName:(NSString *)imageName toView:(UIView *)view
{
    self.frame = CGRectMake(0, 0, view.width, view.height);
    self.image = [UIImage imageNamed:imageName];
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    [view addSubview:self];
}

//在view上 加 蒙版
+ (void)addDimImageViewWithImageName:(NSString *)imageName toView:(UIView *)view
{
    [[[self alloc] init] addImageViewWithImageName:imageName toView:view];
}

@end
