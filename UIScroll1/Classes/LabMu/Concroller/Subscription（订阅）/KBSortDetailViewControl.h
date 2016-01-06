//
//  NewTypeThreeViewControl.h
//  UIScroll1
//
//  Created by kuibu technology on 15/9/23.
//  Copyright © 2015年 Test. All rights reserved.
//

//每个标签对应的具体内容 (三级分类)

#import <UIKit/UIKit.h>

@interface KBSortDetailViewControl : UIViewController
/**
 *  collectionView
 */
@property (nonatomic,strong) UICollectionView * collectionView;

/**
 *  三级分类的代理
 */
@property (nonatomic,strong) id threeDelegate;
/**
 *  二级分类的Id
 */
@property (nonatomic,assign) NSInteger secondTypeID;
/**
 *  三级分类的昵称
 */
@property (nonatomic,strong) NSString *thirdTypeName;

@end
