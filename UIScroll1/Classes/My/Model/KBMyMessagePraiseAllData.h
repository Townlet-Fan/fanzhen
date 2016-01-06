//
//  KBMyMessagePraiseAllData.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//

//我的消息里点赞所有数据
#import <Foundation/Foundation.h>

@interface KBMyMessagePraiseAllData : NSObject


/**
 *  我的消息点赞所有数据的数组
 */
@property (nonatomic,strong) NSMutableArray * myMessagePraiseAllDataArray;

//整理数据
-(void)setDataWithDictionary:(NSDictionary *)dict;
@end
