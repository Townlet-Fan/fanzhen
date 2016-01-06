//
//  KBLanMuModel.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

//栏目的模型
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KBColumnModel : NSObject
/**
 *  文章的Id
 */
@property (nonatomic,strong) NSNumber * pageId;

/**
 *  图片的地址
 */
@property (nonatomic ,strong) NSString * imageSrc;


/**
 *  文章的标题
 */
@property (nonatomic,strong) NSString * pageTitle;

/**
 *  文章的阅读量
 */
@property (nonatomic,strong) NSNumber * readNumber;

/**
 *  所属的二级分类
 */
@property (nonatomic,strong) NSNumber * secondType;

/**
 *  所属三级分类的名字
 */
@property(nonatomic,strong) NSString * thirdTypeName;

/**
 *  图片大小
 */
@property(nonatomic,assign) CGSize imageSize;

/**
 *  判断学科和规划的第一张图片是大还是小
 */
@property(nonatomic,assign) int infoImgType;


/**
 *  cell下面的高度
 */
@property(nonatomic,assign) CGFloat cellHeight;

//根据字典得到模型
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)arcticleModelWithDictionary:(NSDictionary *)dict;


@end
