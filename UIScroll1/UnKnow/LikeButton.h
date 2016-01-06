//
//  LikeButton.h
//  UIScroll1
//
//  Created by kuibu technology on 15/6/23.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeButton : UIButton
@property NSIndexPath *indexPath;
@property BOOL isLiked;
@property  int Count;
-(void)setCustomTitle;
@end
