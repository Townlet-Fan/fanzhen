//
//  UICopyLable.h
//  UIScroll1
//
//  Created by eddie on 15-4-17.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBLoginSingle.h"
@interface UICopyLable : UILabel
@property BOOL isLongPressing;
@property id cellDelegate;
@property id tableDelegate;
@property bool isHaveHot;
@property NSInteger commentid;
@property  NSString *respondNameStr;

@end
