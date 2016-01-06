//
//  UserGuideViewController.h
//  UIScroll1
//
//  Created by kuibu technology on 15/10/7.
//  Copyright © 2015年 Test. All rights reserved.
//

//引导页


#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface KBUserGuideViewController : UIViewController<UIScrollViewDelegate,CLLocationManagerDelegate>
@property id NavigationController;
@property (strong,nonatomic) CLLocationManager * locationManager;
@end
