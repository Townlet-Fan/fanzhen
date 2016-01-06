//
//  KBMyCollectionReusableView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/14.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMyCollectionReusableView.h"
#import "KBTwoSortModel.h"
#import "KBConstant.h"
@interface KBMyCollectionReusableView ()

/**
 *  SectionHeader或SectionFooter标签
 */
@property UILabel *label;

@end

@implementation KBMyCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
        self.label.font=[UIFont systemFontOfSize:15.0f];
        self.label.textColor=[UIColor grayColor];
        [self addSubview:self.label];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)setReusableViewWithModel:(KBTwoSortModel*)model andIsSectionHeader:(BOOL)isSectionHeader
{
    if (isSectionHeader) {
        self.label.text = model.name;
    }
    else{
        self.label.frame=CGRectMake(kWindowSize.width-100, 0, 120, 20);
        self.label.font=[UIFont systemFontOfSize:12.0f];
        self.label.text=@"长按编辑删除";
        self.label.textAlignment=NSTextAlignmentLeft;
    }
    
}
- (void)setBorderView
{
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, kWindowSize.width, 2)];
    borderView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self addSubview:borderView];
}

@end
