//
//  LeftTableViewCell.m
//  UIScroll1
//
//  Created by 樊振 on 15/10/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBTwoSortSubscriptionCell.h"
#import "KBTwoSortModel.h"
#import "KBColor.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
@interface KBTwoSortSubscriptionCell()

/**
 *  二级分类标签
 */
@property(nonatomic,strong) UILabel *secondTypeLabel;

@end

@implementation KBTwoSortSubscriptionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.secondTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.25*kWindowSize.width, 60)];
        self.secondTypeLabel.textAlignment=NSTextAlignmentCenter;
        self.secondTypeLabel.textColor=KColor_102;
        self.secondTypeLabel.font=[UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.secondTypeLabel];
        self.contentView.backgroundColor=KColor_246;
        //选中时背景颜色以及字体颜色改变，未选中时可以恢复原来背景和字体颜色
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTwoSortSubscriptionCellWith:(KBTwoSortModel*)model andIndexPath:(NSIndexPath*)indexPath
{
    self.secondTypeLabel.text = model.name;
    if (indexPath.section==0) {
        self.secondTypeLabel.textColor=KColor_15_86_192;
    }
    else
    {
        self.secondTypeLabel.textColor=KColor_102;
    }
}
- (void)setTitleColor:(UIColor *)color
{
    self.secondTypeLabel.textColor = color;
}
@end
