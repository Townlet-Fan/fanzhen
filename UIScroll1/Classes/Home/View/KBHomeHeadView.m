//
//  KBHomeHeadView.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/10.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeHeadView.h"
#import "KBHomeArticleModel.h"
#import "YYWebImage.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBHomeAllData.h"
#import "KBColor.h"
#import "UIImageView+KBAddView.h"
@interface KBHomeHeadView()

/**
 *  section的Head
 */
@property(nonatomic,strong) UIImageView *sectionHeadImage;

/**
 *  section的Head的breakArray
 */
@property(nonatomic,strong)NSArray * sectionHeadArray;




@end

@implementation KBHomeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionHeadImage = [[UIImageView alloc] init];
        self.sectionHeadImage.contentMode = UIViewContentModeScaleToFill;
        self.sectionHeadImage.clipsToBounds = YES;
        self.sectionHeadImage.userInteractionEnabled = YES;
        self.sectionHeadImage.backgroundColor=KColor_153_Alpha_05;
       
        self.sectionHeadLabel=[[UILabel alloc]init];
        self.sectionHeadLabel.font=KFont_20;
        self.sectionHeadLabel.textColor=[UIColor whiteColor];
        self.sectionHeadLabel.numberOfLines=2;
        
        
        [self addSubview:self.sectionHeadImage];
        [self addSubview:self.sectionHeadLabel];
    }
    
    return self;
}

- (CGFloat)setSectionImageWith:(KBHomeArticleModel *)model andSection:(NSInteger)indexPath withBreakArray:(NSArray *)breakArray withKbHomeHeadView:(KBHomeHeadView *)homeHeadView
{
    _sectionHeadArray=breakArray;
    CGFloat leftX = 5;
     CGFloat topY = 5;
    if (indexPath == 2||indexPath==3||indexPath==5||indexPath==7)
    {
        leftX = 0;
        
    }
    //计算图片大小
     CGFloat scale = [[KBHomeAllData shareInstance].scaleNum[indexPath-1] floatValue];
    self.sectionHeadImage.frame = CGRectMake(leftX,topY,kWindowSize.width-leftX*2,scale<16?kWindowSize.width/scale:9*kWindowSize.width/scale);
    [self.sectionHeadLabel setFrame:CGRectMake(10, self.sectionHeadImage.height-60, self.sectionHeadImage.width-20, 50)];
    //设置图片
    [self.sectionHeadImage yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
   if (scale==16)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewTapDo:)];
        //设置tag
        homeHeadView.tag = indexPath;
        homeHeadView.userInteractionEnabled = YES;
        [homeHeadView addGestureRecognizer:tap];
    }
    self.sectionHeadLabel.text=model.firstTitle;
    //重新设置 frame
    [self setFrame:CGRectMake(0,0,kWindowSize.width,self.sectionHeadImage.height+topY*2)];
    return self.frame.size.height;
}
#pragma mark - headView的点击事件
- (void)headViewTapDo:(UITapGestureRecognizer *)tap
{
    KBHomeArticleModel *headViewModel =_sectionHeadArray[tap.view.tag-1];
    //代理
    if ([_delegate respondsToSelector:@selector(headViewTapActionWithartModel:)]) {
        [_delegate headViewTapActionWithartModel:headViewModel];
    }
    
}


@end
