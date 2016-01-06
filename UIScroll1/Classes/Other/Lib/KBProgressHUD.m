//
//  KBProgressHUD.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/17.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBProgressHUD.h"
#import "KBConstant.h"
@implementation KBProgressHUD

+(void)setHud:(UIView *)view withText:(NSString *)text AndWith:(float)y
{
    
    MBProgressHUD * hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText=text;
    hud.minSize=CGSizeMake(120.0f, 20.0f);
    hud.margin=10.f;
    hud.removeFromSuperViewOnHide=YES;
    hud.yOffset=y*kWindowSize.height;
    hud.mode=MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}

@end
