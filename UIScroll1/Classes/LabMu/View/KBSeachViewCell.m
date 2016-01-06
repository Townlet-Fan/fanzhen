//
//  KBSeachViewCell.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSeachViewCell.h"
#import "UITopLable.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
#import "KBConstant.h"
#import "KBHomeArticleModel.h"
#import "YYWebImage.h"
//控件距离左边的距离
#define MARGIN_WIDTH 14
//控件距离上边的距离
#define MARGIN_HEIGHT 10
//cell的高度
#define USUAL_CELL_HEIGHT 107

@interface KBSeachViewCell()

/**
 *  cell的图片
 */
@property (nonatomic,strong)UIImageView * artImageView;

/**
 *  cell的标题
 */

@property (nonatomic,strong) UITopLable * artTitleLabel;

/**
 *  提示Label
 */

@property (nonatomic,strong) UILabel * comeInLabel;

@end

@implementation KBSeachViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, USUAL_CELL_HEIGHT)];
        [self.contentView setFrame:self.frame];
        
        //cell的图
        self.artImageView=[[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_WIDTH ,MARGIN_HEIGHT ,116 , 87)];
        self.artImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.artImageView.clipsToBounds = YES;
        self.artImageView.center=CGPointMake(self.artImageView.center.x, self.center.y);
        
        //cell的label
        self.artTitleLabel =[[UITopLable alloc]initWithFrame:CGRectMake(self.artImageView.right+7, self.artImageView.top , self.contentView.width-MARGIN_WIDTH*2-self.artImageView.width-7, 82)];
        [self.artTitleLabel setVerticalAlignment:VerticalAlignmentTop];
        self.artTitleLabel.font=[UIFont systemFontOfSize:16];
        [self.artTitleLabel setTextColor:KColor_51];
        self.artTitleLabel.numberOfLines=3;
        [self.contentView addSubview:self.artTitleLabel];
        [self.contentView addSubview:self.artImageView];
        
        //点击进入文章的Label
        self.comeInLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.width-110, self.contentView.height-30, 100, 20)];
        self.comeInLabel.font=[UIFont systemFontOfSize:14];
        [self.comeInLabel setTextColor:KColor_51];
        [self.contentView addSubview:self.comeInLabel];
    }
    return self;
}
-(void)setSearchCellWithModel:(KBHomeArticleModel *)model
{
    [self.artImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:[UIImage imageNamed:@"载入中小图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
    
    self.artTitleLabel.text = model.firstTitle;
    
    self.comeInLabel.text=@"点击进入文章";
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
