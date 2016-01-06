//
//  KBSortDetailModel.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSortDetailModel.h"
#import "KBLoginSingle.h"
#import "KBThreeSortModel.h"
#import "KBTwoSortModel.h"
@implementation KBSortDetailModel
//判断三级分类是否关注
+(BOOL)whetherThreeTypeSubscription:(NSString * )threeTypeName
{
    KBLoginSingle * loginSingle = [KBLoginSingle newinstance];
    int i;
    for (i=0; i<4; i++) {
        NSArray *typeOneArray=[loginSingle.userInterestNoStructArray objectAtIndex:i];
        for (int j=0; j<typeOneArray.count; j++) {
            KBThreeSortModel *threeSortModel=[typeOneArray objectAtIndex:j];
            if ([threeSortModel.name isEqualToString:threeTypeName]) {
                if (threeSortModel.isIntrest) {
                    return  YES;
                }
            }
        }
    }
    if (i==4)
    {
        return NO;
    }
    return NO;
}
//三级分类订阅成功
+(int)threeTypeSubcription:(NSString * )threeTypeName
{
    KBLoginSingle * loginSingle = [KBLoginSingle newinstance];
    int i;
    for (i=0; i<4; i++) {
        NSArray *typeOneArray=[loginSingle.userAllTypeArray objectAtIndex:i];
        NSMutableArray *typeOneInterestNo=[loginSingle.userInterestNoStructArray objectAtIndex:i];
        NSMutableArray *typeOneInterest=[loginSingle.userInterestStructArray objectAtIndex:i];
        for (int j=0; j<typeOneArray.count; j++) {
            KBTwoSortModel *twoSortModel=[typeOneArray objectAtIndex:j];
            
            KBTwoSortModel *twoSortInterest=[typeOneInterest objectAtIndex:j];
            
            for (int k=0; k<twoSortModel.subArray.count; k++) {
                
                KBThreeSortModel *threeSortModel=[twoSortModel.subArray objectAtIndex:k];
                if ([threeSortModel.name isEqualToString:threeTypeName]) {
                    threeSortModel.isIntrest=YES;
                    [typeOneInterestNo addObject:threeSortModel];
                    [twoSortInterest.subArray addObject:threeSortModel];
                    return i;
                }
            }
        }
    }
    return 0;
}
//三级分类取消订阅成功
+(int)threeTypeCancelSubcription:(NSString * )threeTypeName
{
    KBLoginSingle * loginSingle = [KBLoginSingle newinstance];
    int i;
    for (i=0; i<4; i++) {
        NSArray *typeOneArray=[loginSingle.userAllTypeArray objectAtIndex:i];
        NSMutableArray *typeOneInterestNo=[loginSingle.userInterestNoStructArray objectAtIndex:i];
        NSMutableArray *typeOneInterest=[loginSingle.userInterestStructArray objectAtIndex:i];
        for (int j=0; j<typeOneArray.count; j++) {
            KBTwoSortModel *twoSortModel=[typeOneArray objectAtIndex:j];
            
            KBTwoSortModel *twoSortInterest=[typeOneInterest objectAtIndex:j];

            for (int k=0; k<twoSortModel.subArray.count; k++) {
                KBThreeSortModel *threeSortModel=[twoSortModel.subArray objectAtIndex:k];
                if ([threeSortModel.name isEqualToString:threeTypeName]) {
                    threeSortModel.isIntrest=NO;
                    [typeOneInterestNo removeObject:threeSortModel];
                    [twoSortInterest.subArray removeObject:threeSortModel];
                    return i;
                }
            }
        }
    }
    return 0;
}
@end
