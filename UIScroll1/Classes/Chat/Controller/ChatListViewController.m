//
//  ChatListViewController.m
//  RongCloudDemo
//
//  Created by 杜立召 on 15/4/18.
//  Copyright (c) 2015年 dlz. All rights reserved.
//

#import "ChatListViewController.h"
#import "KxMenu.h"
#import "RCDChatViewController.h"
#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDUserInfo.h"
#import "rootViewController.h"
#import "RCDChatViewController.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "AppDelegate.h"
#import "RCDSearchFriendViewController.h"
#import "RCDChatListCell.h"
#import "RCDHttpTool.h"
@interface ChatListViewController ()

{
    KBLoginSingle * loginsingle;
    KBCommonSingleValueModel * transport;
    AppDelegate * appdelegate;
    NSString * userPhotoURL;
    NSString * userName;
    UIView *refreshView;
    UILabel *refreshLable;
    UIActivityIndicatorView *indicatorView;
    UIImageView *refreshArrowView;
    NSTimer  *timer1;
    BOOL isrefresh;
    
    UILabel *titleLable;

}
@end

@implementation ChatListViewController
@synthesize rootDelegate;
float DEVICE_WIDTH,DEVICE_HEIGHT;
-(void)viewDidLoad
{
    [super viewDidLoad];
    DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
    DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
    loginsingle=[KBLoginSingle newinstance];
    transport=[KBCommonSingleValueModel newinstance];
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
    //聚合会话类型
    [self setCollectionConversationType:@[@(ConversationType_GROUP)]];
    
    titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    if([[RCIMClient sharedRCIMClient] getTotalUnreadCount]==0)
         titleLable.text=@"我的会话";
    else
        titleLable.text=[NSString stringWithFormat:@"我的会话(%d)",[[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
    titleLable.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    self.navigationItem.titleView = titleLable;
    
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;

    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setImage:[UIImage imageNamed:@"发现"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.conversationListTableView.tableFooterView = [UIView new];
    [self notifyUpdateUnreadMessageCount];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receiveNeedRefreshNotification:)
                                                name:@"kRCNeedReloadDiscussionListNotification"
                                              object:nil];
}
#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        if (message.conversationType != ConversationType_SYSTEM) {
            NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId .length ==0) {
            return;
        }
        //该接口需要替换为从消息体获取好友请求的用户信息
        [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                              completion:^(RCUserInfo *user) {
                                  RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                                  rcduserinfo_.name = user.name;
                                  rcduserinfo_.userId = user.userId;
                                  rcduserinfo_.portraitUri = user.portraitUri;
                                  
                                  RCConversationModel *customModel = [RCConversationModel new];
                                  customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
                                  customModel.extend = rcduserinfo_;
                                  customModel.senderUserId = message.senderUserId;
                                  customModel.lastestMessage = _contactNotificationMsg;
                                  //[_myDataSource insertObject:customModel atIndex:0];
                                  
                                  //local cache for userInfo
                                  NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
                                                                @"portraitUri":rcduserinfo_.portraitUri
                                                                };
                                  [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      //调用父类刷新未读消息数
                                      [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
                                      //[super didReceiveMessageNotification:notification];
                                      //              [blockSelf_ resetConversationListBackgroundViewIfNeeded];
                                      [self notifyUpdateUnreadMessageCount];
                                      
                                      //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                                      //原因请查看super didReceiveMessageNotification的注释。
                                      NSNumber *left = [notification.userInfo objectForKey:@"left"];
                                      if (0 == left.integerValue) {
                                          [super refreshConversationTableViewIfNeeded];
                                      }
                                  });
                              }];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            //            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            //            [self notifyUpdateUnreadMessageCount]; super会调用notifyUpdateUnreadMessageCount
        });
    }
        if([[RCIMClient sharedRCIMClient] getTotalUnreadCount]==0)
            titleLable.text=@"我的会话";
        else
            titleLable.text=[NSString stringWithFormat:@"我的会话(%d)",[[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
}
- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__blockSelf.displayConversationTypeArray.count == 1 && [self.displayConversationTypeArray[0] integerValue]== ConversationType_DISCUSSION) {
            [__blockSelf refreshConversationTableViewIfNeeded];
        }
        
    });
}

-(void)didTapCellPortrait:(RCConversationModel *)model
{
    
}
//会话有新消息通知的时候显示数字提醒，设置为NO,不显示数字只显示红点
//-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    RCConversationModel *model= self.conversationListDataSource[indexPath.row];
//    
//    if (model.conversationType == ConversationType_PRIVATE) {
//        ((RCConversationCell *)cell).isShowNotificationNumber = NO;
//    }
//    
//}

//刷新通知
//- (void)receiveNeedRefreshNotification:(NSNotification *)status {
//    __weak typeof(&*self) __blockSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (__blockSelf.displayConversationTypeArray.count == 1 && [self.displayConversationTypeArray[0] integerValue]== ConversationType_DISCUSSION) {
//            [__blockSelf refreshConversationTableViewIfNeeded];
//        }
//        
//    });
//    //处理好友请求
//    RCMessage *message =status.object;
//    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
//        
//        if (message.conversationType == ConversationType_SYSTEM) {
//            NSLog(@"系统消息！！！");
//        }
//    }
//}
//*********************插入自定义Cell*********************//

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[RCConversationCell class]]) {
        RCConversationCell *conversationCell = (RCConversationCell *) cell;
        //会话头像背景图
       // conversationCell.headerImageViewBackgroundView
        [conversationCell setFrame:CGRectMake( 0, 0, DEVICE_WIDTH,100)];
        conversationCell.conversationTitle.textColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    }
}
- (NSArray *)getConversationList:(NSArray *)conversationTypeList
{
    return conversationTypeList;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int topCount=0;//置顶会话的个数
    //循环数据库获取置顶会话的个数
    for (int i=0; i<self.conversationListDataSource.count;i++) {
        RCConversationModel * topModel = self.conversationListDataSource[i];
        if (topModel.isTop) {
            topCount++;
        }
    }
    //NSLog(@"topcount:%d",topCount);
    //判断是否置顶
    RCConversationModel *topModel = self.conversationListDataSource[indexPath.row];
    NSString * isTopStr;
    if(topModel.isTop)
    {
        isTopStr=@"取消置顶";
    }
    else
        isTopStr=@"置顶";
    //NSLog(@"model.isTop:%d",topModel.isTop);
    UITableViewRowAction *toTopAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:isTopStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        // 实现相关的逻辑代码
        if (model.isTop) {
            //NSLog(@"nonooononttontotontnotontppppp");
            [[RCIMClient sharedRCIMClient]setConversationToTop:model.conversationType targetId:model.targetId isTop:NO];
            NSIndexPath *CancelTopIndexPath = [NSIndexPath indexPathForRow:topCount-1 inSection:indexPath.section];
            
            [self.conversationListTableView  moveRowAtIndexPath:indexPath toIndexPath:CancelTopIndexPath];
        }
        else
        {
            //NSLog(@"totptotptoptpotpottop");
            [[RCIMClient sharedRCIMClient]setConversationToTop:model.conversationType targetId:model.targetId isTop:YES];
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.conversationListTableView  moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        }
        
        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
       
        tableView.editing = NO;
       [self refreshConversationTableViewIfNeeded];
//
    }];
        
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 首先改变model
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
        [[RCIMClient sharedRCIMClient]clearMessages:model.conversationType targetId:model.targetId];
        [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
        //删除历史记录
        [[RCIMClient sharedRCIMClient]clearMessages:model.conversationType targetId:model.targetId];
//        NSString * deletedStr=[NSString stringWithFormat:@"%@",model.targetId];
//        NSMutableArray * deletedArray=[[NSMutableArray alloc]initWithObjects:deletedStr, nil];
//        [[RCIMClient sharedRCIMClient]deleteMessages:deletedArray];
       
        // 接着刷新view
        [self.conversationListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 不需要主动退出编辑模式，上面更新view的操作完成后就会自动退出编辑模式
    }];
    
    return @[deleteAction, toTopAction];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


//左滑删除
//-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //可以从数据库删除数据
//    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
//    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
//    [self.conversationListTableView reloadData];
//}
//
//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}
//自定义cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *username    = nil;
    __block NSString *portraitUri = nil;
    
    __weak ChatListViewController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
        {
            RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
            if (_contactNotificationMsg.sourceUserId == nil) {
                RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                cell.lblDetail.text = [NSString stringWithFormat:@"%@ 请求加为好友",username];
                [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"未登录"]];
                return cell;
                
            }
            NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
            if (_cache_userinfo) {
                username = _cache_userinfo[@"username"];
                portraitUri = _cache_userinfo[@"portraitUri"];
            } else {
                NSDictionary *emptyDic = @{};
                [[NSUserDefaults standardUserDefaults]setObject:emptyDic forKey:_contactNotificationMsg.sourceUserId];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                                      completion:^(RCUserInfo *user) {
                                          if (user == nil) {
                                              return;
                                          }
                                          RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                                          rcduserinfo_.name = user.name;
                                          rcduserinfo_.userId = user.userId;
                                          rcduserinfo_.portraitUri = user.portraitUri;
                                          
                                          model.extend = rcduserinfo_;
                                          
                                          //local cache for userInfo
                                          NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
                                                                        @"portraitUri":rcduserinfo_.portraitUri
                                                                        };
                                          [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
                                          [[NSUserDefaults standardUserDefaults]synchronize];
                                          
                                          [weakSelf.conversationListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                      }];
            }
        }
        
    }
    else{
        RCDUserInfo *user = (RCDUserInfo *)model.extend;
        username    = user.name;
        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.lblDetail.text =[NSString stringWithFormat:@"%@ 请求加为好友",username];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"未登录"]];
    cell.labelTime.text = [self ConvertMessageTime:model.sentTime / 1000];
    return cell;
}


#pragma mark - private
- (NSString *)ConvertMessageTime:(long long)secs {
    NSString *timeText = nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];
    
    //    DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);
        //[formatter setDateFormat:@"HH:mm"];
    }
    
    if (nil != _yesterday) {
        timeText = _yesterday; //[_yesterday stringByAppendingFormat:@" %@", timeText];
    } else {
        timeText = [formatter stringFromDate:messageDate];
    }
    
    return timeText;
}


/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        if (model.conversationType == ConversationType_SYSTEM) {
            _conversationVC.userName = @"系统消息";
            _conversationVC.title = @"系统消息";
        }
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }

    else
    {
    RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    }
    
    
}


/**
 *  退出登录
 *
 *  @param sender <#sender description#>
 */
- (void)backToMenu {
    rootViewController *root1=self.rootDelegate;
    [root1 scrollToMenu];
//     [[RCIM sharedRCIM]disconnect];
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 *  重载右边导航按钮的事件
 *
 *  @param sender <#sender description#>
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = @"84"; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
    conversationVC.userName = @"我的";
    conversationVC.title = @"单聊";
    [self.navigationController pushViewController:conversationVC animated:YES];

}
/**
  *  弹出层
  *
  *  @param sender sender description
  */
- (void)showMenu:(UIButton *)sender {
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"发起聊天"
                     image:[UIImage imageNamed:@"chat_icon"]
                    target:self
                    action:@selector(pushChat)],
      
      [KxMenuItem menuItem:@"讨论组"
                     image:[UIImage imageNamed:@"addfriend_icon"]
                    target:self
                    action:@selector(pushDiscuss)],
      
      [KxMenuItem menuItem:@"添加好友"
                     image:[UIImage imageNamed:@"contact_icon"]
                    target:self
                    action:@selector(pushAddFriend)],
      
      [KxMenuItem menuItem:@"公众账号"
                     image:[UIImage imageNamed:@"public_account"]
                    target:self
                    action:@selector(pushPublicService)],
      
      [KxMenuItem menuItem:@"添加公众号"
                     image:[UIImage imageNamed:@"add_public_account"]
                    target:self
                    action:@selector(pushAddPublicService)],
      ];

   
    CGRect targetFrame = self.navigationItem.rightBarButtonItem.customView.frame;
    [KxMenu setTintColor:[UIColor colorWithRed:49/255.0 green:110/255.0 blue:214/255.0 alpha:1.0]]
    ;
    targetFrame.origin.y = targetFrame.origin.y + 15;
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
}
/**
 *  发起聊天
 *
 *  @param sender sender description
 */

-(void)pushChat
{
    RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = @"84"; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
    conversationVC.userName = @"我的";
    conversationVC.title = @"单聊";
    [self.navigationController pushViewController:conversationVC animated:YES];
}
-(void)pushDiscuss
{
        NSArray * chosedIdArray=[[NSArray alloc]initWithObjects:@"85",@"84",@"216",nil];
        [[RCIMClient sharedRCIMClient] createDiscussion:@"臭嗨群" userIdList:chosedIdArray success:^(RCDiscussion *discussion) {
            NSLog(@"create discussion ssucceed!");
            dispatch_async(dispatch_get_main_queue(), ^{
                RCDChatViewController  *chat =[[RCDChatViewController alloc]init];
                chat.targetId = discussion.discussionId;
                chat.userName = discussion.discussionName;
                chat.conversationType = ConversationType_DISCUSSION;
                chat.title =@"讨论组";
                
                
                // UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                // [weakSelf.navigationController popViewControllerAnimated:NO];
                [self.navigationController pushViewController:chat animated:YES];
            });
        } error:^(RCErrorCode status) {
            NSLog(@"create discussion Failed &gt; %ld!", (long)status);
        }];
}
-(void)pushAddFriend
{
    RCDSearchFriendViewController *searchFirendVC = [[RCDSearchFriendViewController alloc]init];
    [self.navigationController pushViewController:searchFirendVC  animated:YES];
}
-(void)pushPublicService
{
}
-(void)pushAddPublicService
{
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    
//}
-(void)viewDidDisappear:(BOOL)animated
{
//    self.conversationListTableView.scrollsToTop=NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];

 //   [[RCIM sharedRCIM]disconnect];

}




@end
