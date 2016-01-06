//
//  KBCommentModel.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//

//评论的Model
#import <Foundation/Foundation.h>

@interface KBCommentModel : NSObject

/**
 *  评论内容
 */
@property (nonatomic,strong) NSString *comContent;

/**
 *  评论者的昵称
 */
@property (nonatomic,strong)NSString * userName;

/**
 *  评论者的头像
 */
@property (nonatomic,strong)NSString * userPhoto;

/**
 *  评论的时间
 */
@property (nonatomic,strong)NSString * date;

/**
 *  评论的点赞数
 */
@property (nonatomic,strong)NSString * praiseNum;

/**
 *  评论是否点过赞
 */
@property (nonatomic,strong)NSString * hasPraised;

/**
 *  评论的回复数
 */
@property (nonatomic,strong)NSString * replyNum;

/**
 *  评论Id
 */
@property (nonatomic,strong)NSString * commentId;

/**
 *  评论者的Id
 */
@property (nonatomic,strong) NSString * receiverId;

/**
 *  被评论的评论 ID,有的话表示这条评论是对某个评论的回复,没有时 值为-1
 */
@property(nonatomic,strong) NSString * toComId;

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)commentModelWithDictionary:(NSDictionary *)dict;

@end
