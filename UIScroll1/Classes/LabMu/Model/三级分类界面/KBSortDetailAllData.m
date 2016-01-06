//
//  KBSortDetailAllData.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSortDetailAllData.h"
#import "KBColumnModel.h"
@implementation KBSortDetailAllData

//数据处理
-(void)setDataWithDictionary:(NSDictionary *)dict
{
    self.threeTypeAllArray=[self getModelArrWithThreeTypeArray:dict[@"result"]];
}
//分解滑图的数据
-(NSMutableArray *)getModelArrWithThreeTypeArray:(NSArray *)threeTypeArray
{
    NSMutableArray *threeTypeAllArray = [NSMutableArray array];
    [threeTypeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [threeTypeAllArray addObject:[KBColumnModel arcticleModelWithDictionary:obj]];
    }];
    return threeTypeAllArray;
}

@end
