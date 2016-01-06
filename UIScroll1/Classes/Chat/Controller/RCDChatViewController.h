//
//  RCDChatViewController.h
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCDChatViewController : RCConversationViewController<UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, UIAlertViewDelegate, RCMessageCellDelegate>

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;
@property  NSString * userid;
@property UIImage * backgroundImage;
@end
