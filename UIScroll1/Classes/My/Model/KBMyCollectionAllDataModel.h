//
//  KBMyCollectionAllDataModel.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBMyCollectionAllDataModel : NSObject

/**
 *  登录的收藏数组
 */
@property (nonatomic,strong) NSMutableArray * collectArray;

/**
 *  总的收藏数
 */
@property (nonatomic,assign)int allcount;

/**
 *  收藏的二级分类的列表
 */
@property (nonatomic,strong) NSMutableArray *secondTypeArray;


//整理数据
- (void)setDataWithDictionary:(NSDictionary *)dict;

//将数据封装成字典，在转换成模型
-(NSDictionary * )setDictionaryWithData:(NSString *)articleTitle withDate:(NSString * )date withTypeName:(NSString *)typeName withSecondType:(NSString * )secondType withPageId:(NSNumber *)pageId withImageStr:(NSString * )imageStr withImageData:(UIImage * )imageData;
@end
