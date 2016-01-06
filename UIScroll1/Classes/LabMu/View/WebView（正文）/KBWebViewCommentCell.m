
//
//  DiscussCell.m
//  UIScroll1
//
//  Created by eddie on 15-4-19.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBWebViewCommentCell.h"
#import "KBThumpButton.h"
#import "UICopyLable.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "YYWebImage.h"
#import "KBColor.h"
#import "KBCommentModel.h"
#import "KBLoginSingle.h"
//距离上边的高度
#define HEIGHT_MARGIN 20
//距离左边的的宽度
#define WIDTH_MARGIN 20
//头像的宽度
#define HEAD_WIDTH 50
//button的高度
#define BTN_HEIGHT_INCELL 30
//cell的高度
#define USUAL_CELL_HEIGHT 107


@interface KBWebViewCommentCell()
/**
 *  评论的text 有复制的功能
 */
@property (nonatomic,strong) UICopyLable *commentLabel;
/**
 *  评论用户的头像imageView
 */
@property (nonatomic,strong) UIImageView *userHeadImageView;
/**
 *  评论用户的昵称
 */
@property (nonatomic,strong) UILabel *userNameLable;
/**
 *  评论的时间
 */
@property (nonatomic,strong) UILabel *timeLable;

/**
 *  回复的button
 */
@property (nonatomic,strong) KBThumpButton * replyButton;
/**
 *  点赞的Image
 */
@property (nonatomic,strong) UIImageView * thumpImageView;
/**
 *  回复的Image
 */
@property (nonatomic,strong) UIImageView * replyImageView;

@end

@implementation KBWebViewCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, USUAL_CELL_HEIGHT)];
        [self.contentView setFrame:self.frame];
        //用户评论的Label
        self.commentLabel=[[UICopyLable alloc]init];
        self.commentLabel.numberOfLines=0;
        self.commentLabel.tableDelegate=self;
        self.commentLabel.cellDelegate=self;
        self.commentLabel.textColor=KColor_51;
        [self.commentLabel setHighlightedTextColor:[UIColor grayColor]];
        self.commentLabel.font = [UIFont systemFontOfSize:14];
        self.commentLabel.userInteractionEnabled=YES;
        self.commentLabel.isHaveHot=NO;
    
        //用户头像
        self.userHeadImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_MARGIN, HEIGHT_MARGIN, HEAD_WIDTH , HEAD_WIDTH)];
        self.userHeadImageView.layer.cornerRadius=HEAD_WIDTH/2.0;
        self.userHeadImageView.clipsToBounds=YES;
        
        //用户昵称
        self.userNameLable=[[UILabel alloc]init];
        
        self.userNameLable.numberOfLines=1;
        self.userNameLable.font=[UIFont systemFontOfSize:14];
        self.userNameLable.textColor=KColor_15_86_192;
        self.userNameLable.textAlignment=NSTextAlignmentLeft;
        
        //时间标签
        self.timeLable=[[UILabel alloc]init];
        
        self.timeLable.textColor=[UIColor grayColor];
        self.timeLable.numberOfLines=1;
        self.timeLable.textAlignment=NSTextAlignmentLeft;
        self.timeLable.font=[UIFont systemFontOfSize:11];
        
        //点赞标签
        self.thumbUp=[[KBThumpButton alloc]init];
        [self.thumbUp setTitleColor: [UIColor grayColor]forState:UIControlStateNormal];
        self.thumbUp.titleLabel.font=self.timeLable.font;
        [self.thumbUp setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.thumbUp.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        self.thumbUp.layer.masksToBounds=YES;
        //点赞ImageView
        self.thumpImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:self.thumpImageView];
        
        //回复标签
        self.replyButton=[[KBThumpButton alloc]init];
        self.replyButton.titleLabel.font=self.thumbUp.titleLabel.font;
        [self.replyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.replyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
         self.replyButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [self.contentView addSubview:self.replyButton];
        //回复ImageView
        self.replyImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:self.replyImageView];
        
        [self.contentView addSubview:self.userHeadImageView];
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.userNameLable];
        [self.contentView addSubview:self.timeLable];
        [self.contentView addSubview:self.thumbUp];
        
    }
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor whiteColor];
    
    return self;
}
-(void)setCommentCellWithModel:(KBCommentModel *)commentModel
{
    [self setViewWithCommentModel:commentModel];
    
    //commentLabel
    NSString *base64Decoded=[commentModel.comContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.commentLabel.text=base64Decoded;
    self.commentLabel.tableDelegate=self;
    self.commentLabel.respondNameStr=commentModel.userName;
    
    //头像
    if ([commentModel.userPhoto isEqualToString:[KBLoginSingle newinstance].userName]) {
        self.userHeadImageView.image=[KBLoginSingle newinstance].userPhoto;
    }
    else {
        if ([commentModel.userPhoto length]==0) {
            self.userHeadImageView.image=KNoLoginImage;
        }
        else
            [self.userHeadImageView yy_setImageWithURL:[NSURL URLWithString:commentModel.userPhoto] placeholder:KNoLoginImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            }];
    }
    //thump
    self.thumbUp.count=[commentModel.praiseNum intValue];
    NSString * hasPraisedStr=commentModel.hasPraised;
    if (![hasPraisedStr intValue])
    {
        self.thumpImageView.image=KCancelThumbUpImage;
        [self.thumbUp setTitle :[NSString stringWithFormat:@"%d",self.thumbUp.count]forState:UIControlStateNormal];
    }
    else
    {
        self.thumpImageView.image=KThumbUpImage;
        [self.thumbUp setTitle :[NSString stringWithFormat:@"%d",self.thumbUp.count]forState:UIControlStateNormal];
    }
    //reply
    self.replyButton.count=[commentModel.replyNum intValue];
    [self.replyButton setTitle:[NSString stringWithFormat:@"%d",self.replyButton.count] forState:UIControlStateNormal];
    self.replyImageView.image=KReplyImage;

}
//设置各个控件的大小
-(void)setViewWithCommentModel:(KBCommentModel *)commentModel
{
        //用户的昵称
    CGSize  nameSize= [self.userNameLable sizeThatFits:CGSizeMake(HEAD_WIDTH+15, 11)];
    [self.userNameLable setFrame:CGRectMake(WIDTH_MARGIN+HEAD_WIDTH+WIDTH_MARGIN,WIDTH_MARGIN, nameSize.width, 10)];
    
    CGSize dateSize=[self.timeLable sizeThatFits:CGSizeMake(100, 15)];
    [self.timeLable setFrame:CGRectMake(self.userNameLable.left,self.userNameLable.top+self.userNameLable.frame.size.height+5, dateSize.width, 15)];
    
    //comment
    CGRect commentRect = [self sizeWithComment:commentModel.comContent];
    [self.commentLabel setFrame:CGRectMake(WIDTH_MARGIN+HEAD_WIDTH+20,self.timeLable.bottom+10,kWindowSize.width-2*WIDTH_MARGIN-HEAD_WIDTH-10,commentRect.size.height)];

//    CGSize cellSize=[self.commentLabel sizeThatFits:CGSizeMake(kWindowSize.width-2*WIDTH_MARGIN-HEAD_WIDTH-10, 500)];
//    [self.commentLabel setFrame:CGRectMake(WIDTH_MARGIN+HEAD_WIDTH+20,self.userNameLable.top+self.userNameLable.height+self.timeLable.height+10,cellSize.width, cellSize.height)];
    
    //点赞
    [self.thumbUp setFrame:CGRectMake(self.width-50, self.userNameLable.top-4, 60, 20)];
    [self.thumpImageView setFrame:CGRectMake(self.width-50, self.userNameLable.top-2, 15, 15)];
    
    //回复
    [self.replyButton setFrame:CGRectMake(self.width-90, self.userNameLable.top-4, 40, 20)];
    
    //cell.replyButton.backgroundColor=[UIColor redColor];
    [self.replyImageView setFrame:CGRectMake(self.frame.size.width-100, self.userNameLable.frame.origin.y, 15, 15)];
    //判断评论的内容是否大于头像的高度
    if(self.commentLabel.height>=HEAD_WIDTH )
    {
        //[self setFrame:CGRectMake(0, 0, kWindowSize.width, self.commentLabel.height+2*HEIGHT_MARGIN+BTN_HEIGHT_INCELL+20)];
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, self.commentLabel.bottom+BTN_HEIGHT_INCELL)];
    }
    else{
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, HEAD_WIDTH+2*HEIGHT_MARGIN+BTN_HEIGHT_INCELL)];
    }

}
- (CGRect)sizeWithComment:(NSString *)comment
{
    CGRect rect = [comment boundingRectWithSize:CGSizeMake(kWindowSize.width-2*WIDTH_MARGIN-HEAD_WIDTH-10,500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)layoutSubviews
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
