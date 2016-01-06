//
//  KBColumnScrillerView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBColumnScrollerView.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "SDCycleScrollView.h"
#import "KBColumnTableViewController.h"
#import "KBColumnModel.h"
#import "KBColor.h"
#import "UIImageView+KBAddView.h"
#import "KBInterestCollectionViewController.h"

//控件之间的距离
#define kSpace 5

//分类buttton的宽度
#define KTypeButtonWidth 60

//分类button的高度
#define kTypeButtonHeight 20

@interface KBColumnScrollerView()

{
    NSMutableArray *images;//滑图图片的数组
    NSMutableArray *allImageInfoArray;
    NSMutableArray * textArray;//滑图图片的标题的数组
    NSMutableArray * typeButtonArray;//滑图图片分类的数组
}
@property (nonatomic,strong)SDCycleScrollView * scrollerView;


@end

@implementation KBColumnScrollerView
- (instancetype)initWithFrame:(CGRect)frame andTableView:(id)columnTable
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollerView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:nil];
        self.scrollerView.delegate = columnTable;
        self.scrollerView.pageControlDotSize = CGSizeMake(10, 10);
        self.scrollerView.placeholderImage = [UIImage imageNamed:@"载入中大图"];
        self.scrollerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.scrollerView.dotColor = KColor_15_86_192;
        self.scrollerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        self.scrollerView.autoScrollTimeInterval = 5.0;
        self.scrollerView.isHomeScroller=NO;

        [self addSubview:self.scrollerView];
    
    }
    return self;
}
- (void)buildScrollerViewImagesWith:(NSArray *)array
{
    
    allImageInfoArray = [NSMutableArray arrayWithArray:array];
    images=[NSMutableArray array];
    textArray=[NSMutableArray array];
    typeButtonArray=[NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(KBColumnModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [images addObject:obj.imageSrc];
        [textArray addObject:obj.pageTitle];
        [typeButtonArray addObject:obj.thirdTypeName];
        
        
    }];
    self.scrollerView.imageURLStringsGroup = images;
    self.scrollerView.defineNewTitleArray=textArray;
    self.scrollerView.defineNewTypeButtonArray=typeButtonArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
