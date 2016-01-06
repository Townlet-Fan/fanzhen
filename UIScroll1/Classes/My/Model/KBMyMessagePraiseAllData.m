//
//  KBMyMessagePraiseAllData.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBMyMessagePraiseAllData.h"
#import "KBMyMessagePraiseModel.h"
@implementation KBMyMessagePraiseAllData

//数据处理
-(void)setDataWithDictionary:(NSDictionary *)dict
{
    self.myMessagePraiseAllDataArray=[self getModelArrWithMyMessagePraiseAllDataArray:dict[@"praiseList"]];
}
-(NSMutableArray *)getModelArrWithMyMessagePraiseAllDataArray:(NSArray *)allData
{
    
    NSMutableArray *myMessagePraiseAllDataArray = [NSMutableArray array];
    [allData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [myMessagePraiseAllDataArray addObject:[KBMyMessagePraiseModel messagePraiseModelWithDictionary:obj]];
    }];
    return myMessagePraiseAllDataArray;
}

@end
