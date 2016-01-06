//
//  KBSortDetailAllData.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//

//三级分类界面所有的数据
#import <Foundation/Foundation.h>

@interface KBSortDetailAllData : NSObject

/**
 *  三级分类界面所有的数据的数据
 */
@property (nonatomic,strong) NSMutableArray * threeTypeAllArray;

//整理数据
-(void)setDataWithDictionary:(NSDictionary *)dict;

@end
