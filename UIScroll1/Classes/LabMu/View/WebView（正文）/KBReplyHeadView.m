//
//  KBReplyHeadView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/31.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBReplyHeadView.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "YYWebImage.h"
@interface KBReplyHeadView()

/**
 *  回复头部的ImageView
 */
@property(nonatomic,strong)UIImageView * replyImageView;

/**
 *  返回button
 */
@property(nonatomic,strong)UIButton * backButton;

/**
 *  某条评论的内容
 */
@property (nonatomic,strong)UILabel * discusslabel;

@end

@implementation KBReplyHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //回复头部的ImageView
        self.replyImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.width*9/16)];
        self.replyImageView.backgroundColor=KColor_15_86_192;
        self.replyImageView.contentMode=UIViewContentModeScaleAspectFill;
        self.replyImageView.userInteractionEnabled=YES;
        //返回的button
        self.backButton=[[UIButton alloc]initWithFrame:CGRectMake(0,30, 50,50)];
        UIImageView * backImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 11, 19)];
        backImage.image=KBackImage;
        self.backButton.contentMode=UIViewContentModeScaleAspectFit;
        [self.backButton addTarget:self action:@selector(popToHot) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton addSubview:backImage];
        [self.replyImageView addSubview:self.backButton];
        
        //评论的Label
        self.discusslabel=[[UILabel alloc]init];
        self.discusslabel.textColor=[UIColor whiteColor];
        self.discusslabel.textAlignment=NSTextAlignmentCenter;
        self.discusslabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        self.discusslabel.numberOfLines=2;
        [self.replyImageView addSubview:self.discusslabel];
        [self addSubview:self.replyImageView];
        
        //相关回复的Label
        self.refrenceReplyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.replyImageView.left, self.replyImageView.bottom, kWindowSize.width, 25)];
        self.refrenceReplyLabel.backgroundColor = [UIColor whiteColor];
        self.refrenceReplyLabel.textAlignment=NSTextAlignmentLeft;
        self.refrenceReplyLabel.textColor=KColor_85;
        [self addSubview:self.refrenceReplyLabel];
    
        //分隔的View
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.refrenceReplyLabel.bottom, kWindowSize.width, 5)];
        self.separatorView.backgroundColor=KColor_235;
        [self addSubview:self.separatorView];

    }
    return self;
}
#pragma mark - 设置回复头部的数据
-(void)setReplyHeadData:(NSString * )replyHeadUrl withComment:(NSString *)comment withReplyCount:(int)replyCount
{
    CGRect commentRect = [self sizeWithComment:comment];
    [self.discusslabel setFrame:CGRectMake(0.06*kWindowSize.width, self.replyImageView.height-commentRect.size.height-15, kWindowSize.width-0.12*kWindowSize.width, commentRect.size.height)];
    
    [self.replyImageView yy_setImageWithURL:[NSURL URLWithString:replyHeadUrl] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
    //判断imageView的image是否为空 不为空就加入阴影
    if (self.replyImageView.image!=nil) {
        UIImageView * shadow=[[UIImageView alloc]initWithFrame:self.replyImageView.frame];
        shadow.image=[UIImage imageNamed:@"16比9阴影"];
        [self.replyImageView addSubview:shadow];
    }
    self.discusslabel.text=comment;
    self.refrenceReplyLabel.text=[NSString stringWithFormat:@"    相关回复(%d)",replyCount];
}
#pragma mark -  计算评论的label的尺寸
- (CGRect)sizeWithComment:(NSString *)comment
{
    CGRect rect = [comment boundingRectWithSize:CGSizeMake(kWindowSize.width-0.12*kWindowSize.width,60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Bold" size:18]} context:nil];
    return rect;
}
#pragma mark - 返回的点击事件
-(void)popToHot
{
    if ([_delegate respondsToSelector:@selector(popToHot)]) {
        [_delegate popToHot];
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
