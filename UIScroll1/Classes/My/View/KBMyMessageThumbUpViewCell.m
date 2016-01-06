//
//  ThumbUpCell.m
//  UIScroll1
//
//  Created by kuibu technology on 15/7/31.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMyMessageThumbUpViewCell.h"
#import "UIButtonWithIndexPath.h"
#import "UITopLable.h"
#import "UIImageView+WebCache.h"
#import "UICopyLable.h"
#import "YYWebImage.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBMyMessagePraiseModel.h"
#import "KBLoginSingle.h"

//距离上边的距离
#define MARGIN_HEIGHT 20
//距离左边的距离
#define MARGIN_WIDTH 15
//原来自己回复内容label距离View
#define MARGIN_ORIGN_LABLE 3
//头像的高度
#define HEADVIEW_WIDTH 50
//原来自己回复的内容的view的高度
#define HEIGHT_ORIGN_RESPOND_VIEW 40

@interface KBMyMessageThumbUpViewCell()
/**
 *  用户头像的Imageview
 */
@property (nonatomic,strong) UIImageView *userHeadView;
/**
 *  用户昵称的Label
 */
@property (nonatomic,strong) UILabel * userRespondNameLable;
/**
 *  回复内容的Label
 */
@property (nonatomic,strong) UILabel *userRespondLable;
/**
 *  原来自己回复内容的View
 */
@property (nonatomic,strong) UIView *orignRespondView;
/**
 *  原来自己回复内容的Label
 */
@property (nonatomic,strong) UILabel *orignRespondLable;
/**
 *  时间标签
 */
@property (nonatomic,strong) UILabel *timeLable;

@end

@implementation KBMyMessageThumbUpViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        //点赞者头像的ImageView
        self.userHeadView=[[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_WIDTH, MARGIN_HEIGHT, HEADVIEW_WIDTH, HEADVIEW_WIDTH)];
        self.userHeadView.layer.cornerRadius=HEADVIEW_WIDTH/2.0;
        [self.contentView addSubview:self.userHeadView];
        
        //点赞者的昵称的Label
        self.userRespondNameLable=[[UILabel alloc]initWithFrame:CGRectMake(MARGIN_WIDTH+HEADVIEW_WIDTH+14, MARGIN_HEIGHT,kWindowSize.width-MARGIN_WIDTH-(MARGIN_WIDTH+HEADVIEW_WIDTH+14), 20)];
        self.userRespondNameLable.numberOfLines=1;
        [self.userRespondNameLable setTextColor:[UIColor colorWithRed:110/255.0 green:145/255.0 blue:201/255.0 alpha:1]];
        [self.contentView addSubview:self.userRespondNameLable];
        
        //赞了你的评论
        self.userRespondLable=[[UILabel alloc]init ];
        [self.userRespondLable setFrame:CGRectMake(self.userRespondNameLable.left,self.userRespondNameLable.bottom+10, kWindowSize.width-MARGIN_WIDTH-self.userRespondNameLable.left, 20)];
        self.userRespondLable.numberOfLines=0;
        self.userRespondLable.textColor=KColor_51;
        self.userRespondLable.text=@"赞了你的评论";
        [self.contentView addSubview:self.userRespondLable];
        
        //原来自己评论内容的view
        self.orignRespondView=[[UIView alloc]initWithFrame:CGRectMake(MARGIN_WIDTH, self.userRespondLable.bottom+20, kWindowSize.width-2*MARGIN_WIDTH, HEIGHT_ORIGN_RESPOND_VIEW)];
        [self.orignRespondView setBackgroundColor:KColor_220];

        //原来自己的评论内容
        self.orignRespondLable=[[UILabel alloc]initWithFrame:CGRectMake(MARGIN_ORIGN_LABLE, 2, kWindowSize.width-2*MARGIN_WIDTH-2*MARGIN_ORIGN_LABLE, HEIGHT_ORIGN_RESPOND_VIEW-2*MARGIN_ORIGN_LABLE)];
        self.orignRespondLable.textColor=KColor_153_Alpha_1 ;
        self.orignRespondLable.font=[UIFont systemFontOfSize:13];
        self.orignRespondLable.numberOfLines=2;
        [self.orignRespondView addSubview:self.orignRespondLable];
        [self.contentView addSubview:self.orignRespondView];
        
        //时间
        self.timeLable=[[UILabel alloc]initWithFrame:CGRectMake(kWindowSize.width-2*MARGIN_WIDTH-102, self.orignRespondView.bottom+10, 200, 20)];
        self.timeLable.textColor=KColor_153_Alpha_1;
        [self.contentView addSubview:self.timeLable];
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, self.timeLable.bottom+10)];
        [self.contentView setFrame:self.frame];
    }
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
}
//设置cell的数据
-(void)setMessagePraiseCellWithModel:(KBMyMessagePraiseModel *)myMessagePraiseModel
{
    //点赞者的头像
    KBLoginSingle * loginSingle = [KBLoginSingle newinstance];
    
    if ([myMessagePraiseModel.praiserName isEqualToString:loginSingle.userName]) {
        self.userHeadView.image=loginSingle.userPhoto;
        if (loginSingle.userPhoto==nil){
            self.userHeadView.image=KNoLoginImage;
        }
    }
    else
    {
        if ([myMessagePraiseModel.praiserPhoto length]==0){
            self.userHeadView.image=KNoLoginImage;
        }
        else
            [self.userHeadView yy_setImageWithURL:[NSURL URLWithString:myMessagePraiseModel.praiserPhoto] placeholder:KNoLoginImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            }];
        
    }
    //回复者的昵称
    if([myMessagePraiseModel.praiserName length]==0)
    {
        self.userRespondNameLable.text=@"匿名用户";
    }
    else
        self.userRespondNameLable.text=myMessagePraiseModel.praiserName;
    
    //原来自己回复的内容
    NSString *orignRespondLable=[myMessagePraiseModel.comment stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.orignRespondLable.text=orignRespondLable;
    //时间标签
    self.timeLable.text=myMessagePraiseModel.date;
}
@end
