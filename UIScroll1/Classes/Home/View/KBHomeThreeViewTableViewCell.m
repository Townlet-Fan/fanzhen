//
//  RecommendTableViewCell.m
//  UIScroll1
//
//  Created by kuibu technology on 15/9/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeThreeViewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "KBHomeArcticleView.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBHomeArticleModel.h"
#import "UIImageView+KBAddView.h"
#define  rowHeight 201

//控件间距
#define kSpace 2



@interface KBHomeThreeViewTableViewCell()
{
    NSArray *_artsArray; //文章的数组
    float rowHeight1;
    float DEVICE_WIDTH,DEVICE_HEIGHT;
    float ImageWidth,ImageHeight;
}
/**
 *  左上方
 */
@property(nonatomic,strong) KBHomeArcticleView *leftUpView;
/**
 *  左下方
 */
@property(nonatomic,strong) KBHomeArcticleView *leftDownView;
/**
 *  右边
 */
@property(nonatomic,strong) KBHomeArcticleView *rightView;

@end

@implementation KBHomeThreeViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
        DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
        ImageWidth=0.58*DEVICE_WIDTH;
        ImageHeight=ImageWidth/1.8;
        //初始化视图
        //左上方
        self.leftUpView = [[KBHomeArcticleView alloc] initWithFrame:CGRectMake(0, kSpace, ImageWidth, ImageHeight)];
        //加阴影
        [self setDimViewWithView:self.leftUpView andImageName:@"横"];
        
        [self.contentView addSubview:self.leftUpView];
        //左下方
        self.leftDownView = [[KBHomeArcticleView alloc] initWithFrame:CGRectMake(0, self.leftUpView.bottom + kSpace,ImageWidth,ImageHeight)];
        [self setDimViewWithView:self.leftDownView andImageName:@"横"];
        [self.contentView addSubview:self.leftDownView];
        //右边
        self.rightView = [[KBHomeArcticleView alloc] initWithFrame:CGRectMake(self.leftDownView.right+kSpace,kSpace,kWindowSize.width-self.leftDownView.width-kSpace, ImageHeight*2+kSpace)];
        [self setDimViewWithView:self.rightView andImageName:@"竖"];
        
        [self.contentView addSubview:self.rightView];
        
        [self setFrame:CGRectMake(0, 0, DEVICE_WIDTH, ImageHeight*2+2+kSpace)];
        [self.contentView setFrame:self.frame];
        
        
    }
    return  self;
}

- (void)setAcrticleViewWithArray:(NSArray *)array
{
    _artsArray = array;
    //设置每个view
    [_artsArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:{
                [self setarctModelWithTag:idx andView:self.leftUpView];
            }
                break;
            case 1:{
                [self setarctModelWithTag:idx andView:self.leftDownView];
            }
                break;
            case 2:{
                [self setarctModelWithTag:idx andView:self.rightView];
            }
                break;
            default:
                break;
        }
    }];
   
    
}

#pragma mark - 图片上加蒙版

- (void)setDimViewWithView:(KBHomeArcticleView *)view andImageName:(NSString *)imageName
{
    [UIImageView addDimImageViewWithImageName:imageName toView:view];
    [view addSubview:view.arcticleLabel];
}

#pragma mark - 设置文章的view
- (void)setarctModelWithTag:(NSInteger)tag andView:(KBHomeArcticleView *)artView
{
    //取出model
    KBHomeArticleModel *art = _artsArray[tag];
    //有数据的时候再 加上手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arctViewTapDo:)];
    [artView addGestureRecognizer:tap];
    //设置tag
    artView.tag = tag;
    artView.userInteractionEnabled = YES;
    //设置view
    [artView setViewWithartModel:art];
}

#pragma mark - 文章view的点击事件
- (void)arctViewTapDo:(UITapGestureRecognizer *)tap
{
    KBHomeArticleModel *artModel = _artsArray[tap.view.tag];
    //代理 
    if ([_delegate respondsToSelector:@selector(artViewTapActionWithartModel:)]) {
        [_delegate artViewTapActionWithartModel:artModel];
    }
    
}


@end
