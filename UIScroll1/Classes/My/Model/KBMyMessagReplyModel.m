//
//  KBMyMessagModel.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBMyMessagReplyModel.h"

@implementation KBMyMessagReplyModel


-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        self.replyerName=dict[@"replyerName"]?dict[@"replyerName"]:@"";
        self.replyerPhoto=dict[@"replyerPhoto"]?dict[@"replyerPhoto"]:@"";
        self.replyerContent=dict[@"replyContent"]?dict[@"replyContent"]:@"";
        self.replyerDate=dict[@"date"]?dict[@"date"]:@"";
        self.comment=dict[@"comment"]?dict[@"comment"]:@"";
        self.pageId=dict[@"pageId"]?dict[@"pageId"]:@"";
        self.commentId=dict[@"commentId"]?dict[@"commentId"]:@"";
    }
    return self;
}

+ (instancetype)messageReplyModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc]initWithDictionary:dict];
}


@end
