//
//  KBPlanSectionFooterView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/28.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBPlanSectionFooterView.h"
#import "KBColor.h"
#import "KBConstant.h"
@interface KBPlanSectionFooterView ()

/**
 *  section的Footer
 */
@property (nonatomic,strong) UIView * sectionFooterView;

@end

@implementation KBPlanSectionFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(7, 0, kWindowSize.width-14, 10)];
        self.sectionFooterView.backgroundColor=[UIColor whiteColor];
        //设置某几个角为圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sectionFooterView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.sectionFooterView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.sectionFooterView.layer.mask = maskLayer;
        [self addSubview:self.sectionFooterView];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
