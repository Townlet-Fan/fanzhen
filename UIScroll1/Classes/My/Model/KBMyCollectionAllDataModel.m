//
//  KBMyCollectionAllDataModel.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMyCollectionAllDataModel.h"
#import "KBMyCollectionDataModel.h"
@implementation KBMyCollectionAllDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
- (void)setDataWithDictionary:(NSDictionary *)dict
{
    self.collectArray=[self getModelArrWithArray:dict[@"collectList"]];
    
    self.allcount=[dict[@"count"] intValue];
    
    self.secondTypeArray=[self getModelArrWithArray:dict[@"secondTypeList"]];
    NSLog(@"secontypeArray:%@",self.secondTypeArray);
    
}
- (NSMutableArray *)getModelArrWithArray:(NSArray *)startData
{
    //分解数据
    NSMutableArray *chlists = [NSMutableArray array];
    [startData enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [chlists addObject:[KBMyCollectionDataModel arcticleModelWithDictionary:obj]];
    }];
    return chlists;
}
-(NSDictionary * )setDictionaryWithData:(NSString *)articleTitle withDate:(NSString *)date withTypeName:(NSString *)typeName withSecondType:(NSString *)secondType withPageId:(NSNumber *)pageId withImageStr:(NSString *)imageStr withImageData:(UIImage *)imageData
{
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:articleTitle forKey:@"firstTitle"];
    [dictionary setObject:date forKey:@"date"];
    [dictionary setObject:typeName forKey:@"thirdTypeName"];
    [dictionary setObject:secondType forKey:@"secondType"];
    [dictionary setObject:pageId forKey:@"pageId"];
    [dictionary setObject:imageStr forKey:@"imageStr"];
    [dictionary setObject:imageData forKey:@"imageData"];
    return dictionary;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
