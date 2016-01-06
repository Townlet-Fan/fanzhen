//
//  KBComEditTableViewController.h
//  UIScroll1
//
//  Created by 樊振 on 15/12/27.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"
@class UMComTopic,UMComImageView;

@interface KBComEditTableViewController : UITableViewController<ELCImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  话题对象
 */
@property (nonatomic,strong) UMComTopic *topic;
/**
 *  话题名字
 */
@property (nonatomic,strong) UILabel *topicName;


-(id)initWithTopic:(UMComTopic*)topic;

@end
