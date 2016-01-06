//
//  KBProgressHUD.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/17.
//  Copyright © 2015年 Test. All rights reserved.
//

//继承自MBProgreessHUD
#import "MBProgressHUD.h"

@interface KBProgressHUD : MBProgressHUD

/**
 *  设置重定义的hud
 *
 *  @param view 当前的view
 *  @param text 要显示的文字
 *  @param y    离中心点y的距离
 */
+(void)setHud:(UIView *)view withText:(NSString *)text AndWith:(float)y;
@end
