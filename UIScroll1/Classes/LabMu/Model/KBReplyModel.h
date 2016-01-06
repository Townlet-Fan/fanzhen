//
//  KBReplyModel.h
//  UIScroll1
//
//  Created by 邓存彬 on 16/1/1.
//  Copyright © 2016年 Test. All rights reserved.
//

//某条评论的回复的Model
#import <Foundation/Foundation.h>

@interface KBReplyModel : NSObject

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
 *  回复文章的pageId
 */
@property (nonatomic,strong) NSNumber * pageId;

/**
 *  评论的Id
 */
@property (nonatomic,strong) NSString * commentId;


/**
 * 回复数据的数组
 */
@property (nonatomic,strong)NSMutableArray * replyArray;

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict;

//-(instancetype)replyModelWithDictionary:(NSDictionary *)dict;

- (void)setDataWithDictionary:(NSDictionary *)dict;
@end
