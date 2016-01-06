//
//  KBPlanSectionHeadView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/28.
//  Copyright © 2015年 Test. All rights reserved.
//

//主界面规划的sectionHeadView
#import <UIKit/UIKit.h>

@class KBJudgeTwoSortIdModel;

@interface KBPlanSectionHeadView : UIView


- (instancetype)initWithFrame:(CGRect)frame addSectionLabel:(KBJudgeTwoSortIdModel *)towSortData;
@end
