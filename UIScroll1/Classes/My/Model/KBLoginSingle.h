//
//  LoginSingle.h
//  UIScroll1
//
//  Created by eddie on 15-4-20.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//登陆信息 单例

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KBLoginSingle : NSObject<NSCoding>
/**
 *  用户是否登录
 */
@property (nonatomic,assign) BOOL isLogined;
/**
 *  用户昵称
 */
@property (nonatomic,strong) NSString * userName;
/**
 *  用户积分
 */
@property (nonatomic,assign) NSInteger  userCoin;
/**
 *  用户头像
 */
@property (nonatomic,strong) UIImage  *userPhoto;
/**
 *  用户性别
 */
@property (nonatomic,strong)  NSString * userSex;
/**
 *  用户收藏数
 */
@property  (nonatomic,assign) NSInteger  userCollectedNum;
/**
 *  用户学校
 */
@property (nonatomic,strong)  NSString * userSchool;
/**
 *  用户入学年份
 */
@property (nonatomic,assign) NSInteger userYearComeINSchool;
/**
 *  用户关注数组
 */
@property (nonatomic,strong) NSArray * userFocusId;
/**
 *  用户收藏
 */
@property (nonatomic,strong) NSMutableString * userCollect;
/**
 * 用户Id
 */
@property (nonatomic,assign) NSInteger userID;
/**
 *  用户订阅有结构的数组，有二级、三级的逻辑结构
 */
@property (nonatomic,strong) NSMutableArray *userInterestStructArray;
/**
 *  用户订阅没结构的数组，也就是只存了三级分类的数组
 */
@property (nonatomic,strong) NSMutableArray *userInterestNoStructArray;
/**
 *  所有分类的数组
 */
@property  (nonatomic,strong) NSMutableArray *userAllTypeArray;
/**
 * 用户账号
 */
@property(nonatomic,strong) NSString *userCounter;
/**
 *  用户登录融云的token
 */
@property (nonatomic,strong) NSString *userToken;
/**
 *  用户头像的URL
 */
@property (nonatomic,strong) NSString *userPhotoURL;

//创建单例的方法
-(id)newinstanceWith:(KBLoginSingle *)loginsingle;
+(KBLoginSingle *)newinstance;

@end
