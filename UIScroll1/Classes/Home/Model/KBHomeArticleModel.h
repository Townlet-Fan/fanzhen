//
//  KBHomeArticleModel.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//"pageId": 17314,
//"imageSrc": "http://121.40.188.62/upfile/images/2015/12/08/1449586781952.jpg",
//"firstTitle": "鍐ぉ鏈夎繖鏍蜂竴涓垝閫傚皬绐濓紝姣斿埆澧呰繕璞�",
//"secondType": 25,
//"thirdTypeName": "灏忚祫鐢熸椿",
//"recomPos": 2

@interface KBHomeArticleModel : NSObject

/**
 *  文章的id
 */
@property(nonatomic,strong) NSNumber *pageId;

/**
 *  图片地址
 */
@property(nonatomic,strong) NSString *imageSrc;


/**
 *  标题
 */
@property(nonatomic,strong) NSString *firstTitle;

/**
 *  所属二级分类
 */
@property(nonatomic,strong) NSNumber * secondType;

/**
 *  所属三级分类的名字
 */
@property(nonatomic,strong) NSString *thirdTypeName;
/**
 *   标志
 */
@property(nonatomic,strong) NSNumber *recomPos;
/**
 *  文章的阅读量
 */
@property(nonatomic,strong) NSNumber *readNumber;
/**
 *  breake图的编号
 */
@property(nonatomic,assign) NSNumber *breakNum;
/**
 *  图片大小
 */
@property(nonatomic,assign) CGSize imageSize;

/**
 *  cell下面的高度
 */
@property(nonatomic,assign) CGFloat cellHeight;


//根据字典得到模型
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)arcticleModelWithDictionary:(NSDictionary *)dict;

@end
