//
//  KBSchoolLocationRefreshView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/24.
//  Copyright © 2015年 Test. All rights reserved.
//

//学校定位的刷新结果的View
#import <UIKit/UIKit.h>

@protocol KBSchoolLocationRefreshViewDelegate <NSObject>

-(void)refreshSchool;

@end

@interface KBSchoolLocationRefreshView : UIView

/**
 *  刷新显示定位的结果的Label
 */
@property (nonatomic,strong) UILabel * refreshLabel;

@property (nonatomic,weak)id<KBSchoolLocationRefreshViewDelegate>delegate;
@end
