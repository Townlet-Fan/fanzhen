//
//  LeftTableViewCell.h
//  UIScroll1
//
//  Created by 樊振 on 15/10/11.
//  Copyright © 2015年 Test. All rights reserved.
//

//订阅 二级分类cell

#import <UIKit/UIKit.h>

@class KBTwoSortModel;

@interface KBTwoSortSubscriptionCell : UITableViewCell

- (void)setTwoSortSubscriptionCellWith:(KBTwoSortModel*)model andIndexPath:(NSIndexPath*)indexPath;

- (void)setTitleColor:(UIColor *)color;

@end
