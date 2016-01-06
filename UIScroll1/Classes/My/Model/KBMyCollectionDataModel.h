//
//  MyCollectionData.h
//  UIScroll1
//
//  Created by eddie on 15-5-2.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//收藏数据模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KBMyCollectionDataModel : NSObject<NSCoding>
/**
 *  收藏的标题
 */
@property (nonatomic,strong) NSString * articleTitle;
/**
 *  收藏的时间
 */
@property (nonatomic,strong) NSString * time;
/**
 *  收藏的三级分类的类型
 */
@property (nonatomic,strong) NSString * TypeName;
/**
 *  收藏的文章Id
 */
@property (nonatomic,assign) NSNumber * pageID;
/**
 *  收藏的序号
 */
@property (nonatomic,assign) int ID;
/**
 *  收藏的图像
 */
@property (nonatomic,strong)  NSString * imagestr;
/**
 *  收藏的图像的Image
 */
@property (nonatomic,strong) UIImage * imageData;
/**
 *  收藏的二级分类
 */
@property (nonatomic,strong) NSString * secondType;
/**
 *  收藏的二级分类的名字
 */
@property (nonatomic,strong) NSString * secondTypeName;
/**
 *  收藏的某个二级分类的数目
 */
@property (nonatomic,assign) int  secondTypNum;
/**
 *  收藏的总数
 */
@property (nonatomic,assign) int  collectNum;

//根据字典得到模型
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)arcticleModelWithDictionary:(NSDictionary *)dict;
@end
