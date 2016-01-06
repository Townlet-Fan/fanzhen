//
//  KBLoginModel.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/27.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBLoginModel.h"
#import "KBLoginSingle.h"
#import "KBAllTypeInfoModel.h"

@interface KBLoginModel()
{
    KBLoginSingle * loginSingle;//用户的单例
}

@end

@implementation KBLoginModel

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self= [super init];
    if (self) {
        loginSingle = [KBLoginSingle newinstance];
        loginSingle.userID = [dict[@"userId"] integerValue]?[dict[@"userId"] integerValue]:0;
        loginSingle.userCoin=[dict[@"userCoin"] intValue]?[dict[@"userCoin"] intValue]:0;
        loginSingle.userName=dict[@"userName"]?dict[@"userName"]:@"";
        loginSingle.userToken=dict[@"token"]?dict[@"token"]:@"";
        loginSingle.userSchool=dict[@"school"]?dict[@"school"]:@"";
        loginSingle.userYearComeINSchool=[dict[@"schoolYear"]integerValue]?[dict[@"schoolYear"]integerValue]:2012;
        loginSingle.userPhotoURL=dict[@"userPhoto"]?dict[@"userPhoto"]:@"";
        
//        NSData *  ImageData   = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"userPhoto"]]];
//        UIImage *Image  =[UIImage imageWithData:ImageData];
//        loginSingle.userPhoto=Image;
        
        loginSingle.userSex=dict[@"userSex"]?dict[@"userSex"]:@"";
        loginSingle.userFocusId=dict[@"userFocusId"]?dict[@"userFocusId"]:@"";
        [loginSingle.userCollect appendString:dict[@"userCollect"]];
        if (![loginSingle.userCollect isEqualToString:@""]) {
            [loginSingle.userCollect appendString:@","];
        }
        loginSingle.userCollectedNum=[dict[@"userCollectedNum"]intValue]?[dict[@"userCollectedNum"]intValue]:0;
        loginSingle.isLogined=YES;
        
        KBAllTypeInfoModel * allTypeInfoModel=[KBAllTypeInfoModel resetinstance];
        //初始化关注的列表Array结构
        loginSingle.userInterestStructArray =  [allTypeInfoModel useFocuArrayReturnInterestStruct:loginSingle.userFocusId];
        loginSingle.userInterestNoStructArray=[allTypeInfoModel ReturnInterestNoStruct];
        loginSingle.userAllTypeArray=allTypeInfoModel.allTypeArray;
    }
    return self;
}
+ (instancetype)loginSingleModelWithDictionary:(NSDictionary *)dict
{
    return  [[self alloc]initWithDictionary:dict];
}

@end
