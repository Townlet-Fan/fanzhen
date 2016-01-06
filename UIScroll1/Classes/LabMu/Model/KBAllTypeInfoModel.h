//
//  TypeClass.h
//  UIScroll1
//
//  Created by eddie on 15-5-13.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//分类标签的信息

#import <Foundation/Foundation.h>


@interface KBAllTypeInfoModel : NSObject

/**
 *  所有分类的数组
 */
@property (nonatomic,strong) NSMutableArray *allTypeArray;

/**
 *  所有分类的数组 经过allTypeArray整理的来的 里面存的是二级分类
 */
@property (nonatomic,strong)NSMutableArray *interestStructArray;

/**
 *  所有订阅的分类 里面存的是三级分类的数组
 */
@property (nonatomic,strong)NSMutableArray *interestNoStructArray;
/**
 *  单例
 */
+(KBAllTypeInfoModel *)newinstance;
/**
 *  可能会内存泄漏
 */
+(KBAllTypeInfoModel *)resetinstance;

/**
 *  返回登录用户经过整理的订阅分类的数组
 *
 *  @param array 订阅的数组
 *
 *  @return interestStructArray
 */
-(NSMutableArray *)useFocuArrayReturnInterestStruct:(NSArray *) array;
/**
 *  返回只存三级分类的数组 interestNoStructArray
 *
 *  @return interestNoStructArray
 */
-(NSMutableArray *)ReturnInterestNoStruct;
@end
