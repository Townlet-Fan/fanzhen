//
//  KBPlanViewCell.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/28.
//  Copyright © 2015年 Test. All rights reserved.
//

//主界面的规划的cell
#import <UIKit/UIKit.h>

@class KBColumnModel;

@interface KBPlanViewCell : UITableViewCell

/**
 *  cell的图片
 */
@property (nonatomic,strong)UIImageView * artImageView;

/**
 *  cell的阅读量的Label
 */
@property (nonatomic,strong) UILabel * readNumLabel;

//设置cell模型的数据
- (void)setPlanCellWithModel:(KBColumnModel *)model;
@end
