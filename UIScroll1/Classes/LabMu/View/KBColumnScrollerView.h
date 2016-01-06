//
//  KBColumnScrillerView.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//


//栏目是的滑动视图
#import <UIKit/UIKit.h>

@class KBColumnTableViewController;

typedef NS_ENUM(NSInteger,KBColunmnScrollerViewStyle){
    kBColumnScrollerViewStyleSubject,
    kBColumnScrollerViewStyleAbility,
    KBColumnScrollerViewStylePlan,
    KBColumnScrollerViewStyleInterest,
}kBColumnScrollerViewStyle;

@interface KBColumnScrollerView : UIView

@property (nonatomic,assign)KBColunmnScrollerViewStyle * style;

//初始化
- (instancetype)initWithFrame:(CGRect)frame andTableView:(id)columnTable;

- (void)buildScrollerViewImagesWith:(NSArray *)array;



@end
