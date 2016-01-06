//
//  NewSchoolChoose.h
//  UIScroll1
//
//  Created by kuibu technology on 15/11/21.
//  Copyright © 2015年 Test. All rights reserved.
//

//定位选择学校

#import <UIKit/UIKit.h>

#import <CoreLocation/CLLocationManagerDelegate.h>

@interface KBSchoolLocationViewController : UIViewController
/**
 *  定位
 */
@property (nonatomic,strong)CLLocationManager * locationManager;
@end
