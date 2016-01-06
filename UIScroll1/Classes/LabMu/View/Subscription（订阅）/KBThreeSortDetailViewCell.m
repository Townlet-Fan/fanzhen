//
//  NewTypeThreeCollectionViewCell.m
//  UIScroll1
//
//  Created by kuibu technology on 15/10/7.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBThreeSortDetailViewCell.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
#import "KBColumnModel.h"
#import "YYWebImage.h"
@implementation KBThreeSortDetailViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(2,0, CGRectGetWidth(self.frame)-2, CGRectGetHeight(self.frame)-50)];
        
        self.text=[[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(self.imageView.frame), CGRectGetWidth(self.frame)-5, 50)];
        [self.text setTextColor:KColor_51];
        self.text.textAlignment=NSTextAlignmentLeft;
        self.text.numberOfLines=2;
        
        [self.contentView addSubview:self.imageView];
        [self.imageView addSubview:self.text];

    }
    return self;
}
- (void)setThreeSortDetailViewCellWithModel:(KBColumnModel *)model
{
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholder:KLoadingMinImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        
    }];
    self.text.text=model.pageTitle;
}

@end
