//
//  FIndType_3.h
//  UIScroll1
//
//  Created by eddie on 15-4-6.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//三级标签 （三级分类）模型

#import <Foundation/Foundation.h>

@interface KBThreeSortModel : NSObject<NSCoding>
/**
 *  三级分类的名字
 */
@property (nonatomic,strong) NSString *name;

/**
 *  三级分类是否关注
 */
@property (nonatomic,assign) bool isIntrest;
/**
 *  三级分类所属的二级分类
 */
@property (nonatomic,strong) id parentFind_2Delegate;

/**
 *  三级分类所属的二级分类Id
 */
@property (nonatomic,assign) NSInteger TypeTowID;

/**
 *  三级分类Id
 */
@property (nonatomic,assign) NSInteger TypeThreeID;

/**
 *  三级分类的 排序Id (暂时没用)
 */
@property (nonatomic,assign) NSInteger sortID;
@end