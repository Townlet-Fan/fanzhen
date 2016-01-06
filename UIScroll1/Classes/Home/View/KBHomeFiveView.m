//
//  KBHomeFiveView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeFiveView.h"
#import "KBConstant.h"
#import "KBHomeArticleModel.h"
#import "YYWebImage.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
//距离左边
#define KTitlex 10

//控件的间距
#define KSpace 2

//字体
#define KTopBitImageFont [UIFont fontWithName:@"TrebuchetMS-Bold" size:18]

//下面四个Image和Label之间的间距
#define KImage_Label 5

//下面四个Label的高度

#define KLabelHeight 40

//顶部Label的高度
#define KTopLabelHeight 50

@interface KBHomeFiveView()
///**
// *  五个的顶部大图图片
// */
//@property(nonatomic,strong) UIImageView *topBigImageView;
//
///**
// *  五个的顶部大图标题
// */
//@property(nonatomic,strong) UILabel *topBigImageLabel;

/**
 *  五个的文章的图片
 */

@property(nonatomic,strong)UIImageView * FiveImageView;



@end

@implementation KBHomeFiveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.FiveImageView=[[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.FiveImageView.contentMode=UIViewContentModeScaleAspectFill;
        //可裁剪
        self.FiveImageView.clipsToBounds=YES;
        //可交互
        self.FiveImageView.userInteractionEnabled=YES;
        
       
        [self addSubview:self.FiveImageView];
        
        
        
        self.FiveImageLabel=[[UILabel alloc]init];
        
        [self addSubview:self.FiveImageLabel];
        
    }
    return self;
}
//下面四个小图的model设置
- (void)setViewWithFourViewModel:(KBHomeArticleModel *)model
{
    //计算出标题的大小
    self.FiveImageLabel.frame=CGRectMake(KTitlex, self.FiveImageView.bottom+KImage_Label, (self.FiveImageView.width-2*KTitlex),KLabelHeight);

    self.FiveImageLabel.numberOfLines=2;
    self.FiveImageLabel.textColor=KColor_102;
    self.FiveImageLabel.font=[UIFont systemFontOfSize:15];
  
    //设置标题
    self.FiveImageLabel.text = model.firstTitle;
    
    //设置图片
    [self.FiveImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
    
    
}
//顶部大图的model设置
-(void)setViewWithTopViewModel:(KBHomeArticleModel *)model
{
    //设置大小
    self.FiveImageLabel.frame = CGRectMake(KTitlex,0.6*self.FiveImageView.height, self.FiveImageView.width-2*KTitlex, KTopLabelHeight);
    //设置标题
    self.FiveImageLabel.text = model.firstTitle;
    self.FiveImageLabel.numberOfLines=2;
    self.FiveImageLabel.textColor=[UIColor whiteColor];
     self.FiveImageLabel.font=KFont_20;
    //设置图片
    [self.FiveImageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
    

}


@end
