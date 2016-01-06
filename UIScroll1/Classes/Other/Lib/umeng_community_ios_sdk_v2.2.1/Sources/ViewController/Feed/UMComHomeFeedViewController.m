//
//  UMComHomeFeedViewController.m
//  UMCommunity
//
//  Created by umeng on 15-4-2.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComHomeFeedViewController.h"
#import "UMComNavigationController.h"
#import "UMComSearchBar.h"
#import "UMComFeedTableView.h"
#import "UMComAction.h"
#import "UMComPageControlView.h"
#import "UMComSearchViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComBarButtonItem.h"
#import "UMComEditViewController.h"
#import "UMComFindViewController.h"
#import "UMComPullRequest.h"
#import "UMComPushRequest.h"
#import "UMComSession.h"
#import "UMComTopicsTableView.h"
#import "UMComLoginManager.h"
#import "UMComFeedStyle.h"
#import "UMComTopic+UMComManagedObject.h"
#import "UMComFilterTopicsViewCell.h"
#import "UMComTopicFeedViewController.h"
#import "UMComShowToast.h"
#import "UMComRefreshView.h"
#import "UMComScrollViewDelegate.h"
#import "UMComClickActionDelegate.h"
#import "UMComPushRequest.h"
#import "UMComUnReadNoticeModel.h"
#import "KB_RegisterAndLoginViewController.h"
#import "KBConstant.h"
#import "KBLoginSingle.h"
#define kTagRecommend 100
#define kTagAll 101

#define DeltaBottom  45
#define DeltaRight 45

@interface UMComHomeFeedViewController ()<UISearchBarDelegate, UMComScrollViewDelegate, UMComClickActionDelegate,UMComFilterTopicsViewCellDelegate>


@property (strong, nonatomic) UMComSearchBar *searchBar;

@property (nonatomic, strong) UMComFeedTableView *recommentfeedTableView;

@property (nonatomic, strong) UMComTopicsTableView *topicsTableView;

@property (strong,nonatomic) UMComAllTopicsRequest *allTopicsRequest;

@property (nonatomic, strong) UMComPageControlView *titlePageControl;

@property (nonatomic, strong) UIButton *findButton;

@property (nonatomic, strong) UIView *itemNoticeView;

@property (nonatomic, assign) CGFloat searchBarOriginY;

@end

@implementation UMComHomeFeedViewController
{
    BOOL  isTransitionFinish;
    CGPoint originOffset;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([UIApplication sharedApplication].keyWindow.rootViewController == self.navigationController) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    //创建导航条视图
    [self creatNigationItemView];

    CGRect headViewFrame = CGRectMake(0, 0, self.view.frame.size.width, kUMComRefreshOffsetHeight);
//   关注页面
    self.feedsTableView.fetchRequest = [[UMComAllFeedsRequest alloc]initWithCount:BatchSize];
    self.feedsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.feedsTableView.feedType = feedFocusType;
//    [self.feedsTableView loadAllData:nil fromServer:nil];

//    __weak typeof(self) weakSelf = self;
//    self.feedsTableView.loadSeverDataCompletionHandler = ^(NSArray *data, BOOL haveNextPage, NSError *error){
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (strongSelf.titlePageControl.currentPage == 0) {
//            [weakSelf showUnreadFeedWithCurrentFeedArray:weakSelf.feedsTableView.dataArray compareArray:data];     
//        }
//    };
    self.feedsTableView.tableHeaderView = [[UIView alloc]initWithFrame:headViewFrame];

//话题列表
    self.topicsTableView = [[UMComTopicsTableView alloc]initWithFrame:CGRectMake(0, self.feedsTableView.frame.origin.y, self.feedsTableView.frame.size.width, self.feedsTableView.frame.size.height) style:UITableViewStylePlain];
    self.allTopicsRequest = [[UMComAllTopicsRequest alloc]initWithCount:TotalTopicSize];
    self.topicsTableView.fetchRequest = self.allTopicsRequest;
    self.topicsTableView.clickActionDelegate = self;
    self.topicsTableView.scrollViewDelegate = self;
    self.topicsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.topicsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.topicsTableView];
    self.topicsTableView.tableHeaderView = [[UIView alloc]initWithFrame:headViewFrame];
    [self.topicsTableView loadAllData:nil fromServer:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewFeedDataWhenFeedCreatSucceed:) name:kNotificationPostFeedResultNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAllDataWhenLoginUserChange:) name:kUserLoginSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAllDataWhenLoginUserChange:) name:kUserLogoutSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageData:) name:kUMComRemoteNotificationReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageData:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.view bringSubviewToFront:self.searchBar];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isTransitionFinish = YES;
    [self refreshUnreadMessageNotification];
    [self.topicsTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //友盟更新(login时，图片上传不了，所以用更新方式,且登录时就更新会报未登录错误)
    [self UMengAccpuntUpdate];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    self.topicsTableView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.topicsTableView = nil;
    self.allTopicsRequest = nil;
    self.itemNoticeView = nil;
}
#pragma mark - 微社区 友盟用户资料更新
- (void)UMengAccpuntUpdate
{
    //友盟用户更新
    UMComUserAccount *userAccount = [[UMComUserAccount alloc]initWithSnsType:UMComSnsTypeSelfAccount];
    userAccount.usid = [NSString stringWithFormat:@"%ld",(long)[KBLoginSingle newinstance].userID];//自己账号UID（本方服务器生成的）
    userAccount.name = [KBLoginSingle newinstance].userName;
    userAccount.iconImage = [KBLoginSingle newinstance].userPhoto;
    //NSLog(@"userACCOUNt:%@,%@,%@,%@",userAccount.usid,userAccount.name,userAccount.iconImage,userAccount.icon_url);
    [UMComPushRequest updateWithUser:userAccount completion:^(NSError *error) {
        NSLog(@"<<<<<<<--------->%@",error);
    }];
    
}
#pragma mark - 代理方法，弹出登录界面
- (void)showLoginView
{
    KB_RegisterAndLoginViewController *loginVC = [[KB_RegisterAndLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
    }];
    [loginVC.scrollView setContentOffset:CGPointMake(3*kWindowSize.width, 0)];
}

#pragma mark - privite methods
-(void)onClickClose
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
- (void)creatNigationItemView
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.view.frame.size.width-27, self.navigationController.navigationBar.frame.size.height/2-22, 44, 44);
    CGFloat delta = 9;
    rightButton.imageEdgeInsets =  UIEdgeInsetsMake(delta, delta, delta, delta);
    [rightButton setImage:UMComImageWithImageName(@"find+") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onClickFind:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:rightButton];
    self.findButton = rightButton;
    
    self.itemNoticeView = [self creatNoticeViewWithOriginX:rightButton.frame.size.width-10];
    [self.findButton addSubview:self.itemNoticeView];
    [self refreshMessageData:nil];
    //创建菜单栏
    UMComPageControlView *titlePageControl = [[UMComPageControlView alloc]initWithFrame:CGRectMake(0, 0, 180, 25) itemTitles:[NSArray arrayWithObjects:UMComLocalizedString(@"topic",@"话题"), nil] currentPage:0];
    titlePageControl.currentPage = 0;
    titlePageControl.selectedColor = [UIColor whiteColor];
    titlePageControl.unselectedColor = [UIColor blackColor];
    
    [titlePageControl setItemImages:[NSArray arrayWithObjects:UMComImageWithImageName(@"right_item"), nil]];
//    __weak UMComHomeFeedViewController *wealSelf = self;
    titlePageControl.didSelectedAtIndexBlock = ^(NSInteger index){
//        [wealSelf transitionViewControllers:nil];
//        [wealSelf hidenKeyBoard];
    };
//    [self.navigationItem setTitleView:titlePageControl];
    self.titlePageControl = titlePageControl;
    
    [self setTitleViewWithTitle:@"话题"];
    [self setLeftButtonWithImageName:@"Backx" action:@selector(onClickClose)];
}

- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX
{
    CGFloat noticeViewWidth = 8;
    UIView *itemNoticeView = [[UIView alloc]initWithFrame:CGRectMake(originX,5, noticeViewWidth, noticeViewWidth)];
    itemNoticeView.backgroundColor = [UIColor redColor];
    itemNoticeView.layer.cornerRadius = noticeViewWidth/2;
    itemNoticeView.clipsToBounds = YES;
    itemNoticeView.hidden = YES;
    return itemNoticeView;
}

#pragma mark -
- (void)refreshMessageData:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [UMComPushRequest requestConfigDataWithResult:^(id responseObject, NSError *error) {
        [self refreshUnreadMessageNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUMComUnreadNotificationRefreshNotification object:nil userInfo:responseObject];
    }];
}

- (void)refreshUnreadMessageNotification
{
    UMComUnReadNoticeModel *unReadNotice = [UMComSession sharedInstance].unReadNoticeModel;
    if (unReadNotice.totalNotiCount == 0) {
        self.itemNoticeView.hidden = YES;
    }else{
        self.itemNoticeView.hidden = NO;
    }
}

#pragma mark - 重写父类方法
- (void)refreshAllData
{
    __weak typeof(self) weakSelf = self;
    __block NSArray *tempArray = nil;
    [self.feedsTableView loadAllData:^(NSArray *data, NSError *error) {
        tempArray = self.feedsTableView.dataArray;
    } fromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        [weakSelf showUnreadFeedWithCurrentFeedArray:tempArray compareArray:data];
    }];
}

- (void)showUnreadFeedWithCurrentFeedArray:(NSArray *)currentArr compareArray:(NSArray *)compareArr
{
    int unReadCount = (int)compareArr.count;
    for (UMComFeed *feed in compareArr) {
        for (UMComFeed *curentFeed in currentArr) {
            if ([feed.feedID isEqualToString:curentFeed.feedID]) {
                unReadCount -= 1;
                break;
            }
        }
    }
    if (unReadCount > 0) {
        [self showTipLableFromTopWithTitle:[NSString stringWithFormat:@"%d条新内容",unReadCount]];
    }
}

- (void)addNewFeedDataWhenFeedCreatSucceed:(NSNotification *)notification
{
    UMComFeed *newFeed = (UMComFeed *)notification.object;
    [self.feedsTableView insertFeedStyleToDataArrayWithFeed:newFeed];
}

#pragma mark - notifcation action
- (void)refreshAllDataWhenLoginUserChange:(NSNotification *)notification
{
    if ([kUserLogoutSucceedNotification isEqualToString:notification.name]) {
        [self.feedsTableView.dataArray removeAllObjects];
        [self.feedsTableView reloadFeedData];
        [self.recommentfeedTableView.dataArray removeAllObjects];
        [self.recommentfeedTableView reloadFeedData];
        [self.topicsTableView.dataArray removeAllObjects];
        [self.topicsTableView reloadData];
    }
    __weak typeof(self) weakSelf = self;
    if (self.titlePageControl.currentPage == 0) {
        [self.feedsTableView refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
            [weakSelf.recommentfeedTableView refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
                [weakSelf.topicsTableView refreshNewDataFromServer:nil];
            }];
        }];
    } else if(self.titlePageControl.currentPage == 1){
        [self.recommentfeedTableView refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
            [weakSelf.feedsTableView refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
                [weakSelf.topicsTableView refreshNewDataFromServer:nil];
            }];
        }];
    } else if (self.titlePageControl.currentPage ==2){
        [self.topicsTableView refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
            [weakSelf.feedsTableView refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
                [weakSelf.recommentfeedTableView refreshNewDataFromServer:nil];
            }];
        }];
    }
    
    [self refreshMessageData:nil];
}

#pragma mark - UMComClickActionDelegate
- (void)customObj:(UMComFilterTopicsViewCell *)cell clickOnFollowTopic:(UMComTopic *)topic
{
    __weak UMComFilterTopicsViewCell *weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [[UMComAction action] performActionAfterLogin:nil viewController:self completion:^(NSArray *data, NSError *error) {
        BOOL isFocus = [[topic is_focused] boolValue];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [UMComPushRequest followerWithTopic:topic isFollower:!isFocus completion:^(NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (!error) {
                [weakCell setFocused:[[topic is_focused] boolValue]];
            } else {
                [UMComShowToast showFetchResultTipWithError:error];
            }
            [weakSelf.topicsTableView reloadData];
        }];
    }];
}

- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    UMComTopicFeedViewController *oneFeedViewController = [[UMComTopicFeedViewController alloc] initWithTopic:topic];
    [self.navigationController pushViewController:oneFeedViewController animated:YES];
}
@end
