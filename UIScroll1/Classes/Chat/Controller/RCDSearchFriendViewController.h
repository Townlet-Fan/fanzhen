//
//  RCDSearchFriendTableViewController.h
//  RCloudMessage
//
//  Created by Liv on 15/3/12.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDSearchFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *AllUserInfoArray;//所有用户的个人信息的数组
@property (strong,nonatomic)NSMutableArray * AllUserInfo_Name;//所有用户名字的数字
@end
