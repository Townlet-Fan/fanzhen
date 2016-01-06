//
//  KBColumnHeadView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBColumnHeadView.h"
#import "KBColumnModel.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "KBJudgeTwoSortIdModel.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
@interface KBColumnHeadView()
/**
 *  section的head
 */
@property (nonatomic,strong) UIView * sectionHeadView;

/**
 * setion的label
 */
@property (nonatomic,strong) UILabel *sectionHeadLabel;

@end

@implementation KBColumnHeadView

- (instancetype)initWithFrame:(CGRect)frame addSectionLabel:(KBJudgeTwoSortIdModel *)towSortData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor= KColor_230;
        self.sectionHeadView = [[UIView alloc] initWithFrame:frame];
        self.sectionHeadView.backgroundColor=KColor_246;
        
        self.sectionHeadLabel=[[UILabel alloc]initWithFrame:self.sectionHeadView.frame];
        
        for (int i=0; i<4; i++) {
            NSArray *typeOneArray=[[NSArray alloc]initWithArray:[[KBLoginSingle newinstance].userAllTypeArray objectAtIndex:i]];
            for (int j=0; j<typeOneArray.count; j++) {
                KBTwoSortModel * twoSort=[typeOneArray objectAtIndex:j];
                if (towSortData.ID==twoSort.TypeTowID) {
                    [self.sectionHeadLabel setText:twoSort.name];
                }
                
            }
            
        }

        self.sectionHeadLabel.textAlignment=NSTextAlignmentCenter;
        
        [self.sectionHeadLabel setTextColor:[UIColor grayColor]];
        
        [self addSubview:self.sectionHeadView];
        [self addSubview:self.sectionHeadLabel];
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
