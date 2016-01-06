//
//  KBWhetherLoginModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/14.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBWhetherLoginModel.h"
#import "KBLoginSingle.h"

@implementation KBWhetherLoginModel

+(BOOL)userWhetherLogin
{
    if ([KBLoginSingle newinstance].isLogined) {
        return YES;
    }
    else
        return NO;
}
@end
