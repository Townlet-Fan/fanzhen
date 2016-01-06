//
//  MenuTableViewCell.h
//  UIScroll1
//
//  Created by kuibu technology on 15/11/20.
//  Copyright © 2015年 Test. All rights reserved.
//

//我的里面 cell

#import <UIKit/UIKit.h>

@interface KBMyTableViewCell : UITableViewCell
/**
 *  Menu下面的tableView的左边的Icon
 */
@property (nonatomic,strong ) UIImageView * leftIconImage;
/**
 *  Menu下面的tableView的左边的文字
 */
@property (nonatomic,strong ) UILabel * leftLabel;

@end
