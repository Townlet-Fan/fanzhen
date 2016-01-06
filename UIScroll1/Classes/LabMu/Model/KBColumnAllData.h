//
//  KBColumnAllData.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

//栏目数据的数组
#import <Foundation/Foundation.h>

@interface KBColumnAllData : NSObject

/**
 *  轮播的数据数组
 */
@property (nonatomic,strong) NSArray * columnTopData;

/**
 *  分类数据的数组
 */
@property (nonatomic,strong) NSArray * columnTypeData;

/**
 *  是否到最后一页
 */
@property (nonatomic,assign) NSString * isLast;


//整理数据
-(void)setDataWithDictionary:(NSDictionary *)dict addTypeArray:(NSMutableArray *)typeArray withItemNumber:(NSInteger)itemNumer;
@end
