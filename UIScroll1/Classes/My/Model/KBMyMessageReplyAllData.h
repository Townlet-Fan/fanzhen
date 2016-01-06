//
//  KBMyMessageAllData.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//

//我的消息里回复所有数据
#import <Foundation/Foundation.h>

@interface KBMyMessageReplyAllData : NSObject

/**
 *  我的消息回复所有数据的数组
 */
@property (nonatomic,strong) NSMutableArray * myMessageReplyAllDataArray;

//整理数据
-(void)setDataWithDictionary:(NSDictionary *)dict;

@end
