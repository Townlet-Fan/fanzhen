//
//  KBHomeScrollerView.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

//首页滑动视图

#import <UIKit/UIKit.h>

@class KBHomeMainTableViewController;

typedef NS_ENUM(NSInteger,KBHomeScrollerViewStyle){
    kBHomeScrollerViewStyleHome,
    kBHomeScrollerViewStyleFind,
}kBHomeScrollerViewStyle;

@interface KBHomeScrollerView : UIView

@property(nonatomic,assign) KBHomeScrollerViewStyle style;
//初始化
- (instancetype)initWithFrame:(CGRect)frame andTableView:(KBHomeMainTableViewController *)homeTable;

- (void)buildScrollerViewImagesWith:(NSArray *)array;

@end
