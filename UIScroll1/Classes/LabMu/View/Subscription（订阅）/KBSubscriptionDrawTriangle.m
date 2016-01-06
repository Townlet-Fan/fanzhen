//
//  DrawTriangle.m
//  UIScroll1
//
//  Created by 樊振 on 15/11/10.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSubscriptionDrawTriangle.h"

@implementation KBSubscriptionDrawTriangle

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //设置背景颜色
//    [[UIColor whiteColor]set];
//    UIRectFill(rect);//会给rect区域填充颜色，导致外部设置backgroundcolor无用
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,0, rect.size.height);//设置起点
    CGContextAddLineToPoint(context,0.5*rect.size.width, rect.size.height*0.5);
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [[UIColor whiteColor] setFill]; //设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
//    CGFloat zStrokeColour[4]    = {180.0/255,180.0/255.0,180.0/255.0,1.0};
//    CGContextSetStrokeColor(context, zStrokeColour );
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}


@end
