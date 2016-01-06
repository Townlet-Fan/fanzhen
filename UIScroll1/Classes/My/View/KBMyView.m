//
//  KBMyView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/24.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMyView.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"

@implementation KBMyView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //头像的headImagView
        
        float VIEW_WIDTH=0.75*kWindowSize.width;
        self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,VIEW_WIDTH, kWindowSize.height*0.47)];
        [self addSubview:self.headImageView];
        //头像的点击
        self.headViewButton=[[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH/3,VIEW_WIDTH*7/24, VIEW_WIDTH/3, VIEW_WIDTH/3)];
        self.headViewButton.layer.cornerRadius=self.headViewButton.layer.frame.size.width/2;
        self.headViewButton.layer.borderColor=[UIColor whiteColor].CGColor;
        self.headViewButton.layer.borderWidth=2;
        self.headViewButton.clipsToBounds=YES;
        [self addSubview:self.headViewButton];
        
       //用户昵称的button
        self.userNameLabelButton=[[UIButton alloc]initWithFrame:CGRectMake(0,self.headViewButton.bottom+0.05*VIEW_WIDTH, VIEW_WIDTH, kWindowSize.height*0.05)];
        [self addSubview:self.userNameLabelButton];
        
        //足迹的button
        self.footerButton=[[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH*3/15.0, self.userNameLabelButton.bottom+VIEW_WIDTH/15.0, VIEW_WIDTH*4/15.0, VIEW_WIDTH/10.0)];
        [self.footerButton setTitle: @"足 迹" forState:UIControlStateNormal];
        self.footerButton.contentMode=UIViewContentModeScaleToFill;
        [self.footerButton addTarget:self action:@selector(pushFooter) forControlEvents:UIControlEventTouchUpInside];
        [self.footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIView *footerView=[[UIView alloc]initWithFrame:self.footerButton.frame];
        footerView.backgroundColor=[UIColor grayColor];
        footerView.alpha=0.5;
        footerView.layer.cornerRadius=5;
        
        //收藏
        self.collectButton=[[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH*8/15.0, self.userNameLabelButton.bottom+VIEW_WIDTH/15.0,VIEW_WIDTH*4/15.0, VIEW_WIDTH/10.0)];
        [self.collectButton setTitle: @"收藏" forState:UIControlStateNormal];
        [self.collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.collectButton addTarget:self action:@selector(pushCollection) forControlEvents:UIControlEventTouchUpInside];
        UIView *collectView=[[UIView alloc]initWithFrame:self.collectButton.frame];
        collectView.backgroundColor=[UIColor grayColor];
        collectView.alpha=0.5;
        collectView.layer.cornerRadius=5;

        [self addSubview:footerView];
        [self addSubview:self.footerButton];
        [self addSubview:collectView];
        [self addSubview:self.collectButton];

    }
    return self;
}
-(void)pushFooter
{
    if ([_delegate respondsToSelector:@selector(pushFooter)]) {
        [_delegate pushFooter];
    }
}
-(void)pushCollection
{
    if ([_delegate respondsToSelector:@selector(pushCollection)]) {
        [_delegate pushCollection];
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
