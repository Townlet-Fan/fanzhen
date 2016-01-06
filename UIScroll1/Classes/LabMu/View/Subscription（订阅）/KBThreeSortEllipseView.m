//
//  arcView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/10/25.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBThreeSortEllipseView.h"

@implementation KBThreeSortEllipseView

float DEVICE_WIDTH;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.0);//线的宽度
     UIColor *aColor = [UIColor colorWithRed:163/255.0 green:128/255.0 blue:216/255.0 alpha:1];//blue蓝色
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextAddRect(context,CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0));//画方框
//    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
    if (DEVICE_WIDTH==320) {
        CGContextAddEllipseInRect(context, CGRectMake(-10, -35, [[UIScreen mainScreen] bounds].size.width+20, 50));
        
    }
    else
    {
        CGContextAddEllipseInRect(context, CGRectMake(-10, -45, [[UIScreen mainScreen] bounds].size.width+20, 70));
    }    
    CGContextSetFillColorWithColor(context, aColor.CGColor);//椭圆
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
