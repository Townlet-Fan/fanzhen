//
//  KBSearchWebInfoAllData.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBSearchWebInfoAllData.h"
#import "KBHomeArticleModel.h"

@implementation KBSearchWebInfoAllData

- (void)setDataWithDictionary:(NSDictionary *)dict
{
    self.searchWebInfoArray=[self getModelArrWithArray:dict[@"searchResult"]];
}
-(NSMutableArray * )getModelArrWithArray:(NSArray *)searchArray
{
    NSMutableArray * searchWebInfoArray=[NSMutableArray array];
    [searchArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [searchWebInfoArray addObject:[KBHomeArticleModel arcticleModelWithDictionary:obj]];
    }];
    return searchWebInfoArray;
}
@end
