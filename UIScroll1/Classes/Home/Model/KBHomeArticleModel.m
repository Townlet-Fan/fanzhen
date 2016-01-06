//
//  KBHomeArticleModel.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeArticleModel.h"


@implementation KBHomeArticleModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.pageId = dict[@"pageId"]?dict[@"pageId"]:@"";
        self.secondType = dict[@"secondType"]?dict[@"secondType"]:@"";
        self.thirdTypeName = dict[@"thirdTypeName"]?dict[@"thirdTypeName"]:@"";
        self.recomPos = dict[@"recomPos"]?dict[@"recomPos"]:@-1;
        self.firstTitle = dict[@"firstTitle"]?dict[@"firstTitle"]:@"";
        self.imageSrc = dict[@"imageSrc"]?dict[@"imageSrc"]:@"";
        self.readNumber = dict[@"readNumber"]?dict[@"readNumber"]:@0;
        self.breakNum = dict[@"breakNum"]?dict[@"breakNum"]:@-1;
    }
    return self;
}

+ (instancetype)arcticleModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

@end
