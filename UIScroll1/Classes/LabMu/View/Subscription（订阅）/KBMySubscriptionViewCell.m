//
//  InterestedCollectionViewCell.m
//  UIScroll1
//
//  Created by 樊振 on 15/10/14.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMySubscriptionViewCell.h"
#import "KBThreeSortModel.h"
#import "KBConstant.h"
#import "KBColumnSortButton.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
@interface KBMySubscriptionViewCell ()
{
    NSIndexPath *_indexPath;
}
/**
 *  三级标签上小图标
 */
@property(nonatomic,strong) UIImageView *imageView;

/**
 *  三级标签名字
 */
@property(nonatomic,strong) UILabel *thirdTypeName;

/**
 *  删除图标
 */
@property(nonatomic,strong) KBColumnSortButton *deleteButton;

@end

@implementation KBMySubscriptionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //图标
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(0.1*self.width, 0.3*self.height, 0.4*self.width, 0.4*self.height);
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.imageView setImage:KLoadingMinImage];
        [self.contentView addSubview:self.imageView];
        //三级标签名字
        self.thirdTypeName = [[UILabel alloc] init];
        self.thirdTypeName.textColor=KColor_85;
        self.thirdTypeName.frame = CGRectMake(self.imageView.right, self.imageView.top, 0.5*self.width, 0.8*self.height);
        self.thirdTypeName.textAlignment=NSTextAlignmentCenter;
        if (kWindowSize.width==320) {
            self.thirdTypeName.font=[UIFont systemFontOfSize:self.thirdTypeName.height*0.4];
        }
        else
            self.thirdTypeName.font=[UIFont systemFontOfSize:self.thirdTypeName.height*0.5];
        [self.contentView addSubview:self.thirdTypeName];
        //cell设置
        self.contentView.layer.borderColor=[UIColor grayColor].CGColor;
        self.contentView.layer.borderWidth=0.8;
        self.contentView.layer.cornerRadius=MIN(self.width, self.height)*0.5;
        self.contentView.backgroundColor = [UIColor whiteColor];
        //删除图标
        self.deleteButton=[[KBColumnSortButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.deleteButton.center=CGPointMake(self.width-10, 0);
        [self.deleteButton setHidden:YES];
        [self addSubview:self.deleteButton];
        UIImageView *deleteImageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20 , 20)];
        deleteImageView.image=[UIImage imageNamed:@"取消关注"];
        [self.deleteButton addSubview:deleteImageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0.1*self.width, 0.1*self.height, 0.2*self.width, 0.8*self.height);
    
    self.thirdTypeName.frame = CGRectMake(self.imageView.right+0.1*self.width, self.imageView.top, 0.5*self.width, 0.8*self.height);
    
}

- (void)setMySubscriptionViewWithModel:(KBThreeSortModel*)model andIndexPath:(NSIndexPath*)indexPath
{
    _indexPath = indexPath;
    //设置删除button
    self.deleteButton.indexPath = indexPath;
    [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置标题
    self.thirdTypeName.text = model.name;
    //设置图片
    if (model.name) {
        [self.imageView setImage:[UIImage imageNamed:model.name]];
    }
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mySubscriptionViewLongPressDo)];
    [self addGestureRecognizer:longPress];
}
//长按
- (void)mySubscriptionViewLongPressDo{
    if ([self.delegate respondsToSelector:@selector(mySubscriptionViewLongPressActionWithIndexPath:)]) {
        [self.delegate mySubscriptionViewLongPressActionWithIndexPath:_indexPath];
    }
}

- (void)deleteAction:(KBColumnSortButton *)button{
    [self.delegate mySubscriptionCellDelete:button.indexPath];
}
//删除图标的隐藏
- (void)setDeleteButtonHidden:(BOOL)hidden
{
    [self.deleteButton setHidden:hidden];
}

@end
