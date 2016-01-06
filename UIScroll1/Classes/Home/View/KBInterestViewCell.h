//
//  KBInterestViewCell.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KBHomeArticleModel;


@protocol KBInterestViewCellDelegate <NSObject>

- (void)setCellSizeWithIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^comption)(BOOL);


@interface KBInterestViewCell : UICollectionViewCell


/**
 *  文章图片
 */
@property(nonatomic,strong) UIImageView *cellImageView;


@property(nonatomic,weak) id<KBInterestViewCellDelegate>delegate;


- (void)setInterestCellWithModel:(KBHomeArticleModel *)model andIndexPath:(NSIndexPath *)indexPath;

- (CGRect)sizeWithTitle:(NSString *)title;

@end


@interface KBInterestViewCellButton : UIButton

@end
