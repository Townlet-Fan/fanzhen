//
//  MyFooterTableViewCell.m
//  UIScroll1
//
//  Created by kuibu technology on 15/7/26.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMyFooterViewCell.h"
#import "KBCommonSingleValueModel.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "UITopLable.h"
#import "YYWebImage.h"
#import "KBMyCollectionDataModel.h"
#import "KBLoginSingle.h"
//距离左边的距离
#define MARGIN_WIDTH 12
//距离上边的距离
#define MARGIN_HEIGHT 10
//cell的高度
#define USUAL_CELL_HEIGHT 90
//typeButton的高度
#define BTN_HEIGHT 15


@implementation KBMyFooterViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, USUAL_CELL_HEIGHT)];
        [self.contentView setFrame:self.frame];
        
        //左侧图
        self.customImageView=[[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_WIDTH ,MARGIN_HEIGHT , 80, 59)];
        self.customImageView.center=CGPointMake(self.customImageView.center.x, self.center.y);
        
        //标题
        self.titleLable  =[[UITopLable alloc]initWithFrame:CGRectMake(self.customImageView.right+7, self.customImageView.top , self.contentView.width-MARGIN_WIDTH*2-self.customImageView.width-7, 82)];
        [self.titleLable setVerticalAlignment:VerticalAlignmentTop];
        self.titleLable.font=[UIFont systemFontOfSize:16];
        [self.titleLable setTextColor:KColor_51];
        self.titleLable.numberOfLines=1;
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.customImageView];
        
        //三级分类
        self.TypeBtn  =[[UIButton alloc]initWithFrame:CGRectMake(self.titleLable.left, self.customImageView.height, 50, BTN_HEIGHT)];
        [self.TypeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.TypeBtn setTitle:@"类别" forState:UIControlStateNormal];
        self.TypeBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        self.TypeBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        
        self.TypeBtn.layer.borderColor=[UIColor grayColor].CGColor;
        self.TypeBtn.layer.borderWidth=1;
        self.TypeBtn.layer.cornerRadius=3;
        if ([[KBCommonSingleValueModel newinstance].DeviceModel rangeOfString:@"iPhone 4"].location != NSNotFound) {
            self.TypeBtn.titleEdgeInsets=UIEdgeInsetsMake(2, 0, 0, 0) ;
        }
        [self.contentView addSubview:self.TypeBtn];
        
        //时间标签
        self.timeLable=[[UILabel alloc]initWithFrame:CGRectMake(self.titleLable.left+70, self.TypeBtn.top, self.width-(self.TypeBtn.right), 15)];
        self.timeLable.textColor=[UIColor grayColor];
        self.timeLable.font=[UIFont systemFontOfSize:14];
        self.timeLable.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLable];
    }
    return self;
}
- (void)setUsualCellWithModel:(KBMyCollectionDataModel *)model
{
    if ([KBLoginSingle newinstance].isLogined) {
        [self.customImageView yy_setImageWithURL:[NSURL URLWithString:model.imagestr] placeholder:[UIImage imageNamed:@"载入中小图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        }];
    }
    else
        self.customImageView.image=model.imageData;

    self.titleLable.text = model.articleTitle;
    
    [self.TypeBtn setTitle:model.TypeName forState:UIControlStateNormal];
    
    self.timeLable.text=model.time;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
