//
//  MyCollectionData.m
//  UIScroll1
//
//  Created by eddie on 15-5-2.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMyCollectionDataModel.h"

@implementation KBMyCollectionDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.articleTitle = dict[@"firstTitle"]?dict[@"firstTitle"]:@"";
        NSLog(@"self.articletitle:%@",self.articleTitle);
        self.time = dict[@"date"]?dict[@"date"]:@"";
        
        self.TypeName = dict[@"thirdTypeName"]?dict[@"thirdTypeName"]:@"";
        
        self.pageID = dict[@"pageId"]?dict[@"pageId"]:@"";
        
        self.imagestr = dict[@"imageSrc"]?dict[@"imageSrc"]:@"";
        
        self.secondType = dict[@"secondType"]?dict[@"secondType"]:@"";
        
        self.imageData = dict [@"imageData"]?dict [@"imageData"]:@"";
    }
    return self;
}

+ (instancetype)arcticleModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _TypeName = [aDecoder decodeObjectForKey:@"TypeName"];
        _articleTitle=[aDecoder decodeObjectForKey:@"articleTitle"];
        _time=[aDecoder decodeObjectForKey:@"time"];
        _imagestr=[aDecoder decodeObjectForKey:@"imagestr"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_TypeName forKey:@"TypeName"];
    [aCoder encodeObject:_articleTitle forKey:@"articleTitle"];
    [aCoder encodeObject:_imagestr forKey:@"imagestr"];
   
}

@end
