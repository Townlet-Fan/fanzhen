//
//  LikeButton.m
//  UIScroll1
//
//  Created by kuibu technology on 15/6/23.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "LikeButton.h"

@implementation LikeButton
@synthesize isLiked;
@synthesize indexPath;
@synthesize Count;
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
        
    return self;
}
-(void)setCustomTitle{
//    NSLog(@"setCustomTitle");
//  
//    if (self.isLiked)
//    {
//        
//        [self.imageView setImage:[UIImage imageNamed:@"收藏实心"]];
//        
//    }
//    else
//    {
//        [self.imageView setImage:[UIImage imageNamed:@"收藏空心"]];
//    }
//    [ self setTitle:[NSString stringWithFormat:@"%ld",(long)Count] forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
