//
//  KBReplyModel.m
//  UIScroll1
//
//  Created by 邓存彬 on 16/1/1.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "KBReplyModel.h"

@implementation KBReplyModel

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        self.replyerName=dict[@"replyerName"]?dict[@"replyerName"]:@"";
        self.replyerPhoto=dict[@"replyerPhoto"]?dict[@"replyerPhoto"]:@"";
        self.replyerContent=dict[@"replyContent"]?dict[@"replyContent"]:@"";
        self.replyerDate=dict[@"replyDate"]?dict[@"replyDate"]:@"";
        self.pageId=dict[@"pageId"]?dict[@"pageId"]:@"";
        self.commentId=dict[@"commentId"]?dict[@"commentId"]:@"";
    }
    return self;
}

//- (instancetype)replyModelWithDictionary:(NSDictionary *)dict
//{
//    return [[self alloc]initWithDictionary:dict];
//}
- (void)setDataWithDictionary:(NSArray *)dict
{
    self.replyArray =[self getModelArrWithReplyArray:dict];
}
//评论
-(NSMutableArray*)getModelArrWithReplyArray:(NSArray * )array
{
    //分解数据
    NSMutableArray * replyArray=[[NSMutableArray alloc]init];
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [replyArray addObject:[self initWithDictionary:obj]];
    }];
    return replyArray;
}


@end
