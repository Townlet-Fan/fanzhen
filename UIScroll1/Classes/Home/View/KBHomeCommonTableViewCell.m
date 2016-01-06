//
//  KBHomeCommonTableViewCell.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/10.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeCommonTableViewCell.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "UITopLable.h"
#import "KBHomeArticleModel.h"
#import "YYWebImage.h"
#import "KBColor.h"
//控件的间距
#define kSpace 5
//cell的大小
#define USUAL_CELL_HEIGHT 95
//button 的高度
#define BTN_HEIGHT 15
//readImage
#define ReadImage [UIImage imageNamed:@"浏览量.png"]

@interface KBHomeCommonTableViewCell()
{
    NSIndexPath *_indexPath; //记录行数
}
/**
 *  第一张图片
 */
@property(nonatomic,strong) UIImageView *headImageView;

/**
 *  文章的图片
 */
@property(nonatomic,strong) UIImageView *artImageView;

/**
 *  文章标题
 */
@property(nonatomic,strong) UITopLable *artTitleLabel;

/**
 * 文章的三级分类
 */
@property (nonatomic,strong) UIButton * artTypeButton;
/**
 *  cell的阅读量的ImageView
 */
@property (nonatomic,strong) UIImageView * readNumImageView;



@end

@implementation KBHomeCommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _indexPath = indexPath;
       self.backgroundColor=KColor_235;
        if (indexPath.row == 0) {
            //cell的尺寸重新设置
            [self setFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.width/2.727+kSpace)];
            [self.contentView setFrame:self.frame];
            //第一个cell的 头视图
            self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpace,kSpace,kWindowSize.width-kSpace*2,kWindowSize.width/2.727)];
            self.headImageView.backgroundColor=KColor_153_Alpha_05;
            self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
//            self.headImageView.backgroundColor=KColor_153_Alpha_05;
            self.headImageView.clipsToBounds = YES;
            [self.contentView addSubview:self.headImageView];
           
        }else{
            [self setFrame:CGRectMake(0, 0, kWindowSize.width, USUAL_CELL_HEIGHT)];
            [self.contentView setFrame:self.frame];
           
            //cell加入到colorView
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(kSpace, kSpace, self.width-10, self.height-5)];
            colorView.backgroundColor=[UIColor whiteColor];
            [self.contentView addSubview:colorView];
            //文章的图
            self.artImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (self.height)*1.5,colorView.height)];
            self.artImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.artImageView.clipsToBounds = YES;
            [colorView addSubview:self.artImageView];
            
            //文章的标题
            self.artTitleLabel = [[UITopLable alloc] initWithFrame:CGRectMake(self.artImageView.right+7,self.artImageView.left+15,colorView.width-self.artImageView.width-17,82)];
            self.artTitleLabel.numberOfLines = 2;
            self.artTitleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
            [self.artTitleLabel setTextColor:KColor_51];
            self.artTitleLabel.numberOfLines=2;
            [colorView addSubview:self.artTitleLabel];
            
            //cell的类型的button
            self.artTypeButton =[[UIButton alloc]initWithFrame:CGRectMake(self.artTitleLabel.left, self.artImageView.height-25, 50, BTN_HEIGHT)];
            [self.artTypeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.artTypeButton setTitle:@"类别" forState:UIControlStateNormal];
            self.artTypeButton.titleLabel.font=[UIFont systemFontOfSize:11];
            self.artTypeButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            
            //typebutton的layerout
            self.artTypeButton.layer.borderColor=[UIColor grayColor].CGColor;
            self.artTypeButton.layer.borderWidth=1;
            self.artTypeButton.layer.cornerRadius=3;
            [colorView addSubview:self.artTypeButton];
            
            //cell的阅读量的ImageView
            self.readNumImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.artTitleLabel.left+63, self.artTypeButton.top+3, 20, 10)];
            self.readNumImageView.image=ReadImage;
            [colorView addSubview:self.readNumImageView];
            
            //cell的阅读量的Label
            self.readNumLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.artTitleLabel.left+86, self.artTypeButton.top+2, 100, 13)];
            self.readNumLabel.textColor=[UIColor grayColor];
            self.readNumLabel.font=[UIFont systemFontOfSize:11];
            self.readNumLabel.textAlignment=NSTextAlignmentLeft;
            [colorView addSubview:self.readNumLabel];
        }
    }
    
    return self;
}

- (void)setCommonCellWithModel:(KBHomeArticleModel *)model
{
    if (_indexPath.row == 0) {
        [self.headImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            
        }];
    }else
    {
        [self.artImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:[UIImage imageNamed:@"载入中小图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        }];
        
        self.artTitleLabel.text = model.firstTitle;
        [self.artTypeButton setTitle:model.thirdTypeName forState:UIControlStateNormal];
        self.readNumLabel.text=[model.readNumber stringValue];
    }
}


@end
