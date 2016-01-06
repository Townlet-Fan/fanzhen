//
//  KBSchoolLocationRefreshView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/24.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBSchoolLocationRefreshView.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
@implementation KBSchoolLocationRefreshView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        //刷新显示定位结果的label
        self.refreshLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWindowSize.width, 40)];
        self.refreshLabel.text=[NSString stringWithFormat:@"共0项结果"];
        self.refreshLabel.textColor=KColor_15_86_192;
        self.refreshLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.refreshLabel];
        //刷新按钮
        UIButton * refreshButton=[[UIButton alloc]initWithFrame:CGRectMake(kWindowSize.width-60, 0, 60, self.refreshLabel.height)];
        [refreshButton addTarget:self action:@selector(refreshSchool) forControlEvents:UIControlEventTouchDown];
        UIImageView * refreshImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
        refreshImageView.image=[UIImage imageNamed:@"刷新蓝"];
        [refreshButton addSubview:refreshImageView];
        [self addSubview:refreshButton];
    }
    return self;
}
-(void)refreshShcool
{
    if ([_delegate respondsToSelector:@selector(refreshSchool)]) {
        [_delegate refreshSchool];
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
