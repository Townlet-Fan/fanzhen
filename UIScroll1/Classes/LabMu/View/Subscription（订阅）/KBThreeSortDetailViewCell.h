//
//  NewTypeThreeCollectionViewCell.h
//  UIScroll1
//
//  Created by kuibu technology on 15/10/7.
//  Copyright © 2015年 Test. All rights reserved.
//

//三级标签（三级分类界面） cell 

#import <UIKit/UIKit.h>

@class KBColumnModel;

@interface KBThreeSortDetailViewCell : UICollectionViewCell
/**
 *  三级界面的各个小图
 */
@property (nonatomic,strong ) UIImageView *imageView;

/**
 *  图下的label
 */
@property (nonatomic,strong ) UILabel *text;

//设置cell的数据
- (void)setThreeSortDetailViewCellWithModel:(KBColumnModel *)model;
@end
