//
//  KBFindData.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/15.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBFindData.h"
#import "KBHomeArticleModel.h"


@implementation KBFindData

+ (instancetype)sharedInstans
{
    static KBFindData *data = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[KBFindData alloc] init];
    });
    
    return data;
}

#pragma mark - 

- (NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}


- (void)setModelArrayWithArray:(NSDictionary *)dataDict
{
    self.titleArray = [self arrayWithArray:dataDict[@"title"]];
    
    self.resultArray = [[self arrayWithArray:dataDict[@"result"]] mutableCopy];
}


- (NSArray *)arrayWithArray:(NSArray *)data
{
    NSMutableArray *allData = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KBHomeArticleModel *model = [KBHomeArticleModel arcticleModelWithDictionary:obj];
        [allData addObject:model];
    }];
    
    return allData;
}

- (void)arrayAddDataWithDictionary:(NSDictionary *)dataDict
{
    [self.resultArray addObjectsFromArray:[self arrayWithArray:dataDict[@"result"]]];
}


@end
