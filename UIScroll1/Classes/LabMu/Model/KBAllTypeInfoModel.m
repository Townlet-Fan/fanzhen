//
//  TypeClass.m
//  UIScroll1
//
//  Created by eddie on 15-5-13.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBAllTypeInfoModel.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
@implementation KBAllTypeInfoModel

static  KBAllTypeInfoModel *sharedInstance = nil;
-(instancetype)init{
    self=[super init];
    self.allTypeArray=[[NSMutableArray alloc]init];
    self.interestStructArray=[[NSMutableArray alloc]init];
    NSMutableArray *typeOneArray=[[NSMutableArray alloc]init];
    NSMutableArray *typeTwoArray=[[NSMutableArray alloc]init];
    NSMutableArray *typeThreeArray=[[NSMutableArray alloc]init];
    NSMutableArray *typeFourArray=[[NSMutableArray alloc]init];
    NSMutableArray *typeFiveArray=[[NSMutableArray alloc]init];
    /*一级分类热点下二极分类新闻头条*/
    KBTwoSortModel *find0_0=[[KBTwoSortModel alloc]init];
    find0_0.name=@"新闻头条";
    find0_0.TypeTowID=0;
    find0_0.typeOneInteger=0;
    
    KBThreeSortModel *find0_0_0=[[KBThreeSortModel alloc]init];
    find0_0_0.name=@"天朝要闻";
    find0_0_0.TypeTowID=0;
    find0_0_0.parentFind_2Delegate=find0_0;
    
    KBThreeSortModel *find0_0_1=[[KBThreeSortModel alloc]init];
    find0_0_1.name=@"环球时讯";
    find0_0_1.TypeTowID=0;
    find0_0_1.parentFind_2Delegate=find0_0;
    
    KBThreeSortModel *find0_0_2=[[KBThreeSortModel alloc]init];
    find0_0_2.name=@"阿拉上海";
    find0_0_2.TypeTowID=0;
    find0_0_2.parentFind_2Delegate=find0_0;
    
    [find0_0.subArray addObject:find0_0_0];
    [find0_0.subArray addObject:find0_0_1];
    [find0_0.subArray addObject:find0_0_2];
    
    /*一级分类热点下二极分类娱乐前线*/
    KBTwoSortModel *find0_1=[[KBTwoSortModel alloc]init];
    find0_1.name=@"娱乐前线";
    find0_1.TypeTowID=1;
    find0_1.typeOneInteger=0;
    
    //    FIndType_3 *find0_1_0=[[FIndType_3 alloc]init];
    //    find0_1_0.name=@"影视综艺";
    //    find0_1_0.TypeTowID=1;
    //    find0_1_0.parentFind_2Delegate=find0_1;
    
    KBThreeSortModel *find0_1_1=[[KBThreeSortModel alloc]init];
    find0_1_1.name=@"魅力音乐";
    find0_1_1.TypeTowID=1;
    find0_1_1.parentFind_2Delegate=find0_1;
    
    KBThreeSortModel *find0_1_2=[[KBThreeSortModel alloc]init];
    find0_1_2.name=@"星闻八卦";
    find0_1_2.TypeTowID=1;
    find0_1_2.parentFind_2Delegate=find0_1;
    
    //    FIndType_3 *find0_1_3=[[FIndType_3 alloc]init];
    //    find0_1_3.name=@"票子要伐";
    //    find0_1_3.TypeTowID=1;
    //    find0_1_3.parentFind_2Delegate=find0_1;
    
    //[find0_1.subArray addObject:find0_1_0];
    [find0_1.subArray addObject:find0_1_1];
    [find0_1.subArray addObject:find0_1_2];
    //[find0_1.subArray addObject:find0_1_3];
    
    //    /*一级分类热点下二极分类劲爆体育*/
    //    FindType_2 *find0_2=[[FindType_2 alloc]init];
    //    find0_2.name=@"劲爆体育";
    //    find0_2.TypeTowID=2;
    //    find0_2.typeOneInteger=0;
    //
    //    FIndType_3 *find0_2_0=[[FIndType_3 alloc]init];
    //    find0_2_0.name=@"体育资讯";
    //    find0_2_0.TypeTowID=2;
    //    find0_2_0.parentFind_2Delegate=find0_2;
    //
    //    //    FIndType_3 *find0_2_1=[[FIndType_3 alloc]init];
    //    //    find0_2_1.name=@"体坛人物";
    //    //    find0_2_1.TypeTowID=2;
    //    //    find0_2_1.parentFind_2Delegate=find0_2;
    //    //
    //    FIndType_3 *find0_2_2=[[FIndType_3 alloc]init];
    //    find0_2_2.name=@"赛事前瞻";
    //    find0_2_2.TypeTowID=2;
    //    find0_2_2.parentFind_2Delegate=find0_2;
    //
    //    //FIndType_3 *find0_2_3=[[FIndType_3 alloc]init];
    //    //find0_2_3.name=@"综合资讯";
    //    //find0_2_3.TypeTowID=2;
    //    //find0_2_3.parentFind_2Delegate=find0_2;
    //
    //    [find0_2.subArray addObject:find0_2_0];
    //    //[find0_2.subArray addObject:find0_2_1];
    //    [find0_2.subArray addObject:find0_2_2];
    //    //[find0_2.subArray addObject:find0_2_3];
    
    /*一级分类热点下二极分类科技数码*/
    KBTwoSortModel *find0_2=[[KBTwoSortModel alloc]init];
    find0_2.name=@"科技数码";
    find0_2.TypeTowID=2;
    find0_2.typeOneInteger=0;
    
    KBThreeSortModel *find0_2_0=[[KBThreeSortModel alloc]init];
    find0_2_0.name=@"互联网";
    find0_2_0.TypeTowID=2;
    find0_2_0.parentFind_2Delegate=find0_2;
    
    KBThreeSortModel *find0_2_1=[[KBThreeSortModel alloc]init];
    find0_2_1.name=@"科技资讯";
    find0_2_1.TypeTowID=2;
    find0_2_1.parentFind_2Delegate=find0_2;
    
    KBThreeSortModel *find0_2_2=[[KBThreeSortModel alloc]init];
    find0_2_2.name=@"新品动态";
    find0_2_2.TypeTowID=2;
    find0_2_2.parentFind_2Delegate=find0_2;
    
    //    FIndType_3 *find0_3_3=[[FIndType_3 alloc]init];
    //    find0_3_3.name=@"最新报价";
    //    find0_3_3.TypeTowID=3;
    //    find0_3_3.parentFind_2Delegate=find0_3;
    
    [find0_2.subArray addObject:find0_2_0];
    [find0_2.subArray addObject:find0_2_1];
    [find0_2.subArray addObject:find0_2_2];
    //[find0_3.subArray addObject:find0_3_3];
    
    
    /*一级分类热点下二极分类玩转大学*/
    KBTwoSortModel *find0_3=[[KBTwoSortModel alloc]init];
    find0_3.name=@"玩转大学";
    find0_3.TypeTowID=3;
    find0_3.typeOneInteger=0;
    
    KBThreeSortModel *find0_3_0=[[KBThreeSortModel alloc]init];
    find0_3_0.name=@"玩转大学";
    find0_3_0.TypeTowID=3;
    find0_3_0.parentFind_2Delegate=find0_3;
    
    
    //    FIndType_3 *find0_4_1=[[FIndType_3 alloc]init];
    //    find0_4_1.name=@"教务通知";
    //    find0_4_1.TypeTowID=4;
    //    find0_4_1.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_2=[[FIndType_3 alloc]init];
    //    find0_4_2.name=@"社团活动";
    //    find0_4_2.TypeTowID=4;
    //    find0_4_2.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_3=[[FIndType_3 alloc]init];
    //    find0_4_3.name=@"精彩赛事";
    //    find0_4_3.TypeTowID=4;
    //    find0_4_3.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_4=[[FIndType_3 alloc]init];
    //    find0_4_4.name=@"校园周边";
    //    find0_4_4.TypeTowID=4;
    //    find0_4_4.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_5=[[FIndType_3 alloc]init];
    //    find0_4_5.name=@"考证驿站";
    //    find0_4_5.TypeTowID=4;
    //    find0_4_5.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_6=[[FIndType_3 alloc]init];
    //    find0_4_6.name=@"最新兼职";
    //    find0_4_6.TypeTowID=4;
    //    find0_4_6.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_7=[[FIndType_3 alloc]init];
    //    find0_4_7.name=@"华理知道";
    //    find0_4_7.TypeTowID=4;
    //    find0_4_7.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_8=[[FIndType_3 alloc]init];
    //    find0_4_8.name=@"高校资讯";
    //    find0_4_8.TypeTowID=4;
    //    find0_4_8.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_9=[[FIndType_3 alloc]init];
    //    find0_4_9.name=@"风采展示";
    //    find0_4_9.TypeTowID=4;
    //    find0_4_9.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_10=[[FIndType_3 alloc]init];
    //    find0_4_10.name=@"实践真知";
    //    find0_4_10.TypeTowID=4;
    //    find0_4_10.parentFind_2Delegate=find0_4;
    //
    //    FIndType_3 *find0_4_11=[[FIndType_3 alloc]init];
    //    find0_4_11.name=@"社团联盟";
    //    find0_4_11.TypeTowID=4;
    //    find0_4_11.parentFind_2Delegate=find0_4;
    
    //[find0_4.subArray addObject:find0_4_0];
    //    [find0_4.subArray addObject:find0_4_1];
    //    [find0_4.subArray addObject:find0_4_2];
    //    [find0_4.subArray addObject:find0_4_3];
    //    [find0_4.subArray addObject:find0_4_4];
    //    [find0_4.subArray addObject:find0_4_5];
    //    [find0_4.subArray addObject:find0_4_6];
    //    [find0_4.subArray addObject:find0_4_7];
    //    [find0_4.subArray addObject:find0_4_8];
    //    [find0_4.subArray addObject:find0_4_9];
    //    [find0_4.subArray addObject:find0_4_10];
    //    [find0_4.subArray addObject:find0_4_11];
    
    /*一级分类推荐下二级分类整合*/
    KBTwoSortModel *find0_4=[[KBTwoSortModel alloc]init];
    find0_4.name=@"整合";
    find0_4.TypeTowID=4;
    find0_4.typeOneInteger=0;
    
    KBThreeSortModel *find0_4_0=[[KBThreeSortModel alloc]init];
    find0_4_0.name=@"24h头条";
    find0_4_0.TypeTowID=4;
    find0_4_0.parentFind_2Delegate=find0_4;
    
    KBThreeSortModel *find0_4_1=[[KBThreeSortModel alloc]init];
    find0_4_1.name=@"24h娱乐";
    find0_4_1.TypeTowID=4;
    find0_4_1.parentFind_2Delegate=find0_4;
    
    KBThreeSortModel *find0_4_2=[[KBThreeSortModel alloc]init];
    find0_4_2.name=@"24h体育";
    find0_4_2.TypeTowID=4;
    find0_4_2.parentFind_2Delegate=find0_4;
    
    KBThreeSortModel *find0_4_3=[[KBThreeSortModel alloc]init];
    find0_4_3.name=@"24h科技";
    find0_4_3.TypeTowID=4;
    find0_4_3.parentFind_2Delegate=find0_4;
    
    KBThreeSortModel *find0_4_4=[[KBThreeSortModel alloc]init];
    find0_4_4.name=@"24h商业";
    find0_4_4.TypeTowID=4;
    find0_4_4.parentFind_2Delegate=find0_4;
    
    [find0_4.subArray addObject:find0_4_0];
    [find0_4.subArray addObject:find0_4_1];
    [find0_4.subArray addObject:find0_4_2];
    [find0_4.subArray addObject:find0_4_3];
    [find0_4.subArray addObject:find0_4_4];
    
    
    [typeOneArray addObject:find0_0];
    [typeOneArray addObject:find0_1];
    [typeOneArray addObject:find0_2];
    [typeOneArray addObject:find0_3];
    [typeOneArray addObject:find0_4];
    
    
    
    /*一级分类学科下二极分类工学*/
    KBTwoSortModel *find1_0=[[KBTwoSortModel alloc]init];
    find1_0.name=@"工学";
    find1_0.TypeTowID=5;
    find1_0.typeOneInteger=1;
    
    KBThreeSortModel *find1_0_0=[[KBThreeSortModel alloc]init];
    find1_0_0.name=@"化学工程";
    find1_0_0.TypeTowID=5;
    find1_0_0.parentFind_2Delegate=find1_0;
    find1_0_0.sortID=0;
    find1_0_0.TypeThreeID=15;
    //    FIndType_3 *find1_0_1=[[FIndType_3 alloc]init];
    //    find1_0_1.name=@"石油工程";
    //    find1_0_1.TypeTowID=5;
    //    find1_0_1.parentFind_2Delegate=find1_0;
    
    KBThreeSortModel *find1_0_2=[[KBThreeSortModel alloc]init];
    find1_0_2.name=@"能源动力";
    find1_0_2.TypeTowID=5;
    find1_0_2.parentFind_2Delegate=find1_0;
    find1_0_2.sortID=1;
    find1_0_2.TypeThreeID=16;
    //    FIndType_3 *find1_0_3=[[FIndType_3 alloc]init];
    //    find1_0_3.name=@"机械电子";
    //    find1_0_3.TypeTowID=5;
    //    find1_0_3.parentFind_2Delegate=find1_0;
    
    KBThreeSortModel *find1_0_4=[[KBThreeSortModel alloc]init];
    find1_0_4.name=@"机械工程";
    find1_0_4.TypeTowID=5;
    find1_0_4.parentFind_2Delegate=find1_0;
    find1_0_4.sortID=3;
    find1_0_4.TypeThreeID=17;
    //    FIndType_3 *find1_0_5=[[FIndType_3 alloc]init];
    //    find1_0_5.name=@"车辆工程";
    //    find1_0_5.TypeTowID=5;
    //    find1_0_5.parentFind_2Delegate=find1_0;
    
    KBThreeSortModel *find1_0_6=[[KBThreeSortModel alloc]init];
    find1_0_6.name=@"材料工程";
    find1_0_6.TypeTowID=5;
    find1_0_6.parentFind_2Delegate=find1_0;
    find1_0_6.sortID=4;
    find1_0_6.TypeThreeID=18;
    
    KBThreeSortModel *find1_0_7=[[KBThreeSortModel alloc]init];
    find1_0_7.name=@"计算机";
    find1_0_7.TypeTowID=5;
    find1_0_7.parentFind_2Delegate=find1_0;
    find1_0_7.sortID=5;
    find1_0_7.TypeThreeID=19;
    
    KBThreeSortModel *find1_0_8=[[KBThreeSortModel alloc]init];
    find1_0_8.name=@"电信工程";
    find1_0_8.TypeTowID=5;
    find1_0_8.parentFind_2Delegate=find1_0;
    find1_0_8.sortID=6;
    find1_0_8.TypeThreeID=20;
    //    FIndType_3 *find1_0_9=[[FIndType_3 alloc]init];
    //    find1_0_9.name=@"软件工程";
    //    find1_0_9.TypeTowID=5;
    //    find1_0_9.parentFind_2Delegate=find1_0;
    
    KBThreeSortModel *find1_0_10=[[KBThreeSortModel alloc]init];
    find1_0_10.name=@"生物工程";
    find1_0_10.TypeTowID=5;
    find1_0_10.parentFind_2Delegate=find1_0;
    find1_0_10.sortID=7;
    find1_0_10.TypeThreeID=21;
    //    FIndType_3 *find1_0_11=[[FIndType_3 alloc]init];
    //    find1_0_11.name=@"网络工程";
    //    find1_0_11.TypeTowID=5;
    //    find1_0_11.parentFind_2Delegate=find1_0;
    //
    //    FIndType_3 *find1_0_12=[[FIndType_3 alloc]init];
    //    find1_0_12.name=@"制药工程";
    //    find1_0_12.TypeTowID=5;
    //    find1_0_12.parentFind_2Delegate=find1_0;
    //
    //    FIndType_3 *find1_0_13=[[FIndType_3 alloc]init];
    //    find1_0_13.name=@"高分子材料";
    //    find1_0_13.TypeTowID=5;
    //    find1_0_13.parentFind_2Delegate=find1_0;
    //
    //    FIndType_3 *find1_0_14=[[FIndType_3 alloc]init];
    //    find1_0_14.name=@"复合材料";
    //    find1_0_14.TypeTowID=5;
    //    find1_0_14.parentFind_2Delegate=find1_0;
    //
    //    FIndType_3 *find1_0_15=[[FIndType_3 alloc]init];
    //    find1_0_15.name=@"无机材料";
    //    find1_0_15.TypeTowID=5;
    //    find1_0_15.parentFind_2Delegate=find1_0;
    
    
    //    FIndType_3 *find1_0_16=[[FIndType_3 alloc]init];
    //    find1_0_16.name=@"生物工程";
    //    find1_0_16.TypeTowID=5;
    //    find1_0_16.parentFind_2Delegate=find1_0;
    
    KBThreeSortModel *find1_0_17=[[KBThreeSortModel alloc]init];
    find1_0_17.name=@"食品科学";
    find1_0_17.TypeTowID=5;
    find1_0_17.parentFind_2Delegate=find1_0;
    find1_0_17.sortID=8;
    find1_0_17.TypeThreeID=22;
    
    KBThreeSortModel *find1_0_18=[[KBThreeSortModel alloc]init];
    find1_0_18.name=@"环境工程";
    find1_0_18.TypeTowID=5;
    find1_0_18.parentFind_2Delegate=find1_0;
    find1_0_18.sortID=9;
    find1_0_18.TypeThreeID=23;
    
    KBThreeSortModel *find1_0_19=[[KBThreeSortModel alloc]init];
    find1_0_19.name=@"土木建筑";
    find1_0_19.TypeTowID=5;
    find1_0_19.parentFind_2Delegate=find1_0;
    find1_0_19.sortID=10;
    find1_0_19.TypeThreeID=24;
    
    [find1_0.subArray addObject:find1_0_0];
    //[find1_0.subArray addObject:find1_0_1];
    [find1_0.subArray addObject:find1_0_2];
    //[find1_0.subArray addObject:find1_0_3];
    [find1_0.subArray addObject:find1_0_4];
    //[find1_0.subArray addObject:find1_0_5];
    [find1_0.subArray addObject:find1_0_6];
    [find1_0.subArray addObject:find1_0_7];
    [find1_0.subArray addObject:find1_0_8];
    //  [find1_0.subArray addObject:find1_0_9];
    [find1_0.subArray addObject:find1_0_10];
    //    [find1_0.subArray addObject:find1_0_11];
    //    [find1_0.subArray addObject:find1_0_12];
    //    [find1_0.subArray addObject:find1_0_13];
    //    [find1_0.subArray addObject:find1_0_14];
    //    [find1_0.subArray addObject:find1_0_15];
    //[find1_0.subArray addObject:find1_0_16];
    [find1_0.subArray addObject:find1_0_17];
    [find1_0.subArray addObject:find1_0_18];
    [find1_0.subArray addObject:find1_0_19];
    
    /*一级分类学科下二极分类理学*/
    KBTwoSortModel *find1_1=[[KBTwoSortModel alloc]init];
    find1_1.name=@"理学";
    find1_1.TypeTowID=6;
    find1_1.typeOneInteger=1;
    
    
    KBThreeSortModel *find1_1_0=[[KBThreeSortModel alloc]init];
    find1_1_0.name=@"物理";
    find1_1_0.TypeTowID=6;
    find1_1_0.parentFind_2Delegate=find1_1;
    find1_1_0.sortID=1;
    find1_1_0.TypeThreeID=25;
    
    KBThreeSortModel *find1_1_1=[[KBThreeSortModel alloc]init];
    find1_1_1.name=@"数学";
    find1_1_1.TypeTowID=6;
    find1_1_1.parentFind_2Delegate=find1_1;
    find1_1_1.sortID=2;
    find1_1_1.TypeThreeID=26;
    
    KBThreeSortModel *find1_1_2=[[KBThreeSortModel alloc]init];
    find1_1_2.name=@"化学";
    find1_1_2.TypeTowID=6;
    find1_1_2.parentFind_2Delegate=find1_1;
    find1_1_2.sortID=3;
    find1_1_2.TypeThreeID=27;
    
    KBThreeSortModel *find1_1_3=[[KBThreeSortModel alloc]init];
    find1_1_3.name=@"地理学";
    find1_1_3.TypeTowID=6;
    find1_1_3.parentFind_2Delegate=find1_1;
    find1_1_3.sortID=4;
    find1_1_3.TypeThreeID=28;
    
    KBThreeSortModel *find1_1_4=[[KBThreeSortModel alloc]init];
    find1_1_4.name=@"药学";
    find1_1_4.TypeTowID=6;
    find1_1_4.parentFind_2Delegate=find1_1;
    find1_1_4.sortID=5;
    find1_1_3.TypeThreeID=29;
    
    KBThreeSortModel *find1_1_5=[[KBThreeSortModel alloc]init];
    find1_1_5.name=@"生物学";
    find1_1_5.TypeTowID=6;
    find1_1_5.parentFind_2Delegate=find1_1;
    find1_1_5.sortID=6;
    find1_1_5.TypeThreeID=30;
    
    //    FIndType_3 *find1_1_6=[[FIndType_3 alloc]init];
    //    find1_1_6.name=@"信息与计算科学";
    //    find1_1_6.TypeTowID=6;
    //    find1_1_6.parentFind_2Delegate=find1_1;
    
    KBThreeSortModel *find1_1_7=[[KBThreeSortModel alloc]init];
    find1_1_7.name=@"心理学";
    find1_1_7.TypeTowID=6;
    find1_1_7.parentFind_2Delegate=find1_1;
    find1_1_7.sortID=7;
    find1_1_7.TypeThreeID=31;
    
    KBThreeSortModel *find1_1_8=[[KBThreeSortModel alloc]init];
    find1_1_8.name=@"统计学";
    find1_1_8.TypeTowID=6;
    find1_1_8.parentFind_2Delegate=find1_1;
    find1_1_8.sortID=8;
    find1_1_8.TypeThreeID=32;
    
    
    [find1_1.subArray addObject:find1_1_0];
    [find1_1.subArray addObject:find1_1_1];
    [find1_1.subArray addObject:find1_1_2];
    [find1_1.subArray addObject:find1_1_3];
    [find1_1.subArray addObject:find1_1_4];
    [find1_1.subArray addObject:find1_1_5];
    //[find1_1.subArray addObject:find1_1_6];
    [find1_1.subArray addObject:find1_1_7];
    [find1_1.subArray addObject:find1_1_8];
    
    /*一级分类学科下二极分类经济学*/
    KBTwoSortModel *find1_2=[[KBTwoSortModel alloc]init];
    find1_2.name=@"经济学";
    find1_2.TypeTowID=7;
    find1_2.typeOneInteger=1;
    
    KBThreeSortModel *find1_2_0=[[KBThreeSortModel alloc]init];
    find1_2_0.name=@"金融学";
    find1_2_0.TypeTowID=7;
    find1_2_0.parentFind_2Delegate=find1_2;
    find1_2_0.sortID=1;
    find1_2_0.TypeThreeID=33;
    
    KBThreeSortModel *find1_2_1=[[KBThreeSortModel alloc]init];
    find1_2_1.name=@"国际经贸";
    find1_2_1.TypeTowID=7;
    find1_2_1.parentFind_2Delegate=find1_2;
    find1_2_1.sortID=2;
    find1_2_1.TypeThreeID=34;
    
    KBThreeSortModel *find1_2_2=[[KBThreeSortModel alloc]init];
    find1_2_2.name=@"经济学";
    find1_2_2.TypeTowID=7;
    find1_2_2.parentFind_2Delegate=find1_2;
    find1_2_1.sortID=3;
    find1_2_2.TypeThreeID=35;
    
    [find1_2.subArray addObject:find1_2_0];
    [find1_2.subArray addObject:find1_2_1];
    [find1_2.subArray addObject:find1_2_2];
    
    /*一级分类学科下二极分类管理学*/
    KBTwoSortModel *find1_3=[[KBTwoSortModel alloc]init];
    find1_3.name=@"管理学";
    find1_3.TypeTowID=8;
    find1_3.typeOneInteger=1;
    
    
    KBThreeSortModel *find1_3_0=[[KBThreeSortModel alloc]init];
    find1_3_0.name=@"会计财管";
    find1_3_0.TypeTowID=8;
    find1_3_0.parentFind_2Delegate=find1_3;
    find1_3_0.sortID=1;
    find1_3_0.TypeThreeID=36;
    
    KBThreeSortModel *find1_3_1=[[KBThreeSortModel alloc]init];
    find1_3_1.name=@"工商管理";
    find1_3_1.TypeTowID=8;
    find1_3_1.parentFind_2Delegate=find1_3;
    find1_3_1.sortID=2;
    find1_3_1.TypeThreeID=37;
    
    KBThreeSortModel *find1_3_2=[[KBThreeSortModel alloc]init];
    find1_3_2.name=@"市场营销";
    find1_3_2.TypeTowID=8;
    find1_3_2.parentFind_2Delegate=find1_3;
    find1_3_2.sortID=3;
    find1_3_2.TypeThreeID=38;
    
    KBThreeSortModel *find1_3_3=[[KBThreeSortModel alloc]init];
    find1_3_3.name=@"人力资源";
    find1_3_3.TypeTowID=8;
    find1_3_3.parentFind_2Delegate=find1_3;
    find1_3_3.sortID=4;
    find1_3_3.TypeThreeID=39;
    
    KBThreeSortModel *find1_3_4=[[KBThreeSortModel alloc]init];
    find1_3_4.name=@"信息管理";
    find1_3_4.TypeTowID=8;
    find1_3_4.parentFind_2Delegate=find1_3;
    find1_3_4.sortID=5;
    find1_3_4.TypeThreeID=40;
    
    KBThreeSortModel *find1_3_5=[[KBThreeSortModel alloc]init];
    find1_3_5.name=@"工程管理";
    find1_3_5.TypeTowID=8;
    find1_3_5.parentFind_2Delegate=find1_3;
    find1_3_5.sortID=6;
    find1_3_5.TypeThreeID=41;
    
    KBThreeSortModel *find1_3_6=[[KBThreeSortModel alloc]init];
    find1_3_6.name=@"物流管理";
    find1_3_6.TypeTowID=8;
    find1_3_6.parentFind_2Delegate=find1_3;
    find1_3_6.sortID=7;
    find1_3_6.TypeThreeID=42;
    
    KBThreeSortModel *find1_3_7=[[KBThreeSortModel alloc]init];
    find1_3_7.name=@"旅游管理";
    find1_3_7.TypeTowID=8;
    find1_3_7.parentFind_2Delegate=find1_3;
    find1_3_7.sortID=8;
    find1_3_7.TypeThreeID=43;
    
    KBThreeSortModel *find1_3_8=[[KBThreeSortModel alloc]init];
    find1_3_8.name=@"公共管理";
    find1_3_8.TypeTowID=8;
    find1_3_8.parentFind_2Delegate=find1_3;
    find1_3_8.sortID=9;
    find1_3_8.TypeThreeID=44;
    
    //    FIndType_3 *find1_3_9=[[FIndType_3 alloc]init];
    //    find1_3_9.name=@"行政管理";
    //    find1_3_9.TypeTowID=8;
    //    find1_3_9.parentFind_2Delegate=find1_3;
    
    [find1_3.subArray addObject:find1_3_0];
    [find1_3.subArray addObject:find1_3_1];
    [find1_3.subArray addObject:find1_3_2];
    [find1_3.subArray addObject:find1_3_3];
    [find1_3.subArray addObject:find1_3_4];
    [find1_3.subArray addObject:find1_3_5];
    [find1_3.subArray addObject:find1_3_6];
    [find1_3.subArray addObject:find1_3_7];
    [find1_3.subArray addObject:find1_3_8];
    //[find1_3.subArray addObject:find1_3_9];
    
    /*一级分类学科下二极分类外语学*/
    KBTwoSortModel *find1_4=[[KBTwoSortModel alloc]init];
    find1_4.name=@"外语学";
    find1_4.TypeTowID=11;
    find1_4.typeOneInteger=1;
    
    KBThreeSortModel *find1_4_0=[[KBThreeSortModel alloc]init];
    find1_4_0.name=@"英语";
    find1_4_0.TypeTowID=11;
    find1_4_0.parentFind_2Delegate=find1_4;
    find1_4_0.sortID=1;
    
    KBThreeSortModel *find1_4_1=[[KBThreeSortModel alloc]init];
    find1_4_1.name=@"法语";
    find1_4_1.TypeTowID=11;
    find1_4_1.parentFind_2Delegate=find1_4;
    find1_4_1.sortID=2;
    
    KBThreeSortModel *find1_4_2=[[KBThreeSortModel alloc]init];
    find1_4_2.name=@"日语";
    find1_4_2.TypeTowID=11;
    find1_4_2.parentFind_2Delegate=find1_4;
    find1_4_2.sortID=3;
    
    KBThreeSortModel *find1_4_3=[[KBThreeSortModel alloc]init];
    find1_4_3.name=@"德语";
    find1_4_3.TypeTowID=11;
    find1_4_3.parentFind_2Delegate=find1_4;
    find1_4_3.sortID=4;
    
    
    KBThreeSortModel *find1_4_4=[[KBThreeSortModel alloc]init];
    find1_4_4.name=@"韩语";
    find1_4_4.TypeTowID=11;
    find1_4_4.parentFind_2Delegate=find1_4;
    find1_4_4.sortID=5;
    
    [find1_4.subArray addObject:find1_4_0];
    [find1_4.subArray addObject:find1_4_1];
    [find1_4.subArray addObject:find1_4_2];
    [find1_4.subArray addObject:find1_4_3];
    [find1_4.subArray addObject:find1_4_4];
    
    
    /*一级分类学科下二极分类法学*/
    KBTwoSortModel *find1_5=[[KBTwoSortModel alloc]init];
    find1_5.name=@"法学";
    find1_5.TypeTowID=10;
    find1_5.typeOneInteger=1;
    
    KBThreeSortModel *find1_5_0=[[KBThreeSortModel alloc]init];
    find1_5_0.name=@"法学";
    find1_5_0.TypeTowID=10;
    find1_5_0.parentFind_2Delegate=find1_5;
    find1_5_0.sortID=1;
    
    KBThreeSortModel *find1_5_1=[[KBThreeSortModel alloc]init];
    find1_5_1.name=@"社会学";
    find1_5_1.TypeTowID=10;
    find1_5_1.parentFind_2Delegate=find1_5;
    find1_5_1.sortID=2;
    
    
    [find1_5.subArray addObject:find1_5_0];
    [find1_5.subArray addObject:find1_5_1];
    
    
    /*一级分类学科下二极分类哲学*/
    KBTwoSortModel *find1_6=[[KBTwoSortModel alloc]init];
    find1_6.name=@"哲学";
    find1_6.TypeTowID=9;
    find1_6.typeOneInteger=1;
    
    KBThreeSortModel *find1_6_0=[[KBThreeSortModel alloc]init];
    find1_6_0.name=@"哲学";
    find1_6_0.TypeTowID=9;
    find1_6_0.parentFind_2Delegate=find1_6;
    find1_6_0.sortID=1;
    
    [find1_6.subArray addObject:find1_6_0];
    
    /*一级分类学科下二极分类艺术学*/
    KBTwoSortModel *find1_7=[[KBTwoSortModel alloc]init];
    find1_7.name=@"艺术学";
    find1_7.TypeTowID=12;
    find1_7.typeOneInteger=1;
    
    KBThreeSortModel *find1_7_0=[[KBThreeSortModel alloc]init];
    find1_7_0.name=@"设计";
    find1_7_0.TypeTowID=12;
    find1_7_0.parentFind_2Delegate=find1_7;
    find1_7_0.sortID=1;
    
    KBThreeSortModel *find1_7_1=[[KBThreeSortModel alloc]init];
    find1_7_1.name=@"广告";
    find1_7_1.TypeTowID=12;
    find1_7_1.parentFind_2Delegate=find1_7;
    find1_7_1.sortID=2;
    
    //    FIndType_3 *find1_7_2=[[FIndType_3 alloc]init];
    //    find1_7_2.name=@"音乐";
    //    find1_7_2.TypeTowID=12;
    //    find1_7_2.parentFind_2Delegate=find1_7;
    //
    //    FIndType_3 *find1_7_3=[[FIndType_3 alloc]init];
    //    find1_7_3.name=@"戏剧与影视";
    //    find1_7_3.TypeTowID=12;
    //    find1_7_3.parentFind_2Delegate=find1_7;
    
    KBThreeSortModel *find1_7_4=[[KBThreeSortModel alloc]init];
    find1_7_4.name=@"美术";
    find1_7_4.TypeTowID=12;
    find1_7_4.parentFind_2Delegate=find1_7;
    find1_7_4.sortID=3;
    
    [find1_7.subArray addObject:find1_7_0];
    [find1_7.subArray addObject:find1_7_1];
    //    [find1_7.subArray addObject:find1_7_2];
    //    [find1_7.subArray addObject:find1_7_3];
    [find1_7.subArray addObject:find1_7_4];
    
    [typeTwoArray addObject:find1_0];
    [typeTwoArray addObject:find1_1];
    [typeTwoArray addObject:find1_2];
    [typeTwoArray addObject:find1_3];
    [typeTwoArray addObject:find1_6];
    [typeTwoArray addObject:find1_4];
    [typeTwoArray addObject:find1_5];
    [typeTwoArray addObject:find1_7];
    
    /*一级分类能力下二极分类实用软件*/
    KBTwoSortModel *find2_0=[[KBTwoSortModel alloc]init];
    find2_0.name=@"实用软件";
    find2_0.TypeTowID=13;
    find2_0.typeOneInteger=2;
    
    KBThreeSortModel *find2_0_0=[[KBThreeSortModel alloc]init];
    find2_0_0.name=@"Word";
    find2_0_0.TypeTowID=13;
    find2_0_0.parentFind_2Delegate=find2_0;
    find2_0_0.sortID=1;
    
    KBThreeSortModel *find2_0_1=[[KBThreeSortModel alloc]init];
    find2_0_1.name=@"Excel";
    find2_0_1.TypeTowID=13;
    find2_0_1.parentFind_2Delegate=find2_0;
    find2_0_1.sortID=2;
    
    KBThreeSortModel *find2_0_2=[[KBThreeSortModel alloc]init];
    find2_0_2.name=@"PPT";
    find2_0_2.TypeTowID=13;
    find2_0_2.parentFind_2Delegate=find2_0;
    find2_0_2.sortID=3;
    
    KBThreeSortModel *find2_0_3=[[KBThreeSortModel alloc]init];
    find2_0_3.name=@"图像处理";
    find2_0_3.TypeTowID=13;
    find2_0_3.parentFind_2Delegate=find2_0;
    find2_0_3.sortID=4;
    
    KBThreeSortModel *find2_0_4=[[KBThreeSortModel alloc]init];
    find2_0_4.name=@"视频制作";
    find2_0_4.TypeTowID=13;
    find2_0_4.parentFind_2Delegate=find2_0;
    find2_0_4.sortID=5;
    
    [find2_0.subArray addObject:find2_0_0];
    [find2_0.subArray addObject:find2_0_1];
    [find2_0.subArray addObject:find2_0_2];
    [find2_0.subArray addObject:find2_0_3];
    [find2_0.subArray addObject:find2_0_4];
    
    
    /*一级分类能力下二极分类谈笑江湖*/
    KBTwoSortModel *find2_1=[[KBTwoSortModel alloc]init];
    find2_1.name=@"谈笑江湖";
    find2_1.TypeTowID=14;
    find2_1.typeOneInteger=2;
    
    KBThreeSortModel *find2_1_0=[[KBThreeSortModel alloc]init];
    find2_1_0.name=@"交际礼仪";
    find2_1_0.TypeTowID=14;
    find2_1_0.parentFind_2Delegate=find2_1;
    find2_1_0.sortID=1;
    
    KBThreeSortModel *find2_1_1=[[KBThreeSortModel alloc]init];
    find2_1_1.name=@"沟通口才";
    find2_1_1.TypeTowID=14;
    find2_1_1.parentFind_2Delegate=find2_1;
    find2_1_1.sortID=2;
    //    FIndType_3 *find2_1_2=[[FIndType_3 alloc]init];
    //    find2_1_2.name=@"口才训练";
    //    find2_1_2.TypeTowID=14;
    //    find2_1_2.parentFind_2Delegate=find2_1;
    //
    //    FIndType_3 *find2_1_3=[[FIndType_3 alloc]init];
    //    find2_1_3.name=@"社交礼仪";
    //    find2_1_3.TypeTowID=14;
    //    find2_1_3.parentFind_2Delegate=find2_1;
    
    [find2_1.subArray addObject:find2_1_0];
    [find2_1.subArray addObject:find2_1_1];
    //    [find2_1.subArray addObject:find2_1_2];
    //    [find2_1.subArray addObject:find2_1_3];
    
    /*一级分类能力下二极分类内功修炼*/
    KBTwoSortModel *find2_2=[[KBTwoSortModel alloc]init];
    find2_2.name=@"内功修炼";
    find2_2.TypeTowID=15;
    find2_2.typeOneInteger=2;
    
    KBThreeSortModel *find2_2_0=[[KBThreeSortModel alloc]init];
    find2_2_0.name=@"成长力";
    find2_2_0.TypeTowID=15;
    find2_2_0.parentFind_2Delegate=find2_2;
    find2_2_0.sortID=1;
    
    KBThreeSortModel *find2_2_1=[[KBThreeSortModel alloc]init];
    find2_2_1.name=@"行动力";
    find2_2_1.TypeTowID=15;
    find2_2_1.parentFind_2Delegate=find2_2;
    find2_2_1.sortID=2;
    
    KBThreeSortModel *find2_2_2=[[KBThreeSortModel alloc]init];
    find2_2_2.name=@"影响力";
    find2_2_2.TypeTowID=15;
    find2_2_2.parentFind_2Delegate=find2_2;
    find2_2_2.sortID=3;
    
    KBThreeSortModel *find2_2_3=[[KBThreeSortModel alloc]init];
    find2_2_3.name=@"思考力";
    find2_2_3.TypeTowID=15;
    find2_2_3.parentFind_2Delegate=find2_2;
    find2_2_3.sortID=4;
    
    KBThreeSortModel *find2_2_4=[[KBThreeSortModel alloc]init];
    find2_2_4.name=@"领导力";
    find2_2_4.TypeTowID=15;
    find2_2_4.parentFind_2Delegate=find2_2;
    find2_2_4.sortID=5;
    
    
    [find2_2.subArray addObject:find2_2_0];
    [find2_2.subArray addObject:find2_2_1];
    [find2_2.subArray addObject:find2_2_2];
    [find2_2.subArray addObject:find2_2_3];
    [find2_2.subArray addObject:find2_2_4];
    
    
    /*一级分类能力下二极分类思维境界*/
    KBTwoSortModel *find2_3=[[KBTwoSortModel alloc]init];
    find2_3.name=@"思维境界";
    find2_3.TypeTowID=16;
    find2_3.typeOneInteger=2;
    
    KBThreeSortModel *find2_3_0=[[KBThreeSortModel alloc]init];
    find2_3_0.name=@"逻辑思维";
    find2_3_0.TypeTowID=16;
    find2_3_0.parentFind_2Delegate=find2_3;
    find2_3_0.sortID=1;
    
    KBThreeSortModel *find2_3_1=[[KBThreeSortModel alloc]init];
    find2_3_1.name=@"创新思维";
    find2_3_1.TypeTowID=16;
    find2_3_1.parentFind_2Delegate=find2_3;
    find2_3_1.sortID=2;
    //    FIndType_3 *find2_3_2=[[FIndType_3 alloc]init];
    //    find2_3_2.name=@"颠覆式思维";
    //    find2_3_2.TypeTowID=16;
    //    find2_3_2.parentFind_2Delegate=find2_3;
    
    [find2_3.subArray addObject:find2_3_0];
    [find2_3.subArray addObject:find2_3_1];
    //[find2_3.subArray addObject:find2_3_2];
    
    
    /*一级分类能力下二极分类律己秘籍*/
    KBTwoSortModel *find2_4=[[KBTwoSortModel alloc]init];
    find2_4.name=@"律己秘籍";
    find2_4.TypeTowID=17;
    find2_4.typeOneInteger=2;
    
    KBThreeSortModel *find2_4_0=[[KBThreeSortModel alloc]init];
    find2_4_0.name=@"情感调节";
    find2_4_0.TypeTowID=17;
    find2_4_0.parentFind_2Delegate=find2_4;
    find2_4_0.sortID=1;
    
    KBThreeSortModel *find2_4_1=[[KBThreeSortModel alloc]init];
    find2_4_1.name=@"时间管理";
    find2_4_1.TypeTowID=17;
    find2_4_1.parentFind_2Delegate=find2_4;
    find2_4_1.sortID=2;
    
    KBThreeSortModel *find2_4_2=[[KBThreeSortModel alloc]init];
    find2_4_2.name=@"理财达人";
    find2_4_2.TypeTowID=17;
    find2_4_2.parentFind_2Delegate=find2_4;
    find2_4_2.sortID=3;
    
    [find2_4.subArray addObject:find2_4_0];
    [find2_4.subArray addObject:find2_4_1];
    [find2_4.subArray addObject:find2_4_2];
    
    
    [typeThreeArray addObject:find2_0];
    [typeThreeArray addObject:find2_1];
    [typeThreeArray addObject:find2_2];
    [typeThreeArray addObject:find2_3];
    [typeThreeArray addObject:find2_4];
    
    /*一级分类规划下二极分类就业*/
    KBTwoSortModel *find3_0=[[KBTwoSortModel alloc]init];
    find3_0.name=@"就业";
    find3_0.TypeTowID=18;
    find3_0.typeOneInteger=3;
    
    KBThreeSortModel *find3_0_0=[[KBThreeSortModel alloc]init];
    find3_0_0.name=@"求职简历";
    find3_0_0.TypeTowID=18;
    find3_0_0.parentFind_2Delegate=find3_0;
    find3_0_0.sortID=1;
    
    //    FIndType_3 *find3_0_1=[[FIndType_3 alloc]init];
    //    find3_0_1.name=@"笔试环节";
    //    find3_0_1.TypeTowID=18;
    //    find3_0_1.parentFind_2Delegate=find3_0;
    
    KBThreeSortModel *find3_0_2=[[KBThreeSortModel alloc]init];
    find3_0_2.name=@"面试环节";
    find3_0_2.TypeTowID=18;
    find3_0_2.parentFind_2Delegate=find3_0;
    find3_0_2.sortID=2;
    
    KBThreeSortModel *find3_0_3=[[KBThreeSortModel alloc]init];
    find3_0_3.name=@"职场礼仪";
    find3_0_3.TypeTowID=18;
    find3_0_3.parentFind_2Delegate=find3_0;
    find3_0_3.sortID=3;
    
    KBThreeSortModel *find3_0_4=[[KBThreeSortModel alloc]init];
    find3_0_4.name=@"职场法则";
    find3_0_4.TypeTowID=18;
    find3_0_4.parentFind_2Delegate=find3_0;
    find3_0_4.sortID=4;
    
    KBThreeSortModel *find3_0_5=[[KBThreeSortModel alloc]init];
    find3_0_5.name=@"职业规划";
    find3_0_5.TypeTowID=18;
    find3_0_5.parentFind_2Delegate=find3_0;
    find3_0_5.sortID=5;
    
    KBThreeSortModel *find3_0_6=[[KBThreeSortModel alloc]init];
    find3_0_6.name=@"实习就业";
    find3_0_6.TypeTowID=18;
    find3_0_6.parentFind_2Delegate=find3_0;
    find3_0_6.sortID=6;
    
    
    [find3_0.subArray addObject:find3_0_0];
    //[find3_0.subArray addObject:find3_0_1];
    [find3_0.subArray addObject:find3_0_2];
    [find3_0.subArray addObject:find3_0_3];
    [find3_0.subArray addObject:find3_0_4];
    [find3_0.subArray addObject:find3_0_5];
    [find3_0.subArray addObject:find3_0_6];
    
    /*一级分类规划下二极分类考研*/
    KBTwoSortModel *find3_1=[[KBTwoSortModel alloc]init];
    find3_1.name=@"考研";
    find3_1.TypeTowID=19;
    find3_1.typeOneInteger=3;
    
    KBThreeSortModel *find3_1_0=[[KBThreeSortModel alloc]init];
    find3_1_0.name=@"考研资讯";
    find3_1_0.TypeTowID=19;
    find3_1_0.parentFind_2Delegate=find3_1;
    find3_1_0.sortID=1;
    
    KBThreeSortModel *find3_1_1=[[KBThreeSortModel alloc]init];
    find3_1_1.name=@"考研数学";
    find3_1_1.TypeTowID=19;
    find3_1_1.parentFind_2Delegate=find3_1;
    find3_1_1.sortID=2;
    
    KBThreeSortModel *find3_1_2=[[KBThreeSortModel alloc]init];
    find3_1_2.name=@"考研英语";
    find3_1_2.TypeTowID=19;
    find3_1_2.parentFind_2Delegate=find3_1;
    find3_1_2.sortID=3;
    
    KBThreeSortModel *find3_1_3=[[KBThreeSortModel alloc]init];
    find3_1_3.name=@"考研政治";
    find3_1_3.TypeTowID=19;
    find3_1_3.parentFind_2Delegate=find3_1;
    find3_1_3.sortID=4;
    
    KBThreeSortModel *find3_1_4=[[KBThreeSortModel alloc]init];
    find3_1_4.name=@"考研复试";
    find3_1_4.TypeTowID=19;
    find3_1_4.parentFind_2Delegate=find3_1;
    find3_1_4.sortID=5;
    
    KBThreeSortModel *find3_1_7=[[KBThreeSortModel alloc]init];
    find3_1_7.name=@"考研调剂";
    find3_1_7.TypeTowID=19;
    find3_1_7.parentFind_2Delegate=find3_1;
    find3_1_7.sortID=6;
    
    KBThreeSortModel *find3_1_5=[[KBThreeSortModel alloc]init];
    find3_1_5.name=@"经验交流";
    find3_1_5.TypeTowID=19;
    find3_1_5.parentFind_2Delegate=find3_1;
    find3_1_5.sortID=7;
    //    FIndType_3 *find3_1_6=[[FIndType_3 alloc]init];
    //    find3_1_6.name=@"励志时间";
    //    find3_1_6.TypeTowID=19;
    //    find3_1_6.parentFind_2Delegate=find3_1;
    
    [find3_1.subArray addObject:find3_1_0];
    [find3_1.subArray addObject:find3_1_1];
    [find3_1.subArray addObject:find3_1_2];
    [find3_1.subArray addObject:find3_1_3];
    [find3_1.subArray addObject:find3_1_4];
    [find3_1.subArray addObject:find3_1_7];
    [find3_1.subArray addObject:find3_1_5];
    //[find3_1.subArray addObject:find3_1_6];
    
    
    
    /*一级分类规划下二极分类留学*/
    KBTwoSortModel *find3_2=[[KBTwoSortModel alloc]init];
    find3_2.name=@"留学";
    find3_2.TypeTowID=20;
    find3_2.typeOneInteger=3;
    
    KBThreeSortModel *find3_2_0=[[KBThreeSortModel alloc]init];
    find3_2_0.name=@"留学美国";
    find3_2_0.TypeTowID=20;
    find3_2_0.parentFind_2Delegate=find3_2;
    find3_2_0.sortID=3;
    
    KBThreeSortModel *find3_2_1=[[KBThreeSortModel alloc]init];
    find3_2_1.name=@"留学加国";
    find3_2_1.TypeTowID=20;
    find3_2_1.parentFind_2Delegate=find3_2;
    find3_2_1.sortID=4;
    
    KBThreeSortModel *find3_2_2=[[KBThreeSortModel alloc]init];
    find3_2_2.name=@"留学澳洲";
    find3_2_2.TypeTowID=20;
    find3_2_2.parentFind_2Delegate=find3_2;
    find3_2_2.sortID=5;
    
    KBThreeSortModel *find3_2_3=[[KBThreeSortModel alloc]init];
    find3_2_3.name=@"留学英国";
    find3_2_3.TypeTowID=20;
    find3_2_3.parentFind_2Delegate=find3_2;
    find3_2_3.sortID=6;
    
    KBThreeSortModel *find3_2_4=[[KBThreeSortModel alloc]init];
    find3_2_4.name=@"留学法国";
    find3_2_4.TypeTowID=20;
    find3_2_4.parentFind_2Delegate=find3_2;
    find3_2_4.sortID=7;
    
    KBThreeSortModel *find3_2_5=[[KBThreeSortModel alloc]init];
    find3_2_5.name=@"留学德国";
    find3_2_5.TypeTowID=20;
    find3_2_5.parentFind_2Delegate=find3_2;
    find3_2_5.sortID=8;
    
    KBThreeSortModel *find3_2_6=[[KBThreeSortModel alloc]init];
    find3_2_6.name=@"留学日本";
    find3_2_6.TypeTowID=20;
    find3_2_6.parentFind_2Delegate=find3_2;
    find3_2_6.sortID=9;
    
    KBThreeSortModel *find3_2_7=[[KBThreeSortModel alloc]init];
    find3_2_7.name=@"留学韩国";
    find3_2_7.TypeTowID=20;
    find3_2_7.parentFind_2Delegate=find3_2;
    find3_2_7.sortID=10;
    
    KBThreeSortModel *find3_2_8=[[KBThreeSortModel alloc]init];
    find3_2_8.name=@"托福";
    find3_2_8.TypeTowID=20;
    find3_2_8.parentFind_2Delegate=find3_2;
    find3_2_8.sortID=11;
    
    KBThreeSortModel *find3_2_9=[[KBThreeSortModel alloc]init];
    find3_2_9.name=@"雅思";
    find3_2_9.TypeTowID=20;
    find3_2_9.parentFind_2Delegate=find3_2;
    find3_2_9.sortID=12;
    
    KBThreeSortModel *find3_2_10=[[KBThreeSortModel alloc]init];
    find3_2_10.name=@"GRE";
    find3_2_10.TypeTowID=20;
    find3_2_10.parentFind_2Delegate=find3_2;
    find3_2_10.sortID=13;
    
    KBThreeSortModel *find3_2_11=[[KBThreeSortModel alloc]init];
    find3_2_11.name=@"留学香港";
    find3_2_11.TypeTowID=20;
    find3_2_11.parentFind_2Delegate=find3_2;
    find3_2_11.sortID=2;
    
    KBThreeSortModel *find3_2_12=[[KBThreeSortModel alloc]init];
    find3_2_12.name=@"留学百科";
    find3_2_12.TypeTowID=20;
    find3_2_12.parentFind_2Delegate=find3_2;
    find3_2_12.sortID=1;
    
    [find3_2.subArray addObject:find3_2_12];
    [find3_2.subArray addObject:find3_2_11];
    [find3_2.subArray addObject:find3_2_0];
    [find3_2.subArray addObject:find3_2_1];
    [find3_2.subArray addObject:find3_2_2];
    [find3_2.subArray addObject:find3_2_3];
    [find3_2.subArray addObject:find3_2_4];
    [find3_2.subArray addObject:find3_2_5];
    [find3_2.subArray addObject:find3_2_6];
    [find3_2.subArray addObject:find3_2_7];
    //[find3_2.subArray addObject:find3_2_12];
    [find3_2.subArray addObject:find3_2_8];
    [find3_2.subArray addObject:find3_2_9];
    [find3_2.subArray addObject:find3_2_10];
    
    /*一级分类规划下二极分类创业*/
    KBTwoSortModel *find3_3=[[KBTwoSortModel alloc]init];
    find3_3.name=@"创业";
    find3_3.TypeTowID=21;
    find3_3.typeOneInteger=3;
    
    KBThreeSortModel *find3_3_0=[[KBThreeSortModel alloc]init];
    find3_3_0.name=@"创业学堂";
    find3_3_0.TypeTowID=21;
    find3_3_0.parentFind_2Delegate=find3_3;
    find3_3_0.sortID=1;
    
    KBThreeSortModel *find3_3_1=[[KBThreeSortModel alloc]init];
    find3_3_1.name=@"创业资讯";
    find3_3_1.TypeTowID=21;
    find3_3_1.parentFind_2Delegate=find3_3;
    find3_3_1.sortID=2;
    //    FIndType_3 *find3_3_2=[[FIndType_3 alloc]init];
    //    find3_3_2.name=@"创业观点";
    //    find3_3_2.TypeTowID=20;
    //    find3_3_2.parentFind_2Delegate=find3_3;
    
    KBThreeSortModel *find3_3_3=[[KBThreeSortModel alloc]init];
    find3_3_3.name=@"名人视角";
    find3_3_3.TypeTowID=21;
    find3_3_3.parentFind_2Delegate=find3_3;
    find3_3_3.sortID=3;
    //    FIndType_3 *find3_3_4=[[FIndType_3 alloc]init];
    //    find3_3_4.name=@"创业人物";
    //    find3_3_4.TypeTowID=21;
    //    find3_3_4.parentFind_2Delegate=find3_3;
    
    KBThreeSortModel *find3_3_5=[[KBThreeSortModel alloc]init];
    find3_3_5.name=@"创投动向";
    find3_3_5.TypeTowID=21;
    find3_3_5.parentFind_2Delegate=find3_3;
    find3_3_5.sortID=4;
    
//    FIndType_3 *find3_3_6=[[FIndType_3 alloc]init];
//    find3_3_6.name=@"创业前沿";
//    find3_3_6.TypeTowID=21;
//    find3_3_6.parentFind_2Delegate=find3_3;
//    find3_3_6.sortID=5;
    
    //    FIndType_3 *find3_3_7=[[FIndType_3 alloc]init];
    //    find3_3_7.name=@"智能产品创业";
    //    find3_3_7.TypeTowID=20;
    //    find3_3_7.parentFind_2Delegate=find3_3;
    
    [find3_3.subArray addObject:find3_3_0];
    [find3_3.subArray addObject:find3_3_1];
    //[find3_3.subArray addObject:find3_3_2];
    [find3_3.subArray addObject:find3_3_3];
    //[find3_3.subArray addObject:find3_3_4];
    [find3_3.subArray addObject:find3_3_5];
    //[find3_3.subArray addObject:find3_3_6];
    //[find3_3.subArray addObject:find3_3_7];
    
    [typeFourArray addObject:find3_0];
    [typeFourArray addObject:find3_1];
    [typeFourArray addObject:find3_2];
    [typeFourArray addObject:find3_3];
    
    /*一级分类兴趣下二极分类跬步出品*/
    KBTwoSortModel *find4_0=[[KBTwoSortModel alloc]init];
    find4_0.name=@"跬步出品";
    find4_0.TypeTowID=22;
    find4_0.typeOneInteger=4;
    
    KBThreeSortModel *find4_0_0=[[KBThreeSortModel alloc]init];
    find4_0_0.name=@"跬步有曰";
    find4_0_0.TypeTowID=22;
    find4_0_0.parentFind_2Delegate=find4_0;
    find4_0_0.sortID=1;
    
    KBThreeSortModel *find4_0_1=[[KBThreeSortModel alloc]init];
    find4_0_1.name=@"数码宝贝";
    find4_0_1.TypeTowID=22;
    find4_0_1.parentFind_2Delegate=find4_0;
    find4_0_1.sortID=2;
    
    KBThreeSortModel *find4_0_2=[[KBThreeSortModel alloc]init];
    find4_0_2.name=@"男生说";
    find4_0_2.TypeTowID=22;
    find4_0_2.parentFind_2Delegate=find4_0;
    find4_0_2.sortID=3;
    
    KBThreeSortModel *find4_0_3=[[KBThreeSortModel alloc]init];
    find4_0_3.name=@"女生说";
    find4_0_3.TypeTowID=22;
    find4_0_3.parentFind_2Delegate=find4_0;
    find4_0_3.sortID=4;
    
    //    FIndType_3 *find4_0_4=[[FIndType_3 alloc]init];
    //    find4_0_4.name=@"咸聊贫道";
    //    find4_0_4.TypeTowID=22;
    //    find4_0_4.parentFind_2Delegate=find4_0;
    
    KBThreeSortModel *find4_0_5=[[KBThreeSortModel alloc]init];
    find4_0_5.name=@"hi,爱情";
    find4_0_5.TypeTowID=22;
    find4_0_5.parentFind_2Delegate=find4_0;
    find4_0_5.sortID=5;
    
    KBThreeSortModel *find4_0_6=[[KBThreeSortModel alloc]init];
    find4_0_6.name=@"音乐先锋";
    find4_0_6.TypeTowID=22;
    find4_0_6.parentFind_2Delegate=find4_0;
    find4_0_6.sortID=6;
    
    KBThreeSortModel *find4_0_7=[[KBThreeSortModel alloc]init];
    find4_0_7.name=@"神叨叨";
    find4_0_7.TypeTowID=22;
    find4_0_7.parentFind_2Delegate=find4_0;
    find4_0_7.sortID=7;
    
    [find4_0.subArray addObject:find4_0_0];
    [find4_0.subArray addObject:find4_0_1];
    [find4_0.subArray addObject:find4_0_2];
    [find4_0.subArray addObject:find4_0_3];
    //[find4_0.subArray addObject:find4_0_4];
    [find4_0.subArray addObject:find4_0_5];
    [find4_0.subArray addObject:find4_0_6];
    [find4_0.subArray addObject:find4_0_7];
    
    /*一级分类兴趣下二极分类娱乐前线*/
    KBTwoSortModel *find4_13=[[KBTwoSortModel alloc]init];
    find4_13.name=@"娱乐前线";
    find4_13.TypeTowID=23;
    find4_13.typeOneInteger=4;
    
    KBThreeSortModel *find4_13_0=[[KBThreeSortModel alloc]init];
    find4_13_0.name=@"电影频道";
    find4_13_0.TypeTowID=23;
    find4_13_0.parentFind_2Delegate=find4_13;
    find4_13_0.sortID=1;
    
    KBThreeSortModel *find4_13_1=[[KBThreeSortModel alloc]init];
    find4_13_1.name=@"影视综艺";
    find4_13_1.TypeTowID=23;
    find4_13_1.parentFind_2Delegate=find4_13;
    find4_13_1.sortID=2;
    
    KBThreeSortModel *find4_13_2=[[KBThreeSortModel alloc]init];
    find4_13_2.name=@"演出票务";
    find4_13_2.TypeTowID=23;
    find4_13_2.parentFind_2Delegate=find4_13;
    find4_13_2.sortID=3;
    
    [find4_13.subArray addObject:find4_13_0];
    [find4_13.subArray addObject:find4_13_1];
    [find4_13.subArray addObject:find4_13_2];
    
    
    /*一级分类兴趣下二极分类运动达人*/
    KBTwoSortModel *find4_1=[[KBTwoSortModel alloc]init];
    find4_1.name=@"运动达人";
    find4_1.TypeTowID=24;
    find4_1.typeOneInteger=4;
    
    KBThreeSortModel *find4_1_0=[[KBThreeSortModel alloc]init];
    find4_1_0.name=@"热血篮球";
    find4_1_0.TypeTowID=24;
    find4_1_0.parentFind_2Delegate=find4_1;
    find4_1_0.sortID=1;
    
    KBThreeSortModel *find4_1_1=[[KBThreeSortModel alloc]init];
    find4_1_1.name=@"顶级足球";
    find4_1_1.TypeTowID=24;
    find4_1_1.parentFind_2Delegate=find4_1;
    find4_1_1.sortID=2;
    
    KBThreeSortModel *find4_1_2=[[KBThreeSortModel alloc]init];
    find4_1_2.name=@"风云网球";
    find4_1_2.TypeTowID=24;
    find4_1_2.parentFind_2Delegate=find4_1;
    find4_1_2.sortID=3;
    
    KBThreeSortModel *find4_1_3=[[KBThreeSortModel alloc]init];
    find4_1_3.name=@"飞扬乒羽";
    find4_1_3.TypeTowID=24;
    find4_1_3.parentFind_2Delegate=find4_1;
    find4_1_3.sortID=4;
    
    KBThreeSortModel *find4_1_4=[[KBThreeSortModel alloc]init];
    find4_1_4.name=@"田径世界";
    find4_1_4.TypeTowID=24;
    find4_1_4.parentFind_2Delegate=find4_1;
    find4_1_4.sortID=5;
    
    KBThreeSortModel *find4_1_5=[[KBThreeSortModel alloc]init];
    find4_1_5.name=@"动感单车";
    find4_1_5.TypeTowID=24;
    find4_1_5.parentFind_2Delegate=find4_1;
    find4_1_5.sortID=6;
    
    KBThreeSortModel *find4_1_6=[[KBThreeSortModel alloc]init];
    find4_1_6.name=@"激情赛车";
    find4_1_6.TypeTowID=24;
    find4_1_6.parentFind_2Delegate=find4_1;
    find4_1_6.sortID=7;
    
    KBThreeSortModel *find4_1_7=[[KBThreeSortModel alloc]init];
    find4_1_7.name=@"水上竞技";
    find4_1_7.TypeTowID=24;
    find4_1_7.parentFind_2Delegate=find4_1;
    find4_1_7.sortID=8;
    
    KBThreeSortModel *find4_1_8=[[KBThreeSortModel alloc]init];
    find4_1_8.name=@"极致排球";
    find4_1_8.TypeTowID=24;
    find4_1_8.parentFind_2Delegate=find4_1;
    find4_1_8.sortID=9;
    
    KBThreeSortModel *find4_1_9=[[KBThreeSortModel alloc]init];
    find4_1_9.name=@"极限运动";
    find4_1_9.TypeTowID=24;
    find4_1_9.parentFind_2Delegate=find4_1;
    find4_1_9.sortID=10;
    
    KBThreeSortModel *find4_1_10=[[KBThreeSortModel alloc]init];
    find4_1_10.name=@"健身塑形";
    find4_1_10.TypeTowID=24;
    find4_1_10.parentFind_2Delegate=find4_1;
    find4_1_10.sortID=11;
    
    [find4_1.subArray addObject:find4_1_0];
    [find4_1.subArray addObject:find4_1_1];
    [find4_1.subArray addObject:find4_1_2];
    [find4_1.subArray addObject:find4_1_3];
    [find4_1.subArray addObject:find4_1_4];
    [find4_1.subArray addObject:find4_1_5];
    [find4_1.subArray addObject:find4_1_6];
    [find4_1.subArray addObject:find4_1_7];
    
    [find4_1.subArray addObject:find4_1_8];
    [find4_1.subArray addObject:find4_1_9];
    [find4_1.subArray addObject:find4_1_10];
    
    /*一级分类兴趣下二极分类闲情雅致*/
    KBTwoSortModel *find4_2=[[KBTwoSortModel alloc]init];
    find4_2.name=@"闲情雅致";
    find4_2.TypeTowID=25;
    find4_2.typeOneInteger=4;
    
    KBThreeSortModel *find4_2_0=[[KBThreeSortModel alloc]init];
    find4_2_0.name=@"寰宇摄影";
    find4_2_0.TypeTowID=25;
    find4_2_0.parentFind_2Delegate=find4_2;
    find4_2_0.sortID=1;
    
    KBThreeSortModel *find4_2_1=[[KBThreeSortModel alloc]init];
    find4_2_1.name=@"旅游达人";
    find4_2_1.TypeTowID=25;
    find4_2_1.parentFind_2Delegate=find4_2;
    find4_2_1.sortID=2;
    
    KBThreeSortModel *find4_2_2=[[KBThreeSortModel alloc]init];
    find4_2_2.name=@"极致美食";
    find4_2_2.TypeTowID=25;
    find4_2_2.parentFind_2Delegate=find4_2;
    find4_2_2.sortID=3;
    
    KBThreeSortModel *find4_2_3=[[KBThreeSortModel alloc]init];
    find4_2_3.name=@"潮流穿搭";
    find4_2_3.TypeTowID=25;
    find4_2_3.parentFind_2Delegate=find4_2;
    find4_2_3.sortID=4;
    
    KBThreeSortModel *find4_2_4=[[KBThreeSortModel alloc]init];
    find4_2_4.name=@"时尚美妆";
    find4_2_4.TypeTowID=25;
    find4_2_4.parentFind_2Delegate=find4_2;
    find4_2_4.sortID=5;
    
    KBThreeSortModel *find4_2_5=[[KBThreeSortModel alloc]init];
    find4_2_5.name=@"小资生活";
    find4_2_5.TypeTowID=25;
    find4_2_5.parentFind_2Delegate=find4_2;
    find4_2_5.sortID=6;
    
    KBThreeSortModel *find4_2_6=[[KBThreeSortModel alloc]init];
    find4_2_6.name=@"品味花艺";
    find4_2_6.TypeTowID=25;
    find4_2_6.parentFind_2Delegate=find4_2;
    find4_2_6.sortID=7;
    
    KBThreeSortModel *find4_2_7=[[KBThreeSortModel alloc]init];
    find4_2_7.name=@"手工DIY";
    find4_2_7.TypeTowID=25;
    find4_2_7.parentFind_2Delegate=find4_2;
    find4_2_7.sortID=8;
    
    KBThreeSortModel *find4_2_8=[[KBThreeSortModel alloc]init];
    find4_2_8.name=@"四季养生";
    find4_2_8.TypeTowID=25;
    find4_2_8.parentFind_2Delegate=find4_2;
    find4_2_8.sortID=9;
    
    KBThreeSortModel *find4_2_9=[[KBThreeSortModel alloc]init];
    find4_2_9.name=@"跬步阅读";
    find4_2_9.TypeTowID=25;
    find4_2_9.parentFind_2Delegate=find4_2;
    find4_2_9.sortID=10;
    
    [find4_2.subArray addObject:find4_2_0];
    [find4_2.subArray addObject:find4_2_1];
    [find4_2.subArray addObject:find4_2_2];
    [find4_2.subArray addObject:find4_2_3];
    [find4_2.subArray addObject:find4_2_4];
    [find4_2.subArray addObject:find4_2_5];
    [find4_2.subArray addObject:find4_2_6];
    [find4_2.subArray addObject:find4_2_7];
    [find4_2.subArray addObject:find4_2_8];
    [find4_2.subArray addObject:find4_2_9];
    
    /*一级分类兴趣下二极分类炫彩动漫*/
    //    FindType_2 *find4_3=[[FindType_2 alloc]init];
    //    find4_3.name=@"炫彩动漫";
    //    find4_3.TypeTowID=26;
    //    find4_3.typeOneInteger=4;
    //
    //    FIndType_3 *find4_3_0=[[FIndType_3 alloc]init];
    //    find4_3_0.name=@"炫彩动漫 ";
    //    find4_3_0.TypeTowID=26;
    //    find4_3_0.parentFind_2Delegate=find4_3;
    //
    //    //    FIndType_3 *find4_3_1=[[FIndType_3 alloc]init];
    //    //    find4_3_1.name=@"最新资讯";
    //    //    find4_3_1.TypeTowID=25;
    //    //    find4_3_1.parentFind_2Delegate=find4_3;
    //    //
    //    //    FIndType_3 *find4_3_2=[[FIndType_3 alloc]init];
    //    //    find4_3_2.name=@"热力新番";
    //    //    find4_3_2.TypeTowID=25;
    //    //    find4_3_2.parentFind_2Delegate=find4_3;
    //
    //    [find4_3.subArray addObject:find4_3_0];
    //    [find4_3.subArray addObject:find4_3_1];
    //    [find4_3.subArray addObject:find4_3_2];
    
    
    /*一级分类兴趣下二极分类家有萌宠*/
    //    FindType_2 *find4_4=[[FindType_2 alloc]init];
    //    find4_4.name=@"家有萌宠";
    //    find4_4.TypeTowID=34;
    //    find4_4.typeOneInteger=4;
    //
    //    FIndType_3 *find4_4_0=[[FIndType_3 alloc]init];
    //    find4_4_0.name=@"家有萌宠 ";
    //    find4_4_0.TypeTowID=34;
    //    find4_4_0.parentFind_2Delegate=find4_4;
    //
    //    [find4_4.subArray addObject:find4_4_0];
    
    /*一级分类兴趣下二极分类游戏风云*/
    KBTwoSortModel *find4_5=[[KBTwoSortModel alloc]init];
    find4_5.name=@"游戏风云";
    find4_5.TypeTowID=26;
    find4_5.typeOneInteger=4;
    
    KBThreeSortModel *find4_5_0=[[KBThreeSortModel alloc]init];
    find4_5_0.name=@"电竞风暴";
    find4_5_0.TypeTowID=26;
    find4_5_0.parentFind_2Delegate=find4_5;
    find4_5_0.sortID=1;
    
    KBThreeSortModel *find4_5_1=[[KBThreeSortModel alloc]init];
    find4_5_1.name=@"手游精选";
    find4_5_1.TypeTowID=26;
    find4_5_1.parentFind_2Delegate=find4_5;
    find4_5_1.sortID=2;
    
    KBThreeSortModel *find4_5_2=[[KBThreeSortModel alloc]init];
    find4_5_2.name=@"网游动态";
    find4_5_2.TypeTowID=26;
    find4_5_2.parentFind_2Delegate=find4_5;
    find4_5_2.sortID=4;
    
    KBThreeSortModel *find4_5_3=[[KBThreeSortModel alloc]init];
    find4_5_3.name=@"主机游戏 ";
    find4_5_3.TypeTowID=26;
    find4_5_3.parentFind_2Delegate=find4_5;
    find4_5_3.sortID=3;
    
    [find4_5.subArray addObject:find4_5_0];
    [find4_5.subArray addObject:find4_5_1];
    [find4_5.subArray addObject:find4_5_3];
    [find4_5.subArray addObject:find4_5_2];
    
    
    
    /*一级分类兴趣下二极分类军事前沿*/
    //    FindType_2 *find4_6=[[FindType_2 alloc]init];
    //    find4_6.name=@"军事前沿";
    //    find4_6.TypeTowID=30;
    //    find4_6.typeOneInteger=4;
    //
    //    FIndType_3 *find4_6_0=[[FIndType_3 alloc]init];
    //    find4_6_0.name=@"军事前沿 ";
    //    find4_6_0.TypeTowID=30;
    //    find4_6_0.parentFind_2Delegate=find4_6;
    //
    //    [find4_6.subArray addObject:find4_6_0];
    
    /*一级分类兴趣下二极分类历史纵横*/
    //    FindType_2 *find4_7=[[FindType_2 alloc]init];
    //    find4_7.name=@"历史纵横";
    //    find4_7.TypeTowID=31;
    //    find4_7.typeOneInteger=4;
    //
    //    FIndType_3 *find4_7_0=[[FIndType_3 alloc]init];
    //    find4_7_0.name=@"历史纵横 ";
    //    find4_7_0.TypeTowID=31;
    //    find4_7_0.parentFind_2Delegate=find4_7;
    //
    //    [find4_7.subArray addObject:find4_7_0];
    
    /*一级分类兴趣下二极分类爱心公益*/
    KBTwoSortModel *find4_8=[[KBTwoSortModel alloc]init];
    find4_8.name=@"爱心公益";
    find4_8.TypeTowID=27;
    find4_8.typeOneInteger=4;
    
    KBThreeSortModel *find4_8_0=[[KBThreeSortModel alloc]init];
    find4_8_0.name=@"公益中国";
    find4_8_0.TypeTowID=27;
    find4_8_0.parentFind_2Delegate=find4_8;
    find4_8_0.sortID=1;
    
    KBThreeSortModel *find4_8_1=[[KBThreeSortModel alloc]init];
    find4_8_1.name=@"沪上公益";
    find4_8_1.TypeTowID=27;
    find4_8_1.parentFind_2Delegate=find4_8;
    find4_8_1.sortID=2;
    
    [find4_8.subArray addObject:find4_8_0];
    [find4_8.subArray addObject:find4_8_1];
    
    /*一级分类兴趣下二极分类星座&测试*/
    //    FindType_2 *find4_9=[[FindType_2 alloc]init];
    //    find4_9.name=@"星座&测试";
    //    find4_9.TypeTowID=33;
    //    find4_9.typeOneInteger=4;
    //
    //    FIndType_3 *find4_9_0=[[FIndType_3 alloc]init];
    //    find4_9_0.name=@"星座&测试 ";
    //    find4_9_0.TypeTowID=33;
    //    find4_9_0.parentFind_2Delegate=find4_9;
    //
    //    [find4_9.subArray addObject:find4_9_0];
    //
    /*一级分类兴趣下二极分类科学探秘*/
    //    FindType_2 *find4_10=[[FindType_2 alloc]init];
    //    find4_10.name=@"科学探秘";
    //    find4_10.TypeTowID=29;
    //    find4_10.typeOneInteger=4;
    //
    //    FIndType_3 *find4_10_0=[[FIndType_3 alloc]init];
    //    find4_10_0.name=@"科学探秘 ";
    //    find4_10_0.TypeTowID=29;
    //    find4_10_0.parentFind_2Delegate=find4_10;
    //
    //    [find4_10.subArray addObject:find4_10_0];
    
    /*一级分类兴趣下二极分类经典语录*/
    //    FindType_2 *find4_11=[[FindType_2 alloc]init];
    //    find4_11.name=@"经典语录";
    //    find4_11.TypeTowID=32;
    //    find4_11.typeOneInteger=4;
    //
    //    FIndType_3 *find4_11_0=[[FIndType_3 alloc]init];
    //    find4_11_0.name=@"经典语录 ";
    //    find4_11_0.TypeTowID=32;
    //    find4_11_0.parentFind_2Delegate=find4_11;
    //
    //    [find4_11.subArray addObject:find4_11_0];
    
    /*一级分类兴趣下二极分类每日爆笑*/
    //    FindType_2 *find4_12=[[FindType_2 alloc]init];
    //    find4_12.name=@"每日爆笑";
    //    find4_12.TypeTowID=35;
    //    find4_12.typeOneInteger=4;
    //
    //    FIndType_3 *find4_12_0=[[FIndType_3 alloc]init];
    //    find4_12_0.name=@"每日爆笑 ";
    //    find4_12_0.TypeTowID=35;
    //    find4_12_0.parentFind_2Delegate=find4_12;
    //
    //    [find4_12.subArray addObject:find4_12_0];
    
    /*一级分类兴趣下二极分类发现更多*/
    KBTwoSortModel *find4_14=[[KBTwoSortModel alloc]init];
    find4_14.name=@"更多兴趣";
    find4_14.TypeTowID=28;
    find4_14.typeOneInteger=4;
    
    KBThreeSortModel *find4_14_0=[[KBThreeSortModel alloc]init];
    find4_14_0.name=@"炫彩动漫";
    find4_14_0.TypeTowID=28;
    find4_14_0.parentFind_2Delegate=find4_14;
    find4_14_0.sortID=1;
    
    KBThreeSortModel *find4_14_1=[[KBThreeSortModel alloc]init];
    find4_14_1.name=@"科学探秘";
    find4_14_1.TypeTowID=28;
    find4_14_1.parentFind_2Delegate=find4_14;
    find4_14_1.sortID=2;
    
    KBThreeSortModel *find4_14_2=[[KBThreeSortModel alloc]init];
    find4_14_2.name=@"军事前沿";
    find4_14_2.TypeTowID=28;
    find4_14_2.parentFind_2Delegate=find4_14;
    find4_14_2.sortID=3;
    
    KBThreeSortModel *find4_14_3=[[KBThreeSortModel alloc]init];
    find4_14_3.name=@"历史纵横";
    find4_14_3.TypeTowID=28;
    find4_14_3.parentFind_2Delegate=find4_14;
    find4_14_3.sortID=4;
    
    KBThreeSortModel *find4_14_4=[[KBThreeSortModel alloc]init];
    find4_14_4.name=@"经典语录";
    find4_14_4.TypeTowID=28;
    find4_14_4.parentFind_2Delegate=find4_14;
    find4_14_4.sortID=5;
    
    KBThreeSortModel *find4_14_5=[[KBThreeSortModel alloc]init];
    find4_14_5.name=@"星座测试";
    find4_14_5.TypeTowID=28;
    find4_14_5.parentFind_2Delegate=find4_14;
    find4_14_5.sortID=6;
    
    KBThreeSortModel *find4_14_6=[[KBThreeSortModel alloc]init];
    find4_14_6.name=@"家有萌宠";
    find4_14_6.TypeTowID=28;
    find4_14_6.parentFind_2Delegate=find4_14;
    find4_14_6.sortID=7;
    
    KBThreeSortModel *find4_14_7=[[KBThreeSortModel alloc]init];
    find4_14_7.name=@"每日爆笑";
    find4_14_7.TypeTowID=28;
    find4_14_7.parentFind_2Delegate=find4_14;
    find4_14_7.sortID=8;
    
    
    [find4_14.subArray addObject:find4_14_0];
    [find4_14.subArray addObject:find4_14_1];
    [find4_14.subArray addObject:find4_14_2];
    [find4_14.subArray addObject:find4_14_3];
    [find4_14.subArray addObject:find4_14_4];
    [find4_14.subArray addObject:find4_14_5];
    [find4_14.subArray addObject:find4_14_6];
    [find4_14.subArray addObject:find4_14_7];
    
    
    
    [typeFiveArray addObject:find4_13];
    [typeFiveArray addObject:find4_1];
    [typeFiveArray addObject:find4_2];
    // [typeFiveArray addObject:find4_3];
    [typeFiveArray addObject:find4_5];
    [typeFiveArray addObject:find4_8];
    [typeFiveArray addObject:find4_14];
    [typeFiveArray addObject:find4_0];
    
    //    [typeFiveArray addObject:find4_10];
    //    [typeFiveArray addObject:find4_6];
    //    [typeFiveArray addObject:find4_7];
    //    [typeFiveArray addObject:find4_11];
    //    [typeFiveArray addObject:find4_9];
    //    [typeFiveArray addObject:find4_4];
    //    [typeFiveArray addObject:find4_12];
    
    
    //[allTypeArray addObject:typeOneArray];
    [_allTypeArray addObject:typeTwoArray];
    [_allTypeArray addObject:typeThreeArray];
    [_allTypeArray addObject:typeFourArray];
    [_allTypeArray addObject:typeFiveArray];
    [_allTypeArray addObject:typeOneArray];
    
    
    for (int i=0; i<4; i++) {
        NSMutableArray *typeOneArray=[_allTypeArray objectAtIndex:i];
        NSMutableArray *typeOneInterestArray=[[NSMutableArray alloc]init];
        for (int k=0; k<typeOneArray.count; k++)
        {
            KBTwoSortModel *find2;
            find2=[typeOneArray objectAtIndex:k];
            
            KBTwoSortModel *interestFind2=[[KBTwoSortModel alloc]init];
            interestFind2.name=find2.name;
            interestFind2.TypeTowID=find2.TypeTowID;
            interestFind2.typeOneInteger=find2.typeOneInteger;
            [typeOneInterestArray addObject:interestFind2];
        }
        [self.interestStructArray addObject:typeOneInterestArray];
    }
    //NSLog(@"self: %@",self.interestStructArray);
    
    return  self;
}
+(KBAllTypeInfoModel *)newinstance{
    
    if (sharedInstance==nil) {
        sharedInstance=[[KBAllTypeInfoModel alloc]init];
    }
    return sharedInstance;
}
//可能会内存泄漏
+(KBAllTypeInfoModel *)resetinstance{
    sharedInstance=nil;
    sharedInstance= [KBAllTypeInfoModel newinstance];
    return  sharedInstance;
}
-(NSMutableArray *)ReturnInterestNoStruct
{
    // if (interestNoStructArray==nil)
    {
        _interestNoStructArray=[[NSMutableArray alloc]init];
        
        if (_interestStructArray.count!=0 )
        {
            
            for (int i=0;i<4 ; i++)
            {
                NSArray *typeOneInterestArray=[_interestStructArray objectAtIndex:i];
                NSMutableArray *typeOneInterestNostructArray=[[NSMutableArray alloc]init];
                for (int j=0; j<typeOneInterestArray.count; j++)
                {
                    KBTwoSortModel *find2Interest=[typeOneInterestArray objectAtIndex:j];
                    for (int k=0; k<find2Interest.subArray.count; k++)
                    {
                        
                        [typeOneInterestNostructArray addObject:[find2Interest.subArray objectAtIndex:k]];
                        
                    }
                    
                }
                
                [_interestNoStructArray addObject:typeOneInterestNostructArray];
                
            }
        }
    }
    // NSLog(@"interestno:%@",interestNoStructArray);
    
    return _interestNoStructArray;
}

-(NSMutableArray *)useFocuArrayReturnInterestStruct:(NSArray *)focusArray{
    // NSLog(@"focusArray:%@",focusArray);
    for (int i=1; i<focusArray.count; i++)
    {
        
        NSDictionary *firstDic=[focusArray objectAtIndex:i];
        
        NSMutableArray *typeOneInterestArray=[self.interestStructArray objectAtIndex:i-1];;
        
        
        NSMutableArray *typeOneArray=[_allTypeArray objectAtIndex:i-1];
        NSArray *twoID_threeNameArray=[firstDic objectForKey:@"focus"];
        for (int k=0; k<typeOneArray.count; k++)
        {
            
            
            KBTwoSortModel *find2;
            find2=[typeOneArray objectAtIndex:k];
            
            KBTwoSortModel *interestFind2=[typeOneInterestArray objectAtIndex:k];
            
            
            for (int j=0; j<twoID_threeNameArray.count; j++)
            {
                
                
                NSDictionary *twoID_threeNameDic=[twoID_threeNameArray objectAtIndex:j];
                NSInteger secondID=[[twoID_threeNameDic objectForKey:@"secondType"] integerValue];
                if (find2.TypeTowID==secondID)
                {
                    
                    KBThreeSortModel *find3;
                    for (int l=0; l<find2.subArray.count; l++)
                    {
                        find3=[find2.subArray objectAtIndex:l];
                        if ([find3.name isEqualToString:
                             [twoID_threeNameDic objectForKey:@"thirdName"]])
                        {
                            
                            //  [find2.subArray removeObject:find3];
                            find3.isIntrest=YES;
                            
                            [interestFind2.subArray addObject:find3];
                            // find3.parentFind_2Delegate=interestFind2;
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    return _interestStructArray;
}
@end
