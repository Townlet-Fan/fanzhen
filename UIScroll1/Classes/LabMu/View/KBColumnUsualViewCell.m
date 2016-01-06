//
//  usualViewCell.m
//  UIScroll1
//
//  Created by eddie on 15-3-29.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBColumnUsualViewCell.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "UITopLable.h"
#import "KBColumnModel.h"
#import "YYWebImage.h"
#import "KBColor.h"
#import "LikeButton.h"
#import "UIButtonWithIndexPath.h"
#import "KBJudgeTwoSortIdModel.h"

//控件距离左边的距离
#define MARGIN_WIDTH 14
//控件距离上边的距离
#define MARGIN_HEIGHT 10
//cell的高度
#define USUAL_CELL_HEIGHT 107
//button 的高度
#define BTN_HEIGHT 15
//readImage
#define ReadImage [UIImage imageNamed:@"浏览量.png"]

@interface KBColumnUsualViewCell()


/**
 *  cell的标题
 */

@property (nonatomic,strong) UITopLable * artTitleLabel;

/**
 *  cell的类型的button
 */

@property (nonatomic,strong) UIButtonWithIndexPath * typeBtn;

/**
 *  cell的阅读量的ImageView
 */
@property (nonatomic,strong) UIImageView * readNumImageView;


/**
 *  保存当前分类所有数据的数组
 */
@property (nonatomic,strong)NSArray * allTypeArray;

@end

@implementation KBColumnUsualViewCell
- (void)awakeFromNib {
    // Initialization code
  
   
}
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
        
        //cell的类型的button
         self.typeBtn =[[UIButtonWithIndexPath alloc]initWithFrame:CGRectMake(self.artImageView.right+7, self.artImageView.height+MARGIN_HEIGHT-BTN_HEIGHT, 50, BTN_HEIGHT)];
        [self.typeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.typeBtn setTitle:@"类别" forState:UIControlStateNormal];
        self.typeBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        self.typeBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        
        //typebutton的layerout
        self.typeBtn.layer.borderColor=[UIColor grayColor].CGColor;
        self.typeBtn.layer.borderWidth=1;
        self.typeBtn.layer.cornerRadius=3;
        [self.contentView addSubview:self.typeBtn];
        
        //cell的阅读量的ImageView
        self.readNumImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.artTitleLabel.left+63, self.typeBtn.top+3, 20, 10)];
        self.readNumImageView.image=ReadImage;
        [self.contentView addSubview:self.readNumImageView];
        
        //cell的阅读量的Label
        self.readNumLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.artTitleLabel.left+86, self.typeBtn.top+2, 100, 13)];
        self.readNumLabel.textColor=[UIColor grayColor];
        self.readNumLabel.font=[UIFont systemFontOfSize:11];
        self.readNumLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.readNumLabel];
        
    }
    return self;
}
- (void)setUsualCellWithModel:(KBColumnModel *)model withIndex:(NSIndexPath *)indexPath withArray:(NSArray *)columnTypeArray
{
    _allTypeArray=columnTypeArray;
    [self.artImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:[UIImage imageNamed:@"载入中小图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        }];
    
    self.artTitleLabel.text = model.pageTitle;
    [self.typeBtn setTitle:model.thirdTypeName forState:UIControlStateNormal];
    self.readNumLabel.text=[[model readNumber]stringValue];
    self.typeBtn.indexPath=indexPath;
    [self.typeBtn addTarget:self action:@selector(pushTypeThree:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - typeButton的点击事件
- (void)pushTypeThree:(UIButtonWithIndexPath *)typeButton
{
   
    KBJudgeTwoSortIdModel * twoSortIdData=_allTypeArray[typeButton.indexPath.section];
    KBColumnModel * columnModel=twoSortIdData.subArticleArray[typeButton.indexPath.row];
    //代理
    if ([_delegate respondsToSelector:@selector(pushTypeThreeDelegate:)]) {
        
        [_delegate pushTypeThreeDelegate:columnModel];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
