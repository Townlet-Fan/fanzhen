//
//  KBLanMuModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBColumnModel.h"

@implementation KBColumnModel

//根据字典得到模型
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        self.pageId = dict[@"pageId"]?dict[@"pageId"]:@"";
        self.secondType = dict[@"secondType"]?dict[@"secondType"]:@"";
        self.thirdTypeName = dict[@"thirdTypeName"]?dict[@"thirdTypeName"]:@"";
        self.pageTitle = dict[@"pageTitle"]?dict[@"pageTitle"]:@"";
        self.imageSrc = dict[@"imageSrc"]?dict[@"imageSrc"]:@"";
        self.readNumber = dict[@"readNumber"]?dict[@"readNumber"]:@0;
        self.infoImgType = [dict[@"infoImgType"]intValue]?[dict[@"infoImgType"]intValue ]:0;
    }
    return self;

}

+ (instancetype)arcticleModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc]initWithDictionary:dict];
}


@end
