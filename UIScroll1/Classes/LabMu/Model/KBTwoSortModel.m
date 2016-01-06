//
//  FindType_2.m
//  UIScroll1
//
//  Created by eddie on 15-4-6.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBTwoSortModel.h"

@implementation KBTwoSortModel
@synthesize name;
@synthesize subArray;
@synthesize TypeTowID;
@synthesize typeOneInteger;
@synthesize isHaveSorted;

-(instancetype)init{
    self.subArray=[[NSMutableArray alloc]init];
    isHaveSorted=NO;
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        name = [aDecoder decodeObjectForKey:@"name"];
        subArray=[aDecoder decodeObjectForKey:@"array"];
        TypeTowID=[aDecoder decodeIntegerForKey:@"TypeTowID"];
        typeOneInteger=[aDecoder decodeIntegerForKey:@"typeOneInteger"];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:subArray forKey:@"array"];
    [aCoder encodeInteger:TypeTowID  forKey:@"TypeTowID"];
    [aCoder encodeInteger:typeOneInteger forKey:@"typeOneInteger"];
}

@end
