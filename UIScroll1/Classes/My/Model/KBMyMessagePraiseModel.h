//
//  KBMyMessagePraiseModel.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//

//消息点赞的Model
#import <Foundation/Foundation.h>

@interface KBMyMessagePraiseModel : NSObject

/**
 *  点赞者昵称
 */
@property (nonatomic,strong) NSString * praiserName;

/**
 *  点赞者头像
 */
@property (nonatomic,strong) NSString * praiserPhoto;

/**
 *  点赞的内容
 */
@property (nonatomic,strong) NSString * comment;

/**
 *  点赞的时间
 */
@property (nonatomic,strong) NSString * date;

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)messagePraiseModelWithDictionary:(NSDictionary *)dict;

@end
