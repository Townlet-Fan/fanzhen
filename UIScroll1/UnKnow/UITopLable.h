//
//  UITopLable.h
//  UIScroll1
//
//  Created by kuibu technology on 15/6/28.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface UITopLable : UILabel

-(void)setVerticalAlignment:(VerticalAlignment)verticalAlignment;
@end
