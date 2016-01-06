//
//  KBMyCollectionDeleteView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBMyCollectionDeleteView.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
@implementation KBMyCollectionDeleteView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //全选
        self.allDeteleButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 10, (kWindowSize.width-60)/2.0, 44)];
        [self.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
        [self.allDeteleButton setTitleColor:KColor_51 forState:UIControlStateNormal];
        self.allDeteleButton.layer.borderWidth=2.0f;
        //    [allDeteleButton setTintColor:[UIColor whiteColor]];
        self.allDeteleButton.layer.borderColor=[UIColor grayColor].CGColor;
        self.allDeteleButton.layer.cornerRadius=5;
        [self.allDeteleButton addTarget:self action:@selector(allDelelte) forControlEvents:UIControlEventTouchUpInside];
        
        //删除
        self.deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(self.allDeteleButton.right+20, 10, (kWindowSize.width-60)/2.0, 44)];
        [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        self.deleteButton.backgroundColor=KColor_15_86_192;
        self.deleteButton.layer.cornerRadius=5;
        [self.deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.allDeteleButton];
        [self addSubview:self.deleteButton];
    }
    return self;
}
//全选
-(void)allDelelte
{
    if ([_delegate respondsToSelector:@selector(allDelelte)]) {
        [_delegate allDelelte];
    }
}
//删除
-(void)delete
{
    if ([_delegate respondsToSelector:@selector(deleteCollect)]) {
        [_delegate deleteCollect];
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
