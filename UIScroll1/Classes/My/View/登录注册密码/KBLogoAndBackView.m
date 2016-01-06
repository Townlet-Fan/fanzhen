//
//  KBLogoAndBackView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/18.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBLogoAndBackView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"

#define logoSize 80

@interface KBLogoAndBackView ()
{
    //返回按钮
    UIButton *leftBarBtn;
    
    //返回的Image
    UIImageView * backImage;
    
    //logo图标
    UIImageView* logoImageView;
}

@end
@implementation KBLogoAndBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //返回键
        leftBarBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,50, 50,50)];
        leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
        [leftBarBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBarBtn];
        
        //返回的image
        backImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 11, 19)];
        backImage.image=KBackImage;
        [leftBarBtn addSubview:backImage];
        
        //logo图标
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5*kWindowSize.width-0.5*logoSize, 0.2*kWindowSize.height, logoSize, logoSize)];
        [self addSubview:logoImageView];
    }
    return self;
}
#pragma mark - 返回按钮事件
- (void)pop:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(popToSuperNavigation:)]) {
        [self.delegate popToSuperNavigation:button.tag];
    }
}

- (void)setBackButtonTag:(NSInteger)buttonTag andLogoImage:(NSString*)string
{
    leftBarBtn.tag = buttonTag;
    logoImageView.image = [UIImage imageNamed:string];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
