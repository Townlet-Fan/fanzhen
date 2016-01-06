//
//  rootViewController.h
//  UIScroll1
//
//  Created by eddie on 15-3-20.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScroll.h"
#import "KBSubcriptionMainViewController.h"
#import "KBBaseNavigationController.h"

@interface rootViewController : UIViewController <UIScrollViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIGestureRecognizerDelegate>
{
    UIView *view1;
    UIView *view2;
    UIView *view3;
    UITapGestureRecognizer *tap;
  
    UIView *view4;
   
}
-(void)returnMain;
-(void)scrollToMenu;
//-(void)returnMainBeforePush;
//-(void)scrollToMenuAfterPop;
@property KBBaseNavigationController *nav;

@property MainScroll *scView;
@end
