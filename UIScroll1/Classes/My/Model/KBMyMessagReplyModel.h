//
//  KBMyMessagModel.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//

//我的消息的模型
#import <Foundation/Foundation.h>

@interface KBMyMessagReplyModel : NSObject

/**
 *  回复者的昵称
 */
@property (nonatomic,strong) NSString * replyerName;

/**
 *  回复者的头像
 */
@property (nonatomic,strong) NSString * replyerPhoto;

/**
 *  回复的内容
 */
@property (nonatomic,strong) NSString * replyerContent;

/**
 *  回复的时间
 */
@property (nonatomic,strong) NSString * replyerDate;

/**
 *  原来回复的内容
 */
@property (nonatomic,strong) NSString * comment;

/**
 *  回复文章的pageId
 */
@property (nonatomic,strong) NSNumber * pageId;

/**
 *  评论的Id
 */
@property (nonatomic,strong) NSString * commentId;

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)messageReplyModelWithDictionary:(NSDictionary *)dict;
@end
