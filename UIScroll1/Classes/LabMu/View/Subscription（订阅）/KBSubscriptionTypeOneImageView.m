//
//  KBSubscriptionTypeOneImageView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/15.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSubscriptionTypeOneImageView.h"

@interface KBSubscriptionTypeOneImageView ()
{
    NSInteger _tag;
}
@end
@implementation KBSubscriptionTypeOneImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeScrollViewOffset)];
        [self addGestureRecognizer:tap];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)setImageViewWithTag:(NSInteger)tag andImageString:(NSString*)string andColor:(UIColor *)color;
{
    _tag = tag;
    self.tag = tag;
    self.backgroundColor = color;
    self.image=[UIImage imageNamed:string];
}
- (void)changeScrollViewOffset
{
    if ([self.delegate respondsToSelector:@selector(changeOffset:)]) {
        [self.delegate changeOffset:_tag];
    }
}

@end
