//
//  FIndType_3.m
//  UIScroll1
//
//  Created by eddie on 15-4-6.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBThreeSortModel.h"

@implementation KBThreeSortModel

-(instancetype)init{
    self.isIntrest=NO;
    return self;
}
//解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name_3"];
        _isIntrest=[aDecoder decodeBoolForKey:@"isIntrest"];
        _parentFind_2Delegate=[aDecoder decodeObjectForKey:@"parent"];
        _TypeTowID=[aDecoder decodeIntegerForKey:@"typeTowID"];
        _TypeThreeID = [aDecoder decodeIntegerForKey:@"TypeThreeID"];
        _sortID=[aDecoder decodeIntegerForKey:@"sortID"];
    }
    return self;
}
//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name_3"];
    [aCoder encodeBool:_isIntrest forKey:@"isIntrest"];
    [aCoder encodeObject:_parentFind_2Delegate forKey:@"parent" ];
    [aCoder encodeInteger:_TypeTowID forKey:@"typeTowID"];
    [aCoder encodeInteger:_TypeThreeID forKey:@"TypeThreeID"];
    [aCoder encodeInteger:_sortID forKey:@"sortID"];
}
@end
