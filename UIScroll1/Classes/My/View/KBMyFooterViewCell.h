//
//  MyFooterTableViewCell.h
//  UIScroll1
//
//  Created by kuibu technology on 15/7/26.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//足迹的cell

#import <UIKit/UIKit.h>
#import "UITopLable.h"
@class KBMyCollectionDataModel;

@interface KBMyFooterViewCell : UITableViewCell
/**
 *  左侧图
 */
@property (nonatomic,strong) UIImageView *customImageView;
/**
 *  标题
 */
@property (nonatomic,strong) UITopLable * titleLable;
/**
 *  时间标签
 */
@property (nonatomic,strong) UILabel * timeLable;

/**
 *  三级分类的类型
 */
@property  (nonatomic,strong)UIButton *TypeBtn;


- (void)setUsualCellWithModel:(KBMyCollectionDataModel *)model;

@end
