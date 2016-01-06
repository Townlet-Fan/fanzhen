//
//  KBAboutKuiBuImageView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBAboutKuiBuImageView.h"
#import "KBColor.h"
#import "KBConstant.h"
@implementation KBAboutKuiBuImageView
-(instancetype)initWithFrame:(CGRect)frame withImage:(NSString * )imageName;
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:imageName]];
         self.userInteractionEnabled = YES;
        //返回按钮
        self.backButton=[[UIButton alloc]initWithFrame:CGRectMake(0,40, 50,50)];
        self.backButton.contentMode=UIViewContentModeScaleAspectFit;
        [self.backButton addTarget:self action:@selector(popToMenu) forControlEvents:UIControlEventTouchDown];
        //返回的image
        self.backImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 11, 19)];
        self.backImage.image=KBackImage;
        [self.backButton addSubview:self.backImage];
        [self addSubview:self.backButton];

    }
    return self;
}
-(void)popToMenu
{
    if ([_delegate respondsToSelector:@selector(backToMenu)]) {
         [_delegate backToMenu];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
