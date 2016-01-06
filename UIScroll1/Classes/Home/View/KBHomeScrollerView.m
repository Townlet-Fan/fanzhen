//
//  KBHomeScrollerView.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.

//

#import "KBHomeScrollerView.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "SDCycleScrollView.h"
#import "KBHomeMainTableViewController.h"
#import "KBHomeArticleModel.h"
#import "KBColor.h"
@interface KBHomeScrollerView()

@property(nonatomic,strong) SDCycleScrollView *scrollerView;

@end

@implementation KBHomeScrollerView

- (instancetype)initWithFrame:(CGRect)frame andTableView:(KBHomeMainTableViewController *)homeTable
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollerView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:nil];
        self.scrollerView.delegate = homeTable;
        self.scrollerView.pageControlDotSize = CGSizeMake(10, 10);
        self.scrollerView.placeholderImage = [UIImage imageNamed:@"载入中大图"];
        self.scrollerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.scrollerView.dotColor =KColor_15_86_192;
        self.scrollerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        self.scrollerView.autoScrollTimeInterval = 5.0;
        self.scrollerView.isHomeScroller=YES;
        [self addSubview:self.scrollerView];
    }
    return self;
}

- (void)buildScrollerViewImagesWith:(NSArray *)array
{
    NSMutableArray *images = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(KBHomeArticleModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [images addObject:obj.imageSrc];
    }];
    self.scrollerView.imageURLStringsGroup = images;
}

@end
