//
//  KBSubjectViewCell.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/29.
//  Copyright © 2015年 Test. All rights reserved.
//

//主界面的学科和规划的cell

#import <UIKit/UIKit.h>
#import "UIButtonWithIndexPath.h"

@class KBColumnModel;

@protocol KBSubjectViewCellDelegate <NSObject>

//置顶功能
-(void)touchToTopButton:(NSIndexPath *)indexPath;

//取消置顶
-(void)touchCancelToTopButton:(NSIndexPath *)indexPath;

//view的点击 代理  传模型出去
- (void)viewTapActionWithColumnModel:(KBColumnModel *)columnModel;


@end

@interface KBSubjectViewCell : UITableViewCell

/**
 *  第一个图片的阅读量的Label
 */
@property (nonatomic,strong) UILabel * readNumFirstLabel;

/**
 *  第二个图片的阅读量的Label
 */
@property (nonatomic,strong) UILabel * readNumSecondLabel;
/**
 *  第三个图片的阅读量的Label
 */
@property (nonatomic,strong) UILabel * readNumThirdLabel;

/**
 *  置顶功能的button
 */
@property(nonatomic,strong) UIButtonWithIndexPath * TopButtonWithIndexpath;



/**
 *  cell里容纳各个空间的View
 */
@property (nonatomic,strong) UIView *colorView;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  withIndexpathArray:(NSArray * )indexpathArray;
//设置cell模型的数据
- (void)setSubjectCellWithModel:(NSMutableArray *)indexpathArray withIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,weak)id <KBSubjectViewCellDelegate>delegate;
//(KBColumnModel *)model;
@end
