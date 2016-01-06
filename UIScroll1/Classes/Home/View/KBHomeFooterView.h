//
//  KBHomeFooterView.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

//table的FooterView
#import "MBProgressHUD.h"

@interface KBHomeFooterView : MBProgressHUD

/**
 *  view
 */
@property (nonatomic,strong) UIView * tableFooterView;

/**
 *  加载更多的提示文字
 */
@property (nonatomic,strong) UILabel * loadMoreText;

-(instancetype)initWithFrame:(CGRect)frame withText:(NSString *)loadMoreText;
@end
