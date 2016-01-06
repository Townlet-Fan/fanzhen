//
//  MainType2Data.m
//  UIScroll1
//
//  Created by kuibu technology on 15/5/17.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBJudgeTwoSortIdModel.h"

@implementation KBJudgeTwoSortIdModel


-(instancetype)init{
    self=[super init];
    _imageDic=[[NSMutableDictionary alloc]init];
    _subArticleArray=[[NSMutableArray alloc]init];
    return self;
    
}
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_ID forKey:@"ID"];
    [aCoder encodeObject:_subArticleArray forKey:@"subArticleArray"];
    [aCoder encodeObject:_imageDic forKey:@"imageDic"];
    [aCoder encodeObject:_thirdTypeName forKey:@"thirdTypeName"];
    [aCoder encodeObject:_sameThirdNameArray forKey:@"sameThirdNameArray"];
   
    
    
}
//解档
- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    _imageDic=[aDecoder decodeObjectForKey:@"imageDic"];
    _subArticleArray=[aDecoder decodeObjectForKey:@"subArticleArray"];
    _ID=[aDecoder decodeIntForKey:@"ID"];
    _thirdTypeName =[aDecoder decodeObjectForKey:@"thirdTypeName"];
    _sameThirdNameArray = [aDecoder decodeObjectForKey:@"sameThirdNameArray"];
  
    return self;
}
@end
