//
//  RecommendViewCell.h
//  UIScroll1
//
//  Created by 樊振 on 15/10/30.
//  Copyright © 2015年 Test. All rights reserved.
//

//首页的普通cell

#import <UIKit/UIKit.h>
#import "UIButtonWithIndexPath.h"
#import "LikeButton.h"
#import "UITopLable.h"

@interface KBHomeTableViewCell : UITableViewCell

@property  UIImageView *customImageView;
@property UITopLable *titleLable;
@property LikeButton *likeBtn;
@property  UIButtonWithIndexPath *TypeBtn;
@property UIButton *likeImageBtn;

@end
