//
//  KBMyCollectBottomView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMyCollectBottomView.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
@implementation KBMyCollectBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //收藏下的UIView 删除和筛选
        self.underCollectView=[[UIView alloc]initWithFrame:CGRectMake(0,0,kWindowSize.width, 40)];
        self.underCollectView.backgroundColor=[UIColor whiteColor];
    
        //删除button
        self.deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.underCollectView.width/2.0-1, self.underCollectView.height)];
        [self.deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        //删除label
        self.deleteLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.deleteButton.width/2.0,10 , 50, 20)];
        self.deleteLabel.text=@"删除";
        self.deleteLabel.textColor=[UIColor grayColor];
        //删除image
        self.deleteImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.deleteButton.width/2.0-35, 10, 20, 20)];
        self.deleteImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.deleteImageView.image=[UIImage imageNamed:@"删除小灰"];
        [self.deleteButton addSubview:self.deleteImageView];
        [self.deleteButton addSubview:self.deleteLabel];
        [self.underCollectView addSubview:self.deleteButton];
        
        //中间的分割线
        UIView * verticalView=[[UIView alloc]initWithFrame:CGRectMake(self.deleteButton.width, 10, 1,self.underCollectView.height-20)];
        verticalView.backgroundColor=[UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        [self.underCollectView addSubview:verticalView];
        
        //筛选button
        self.selectButton=[[UIButton alloc]initWithFrame:CGRectMake(verticalView.right, 0, kWindowSize.width-(verticalView.right), self.underCollectView.height)];
        [self.selectButton addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
        
        //筛选label
        self.selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.selectButton.frame.size.width/2.0,10 , 50, 20)];
        self.selectLabel.text=@"筛选";
        self.selectLabel.textColor=[UIColor grayColor];
        //筛选image
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.selectButton.width/2.0-35, 10, 20, 20)];
        self.selectImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.selectImageView.image=[UIImage imageNamed:@"筛选灰"];
        [self.selectButton addSubview:self.selectImageView];
        [self.selectButton addSubview:self.selectLabel];
        [self.underCollectView addSubview:self.selectButton];
        [self addSubview:self.underCollectView];
    }
    return self;
}
//删除
-(void)delete
{
    if([_delegate respondsToSelector:@selector(beginDelete)])
       [_delegate beginDelete];
}
//筛选
-(void)select
{
    if ([_delegate respondsToSelector:@selector(beginSelect)]) {
         [_delegate beginSelect];
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
