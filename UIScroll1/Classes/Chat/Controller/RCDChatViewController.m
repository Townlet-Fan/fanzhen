//
//  RCDChatViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "KBPersonalDataViewController.h"
#import "KBLoginSingle.h"
#import "SJAvatarBrowser.h"
#import "RCDDiscussGroupSettingViewController.h"
#import "RCDPrivateSettingViewController.h"
@interface RCDChatViewController () 

{
    UILabel *titleLable;
}

@end

@implementation RCDChatViewController
@synthesize userid;
@synthesize backgroundImage;
- (void)viewDidLoad {
  [super viewDidLoad];
    
    self.enableSaveNewPhotoToLocalSystem = YES;
   
    if(backgroundImage!=nil)
    {
        self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
        
        //设置self.view.backgroundColor用自己的背景图片
      self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    }
   
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setImage:[UIImage imageNamed:@"删除小灰"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    if (self.conversationType != ConversationType_CHATROOM) {
        if (self.conversationType == ConversationType_DISCUSSION) {
            [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
                if (discussion != nil && discussion.memberIdList.count>0) {
                    if ([discussion.memberIdList containsObject:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
                        [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [rightBtn setImage:[UIImage imageNamed:@"删除小灰"] forState:UIControlStateNormal];
                        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
                        self.navigationItem.rightBarButtonItem = rightItem;

                    }else
                    {
                        self.navigationItem.rightBarButtonItem = nil;
                    }
                }
            } error:^(RCErrorCode status) {
                
            }];
        }
        else if(self.conversationType==ConversationType_PRIVATE)
        {
             UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//            if (self.conversationType==ConversationType_DISCUSSION) {
//                [rightBtn addTarget:self action:@selector(addMember) forControlEvents:UIControlEventTouchUpInside];
//            }
//            else
                [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [rightBtn setImage:[UIImage imageNamed:@"发现"] forState:UIControlStateNormal];
            UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
            self.navigationItem.rightBarButtonItem = rightItem;

                    }
        else
        {
            UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
            //            if (self.conversationType==ConversationType_DISCUSSION) {
            //                [rightBtn addTarget:self action:@selector(addMember) forControlEvents:UIControlEventTouchUpInside];
            //            }
            //            else
            [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [rightBtn setImage:[UIImage imageNamed:@"删除小灰"] forState:UIControlStateNormal];
            UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        
    }
    else {
        self.navigationItem.rightBarButtonItem=nil;
    }


    // self.navigationItem.rightBarButtonItem = nil;
    
    
    [self notifyUpdateUnreadMessageCount];
    
    //如果是单聊，不显示发送方昵称
    if (self.conversationType == ConversationType_PRIVATE) {
        self.displayUserNameInCell = NO;
    }
    [self.pluginBoardView removeItemAtIndex:3];

    titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    titleLable.text=self.userName;
    self.navigationItem.titleView=titleLable;

}
-(void)viewWillAppear:(BOOL)animated
{  //设置背景图
    if(backgroundImage!=nil)
    {
        self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
        
        //设置self.view.backgroundColor用自己的背景图片
        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    }

}
/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
- (void)rightBarButtonItemClicked:(id)sender {
    if (self.conversationType == ConversationType_PRIVATE) {
        
        RCDPrivateSettingViewController *settingVC =
        [[RCDPrivateSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
//            settingVC.conversationTitle = self.userName;
//            //设置讨论组标题时，改变当前聊天界面的标题
//            settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
//              self.title = discussTitle;
//            };
        //清除聊天记录之后reload data
        __weak RCDChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
        
    } else if (self.conversationType == ConversationType_DISCUSSION) {
        
        RCDDiscussGroupSettingViewController *settingVC =
        [[RCDDiscussGroupSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        settingVC.conversationTitle = self.userName;
        //设置讨论组标题时，改变当前聊天界面的标题
        settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
            self.title = discussTitle;
        };
        //清除聊天记录之后reload data
        __weak RCDChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
    //聊天室设置
//    else if (self.conversationType == ConversationType_CHATROOM) {
//        RCDRoomSettingViewController *settingVC =
//        [[RCDRoomSettingViewController alloc] init];
//        settingVC.conversationType = self.conversationType;
//        settingVC.targetId = self.targetId;
//        [self.navigationController pushViewController:settingVC animated:YES];
//    }
//    
//    //群组设置
//    else if (self.conversationType == ConversationType_GROUP) {
//        UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        RCDGroupDetailViewController *detail=[secondStroyBoard instantiateViewControllerWithIdentifier:@"RCDGroupDetailViewController"];
//        NSMutableArray *groups=RCDHTTPTOOL.allGroups ;
//        __weak RCDChatViewController *weakSelf = self;
//        detail.clearHistoryCompletion = ^(BOOL isSuccess) {
//            if (isSuccess) {
//                [weakSelf.conversationDataRepository removeAllObjects];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.conversationMessageCollectionView reloadData];
//                });
//            }
//        };
//        
//        [RCDHTTPTOOL getGroupByID:self.targetId
//                successCompletion:^(RCGroup *group)
//         {
//             detail.groupInfo=group;
//             [self.navigationController pushViewController:detail animated:YES];
//             return;
//         }];
//        //      if (groups) {
//        //          for (RCDGroupInfo *group in groups) {
//        //              if ([group.groupId isEqualToString: self.targetId]) {
//        //                  detail.groupInfo=group;
//        //                  [self.navigationController pushViewController:detail animated:YES];
//        //                  return;
//        //              }
//        //          }
//        //      }
//        
//        //没有找到群组信息，可能是获取群组信息失败，这里重新获取一些群众信息。
//        [RCDHTTPTOOL getAllGroupsWithCompletion:^(NSMutableArray *result) {
//            
//        }];
//        //      [RCDDataSource getGroupInfoWithGroupId:self.targetId completion:^(RCGroup *groupInfo) {
//        //          detail.groupInfo=[[RCDGroupInfo alloc]init];
//        //          detail.groupInfo.groupId=groupInfo.groupId;
//        //          detail.groupInfo.groupName=groupInfo.groupName;
//        //          dispatch_async(dispatch_get_main_queue(), ^{
//        //              [self.navigationController pushViewController:detail animated:NO];
//        //          });
//        //
//        //      }];
//        
//        
//    }
//    //客服设置
//    else if (self.conversationType == ConversationType_CUSTOMERSERVICE) {
//        RCDSettingBaseViewController *settingVC = [[RCDSettingBaseViewController alloc] init];
//        settingVC.conversationType = self.conversationType;
//        settingVC.targetId = self.targetId;
//        //清除聊天记录之后reload data
//        __weak RCDChatViewController *weakSelf = self;
//        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
//            if (isSuccess) {
//                [weakSelf.conversationDataRepository removeAllObjects];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.conversationMessageCollectionView reloadData];
//                });
//            }
//        };
//        [self.navigationController pushViewController:settingVC animated:YES];
//    }
    
}

//邀请加入讨论组
-(void)addMember
{
    NSArray * addMemberIdArray=[[NSArray alloc]initWithObjects:@"26", nil];
    [[RCIMClient sharedRCIMClient]addMemberToDiscussion:self.targetId userIdList:addMemberIdArray success:^(RCDiscussion *discussion) {
        NSLog(@"create addMemberTodiscussion ssucceed!");
    } error:^(RCErrorCode status) {
        NSLog(@"create addMemberTodiscussion Failed &gt; %ld!", (long)status);
    }];
}
//选择背景图
-(void)selectBackImage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [picker.navigationBar setBarTintColor:[UIColor colorWithRed:15/255.0 green:86/255.0 blue:208/255.0 alpha:1.0]];
    //    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
        
    }];
    
    
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //状态栏的颜色改变
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //导航栏左右按钮变白
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //导航栏标题变白
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"info:%@",info);
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        backgroundImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //UIImage *img= [self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];
        self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
        
        //设置self.view.backgroundColor用自己的背景图片
        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
//-(UIImage *) scaleFromImage: (UIImage *) image1 toSize: (CGSize) size
//{
//    UIGraphicsBeginImageContext(size);
//    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)leftBarButtonItemPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
  RCImagePreviewController *_imagePreviewVC =
      [[RCImagePreviewController alloc] init];
  _imagePreviewVC.messageModel = model;
  _imagePreviewVC.title = @"图片预览";

  UINavigationController *nav = [[UINavigationController alloc]
      initWithRootViewController:_imagePreviewVC];

  [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}


/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
  __weak typeof(&*self) __weakself = self;
  int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    @(ConversationType_PRIVATE),
    @(ConversationType_DISCUSSION),
    @(ConversationType_APPSERVICE),
    @(ConversationType_PUBLICSERVICE),
    @(ConversationType_GROUP)
  ]];
  dispatch_async(dispatch_get_main_queue(), ^{
      NSString *backString = nil;
    if (count > 0 && count < 1000) {
      backString = [NSString stringWithFormat:@" 会话(%d)", count];
    } else if (count >= 1000) {
      backString = @" 会话(...)";
    } else {
      backString = @" 会话";
    }
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 6, 87, 23);
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 6, 87, 23)];
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回"]];
    backImg.frame = CGRectMake(0, 2, 11, 19);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 85, 22)];
    backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
//   backText.font = [UIFont systemFontOfSize:17];
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[UIColor whiteColor]];
    [backBtn addSubview:backText];
    [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [__weakself.navigationItem setLeftBarButtonItem:leftButton];
  });
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}


- (void)didTapCellPortrait:(NSString *)userId{
    //单聊
    if(self.conversationType==ConversationType_PRIVATE)
    {
        if ([userId isEqualToString:[NSString stringWithFormat:@"%ld",(long)[KBLoginSingle newinstance].userID]])
        {
            KBPersonalDataViewController * personalDataVC=[[KBPersonalDataViewController alloc]init];
            [self.navigationController pushViewController:personalDataVC animated:YES];
        }
    }
    
}
/* 头像放大
- (void)magnifyImage
{
    NSLog(@"局部放大");
    [SJAvatarBrowser showImage:headImageView];//调用方法
}
 */


#pragma mark override
/**
 *  重写方法实现自定义消息的显示的高度
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

/**
 *  重写方法实现未注册的消息的显示
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  需要设置RCIM showUnkownMessage属性
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcUnkownConversationCollectionView:(UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    NSLog(@"message objectName = %@", model.objectName);
    RCMessageCell *cell = [collectionView
                             dequeueReusableCellWithReuseIdentifier:RCUnknownMessageTypeIdentifier
                             forIndexPath:indexPath];
    [cell setDataModel:model];
    return cell;
}
@end
