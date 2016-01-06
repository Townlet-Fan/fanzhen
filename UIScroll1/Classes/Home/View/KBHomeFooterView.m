//
//  KBHomeFooterView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBHomeFooterView.h"
#import "KBColor.h"
@implementation KBHomeFooterView

-(instancetype)initWithFrame:(CGRect)frame withText:(NSString *)loadMoreText
{
    self=[super initWithFrame:frame];
    if (self) {
         self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 40)];
        self.loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.2*self.bounds.size.width,0.0f, 0.6*self.bounds.size.width, 40.0f)];
        self.loadMoreText.text=loadMoreText;
        self.loadMoreText.textColor=KColor_102;
        self.loadMoreText.textAlignment=NSTextAlignmentCenter;
        [self.loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        self.loadMoreText.numberOfLines=2;
        [self.tableFooterView addSubview:self.loadMoreText];
        self = (KBHomeFooterView * )self.tableFooterView;
    }
    return self;
}

@end
