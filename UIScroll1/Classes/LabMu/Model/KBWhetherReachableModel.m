//
//  KBWhetherReachableModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/14.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBWhetherReachableModel.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "KBConstant.h"
@implementation KBWhetherReachableModel

//判断是否有网
+(BOOL)whetherReachable
{
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSParameterAssert([appDlg.reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [appDlg.reach currentReachabilityStatus];
    if (status == NotReachable) {
        //KBLog(@"----Notification Says Unreachable");
        return NO;
    }else if(status == ReachableViaWWAN){
        //KBLog(@"----Notification Says mobilenet");
        return YES;
    }else if(status == ReachableViaWiFi){
       // KBLog(@"----Notification Says wifinet");
        return YES;
    }
    return YES;
}

@end
