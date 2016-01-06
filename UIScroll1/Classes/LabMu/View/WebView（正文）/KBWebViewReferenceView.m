//
//  ReferenceView.m
//  UIScroll1
//
//  Created by xiaoxuehui on 15/10/7.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBWebViewReferenceView.h"
#import "KBInfoTableViewController.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"

@implementation KBWebViewReferenceView
//100+5+20＋10+50+152=337 所以这个view的高度为337
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        //广告View
        self.advertView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width*3/10)];
        self.advertView.image=KLocalZhuoZi;
        [self addSubview:self.advertView];
        
        //相关推荐的Label
        self.recommendLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,self.advertView.bottom+5, 200 ,20 )];
        self.recommendLabel.text=@"相关推荐";
        self.recommendLabel.textColor=[UIColor grayColor];
        [self addSubview:self.recommendLabel];
        
        //三级分类的的整个view 包括typeThreeButton typeThreeImageView  typeThreeLabel
        self.typeThreeView=[[UIView alloc]initWithFrame:CGRectMake(0,self.recommendLabel.bottom+10, self.advertView.width, 50)];
        self.typeThreeView.backgroundColor=[UIColor whiteColor];
        self.typeThreeView.layer.borderColor=KColor_191.CGColor;
        self.typeThreeView.layer.borderWidth=1;
        [self addSubview:self.typeThreeView];
        
        //三级分类的可点button (现在不可点)
        self.typeThreeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.typeThreeView.width*0.7, 50)];
        [self.typeThreeView addSubview:self.typeThreeButton];
        
        //三级分类的Icon ImageView
        self.typeThreeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40,12.5,25,25 )];
        self.typeThreeImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.typeThreeImageView.image=KLoadingMinImage;
        [self.typeThreeButton addSubview:self.typeThreeImageView];
        
        //三级分类的Label
        self.typeThreeLable=[[UILabel alloc]initWithFrame:CGRectMake(self.typeThreeImageView.right+20, 10,self.typeThreeButton.width-(self.typeThreeImageView.right+20),30 )];
        self.typeThreeLable.text=@"跬步";
        self.typeThreeLable.textColor=KColor_15_86_192;
        [self.typeThreeButton addSubview:self.typeThreeLable];
        
        //三级分类的订阅
        self.subscriptionButton=[[UIButton alloc]initWithFrame:CGRectMake(self.typeThreeButton.right+20, 10,70 ,30)];
        if([UIScreen mainScreen].bounds.size.width==320)
        {
            [self.subscriptionButton setFrame:CGRectMake(self.typeThreeButton.right, 10, 70, 30)];
        }
        self.subscriptionButton.backgroundColor=KColor_15_86_192;
        [self.subscriptionButton setTitle:@"+订阅" forState:UIControlStateNormal];
        [self.subscriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.subscriptionButton.titleLabel.font=[UIFont systemFontOfSize:self.subscriptionButton.height*0.5];
        self.subscriptionButton.layer.cornerRadius=5;
        self.subscriptionButton.layer.borderWidth=1;
        self.subscriptionButton.layer.borderColor=KColor_15_86_192.CGColor;
        [self.typeThreeView addSubview:self.subscriptionButton];
        
        //相关推荐文章的外层view
        self.recommendView=[[UIView alloc]initWithFrame:CGRectMake(self.typeThreeView.left, self.typeThreeView.bottom+10, self.typeThreeView.width, 152)];
        self.recommendView.backgroundColor=[UIColor whiteColor];
        self.recommendView.layer.borderColor=KColor_191.CGColor;
        self.recommendView.layer.borderWidth=1;
        [self addSubview:self.recommendView];
        
        //评论数
        self.commentCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.recommendView.left+10, self.bottom+10, self.recommendView.width, 20)];
        self.commentCount=0;
        self.commentCountLabel.text=[NSString stringWithFormat:@"评论(%d)",self.commentCount];
        self.commentCountLabel.textColor=[UIColor grayColor];
        [self addSubview:self.commentCountLabel];

    }
    
    return self;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
