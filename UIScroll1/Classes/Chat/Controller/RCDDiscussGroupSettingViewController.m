//
//  RCDiscussGroupSettingViewController.m
//  RongIMToolkit
//
//  Created by Liv on 15/3/30.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDDiscussGroupSettingViewController.h"
#import "RCDUpdateNameViewController.h"
#import "RCDDiscussSettingCell.h"
#import "RCDDiscussSettingSwitchCell.h"
#import "RCDSelectPersonViewController.h"
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDPersonDetailViewController.h"
#import "RCDataBaseManager.h"
#import "RCDAddFriendViewController.h"
#import "RCDSelectPersonViewController.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "KBConstant.h"
#import "KBHTTPTool.h"
@interface RCDDiscussGroupSettingViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) NSString* discussTitle;

@property (nonatomic, strong) NSMutableDictionary* members;

@property (nonatomic)BOOL isOwner;
@property (nonatomic,assign) BOOL isClick;
@property (nonatomic,strong)AppDelegate * appdelegate;
@property (nonatomic,strong)KBCommonSingleValueModel * transport;
@end

@implementation RCDDiscussGroupSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appdelegate=[UIApplication sharedApplication].delegate;
    _transport=[KBCommonSingleValueModel newinstance];
    //显示顶部视图
    self.headerHidden = NO;
    _members = [[NSMutableDictionary alloc]init];
    
    //添加当前聊天用户
    if (self.conversationType == ConversationType_PRIVATE) {

        {
            [KBHTTPTool getRequestWithUrlStr:KRongYunGetUserInfoUrl(kBaseUrl,self.targetId) parameters:nil completionHandr:^(id responseObject) {
                NSString *  code=[responseObject objectForKey:@"code"];
                RCUserInfo * user;
                int codeInt=[code intValue];
                if (codeInt==1) {
                    user = [[RCUserInfo alloc]initWithUserId:self.targetId name:[responseObject objectForKey:@"userName"] portrait:[responseObject objectForKey:@"userPhoto"]];
                    
                }
                else
                {
                    user = [[RCUserInfo alloc]initWithUserId:self.targetId name:[responseObject  objectForKey:@"userName"] portrait:[responseObject objectForKey:@"userPhoto"]];
                    
                    
                }
                [self addUsers:@[user]];
                [_members setObject:user forKey:user.userId];
                
            } error:^(NSError *error) {
                ;
            }];

        }
    }

    //添加讨论组成员
    if (self.conversationType == ConversationType_DISCUSSION) {

        __weak RCDSettingBaseViewController* weakSelf = self;
        [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion* discussion) {
            if (discussion) {
                
                if([[RCIMClient sharedRCIMClient].currentUserInfo.userId isEqualToString:discussion.creatorId])
                {
                    [weakSelf disableDeleteMemberEvent:NO];
                    self.isOwner = YES;
                    
                }else{
                    [weakSelf disableDeleteMemberEvent:YES];
                    self.isOwner = NO;
                    if (discussion.inviteStatus == 1) {
                        [self disableInviteMemberEvent:YES];
                    }
                }
                
                NSMutableArray *users = [NSMutableArray new];
                
                for (NSString *targetId in discussion.memberIdList) {
                    [KBHTTPTool getRequestWithUrlStr:KRongYunGetUserInfoUrl(kBaseUrl,self.targetId) parameters:nil completionHandr:^(id responseObject) {
                        NSString *  code=[responseObject objectForKey:@"code"];
                        RCUserInfo * user;
                        int codeInt=[code intValue];
                        if (codeInt==1) {
                            user = [[RCUserInfo alloc]initWithUserId:targetId name:[responseObject objectForKey:@"userName"] portrait:[responseObject objectForKey:@"userPhoto"]];
                            
                        }
                        else
                        {
                            user = [[RCUserInfo alloc]initWithUserId:targetId name:[responseObject objectForKey:@"userName"] portrait:[responseObject objectForKey:@"userPhoto"]];
                            
                            
                        }
                        [users addObject:user];
                        [_members setObject:user forKey:targetId];
                        [weakSelf addUsers:users];
                        
                    } error:^(NSError *error) {
                        ;
                    }];

                }
            }
        }
        error:^(RCErrorCode status){
            //
        }];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    
    //UIImage *image =[UIImage imageNamed:@"zhuozi"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 42, 90/2)];
    
    [button setBackgroundColor:[UIColor colorWithRed:236/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]];
    [button setTitle:@"删除并退出" forState:UIControlStateNormal];
    [button setCenter:CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.tableView.tableFooterView = view;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isClick = YES;
}

-(void)buttonAction:(UIButton*)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"删除并且退出讨论组" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark-UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:self.clearMsgHistoryActionSheet]) {
        [self clearHistoryMessage];
    }else{
        if (0 == buttonIndex) {
            __weak typeof(&*self)  weakSelf = self;
            [[RCIMClient sharedRCIMClient] quitDiscussion:self.targetId success:^(RCDiscussion *discussion) {
            NSLog(@"退出讨论组成功");
            UIViewController *temp = nil;
            NSArray *viewControllers = weakSelf.navigationController.viewControllers;
            temp = viewControllers[viewControllers.count -1 -2];
            if (temp) {
                //切换主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToViewController:temp animated:YES];
                });
                }
            } error:^(RCErrorCode status) {
                    NSLog(@"quit discussion status is %ld",(long)status);
                    
            }];
            
        }
    }
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOwner)
    {
        return self.defaultCells.count + 2;
    } else
    {
        return self.defaultCells.count + 1;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = nil;
    int offset = 2;
    if (!self.isOwner) {
        offset = 1;
    }
    switch (indexPath.row) {
        case 0:
        {
            RCDDiscussSettingCell *discussCell = [[RCDDiscussSettingCell alloc] initWithFrame:CGRectZero];
            discussCell.lblDiscussName.text = self.conversationTitle;
            discussCell.lblTitle.text = @"讨论组名称";
            cell = discussCell;
            _discussTitle = discussCell.lblDiscussName.text;
        }
            break;
//        case 1:
//        {
//            RCDDiscussSettingCell * backgroundImageCell = [[RCDDiscussSettingCell alloc] initWithFrame:CGRectZero];
//            backgroundImageCell.lblTitle.text = @"讨论组名称";
//
//        }
        case 1:
        {
            if (self.isOwner) {
                RCDDiscussSettingSwitchCell *switchCell = [[RCDDiscussSettingSwitchCell alloc] initWithFrame:CGRectZero];
                switchCell.label.text = @"开放成员邀请";
                [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
                    if (discussion.inviteStatus == 0) {
                        switchCell.swich.on = YES;
                    }
                } error:^(RCErrorCode status){
                    
                }];
                [switchCell.swich addTarget:self action:@selector(openMemberInv:) forControlEvents:UIControlEventTouchUpInside];
                cell = switchCell;
            } else {
                cell = self.defaultCells[0];
            }


    } break;
    case 2: {
        cell = self.defaultCells[indexPath.row - offset];
    } break;
    case 3: {
        cell = self.defaultCells[indexPath.row - offset];

    } break;
    case 4: {
        cell = self.defaultCells[indexPath.row - offset];

    } break;
//        case 5:{
//            cell=[[UITableViewCell alloc] initWithFrame:CGRectZero];
//            cell.textLabel.text=@"背景图片";
//        }
            
    }
 

    return cell;
}

#pragma mark - RCConversationSettingTableViewHeader Delegate
//点击最后一个+号事件
- (void)settingTableViewHeader:(RCConversationSettingTableViewHeader*)settingTableViewHeader indexPathOfSelectedItem:(NSIndexPath*)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray*)users
{
    //点击最后一个+号,调出选择联系人UI
    if (indexPathOfSelectedItem.row == settingTableViewHeader.users.count) {

//        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        RCDSelectPersonViewController* selectPersonVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSelectPersonViewController"];
        RCDSelectPersonViewController * selectPersonVC=[[RCDSelectPersonViewController alloc]init];
        [selectPersonVC setSeletedUsers:users];
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count) {
                NSMutableArray *newUsers = [[NSMutableArray alloc]init];
                for (int i=0;i<selectedUsers.count; i++) {
                    RCUserInfo *user = (RCUserInfo *)selectedUsers[i];
                    if (![_members.allKeys containsObject:user.userId]) {
                        [_members setObject:user forKey:user.userId];
                        [newUsers addObject:user];
                    }
                }
                [self addUsers:_members.allValues];
                [self createDiscussionOrInvokeMemberWithSelectedUsers:selectedUsers];

            }
            
            [selectPersonViewController.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
}

#pragma mark - private method
- (void)createDiscussionOrInvokeMemberWithSelectedUsers:(NSArray*)selectedUsers
{
    //    __weak RCDSettingViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ConversationType_DISCUSSION == self.conversationType) {
            //invoke new member to current discussion
            
            NSMutableArray *addIdList = [NSMutableArray new];
            for (RCUserInfo *user in selectedUsers) {
                [addIdList addObject:user.userId];
            }
            
            //加入讨论组
            if(addIdList.count != 0){
                
                [[RCIMClient sharedRCIMClient] addMemberToDiscussion:self.targetId userIdList:addIdList success:^(RCDiscussion *discussion) {
                    NSLog(@"成功");
                } error:^(RCErrorCode status) {
                }];
            }
            
        }else if (ConversationType_PRIVATE == self.conversationType)
        {
            //create new discussion with the new invoked member.
            NSUInteger _count = [selectedUsers count];
            if (_count > 1) {
                
                NSMutableString *discussionTitle = [NSMutableString string];
                NSMutableArray *userIdList = [NSMutableArray new];
                for (int i=0; i<_count; i++) {
                    RCUserInfo *_userInfo = (RCUserInfo *)selectedUsers[i];
                    [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", _userInfo.name,@","]];

                    [userIdList addObject:_userInfo.userId];
                }
                [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
                self.conversationTitle = discussionTitle;
                
                __weak typeof(&*self)  weakSelf = self;
                [[RCIMClient sharedRCIMClient] createDiscussion:discussionTitle userIdList:userIdList success:^(RCDiscussion *discussion) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        RCDChatViewController *chat =[[RCDChatViewController alloc]init];
                        chat.targetId                      = discussion.discussionId;
                        chat.userName                    = discussion.discussionName;
                        chat.conversationType              = ConversationType_DISCUSSION;
                        chat.title                         = discussionTitle;//[NSString stringWithFormat:@"讨论组(%lu)", (unsigned long)_count];
                        
                        UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                        [weakSelf.navigationController popToViewController:tabbarVC animated:NO];
                        [tabbarVC.navigationController  pushViewController:chat animated:YES];
                    });
                } error:^(RCErrorCode status) {
                    //            DebugLog(@"create discussion Failed > %ld!", (long)status);
                }];
            }
            
        }
    });
}

- (void)openMemberInv:(UISwitch*)swch
{
    //设置成员邀请权限


    [[RCIMClient sharedRCIMClient] setDiscussionInviteStatus:self.targetId isOpen:swch.on success:^{
//        DebugLog(@"设置成功");
    } error:^(RCErrorCode status) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.setDiscussTitleCompletion) {
        self.setDiscussTitleCompletion(_discussTitle);
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        RCDDiscussSettingCell* discussCell = (RCDDiscussSettingCell*)[tableView cellForRowAtIndexPath:indexPath];
        discussCell.lblTitle.text = @"讨论组名称";
        RCDUpdateNameViewController* updateNameViewController =[[RCDUpdateNameViewController alloc]init];
        updateNameViewController.targetId = self.targetId;
        updateNameViewController.displayText = discussCell.lblDiscussName.text;
        updateNameViewController.setDisplayTextCompletion = ^(NSString* text) {
            discussCell.lblDiscussName.text = text;
            _discussTitle = text;

        };
//        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:updateNameViewController];
        [self.navigationController pushViewController:updateNameViewController animated:YES];
    }
    else if(indexPath.row ==1)
    {
        [self selectBackImage];
    }
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

    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        RCDChatViewController * RCDchatVC=[[RCDChatViewController alloc]init];
        RCDchatVC.backgroundImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //UIImage *img= [self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];
        RCDchatVC.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
        
        //设置self.view.backgroundColor用自己的背景图片
        self.view.backgroundColor = [UIColor colorWithPatternImage:RCDchatVC.backgroundImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 *  override
 *
 *  @param 添加顶部视图显示的user,必须继承以调用父类添加user
 */
- (void)addUsers:(NSArray*)users
{
    [super addUsers:users];
}

/**
 *  override 左上角删除按钮回调
 *
 *  @param indexPath indexPath description
 */
- (void)deleteTipButtonClicked:(NSIndexPath*)indexPath
{
    RCUserInfo* user = self.users[indexPath.row];
    if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        return;
    }
    [[RCIMClient sharedRCIMClient] removeMemberFromDiscussion:self.targetId
                                                   userId:user.userId
    success:^(RCDiscussion *discussion) {
        NSLog(@"踢人成功");
        [self.users removeObject:user];
    } error:^(RCErrorCode status) {
        NSLog(@"踢人失败");
    }];
}



- (void)didTipHeaderClicked:(NSString*)userId
{
    if(_isClick){
        _isClick = NO;
        [[RCDRCIMDataSource shareInstance]getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            [[RCDHttpTool shareInstance]updateUserInfo:userId success:^(RCUserInfo * user) {
                if (![userInfo.name isEqualToString:user.name]) {
                    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
                    
                }
                NSArray *friendList = [[RCDataBaseManager shareInstance] getAllFriends];
                for (RCUserInfo *USER in friendList) {
                    if ([userId isEqualToString:USER.userId] || [userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        RCDPersonDetailViewController *temp = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDPersonDetailViewController"];
                        temp.userInfo = user;
                        [self.navigationController pushViewController:temp animated:YES];
                        return;
                    }
                }
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RCDAddFriendViewController *addViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddFriendViewController"];
                addViewController.targetUserInfo = userInfo;
                [self.navigationController pushViewController:addViewController animated:YES];
                
            } failure:^(NSError *err) {
                
            }];
        }];
    }
}


@end
