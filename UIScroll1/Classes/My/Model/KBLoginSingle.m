//
//  LoginSingle.m
//  UIScroll1
//
//  Created by eddie on 15-4-20.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBLoginSingle.h"

@implementation KBLoginSingle

static KBLoginSingle *sharedInstance;

-(instancetype)init{
    self=[super init];
    _userFocusId=[[NSArray alloc]init];
    _userInterestNoStructArray=[[NSMutableArray alloc]init];
    _userInterestStructArray=[[NSMutableArray alloc]init];
    _userCollect=[[NSMutableString alloc]init];
    return self;
}
+(KBLoginSingle *)newinstance{
    if (sharedInstance==nil) {
        sharedInstance=[[KBLoginSingle alloc]init];
        sharedInstance.isLogined=NO;
        sharedInstance.userID=-1;
    }
    return sharedInstance;
}
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool: _isLogined forKey:@"isLogined"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_userCounter forKey:@"userCounter"];
    [aCoder encodeInteger:_userCoin forKey:@"userCoin"];
    [aCoder encodeObject:_userPhoto forKey:@"userPhoto"];
    [aCoder encodeObject:_userSchool forKey:@"userSchool"];
    [aCoder encodeObject:_userSex forKey:@"userSex"];
    [aCoder encodeInteger:_userCollectedNum forKey:@"userCollectedNum"];
    [aCoder encodeObject:_userFocusId forKey:@"userFocusId"];
    [aCoder encodeObject:_userCollect forKey:@"userCollect"];
    [aCoder encodeInteger:_userID forKey:@"userID"];
    [aCoder encodeObject:_userInterestNoStructArray forKey:@"userInterestNoStructArray"];
    [aCoder encodeObject:_userInterestStructArray forKey:@"userInterestStructArray"];
    [aCoder encodeObject:_userAllTypeArray forKey:@"userAllTypeArray"];
    [aCoder encodeInteger:_userYearComeINSchool forKey:@"userYearComeINSchool"];
    [aCoder encodeObject:_userToken forKey:@"userToken"];
    [aCoder encodeObject:_userPhotoURL forKey:@"userPhotoURL"];
    
}
//解档
- (id)initWithCoder:(NSCoder *)aDecoder{
    sharedInstance=[super init];
    _isLogined=[aDecoder decodeBoolForKey:@"isLogined"];
    _userName=[aDecoder decodeObjectForKey:@"userName"];
    _userCounter=[aDecoder decodeObjectForKey:@"userCounter"];
    _userCoin=[aDecoder decodeIntegerForKey:@"userCoin"];
    _userPhoto=[aDecoder decodeObjectForKey:@"userPhoto"];
    _userSchool=[aDecoder decodeObjectForKey:@"userSchool"];
    _userSex=[aDecoder decodeObjectForKey:@"userSex"];
    _userCollectedNum=[aDecoder decodeIntegerForKey:@"userCollectedNum"];
    _userFocusId=[aDecoder decodeObjectForKey:@"userFocusId"];
    _userCollect=[aDecoder decodeObjectForKey:@"userCollect"];
    _userID=[aDecoder decodeIntegerForKey:@"userID"];
    _userInterestNoStructArray =[aDecoder decodeObjectForKey:@"userInterestNoStructArray"];
    _userInterestStructArray=[aDecoder decodeObjectForKey:@"userInterestStructArray"];
    _userAllTypeArray=[aDecoder decodeObjectForKey:@"userAllTypeArray"];
    _userYearComeINSchool=[aDecoder decodeIntegerForKey:@"userYearComeINSchool"];
    _userToken=[aDecoder decodeObjectForKey:@"userToken"];
    _userPhotoURL=[aDecoder decodeObjectForKey:@"userPhotoURL"];
    return sharedInstance;
}
-(id)newinstanceWith:(KBLoginSingle *)loginsingle{
    sharedInstance=loginsingle;
    return sharedInstance;
}
@end
