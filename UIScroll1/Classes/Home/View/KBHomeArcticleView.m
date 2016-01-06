//
//  KBHomeArcticleView.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeArcticleView.h"
#import "KBConstant.h"
#import "KBHomeArticleModel.h"
#import "YYWebImage.h"
#import "UIView+ITTAdditions.h"
//距离左边
#define kTitleX 5

//控件的间距
#define kSpace 10

@interface KBHomeArcticleView()

/**
 *  文章的图片
 */
@property(nonatomic,strong) UIImageView *arcticleImage;


@end

@implementation KBHomeArcticleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arcticleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.arcticleImage.contentMode = UIViewContentModeScaleAspectFill;
        //可剪裁
        self.arcticleImage.clipsToBounds = YES;
        //可交互
        self.arcticleImage.userInteractionEnabled = YES;
        [self addSubview:self.arcticleImage];
        
        self.arcticleLabel = [[UILabel alloc] init];
        self.arcticleLabel.textColor = [UIColor whiteColor];
        self.arcticleLabel.numberOfLines = 0;
       // self.arcticleLabel.textAlignment = NSTextAlignmentCenter;
        self.arcticleLabel.font = kFont_14;
        [self addSubview:self.arcticleLabel];
    }
    
    return self;
}

- (void)setViewWithartModel:(KBHomeArticleModel *)model
{
    //计算出标题的大小
    CGRect labelRect = [self labelRectWithTitle:model.firstTitle];
    //设置大小
    self.arcticleLabel.frame = CGRectMake(kTitleX*2,self.arcticleImage.height-labelRect.size.height-kSpace,labelRect.size.width-kSpace*2,labelRect.size.height);
    
    //设置图片
    [self.arcticleImage yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        
    }];
    
    //设置标题
    self.arcticleLabel.text = model.firstTitle;
}

#pragma mark - 计算大小
- (CGRect)labelRectWithTitle:(NSString *)title
{
    CGRect rect = [title boundingRectWithSize:CGSizeMake(self.arcticleImage.width, self.arcticleImage.height/1.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    return rect;
}


@end
