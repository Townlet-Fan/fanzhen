//
//  KBPlanViewCell.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/28.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBPlanViewCell.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "UITopLable.h"
#import "KBColumnModel.h"
#import "YYWebImage.h"
#import "KBColor.h"
#import "KBJudgeTwoSortIdModel.h"
#import "KBSubscriptionDrawTriangle.h"
#import <UIKit/UIKit.h>

//控件距离左边的距离
#define MARGIN_WIDTH 7
//控件距离上边的距离
#define MARGIN_HEIGHT 5
//button 的高度
#define BTN_HEIGHT 20
//readImage
#define ReadImage [UIImage imageNamed:@"浏览量.png"]

@interface KBPlanViewCell()

/**
 *  cell的标题
 */

@property (nonatomic,strong) UITopLable * artTitleLabel;

/**
 *  cell的类型的button
 */

@property (nonatomic,strong) UILabel * typeLabel;

/**
 *  cell的阅读量的ImageView
 */
@property (nonatomic,strong) UIImageView * readNumImageView;

/**
 *  cell里容纳各个空间的View
 */
@property (nonatomic,strong) UIView *colorView;

/**
 *  三角形的View
 */
@property (nonatomic,strong) KBSubscriptionDrawTriangle *triangleView;

/**
 *  三级分类和三级分类之间的间隔
 */
@property (nonatomic,strong) UIView * separatorView;

@end

@implementation KBPlanViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell加入到colorView
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, 0, kWindowSize.width-2*MARGIN_WIDTH,(kWindowSize.width-2*MARGIN_WIDTH) * 9 /16.0 +130)];
        self.colorView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.colorView];
        //cell的图
        self.artImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0 ,0 ,self.colorView.width,self.colorView.width * 9/16.0)];
        self.artImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.artImageView.clipsToBounds = YES;
        self.artImageView.opaque=NO;
        [self.colorView addSubview:self.artImageView];

        self.artTitleLabel =[[UITopLable alloc]initWithFrame:CGRectMake(self.artImageView.left+2*MARGIN_WIDTH, self.artImageView.bottom + 2*MARGIN_HEIGHT , self.colorView.width-MARGIN_WIDTH*4, 90)];
        [self.artTitleLabel setVerticalAlignment:VerticalAlignmentTop];
        self.artTitleLabel.font=[UIFont systemFontOfSize:16];
        [self.artTitleLabel setTextColor:KColor_51];
        self.artTitleLabel.numberOfLines=2;
        [self.colorView addSubview:self.artTitleLabel];
        
        //cell的类型的Label
        self.typeLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.artTitleLabel.left, self.artTitleLabel.bottom+2*MARGIN_HEIGHT, 60, BTN_HEIGHT)];
        self.typeLabel.textColor=KColor_15_86_192;
        self.typeLabel.font=[UIFont systemFontOfSize:15];
        self.typeLabel.textAlignment=NSTextAlignmentLeft;
        [self.colorView addSubview:self.typeLabel];
        
        //cell的阅读量的ImageView
        self.readNumImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.typeLabel.right+20, self.typeLabel.top+5, 20, 10)];
        self.readNumImageView.image=ReadImage;
        [self.colorView addSubview:self.readNumImageView];
        
        //cell的阅读量的Label
        self.readNumLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.readNumImageView.left+22, self.typeLabel.top+3, 40, 13)];
        self.readNumLabel.textColor=[UIColor grayColor];
        self.readNumLabel.font=[UIFont systemFontOfSize:11];
        self.readNumLabel.textAlignment=NSTextAlignmentLeft;
        [self.colorView addSubview:self.readNumLabel];
        
        [self.colorView setFrame:CGRectMake(MARGIN_WIDTH,0, kWindowSize.width-2*MARGIN_WIDTH, self.typeLabel.bottom+20)];
        [self setFrame:CGRectMake(0, 0, kWindowSize.width, self.typeLabel.bottom+20)];
        [self.contentView setFrame:self.frame];
        
        //三级分类之间的分割线
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(self.typeLabel.left+5, self.typeLabel.bottom+5, self.colorView.width-2*(self.typeLabel.left+5), 1)];
        self.separatorView.backgroundColor=[UIColor redColor];
         //self.backgroundColor = [UIColor blueColor];
        self.backgroundColor = KColor_230;
    }
    return self;
}
//设置cell模型的数据
- (void)setPlanCellWithModel:(KBColumnModel *)model;
{
    
   [self setViewWithColumnModel:model];
   [self.artImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:[UIImage imageNamed:@"载入中大图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
    //[self triangle];//三角形会变位置是因为图的尺寸的原因 固定就不会了
    
    self.artTitleLabel.text = model.pageTitle;
    self.typeLabel.text=model.thirdTypeName;
    self.readNumLabel.text=[[model readNumber]stringValue];
}
//设置各个控件的大小
-(void)setViewWithColumnModel:(KBColumnModel *)model
{
    //计算标题的高度
    CGRect titleRect = [self sizeWithTitle:model.pageTitle];
    [self.artTitleLabel setFrame:CGRectMake(self.artImageView.left+MARGIN_WIDTH*2, self.artImageView.bottom + MARGIN_HEIGHT , self.colorView.width-MARGIN_WIDTH*4, titleRect.size.height)];
    [self.typeLabel setFrame:CGRectMake(self.artTitleLabel.left, self.artTitleLabel.bottom+2*MARGIN_HEIGHT, 60, BTN_HEIGHT)];
    [self.readNumImageView setFrame:CGRectMake(self.typeLabel.right+20, self.typeLabel.top+5, 20, 10)];
    [self.readNumLabel setFrame:CGRectMake(self.readNumImageView.left+22, self.typeLabel.top+3, 40, 13)];
    [self setFrame:CGRectMake(0, 0, kWindowSize.width, self.typeLabel.bottom+20)];
    [self.colorView setFrame:CGRectMake(MARGIN_WIDTH,0, kWindowSize.width-2*MARGIN_WIDTH, self.typeLabel.bottom+20)];
    [self.contentView setFrame:self.frame];

}
#pragma mark -  计算title的高度
- (CGRect)sizeWithTitle:(NSString *)title
{
    CGRect rect = [title boundingRectWithSize:CGSizeMake((kWindowSize.width-2*MARGIN_WIDTH)-4*MARGIN_WIDTH,90) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    return rect;
}
#pragma mark - 设置三角形
-(void)triangle
{
    CGSize size = [self.artImageView.image size];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height+4), NO, 0);
    [self.imageView.image drawAtPoint:CGPointMake(0, 0)];
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    //CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextMoveToPoint(context,0.10*size.width, size.height+4);//设置起点
    CGContextAddLineToPoint(context,0.15*size.width, size.height-9);
    CGContextAddLineToPoint(context,0.20*size.width, size.height+4);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [[UIColor whiteColor] setFill]; //设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = im;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
