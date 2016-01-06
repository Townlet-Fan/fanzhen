//
//  KBLoginModel.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/27.
//  Copyright © 2015年 Test. All rights reserved.
//

//初始化loginSinle的属性的数据
#import <Foundation/Foundation.h>

@interface KBLoginModel : NSObject

//根据字典得到模型
-(instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)loginSingleModelWithDictionary:(NSDictionary *)dict;


@end

