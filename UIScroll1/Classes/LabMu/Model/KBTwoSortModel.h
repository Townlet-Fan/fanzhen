//
//  FindType_2.h
//  UIScroll1
//
//  Created by eddie on 15-4-6.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//二级标签 （二级分类） 模型

#import <Foundation/Foundation.h>

@interface KBTwoSortModel : NSObject<NSCoding>
/**
 *  同个二级分类的三级分类的数组
 */
@property (nonatomic,strong) NSMutableArray *subArray;
/**
 *  二级分类的名字
 */
@property (nonatomic,strong) NSString *name;
/**
 *  二级分类的Id
 */
@property (nonatomic,assign) NSInteger TypeTowID;
/**
 *  二级分类所属的一级分类
 */
@property (nonatomic,assign)NSInteger typeOneInteger;
/**
 *  三级分类的名称
 */
@property (nonatomic,assign)NSString * thirdTypeName;

/**
 *  二级分类是否排序(暂时没用)
 */
@property BOOL isHaveSorted;
@end
