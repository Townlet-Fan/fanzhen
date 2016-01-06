//
//  KBHomeAllData.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^homeTopdata)(NSArray *topData);

@interface KBHomeAllData : NSObject

/**
 *  首页轮播数据
 */
@property(nonatomic,strong) NSArray *homeTopData;
/**
 *  第一个cell的3个数据
 */
@property(nonatomic,strong) NSArray *chosenList;
/**
 *  第二个cell的5个数据
 */
@property(nonatomic,strong) NSArray *confirmList;

/**
 *  所有break的图
 */
@property(nonatomic,strong) NSMutableArray *breakList;

/**
 *  页面图的比例
 */
@property(nonatomic,strong) NSArray *scaleNum;

/**
 *  下面cell的数据
 */
@property(nonatomic,strong) NSMutableArray *subJectList;


//@property(nonatomic,copy) homwTopdata topdata;

//单例
+ (instancetype)shareInstance;

//整理数据
- (void)setDataWithDictionary:(NSDictionary *)dict;

//- (void)getHomeTopDataWithBlock:(homwTopdata)data;


@end
