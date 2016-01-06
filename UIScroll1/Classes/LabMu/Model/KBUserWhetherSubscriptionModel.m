//
//  KBLoginUserWhetherSubscriptionModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/14.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBUserWhetherSubscriptionModel.h"
#import "KBWhetherLoginModel.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
@implementation KBUserWhetherSubscriptionModel

+(BOOL)loginUserWhetherSubscription:(NSInteger)itemNumber
{
    NSMutableArray *interestArray=[[KBLoginSingle newinstance].userInterestStructArray objectAtIndex:itemNumber-2];
    int i;
    for (i =0; i<interestArray.count ; i++)
    {
        KBTwoSortModel *twoSortModel=[interestArray objectAtIndex:i];
        if (twoSortModel.subArray.count!=0) {
            
                return YES;
        }
    }
    if (i==interestArray.count)
    {
        return NO;
    }
    return NO;

}
+(BOOL)noLoginUserWhetherSubscription:(NSInteger)itemNumber
{
    NSMutableArray *interestArray=[[KBLoginSingle newinstance].userInterestNoStructArray objectAtIndex:itemNumber-2];
    if (interestArray.count==0) {
        return NO;
    }
    else
        return YES;
}
@end
