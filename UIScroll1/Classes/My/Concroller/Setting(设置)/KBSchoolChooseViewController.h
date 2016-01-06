//
//  SchoolChoose.h
//  UIScroll1
//
//  Created by kuibu technology on 15/7/24.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//学校选择 （plist）

#import <UIKit/UIKit.h>

@protocol SecondViewControllerDelegate;

@interface KBSchoolChooseViewController : UIViewController
/**
 * 学校的搜索
 */
@property (nonatomic, strong)  UISearchBar *search;
/**
 *  读取plist学校的字典
 */
@property (nonatomic, strong) NSDictionary * schoolsdic;
/**
 *  学校的数组
 */
@property (nonatomic, strong) NSMutableArray * schoolsArray;

/**
 *  所有学校的字典
 */
@property (nonatomic, strong) NSMutableDictionary * allSchools;

- (void)resetSearch;//加载并填充words可变字典和keys数组
- (void)handleSearchForTerm:(NSString *)searchTerm;//实现搜索方法
@end

