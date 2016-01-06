//
//  KBHomeAllData.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeAllData.h"
#import "KBHomeArticleModel.h"

@implementation KBHomeAllData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static KBHomeAllData *allData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allData = [[KBHomeAllData alloc] init];
    });
    return allData;
}

- (void)setDataWithDictionary:(NSDictionary *)dict
{
    //得到顶部轮播的数据
     self.homeTopData = [self getModelArrWithArray:dict[@"title"]];
    
//    NSArray *arr = [NSArray arrayWithObject:@"1"];
//    
//    _topdata(arr);
    
     //得到三个 的数据
     self.chosenList = [self getModelArrWithArray:dict[@"chosenList"]];
    
     //得到五个 的数据
     self.confirmList = [self getModelArrWithArray:dict[@"confirmList"]];
    
     //得到brake的图
    self.breakList = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        KBHomeArticleModel *model = [[KBHomeArticleModel alloc] init];
        model.breakNum = 0;
        [self.breakList addObject:model];
    }
     NSMutableArray *beaks = [NSMutableArray array];
  //  NSDictionary *dict = [NSDictionary dictionaryWithObjects:,forKeys:@"imageSrc",@"imageSrc" count:2]
    NSDictionary *cs = [NSDictionary dictionaryWithObject:dict[@"chosen-confirm-break"] forKey:@"imageSrc"];
    NSDictionary *cc = [NSDictionary dictionaryWithObject:dict[@"confirm-subject_break"]  forKey:@"imageSrc"];
    
    [beaks addObject:cs];
    [beaks addObject:cc];
    [dict[@"breakList"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [beaks addObject:obj];
    }];
    //整理数据
    [[self getModelArrWithArray:beaks] enumerateObjectsUsingBlock:^(KBHomeArticleModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.breakNum intValue]>0) {
            //替代
            [self.breakList replaceObjectAtIndex:[obj.breakNum intValue]+1 withObject:obj];
        }else
            [self.breakList replaceObjectAtIndex:idx withObject:obj];
        
    }];

    //页面图的比例
    self.scaleNum = @[@5,@4.814,@16,@0.7283,@16,@0.861,@16];
    
    //下面cell的数据
    self.subJectList = [NSMutableArray array];
    
    [self getBottomCellModelListArray:dict[@"subjectList"]];
   
}

//
- (NSArray *)getModelArrWithArray:(NSArray *)startData
{
    //分解数据
    NSMutableArray *chlists = [NSMutableArray array];
    [startData enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [chlists addObject:[KBHomeArticleModel arcticleModelWithDictionary:obj]];
    }];
   
    return chlists;
}

//下面cell的数据整理
- (void)getBottomCellModelListArray:(NSArray *)list
{
    [list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //先获得第一张图片
        NSDictionary *dict = [NSDictionary dictionaryWithObject:obj[@"streamer"] forKey:@"imageSrc"];
        NSMutableArray *listArr = [NSMutableArray array];
        [listArr addObject:[KBHomeArticleModel arcticleModelWithDictionary:dict]];
        //加上下面个cell的数据
        [listArr addObjectsFromArray:[self getModelArrWithArray:obj[@"pageList"]]];
        
        [self.subJectList addObject:listArr];
    }];
}

//- (void)getHomeTopDataWithBlock:(homwTopdata)data
//{
//    _topdata = data;
//}

@end
