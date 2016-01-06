//
//  RightTableViewCell.m
//  UIScroll1
//
//  Created by 樊振 on 15/10/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBThreeSortSubscriptionViewCell.h"
#import "KBThreeSortModel.h"
#import "KBColumnSortButton.h"
#import "KBTwoSortModel.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
# define DEVICE_WIDTH 0.85*[UIScreen mainScreen].bounds.size.width

@interface KBThreeSortSubscriptionViewCell()

/**
 *  三级标签图标
 */
@property(nonatomic,strong) UIImageView *type3ImageView;

/**
 *  三级标签名称
 */
@property(nonatomic,strong) UILabel *type3Name;

/**
 *  加关注按钮
 */
@property(nonatomic,strong) KBColumnSortButton *button;

@property(nonatomic,strong) UIImageView *_imageView;

@end

@implementation KBThreeSortSubscriptionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //三级分类的Icon
        self.type3ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(30, 17.5, 25, 25)];
        self.type3ImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.type3ImageView setImage:KLoadingMinImage];
        [self.contentView addSubview:self.type3ImageView];
        
        //三级分类的名字
        self.type3Name=[[UILabel alloc] initWithFrame:CGRectMake(80, 20, 150,20)];
        self.type3Name.textColor=KColor_85;
        self.type3Name.font=[UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.type3Name];
        
        //关注按钮
        self.button = [[KBColumnSortButton alloc]initWithFrame:CGRectMake(0.75*kWindowSize.width-50, 0, 50,40)];
        self.button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.button];
        
        self._imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 20, 20)];
        [self.button addSubview:self._imageView];
        
        //        [self drawRect:self.frame];//自定义分割线
    }
    return self;
}

- (void)setThreeSortSubscriptionWithModel:(KBThreeSortModel*)model andTwoSortModel:(KBTwoSortModel*)twoSortModel
{
    if (!model.isIntrest) {
        self._imageView.image = [UIImage imageNamed:@"关注.png"];
        [self.button addTarget:self action:@selector(addFocus:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        self._imageView.image = [UIImage imageNamed:@"取消关注.png"];
        [self.button addTarget:self action:@selector(CancelFocus:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.button.cellDelegate = self;
    self.button.findType_2Delegate = twoSortModel;
    self.button.findType_3Delegate = model;
    
    self.type3Name.text = model.name;
    if ([UIImage imageNamed:model.name]) {
        [self.type3ImageView setImage:[UIImage imageNamed:model.name]];
    }
}

- (void)addFocus:(KBColumnSortButton*)button
{
    if ([self.delegate respondsToSelector:@selector(addInterestCell:)]) {
        [self.delegate addInterestCell:button];
    }
}

- (void)CancelFocus:(KBColumnSortButton*)button
{
    if ([self.delegate respondsToSelector:@selector(removecell:)]) {
        [self.delegate removecell:button];
    }
}

//画直线的
- (void)drawRect:(CGRect)rect
{
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //
    //    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //    CGContextFillRect(context, rect);
    //
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
    
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, 0.5, rect.size.height));
}
@end
