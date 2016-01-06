//
//  KBWebviewInfoModel.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/12.
//  Copyright © 2015年 Test. All rights reserved.
//

//正文的Model
#import <Foundation/Foundation.h>

@class KBColumnModel,KBHomeArticleModel,KBMyCollectionDataModel;
@interface KBWebviewInfoModel : NSObject

/**
 *  正文的pageId
 */
@property (nonatomic,assign) NSInteger pageId;

/**
 *  图片的地址
 */
@property (nonatomic ,strong) NSString * imagestr;

/**
 *  文章的标题
 */
@property (nonatomic,strong) NSString * textString;

/**
 *  所属的二级分类
 */
@property (nonatomic,strong)  NSNumber * secondType;

/**
 *  所属三级分类的名字
 */
@property(nonatomic,strong) NSString * classString;

/**
 *  正文的url
 */
@property ( nonatomic, strong)NSString * shareURL;
/**
 *  图片的数据
 */
@property  ( nonatomic, strong)NSData   *  imageData;
/**
 *  记录在正文里阅读了文章数，点击相关推荐的次数
 */
@property (nonatomic,assign) int readWebViewInfoCount;

/**
 *  是否是推荐(首页)里的分类点击进入的
 */
@property (nonatomic,assign) BOOL isHomeTypeClass;

//正文的单例
+(KBWebviewInfoModel*)newinstance;
//为四个分类的正文ColumnModel设置数据
-(void)setWebviewInfoColumnModel:(KBColumnModel * )columnModel;
//推荐的正文ArticleModel设置数据
-(void)setWebviewInfoArticleModel:(KBHomeArticleModel * )articleModel;
//点击足迹和收藏的正文 设置数据
-(void)setWebviewInfoMyCollectionDataModel:(KBMyCollectionDataModel * )myCollectionDataModel;

@end
