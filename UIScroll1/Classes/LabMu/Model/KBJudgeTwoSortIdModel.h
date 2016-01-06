//
//  MainType2Data.h
//  UIScroll1
//
//  Created by kuibu technology on 15/5/17.
//  Copyright (c) 2015年 Test. All rights reserved.
//
//判断 二级id 将下面的具体标签（三级）放到数组里面

#import <Foundation/Foundation.h>

@interface KBJudgeTwoSortIdModel : NSObject
/**
 *  二级分类的Id
 */
@property (nonatomic,assign)  int ID;
/**
 *  存放三级标签的数组
 */
@property (nonatomic,strong) NSMutableArray * subArticleArray;
/**
 *  二级分类的字典
 */
@property (nonatomic,strong) NSMutableDictionary *imageDic;

/**
 *  三级分类的名称
 */
@property (nonatomic,strong )NSString * thirdTypeName;

/**
 *  存放相同三级分类的数组
 */
@property (nonatomic,strong)NSMutableArray * sameThirdNameArray;
@end
