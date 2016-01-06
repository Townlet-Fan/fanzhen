//
//  KBCommentModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBCommentModel.h"

@implementation KBCommentModel

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        self.comContent=dict[@"comContent"]?dict[@"comContent"]:@"";
        self.userName=dict[@"userName"]?dict[@"userName"]:@"";
        self.userPhoto=dict[@"userPhoto"]?dict[@"userPhoto"]:@"";
        self.date=dict[@"date"]?dict[@"date"]:@"";
        self.praiseNum=dict[@"praiseNum"]?dict[@"praiseNum"]:@"";
        self.replyNum=dict[@"replyNum"]?dict[@"replyNum"]:@"";
        self.hasPraised=dict[@"hasPraised"]?dict[@"hasPraised"]:@"";
        self.commentId=dict[@"commentId"]?dict[@"commentId"]:@"";
        self.receiverId=dict[@"senderId"]?dict[@"senderId"]:@"";
        self.toComId=dict[@"toComId"]?dict[@"toComId"]:@"";
        
    }
    return self;
}

+ (instancetype)commentModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc]initWithDictionary:dict];
}

@end
