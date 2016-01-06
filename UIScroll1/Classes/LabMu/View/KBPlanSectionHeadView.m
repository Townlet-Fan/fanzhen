//
//  KBPlanSectionHeadView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/28.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBPlanSectionHeadView.h"
#import "KBColumnModel.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "KBJudgeTwoSortIdModel.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
//sectionHead的高度
#define sectionHeadHeight 45

@interface KBPlanSectionHeadView()
/**
 *  section的head
 */
@property (nonatomic,strong) UIView * sectionHeadView;

/**
 *  section的Image
 */
@property (nonatomic,strong) UIImageView * sectionHeadImageView;

/**
 * setion的label
 */
@property (nonatomic,strong) UILabel *sectionHeadLabel;
@end

@implementation KBPlanSectionHeadView

- (instancetype)initWithFrame:(CGRect)frame addSectionLabel:(KBJudgeTwoSortIdModel *)towSortData
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=KColor_230;
        self.sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(7, 7, kWindowSize.width-14, sectionHeadHeight)];
        self.sectionHeadView.backgroundColor=[UIColor whiteColor];
        //设置某几个角为圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sectionHeadView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.sectionHeadView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.sectionHeadView.layer.mask = maskLayer;
        
        self.sectionHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 20, 20)];
        self.sectionHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.sectionHeadImageView.image=[UIImage imageNamed:@"删除小蓝"];

        
        self.sectionHeadLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.sectionHeadImageView.right+10, self.sectionHeadImageView.top + 2.5, 80, 15)];
        self.sectionHeadLabel.textColor = KColor_15_86_192;
        self.sectionHeadLabel.textAlignment = NSTextAlignmentLeft;
        
        for (int i=0; i<4; i++) {
            NSArray *typeOneArray=[[NSArray alloc]initWithArray:[[KBLoginSingle newinstance].userAllTypeArray objectAtIndex:i]];
            for (int j=0; j<typeOneArray.count; j++) {
                KBTwoSortModel * twoSort=[typeOneArray objectAtIndex:j];
                if (towSortData.ID==twoSort.TypeTowID) {
                    [self.sectionHeadLabel setText:twoSort.name];
//                     [self.sectionHeadImageView setImage:[UIImage imageNamed:twoSort.name]];
                }
                
            }
            
        }
        [self.sectionHeadView addSubview:self.sectionHeadImageView];
        [self.sectionHeadView addSubview:self.sectionHeadLabel];
        [self addSubview:self.sectionHeadView];
        [self setFrame:CGRectMake(5, 0, kWindowSize.width, sectionHeadHeight)];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
