//
//  KBCustomButton.m
//  UIScroll1
//
//  Created by kuibu on 15/12/18.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBCustomButton.h"
#import "UIView+ITTAdditions.h"
@implementation KBCustomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = self.height*0.2;
//        [self addTarget:self action:@selector(registerJudge) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setButtonWithBackgroundColor:(UIColor*)color andTitle:(NSString*)string andBorderWidth:(NSInteger)width andBorderColor:(UIColor*)borderColor andFont:(UIFont*)font andImageString:(NSString*)imageString
{
    self.backgroundColor = color;
    [self setTitle:string forState:UIControlStateNormal];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
    if (font) {
        self.titleLabel.font = font;
    }
    
    if (imageString) {
        [self setImage:[self scaleFromImage:[UIImage imageNamed:imageString] toSize:CGSizeMake(20,30)] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 30)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
    }
}

//将图片缩放到指定尺寸
-(UIImage *) scaleFromImage: (UIImage *) image1 toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
