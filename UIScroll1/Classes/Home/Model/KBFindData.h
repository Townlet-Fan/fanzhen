//
//  KBFindData.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/15.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBFindData : NSObject

/**
 *  内容数据
 */
@property(nonatomic,strong) NSMutableArray *resultArray;

/**
 *  滑图的数据
 */
@property(nonatomic,strong) NSArray *titleArray;


+ (instancetype)sharedInstans;


- (void)setModelArrayWithArray:(NSDictionary *)dataDict;

//上拉加载数据
- (void)arrayAddDataWithDictionary:(NSDictionary *)dataDict;

@end
