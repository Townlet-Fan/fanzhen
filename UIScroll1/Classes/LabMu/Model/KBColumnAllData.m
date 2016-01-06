//
//  KBColumnAllData.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBColumnAllData.h"
#import "KBColumnModel.h"
#import "KBJudgeTwoSortIdModel.h"
@interface KBColumnAllData()
{
    KBJudgeTwoSortIdModel * typeTwoDataModel;
    
    KBColumnModel *threeSortModel;
}
@end

@implementation KBColumnAllData


//数据处理
-(void)setDataWithDictionary:(NSDictionary *)dict addTypeArray:(NSMutableArray *)typeArray withItemNumber:(NSInteger)itemNumer
{
    typeTwoDataModel=[[KBJudgeTwoSortIdModel alloc]init];
    threeSortModel =[[KBColumnModel alloc]init];
    self.isLast=nil;
    switch (itemNumer) {
        case 2:
        {
            self.columnTypeData = [self getModelArrWithSubjectTypeArray:dict[@"pageList"] addSubejectTypeArray:typeArray];
            self.columnTopData =[self getModelArrWithTopArray:dict[@"titleList"]];
        }
            break;
        case 3:
        {
            self.columnTypeData =[self getModelArrWithTypeArray:dict[@"result"] addTypeArray:typeArray];
            self.columnTopData =[self getModelArrWithTopArray:dict[@"title"]];
            break;
        }
        case 4:
        {
            self.columnTypeData = [self getModelArrWithSubjectTypeArray:dict[@"pageList"] addSubejectTypeArray:typeArray];
            self.columnTopData =[self getModelArrWithTopArray:dict[@"titleList"]];
        }
        case 5:
        {
            self.columnTypeData =[self getModelArrWithInterestTypeArray:dict[@"result"] addInterestTypeArray:typeArray];
            self.columnTopData =[self getModelArrWithTopArray:dict[@"title"]];
            break;

        }
        default:
            break;
    }
   
//    // self.columnTypeData =[self getModelArrWithTypeArray:dict[@"result"] addTypeArray:typeArray];
//    self.columnTypeData = [self getModelArrWithSubjectTypeArray:dict[@"pageList"] addSubejectTypeArray:typeArray];
    self.isLast=dict[@"isLast"];
}
//分解滑图的数据
-(NSArray *)getModelArrWithTopArray:(NSArray *)startData
{
    
    NSMutableArray *topArray = [NSMutableArray array];
    [startData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [topArray addObject:[KBColumnModel arcticleModelWithDictionary:obj]];
    }];
    return topArray;
}
//分解能力的数据
-(NSMutableArray *)getModelArrWithTypeArray:(NSArray *)typeData
                               addTypeArray:(NSMutableArray *)typeArray
{
    
    [typeData enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isExist=NO;
        typeTwoDataModel.ID=[[KBColumnModel arcticleModelWithDictionary:obj].secondType intValue];
        for (int j=0; j<typeArray.count; j++)
        {
            KBJudgeTwoSortIdModel * twoSortModel=[typeArray objectAtIndex:j];
            if (twoSortModel.ID==typeTwoDataModel.ID) {
                    isExist=YES;
                [twoSortModel.subArticleArray addObject:[KBColumnModel arcticleModelWithDictionary:obj]];
            }
        }
        if (isExist==NO)
        {
            [typeTwoDataModel.subArticleArray addObject:[KBColumnModel arcticleModelWithDictionary:obj]];
            [typeArray addObject:typeTwoDataModel];
            typeTwoDataModel=[[KBJudgeTwoSortIdModel alloc]init];
           
        }
     
    }];
    return typeArray;
}
//分解学科分类和规划的数据
-(NSMutableArray *)getModelArrWithSubjectTypeArray:(NSArray *)subjectTypeData addSubejectTypeArray:(NSMutableArray *)subjectTypeArray
{
    [subjectTypeData enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isExist=NO;
        typeTwoDataModel.thirdTypeName=[KBColumnModel arcticleModelWithDictionary:obj].thirdTypeName;
        for (int j=0; j<subjectTypeArray.count; j++)
        {
            KBJudgeTwoSortIdModel * twoSortModel=[subjectTypeArray objectAtIndex:j];
            if ([twoSortModel.thirdTypeName isEqualToString: typeTwoDataModel.thirdTypeName])
            {
                isExist=YES;
                [twoSortModel.subArticleArray addObject:[KBColumnModel arcticleModelWithDictionary:obj]];
            }
        }
        if (isExist==NO)
        {
            [typeTwoDataModel.subArticleArray addObject:[KBColumnModel arcticleModelWithDictionary:obj]];
            [subjectTypeArray addObject:typeTwoDataModel];
            typeTwoDataModel=[[KBJudgeTwoSortIdModel alloc]init];
            threeSortModel=[[KBColumnModel alloc]init];
        }
        
    }];
    return subjectTypeArray;
}
#pragma mark - 分解兴趣的数据
-(NSMutableArray *)getModelArrWithInterestTypeArray:(NSArray *)interestTypeData addInterestTypeArray:(NSMutableArray *)interestTypeArray
{
    [interestTypeData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [interestTypeArray addObject:[KBColumnModel arcticleModelWithDictionary:obj]];
    }];
    return interestTypeArray;
}
@end
