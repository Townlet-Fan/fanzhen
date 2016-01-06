//
//  recommendBigButton.m
//  UIScroll1
//
//  Created by kuibu technology on 15/11/21.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeTopSlideView.h"

@implementation KBHomeTopSlideView
@synthesize bigImage;
float DEVICE_WIDTH,DEVICE_HEIGHT;
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
        DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
        
        bigImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,DEVICE_WIDTH, DEVICE_WIDTH*9/16.0)];
        [self addSubview:bigImage];
    }
    
    
    return self;
    
}

@end
