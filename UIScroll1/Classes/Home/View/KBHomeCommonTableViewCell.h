//
//  KBHomeCommonTableViewCell.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/10.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KBHomeArticleModel;

@interface KBHomeCommonTableViewCell : UITableViewCell

/**
 *  cell的阅读量的Label
 */
@property (nonatomic,strong) UILabel * readNumLabel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andIndexPath:(NSIndexPath *)indexPath;

- (void)setCommonCellWithModel:(KBHomeArticleModel *)model;

@end
