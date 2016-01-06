//
//  usualViewCell.h
//  UIScroll1
//
//  Created by eddie on 15-3-29.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//栏目中的普通Cell

#import <UIKit/UIKit.h>

@class  KBColumnModel;

@protocol ColumnUsualCellDelegate <NSObject>

-(void)pushTypeThreeDelegate:(KBColumnModel *)typeButtonColumnModel;

@end

@interface KBColumnUsualViewCell : UITableViewCell

/**
 *  cell的图片
 */
@property (nonatomic,strong)UIImageView * artImageView;

/**
 *  cell的阅读量的Label
 */
@property (nonatomic,strong) UILabel * readNumLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setUsualCellWithModel:(KBColumnModel *)model withIndex:(NSIndexPath *)indexPath withArray:(NSArray * )columnTypeArray;

@property (weak,nonatomic) id<ColumnUsualCellDelegate>delegate;
@end
