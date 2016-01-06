//
//  KBMyMessageAllData.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBMyMessageReplyAllData.h"
#import "KBMyMessagReplyModel.h"
@implementation KBMyMessageReplyAllData
//数据处理
-(void)setDataWithDictionary:(NSDictionary *)dict
{
    self.myMessageReplyAllDataArray=[self getModelArrWithMyMessageReplyAllDataArray:dict[@"replyList"]];
}
-(NSMutableArray *)getModelArrWithMyMessageReplyAllDataArray:(NSArray *)allData
{
    
    NSMutableArray *myMessageReplyAllDataArray = [NSMutableArray array];
    [allData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [myMessageReplyAllDataArray addObject:[KBMyMessagReplyModel messageReplyModelWithDictionary:obj]];
    }];
    return myMessageReplyAllDataArray;
}

@end
