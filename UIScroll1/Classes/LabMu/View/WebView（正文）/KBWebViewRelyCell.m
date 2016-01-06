//
//  relyCell.m
//  UIScroll1
//
//  Created by kuibu technology on 15/11/23.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBWebViewRelyCell.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "UICopyLable.h"
#import "KBColor.h"
#import "KBConstant.h"
#import "KBReplyModel.h"
#import "YYWebImage.h"
#import "UIView+ITTAdditions.h"
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
@interface KBWebViewRelyCell()

/**
 *  回复内容的Label
 */
@property (nonatomic,strong) UICopyLable *replyLabel;
/**
 *  回复者的头像
 */
@property (nonatomic,strong) UIImageView *replyerHeadImageView;
/**
 *  回复者的昵称
 */
@property (nonatomic,strong) UILabel *replyerNameLable;
/**
 *  回复的时间
 */
@property (nonatomic,strong) UILabel *timeLable;

@end

@implementation KBWebViewRelyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, USUAL_CELL_HEIGHT)];
        [self.contentView setFrame:self.frame];
        //用户回复的label
        self.replyLabel=[[UICopyLable alloc]init];
        self.replyLabel.numberOfLines=0;
        self.replyLabel.tableDelegate=self;
        self.replyLabel.cellDelegate=self;
        self.replyLabel.textColor=KColor_51;
        [self.replyLabel setHighlightedTextColor:[UIColor grayColor]];
        self.replyLabel.font = [UIFont systemFontOfSize:14];
        self.replyLabel.userInteractionEnabled=YES;
        
        //回复者的头像
        self.replyerHeadImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_MARGIN, HEIGHT_MARGIN, HEAD_WIDTH , HEAD_WIDTH)];
        self.replyerHeadImageView.layer.cornerRadius=HEAD_WIDTH/2.0;
        self.replyerHeadImageView.clipsToBounds=YES;
        
        //回复者昵称标签
        self.replyerNameLable=[[UILabel alloc]init];
        self.replyerNameLable.numberOfLines=1;
        self.replyerNameLable.font=[UIFont systemFontOfSize:14];
        self.replyerNameLable.textColor=KColor_15_86_192;
        self.replyerNameLable.textAlignment=NSTextAlignmentLeft;
        
        //时间标签
        self.timeLable=[[UILabel alloc]init];
        self.timeLable.textColor=[UIColor grayColor];
        self.timeLable.numberOfLines=1;
        self.timeLable.textAlignment=NSTextAlignmentLeft;
        self.timeLable.font=[UIFont systemFontOfSize:11];
        
        [self.contentView addSubview:self.replyerHeadImageView];
        [self.contentView addSubview:self.replyLabel];
        [self.contentView addSubview:self.replyerNameLable];
        [self.contentView addSubview:self.timeLable];
    }
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor whiteColor];
    
    return self;
}
//设置cell的数据
-(void)setReplyCellWithModel:(KBReplyModel *)replyModel
{
    [self setViewWithCommentModel:replyModel];
    
    //replyLabel
    NSString *base64Decoded=[replyModel.replyerContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.replyLabel.text=base64Decoded;
    self.replyLabel.tableDelegate=self;
    
    self.replyLabel.respondNameStr=replyModel.replyerName;
    
    //头像
    if ([replyModel.replyerPhoto isEqualToString:[KBLoginSingle newinstance].userName]) {
        self.replyerHeadImageView.image=[KBLoginSingle newinstance].userPhoto;
    }
    else {
        if ([replyModel.replyerPhoto length]==0) {
            self.replyerHeadImageView.image=KNoLoginImage;
        }
        else
            [self.replyerHeadImageView yy_setImageWithURL:[NSURL URLWithString:replyModel.replyerPhoto] placeholder:KNoLoginImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            }];
    }
    //时间标签
    self.timeLable.text = replyModel.replyerDate;
    
    self.replyerNameLable .text = replyModel.replyerName;

}
//设置各个控件的大小
-(void)setViewWithCommentModel:(KBReplyModel *)replyModel
{
    //用户的昵称
    CGSize  nameSize= [self.replyLabel sizeThatFits:CGSizeMake(HEAD_WIDTH+15, 11)];
    [self.replyLabel setFrame:CGRectMake(WIDTH_MARGIN+HEAD_WIDTH+WIDTH_MARGIN,WIDTH_MARGIN, nameSize.width, 10)];
    
    CGSize dateSize=[self.timeLable sizeThatFits:CGSizeMake(100, 15)];
    [self.timeLable setFrame:CGRectMake(self.replyLabel.left,self.replyLabel.bottom+5, dateSize.width, 15)];
    
    //reply
    CGRect replyRect = [self sizeWithReply:replyModel.replyerContent];
    [self.replyLabel setFrame:CGRectMake(WIDTH_MARGIN+HEAD_WIDTH+20,self.timeLable.bottom+10,kWindowSize.width-2*WIDTH_MARGIN-HEAD_WIDTH-10,replyRect.size.height)];
//    CGSize cellSize=[self.replyLabel sizeThatFits:CGSizeMake(kWindowSize.width-2*WIDTH_MARGIN-HEAD_WIDTH-10, 500)];
//    [self.replyLabel setFrame:CGRectMake(WIDTH_MARGIN+HEAD_WIDTH+20,self.replyLabel.top+self.replyLabel.height+self.timeLable.height+10,cellSize.width, cellSize.height)];
    //判断回复的内容是否大于头像的高度
    if(self.replyLabel.height>HEAD_WIDTH )
    {
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, self.replyLabel.bottom+HEIGHT_MARGIN)];
    }
    else{
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, HEAD_WIDTH+2*HEIGHT_MARGIN)];
    }
}
- (CGRect)sizeWithReply:(NSString *)replyContent
{
    CGRect rect = [replyContent boundingRectWithSize:CGSizeMake(kWindowSize.width-2*WIDTH_MARGIN-HEAD_WIDTH-10,500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
