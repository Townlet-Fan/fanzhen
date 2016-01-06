//
//  KBSearchWebInfoAllData.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//

//搜索文章获取得到所有数据
#import <Foundation/Foundation.h>

@interface KBSearchWebInfoAllData : NSObject


//整理数据
- (void)setDataWithDictionary:(NSDictionary *)dict;
/**
 *  搜索文章获取得到所有数据的数组
 */
@property (nonatomic,strong)NSMutableArray * searchWebInfoArray;
@end
