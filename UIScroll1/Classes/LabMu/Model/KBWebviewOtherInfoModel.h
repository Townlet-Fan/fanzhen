//
//  KBWebviewOtherInfoModel.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//
//NSString * praNum;
//NSString * criNum;
//int  userChoice;
//NSString * adPicurl;
//NSString * adLink;
//NSString * isSubscri;
//NSArray * recomArray;
//NSString * comNum;
//NSArray *newArray= [jsondic valueForKey:@"comFirPage"];

#import <Foundation/Foundation.h>

@interface KBWebviewOtherInfoModel : NSObject

/**
 *  好文点赞数
 */
@property (nonatomic,strong)NSString * praNum;
/**
 *  水文点赞数
 */
@property (nonatomic,strong)NSString * criNum;
/**
 *  用户点好文还是水文
 */
@property (nonatomic,strong)NSString * userChoice;
/**
 *  广告位的Url
 */
@property (nonatomic,strong)NSString * adPicurl;

/**
 *  广告
 */
@property (nonatomic,strong)NSString * adLink;

/**
 *  用户是否订阅该分类
 */
@property (nonatomic,strong)NSString * isSubscri;

/**
 * 相关推荐文章的数组
 */
@property (nonatomic,strong)NSMutableArray * recomArray;

/**
 *  总的评论数
 */
@property(nonatomic,strong)NSString * comNum;

/**
 *  评论的数组
 */
@property(nonatomic,strong)NSMutableArray * commentArray;

//单例
+ (instancetype)shareInstance;

//整理数据
- (void)setDataWithDictionary:(NSDictionary *)dict;


@end
