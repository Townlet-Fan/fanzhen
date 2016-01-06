//
//  KBColumnHeadView.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//


//栏目的cell 的section的head
#import <UIKit/UIKit.h>

@class KBJudgeTwoSortIdModel;

@interface KBColumnHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame addSectionLabel:(KBJudgeTwoSortIdModel *)towSortData;
@end
