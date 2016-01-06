//
//  KBMyMessagePraiseModel.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBMyMessagePraiseModel.h"

@implementation KBMyMessagePraiseModel

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.praiserName=dict[@"praiserName"]?dict[@"praiserName"]:@"";
        self.praiserPhoto=dict[@"praiserPhoto"]?dict[@"praiserPhoto"]:@"";
        self.comment=dict[@"comment"]?dict[@"comment"]:@"";
        self.date=dict[@"date"]?dict[@"date"]:@"";
    }
    return self;
}


+ (instancetype)messagePraiseModelWithDictionary:(NSDictionary *)dict
{
    return  [[self alloc]initWithDictionary:dict];
}

@end
