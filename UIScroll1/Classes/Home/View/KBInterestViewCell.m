//
//  KBInterestViewCell.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBInterestViewCell.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "YYWebImage.h"
#import "UITopLable.h"
#import "KBColumnModel.h"
#import "KBColor.h"
@interface KBInterestViewCell()

/**
 *  所属分类
 */
@property(nonatomic,strong) KBInterestViewCellButton *sortBtn;

/**
 *  背景
 */
@property(nonatomic,strong) UIView *backView;

/**
 *  文章标题
 */
@property(nonatomic,strong) UITopLable *artTitleLabel;

/**
 *  图片的背景
 */
@property(nonatomic,strong) UIView *imageBackView;

/**
 * 阅读量的ImageView
 */
@property(nonatomic,strong) UIImageView * readNumberImageView;

/**
 * 阅读量的label
 */
@property(nonatomic,strong) UILabel * readNumberLabel;

/**
 * 时间的Label
 */
@property(nonatomic,strong) UILabel * timeLabel;

@end

#define kButtonHeight 20

#define kButtonWidth 50

#define kSpace 10

#define VMargin 10

#define findLineMargin 5

//readImage
#define ReadImage [UIImage imageNamed:@"浏览量.png"]
//单元格的宽度
#define cellW  ([UIScreen mainScreen].bounds.size.width-VMargin*3)/2

@implementation KBInterestViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景的view
        self.backView = [[UIView alloc] init];
        self.backView.frame = CGRectMake(0, 0, 0, 0);
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        [self addSubview:self.backView];
        //图片
        self.cellImageView = [[UIImageView alloc] init];
        self.cellImageView.frame = CGRectMake(0, 0, 0, 0);
        self.cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cellImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.cellImageView];
        //标题
        self.artTitleLabel = [[UITopLable alloc] init];
        self.artTitleLabel.font = kFont_14;
        self.artTitleLabel.numberOfLines = 2;
        self.artTitleLabel.textColor = KColor_85;
        [self.artTitleLabel setVerticalAlignment:VerticalAlignmentTop];
        [self.backView addSubview:self.artTitleLabel];
        //分类
        self.sortBtn = [KBInterestViewCellButton buttonWithType:UIButtonTypeCustom];
        [self.sortBtn setFrame:CGRectMake(kSpace,self.contentView.height-10, 40,kButtonHeight)];
        [self.sortBtn setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
        [self.sortBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.backView addSubview:self.sortBtn];
        //阅读量的ImageView
        self.readNumberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.width/2.0, self.sortBtn.top+5, 20, 10)];
        self.readNumberImageView.image=ReadImage;
        [self.backView addSubview:self.readNumberImageView];
        //阅读量的Label
        self.readNumberLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.readNumberImageView.left+24, self.readNumberImageView.top -2, 20, 13)];
        self.readNumberLabel.textColor=[UIColor grayColor];
        self.readNumberLabel.font=[UIFont systemFontOfSize:11];
        self.readNumberLabel.textAlignment=NSTextAlignmentLeft;
        [self.backView addSubview:self.readNumberLabel];
    }
    
    return self;
}

- (CGRect)sizeWithTitle:(NSString *)title
{
    CGRect rect = [title boundingRectWithSize:CGSizeMake(self.contentView.width-30,40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFont_14} context:nil];
    return rect;
    
}
-(CGRect)sizeWithReadNumberLabel:(NSString *)readNumberLabel
{
    CGRect rect = [readNumberLabel boundingRectWithSize:CGSizeMake(40,13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    return rect;
}

- (void)setInterestCellWithModel:(KBColumnModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    [self.contentView layoutIfNeeded];
    //[self.contentView setNeedsDisplay];
    CGRect titleRect = [self sizeWithTitle:model.pageTitle];
    CGRect readNumberLaberRect = [self sizeWithReadNumberLabel:[model.readNumber stringValue]];
    
    self.artTitleLabel.text = model.pageTitle;
    
    self.readNumberLabel.text = [model.readNumber stringValue];

    
    [self.cellImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:KLoadingMinImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        if (image) {
            CGFloat ascale = cellW/ image.size.width;
           //得到cell的size
            CGSize modelSize = CGSizeMake(cellW,image.size.height*ascale + 30 + titleRect.size.height + kSpace*2);
            
            self.backView.frame = CGRectMake(0, 0, modelSize.width, modelSize.height);
            
            self.cellImageView.frame = CGRectMake(0, 0,cellW,modelSize.height-kSpace*2-30-titleRect.size.height);
            //设置标题
            self.artTitleLabel.frame = CGRectMake(kSpace,self.cellImageView.bottom+kSpace,cellW-30,titleRect.size.height);
           
            [self.sortBtn setTitle:model.thirdTypeName forState:UIControlStateNormal];
            [self.sortBtn setFrame:CGRectMake(kSpace,self.artTitleLabel.bottom+kSpace,cellW/2-kSpace, kButtonHeight)];
            
            [self.readNumberImageView setFrame:CGRectMake(self.contentView.width/2.0,self.sortBtn.top+5 , 20, 10)];
            
            [self.readNumberLabel setFrame:CGRectMake(self.readNumberImageView.left+24, self.readNumberImageView.top -2, readNumberLaberRect.size.width, 13)];
            
            //如果size不同 代理回调
            if (!CGSizeEqualToSize(modelSize,model.imageSize)) {
                model.imageSize = modelSize;
                if ([_delegate respondsToSelector:@selector(setCellSizeWithIndexPath:)]) {
                    [_delegate setCellSizeWithIndexPath:indexPath];
                }
            }
        }
    }];
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
      //  comption(finished);
    }];
}

@end

//
@implementation KBInterestViewCellButton


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat rectX = 0;
    CGFloat rectY = 0;
    CGFloat rectWidth = contentRect.size.width;
    CGFloat rectHeight = contentRect.size.height;
    return CGRectMake(rectX, rectY, rectWidth, rectHeight);
}

@end
