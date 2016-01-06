//
//  UMComOneFeedViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 9/12/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComTopicFeedViewController.h"
#import "UMComTopic+UMComManagedObject.h"
#import "UMComFeedTableView.h"
#import "UMComAction.h"
#import "UMComSession.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComShowToast.h"
#import "UMComUsersTableView.h"
#import "UIViewController+UMComAddition.h"
#import "UMComEditViewController.h"
#import "UMComNavigationController.h"
#import "UMComMenuControlView.h"
#import "UMComPullRequest.h"
#import "UMComPushRequest.h"
#import "UMComUserTableViewCell.h"
#import "UMComRefreshView.h"
#import "UMComScrollViewDelegate.h"
#import "UMComClickActionDelegate.h"
#import "UMComImageView.h"
#import "KBComEditTableViewController.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
@interface UMComTopicFeedViewController ()<UMComClickActionDelegate,UMComScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) UMComUsersTableView *hotUsersTableView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UMComMenuControlView *menuControlView;

@property (nonatomic, strong) UIView * followBackground;

@end

@implementation UMComTopicFeedViewController

-(id)initWithTopic:(UMComTopic *)topic
{
    self = [super init];
    if (self) {
        self.topic = topic;
        UMComTopicFeedsRequest *topicFeedsController = [[UMComTopicFeedsRequest alloc] initWithTopicId:topic.topicID count:BatchSize order:UMComFeedSortTypeDefault isReverse:YES];
        self.fetchFeedsController = topicFeedsController;
   }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //table 包含头视图和cell
    UIView *topicBackgroundView = [self createTopicBackgroundView];
//    CGRect headViewFrame = CGRectMake(0, 0, self.view.frame.size.width, topicBackgroundView.frame.size.height);
    self.feedsTableView.frame = CGRectMake(0, 0, self.feedsTableView.frame.size.width, self.view.frame.size.height);
    self.feedsTableView.scrollViewDelegate = self;
    self.feedsTableView.feedType = feedTopicType;
    self.feedsTableView.tableHeaderView = topicBackgroundView;
    self.feedsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self setTitleViewWithTitle:@"话题"];
    [self setLeftButtonWithImageName:@"Backx" action:@selector(onClickClose)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewFeedDataWhenFeedCreatSucceed:) name:kNotificationPostFeedResultNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.editButton.hidden = NO;
    self.editButton.center = CGPointMake([UIApplication sharedApplication].keyWindow.bounds.size.width-DeltaRight, [UIApplication sharedApplication].keyWindow.bounds.size.height-DeltaBottom);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewFeedDataWhenFeedCreatSucceed:) name:kNotificationPostFeedResultNotification object:nil];
    [self.view bringSubviewToFront:self.followBackground];
    self.feedsTableView.hidden = NO;
    //self.hotUsersTableView.hidden = NO;
    //if (self.hotUsersTableView.dataArray.count > 0) {
        //[self.hotUsersTableView reloadData];
    //}
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.feedsTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.editButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPostFeedResultNotification object:nil];
    self.feedsTableView.hidden = YES;
    self.hotUsersTableView.hidden = YES;
    [self.view bringSubviewToFront:self.followBackground];
}

-(void)onClickClose
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
- (UIView *)createTopicBackgroundView
{
    //背景图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 310)];
    
    UMComImageView *backgroundView = [[UMComImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 220)];
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    NSString *originUrl=nil;
    for (NSDictionary *imageDict in self.topic.image_urls)
    {
        originUrl = [imageDict valueForKey:@"origin"];
    }
    [backgroundView setImageURL:originUrl placeHolderImage:[UIImage imageNamed:@"zhuozi"]];
    //加三角形
    CGSize size = [backgroundView.image size];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height), NO, 0);
    [backgroundView.image drawAtPoint:CGPointMake(0, 0)];
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,0.45*size.width, size.height);//设置起点
    CGContextAddLineToPoint(context,0.5*size.width, size.height-0.1*size.height);
    CGContextAddLineToPoint(context,0.55*size.width, size.height);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [[UIColor whiteColor] setFill]; //设置填充色
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    backgroundView.image = im;
    [view addSubview:backgroundView];
    
    //时间标签
    UILabel* date = [[UILabel alloc] initWithFrame:CGRectMake(0 , backgroundView.bottom + 10, 0.5*backgroundView.width, 20)];
    date.center = CGPointMake(0.5*kWindowSize.width, date.centerY);
    date.text = [self.topic.descriptor length] == 0 ? UMComLocalizedString(@"Topic_No_Desc", @"该话题没有描述"): self.topic.descriptor;
    date.font = UMComFontNotoSansLightWithSafeSize(14);
    date.textColor = [UMComTools colorWithHexString:FontColorBlue];
    date.textAlignment = NSTextAlignmentCenter;
    [view addSubview:date];
    
    //话题名称
    UILabel* labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, date.bottom+10, 0.9*backgroundView.width, 60)];
    labelName.center = CGPointMake(0.5*kWindowSize.width , labelName.centerY);
    labelName.numberOfLines = 0;
    labelName.textColor = [UIColor blackColor];
    labelName.font = UMComFontNotoSansLightWithSafeSize(18);
    labelName.text = [NSString stringWithFormat:@"    %@",self.topic.name];
    CGSize size1 = [labelName sizeThatFits:CGSizeMake(labelName.width, MAXFLOAT)];
    labelName.frame = CGRectMake(labelName.left, labelName.top, labelName.width, size1.height);
    [view addSubview:labelName];
    
    view.size = CGSizeMake(view.width, labelName.bottom+20);
    return view;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - overwrite super class method

- (void)refreshAllData
{
    if (self.topic.feeds.count > 0) {
        [self.feedsTableView.dataArray addObjectsFromArray:[self.feedsTableView transFormToFeedStylesWithFeedDatas:self.topic.feeds.array]];
        [self.feedsTableView reloadData];
    }
    if (self.fetchFeedsController) {
        self.feedsTableView.fetchRequest = self.fetchFeedsController;
        [self.feedsTableView loadAllData:nil fromServer:nil];
    }
}


//重写父类点击按钮方法
- (void)onClickEdit:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [[UMComAction action] performActionAfterLogin:self.topic viewController:self completion:^(NSArray *data, NSError *error) {
        //UMComEditViewController *editViewController = [[UMComEditViewController alloc] initWithTopic:self.topic];
        KBComEditTableViewController *editViewController = [[KBComEditTableViewController alloc] initWithTopic:self.topic];
        //UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
        //[self presentViewController:editNaviController animated:YES completion:nil];//用这个返回值后，页面呈空白，待解决。。。
        [weakSelf.navigationController pushViewController:editViewController animated:YES];
    }];
}

#pragma mark - privite method
- (void)addNewFeedDataWhenFeedCreatSucceed:(NSNotification *)notification
{
    UMComFeed *newFeed = (UMComFeed *)notification.object;
    if (newFeed) {
        for (UMComTopic *topic in newFeed.topics) {
            if ([self.topic.topicID isEqualToString:topic.topicID]) {
                [self.feedsTableView insertFeedStyleToDataArrayWithFeed:newFeed];    
                break;
            }
        }
    }
}

-(void)onClickFollow:(id)sender
{
    __weak UMComTopicFeedViewController *weakSelf = self;
    [[UMComAction action] performActionAfterLogin:nil viewController:self completion:^(NSArray *data, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [UMComPushRequest followerWithTopic:self.topic isFollower:![self.topic.is_focused boolValue] completion:^(NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (!error) {
                [weakSelf setFocused:[weakSelf.topic.is_focused boolValue] button:sender];
            } else {
                if (error.code == 30001) {
                    [weakSelf setFocused:YES button:sender];
                }
                [UMComShowToast showFetchResultTipWithError:error];
            }
        }];
    }];
}


- (void)setFocused:(BOOL)focused button:(UIButton *)button
{
    [button setBackgroundColor:[UIColor whiteColor]];
    CALayer * downButtonLayer = [button layer];
    UIColor *bcolor = [UMComTools colorWithHexString:TableViewSeparatorColor];//;
    [downButtonLayer setBorderColor:[bcolor CGColor]];
    [downButtonLayer setBorderWidth:0.5];
    if([self.topic.is_focused boolValue]){
        [button setTitle:UMComLocalizedString(@"Has_Focused",@"取消关注") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:15.0/255.0 green:121.0/255.0 blue:254.0/255.0 alpha:1] forState:UIControlStateNormal];
    }else{
        [button setTitle:UMComLocalizedString(@"No_Focused",@"关注") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)onClickTopicFeedsButton:(id)sender {
    self.hotUsersTableView.scrollViewDelegate = nil;
    self.feedsTableView.scrollViewDelegate = self;
    self.editButton.hidden = NO;
    [self resetContentOffsetOfScrollView:self.feedsTableView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [weakSelf.view bringSubviewToFront:weakSelf.followBackground];
        weakSelf.feedsTableView.frame = CGRectMake(0, weakSelf.feedsTableView.frame.origin.y, weakSelf.feedsTableView.frame.size.width, weakSelf.feedsTableView.frame.size.height);
        weakSelf.hotUsersTableView.frame = CGRectMake(weakSelf.feedsTableView.frame.size.width, weakSelf.hotUsersTableView.frame.origin.y, weakSelf.feedsTableView.frame.size.width, weakSelf.feedsTableView.frame.size.height);
    } completion:nil];
}

- (void)onClickHotUserFeedsButton:(id)sender {
    self.feedsTableView.scrollViewDelegate = nil;
    self.hotUsersTableView.scrollViewDelegate = self;
    __weak typeof(self) weakSelf = self;
    if (self.hotUsersTableView.dataArray.count == 0) {
        if (self.topic.follow_users.count > 0) {
            [self.hotUsersTableView.dataArray addObjectsFromArray:self.topic.follow_users.array];
            [self.hotUsersTableView reloadData];
        }
        [self.hotUsersTableView loadAllData:^(NSArray *data, NSError *error) {
            [weakSelf resetContentOffsetOfScrollView:self.hotUsersTableView];
        } fromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
            [weakSelf resetContentOffsetOfScrollView:self.hotUsersTableView];
        }];
    }
    [self resetContentOffsetOfScrollView:self.hotUsersTableView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [weakSelf.view bringSubviewToFront:weakSelf.followBackground];
        weakSelf.feedsTableView.frame = CGRectMake(-weakSelf.feedsTableView.frame.size.width, weakSelf.feedsTableView.frame.origin.y, weakSelf.feedsTableView.frame.size.width, weakSelf.feedsTableView.frame.size.height);
        weakSelf.hotUsersTableView.frame = CGRectMake(0, weakSelf.hotUsersTableView.frame.origin.y, weakSelf.feedsTableView.frame.size.width, weakSelf.feedsTableView.frame.size.height);
    } completion:nil];
    [self.view bringSubviewToFront:self.followBackground];
}


- (void)resetContentOffsetOfScrollView:(UIScrollView *)scrollView
{
    if (!(scrollView.contentOffset.y >= -self.followBackground.frame.origin.y && self.followBackground.frame.size.height-self.menuControlView.frame.size.height == -self.followBackground.frame.origin.y)) {
        [scrollView setContentOffset:CGPointMake(self.followBackground.frame.origin.x, -self.followBackground.frame.origin.y)];
    }
}


- (void)refreshScrollViewWithView:(UIScrollView *)scrollView
{
    CGFloat contenSizeH = self.view.frame.size.height + self.followBackground.frame.size.height;
    if (contenSizeH < self.followBackground.frame.size.height + scrollView.contentSize.height) {
        contenSizeH = self.followBackground.frame.size.height + scrollView.contentSize.height;
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, contenSizeH);
    [scrollView setContentOffset:CGPointMake(self.followBackground.frame.origin.x, -self.followBackground.frame.origin.y)];
}


- (void)scrollEditButtonWithScrollView:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    self.editButton.hidden = NO;
    CGFloat height = self.followBackground.frame.size.height - self.menuControlView.frame.size.height;
    if (scrollView.contentOffset.y < height && scrollView.contentOffset.y >= 0) {
        self.followBackground.frame = CGRectMake(self.followBackground.frame.origin.x,-scrollView.contentOffset.y, self.followBackground.frame.size.width, self.followBackground.frame.size.height);
    }else if (scrollView.contentOffset.y >= height && scrollView.contentOffset.y >= 0) {
        self.followBackground.frame = CGRectMake(self.followBackground.frame.origin.x, -self.followBackground.frame.size.height+self.menuControlView.frame.size.height, self.followBackground.frame.size.width, self.followBackground.frame.size.height);
    }else if (scrollView.contentOffset.y == 0){
          self.followBackground.frame = CGRectMake(self.followBackground.frame.origin.x,0, self.followBackground.frame.size.width, self.followBackground.frame.size.height);
    }
    if (scrollView == self.feedsTableView) {
        if (scrollView.contentOffset.y >0 && scrollView.contentOffset.y > lastPosition.y+15) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.editButton.center = CGPointMake(self.editButton.center.x, [UIApplication sharedApplication].keyWindow.bounds.size.height+DeltaBottom);
            } completion:nil];
        }  else{
            if (scrollView.contentOffset.y < lastPosition.y-15) {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.editButton.center = CGPointMake(self.editButton.center.x, [UIApplication sharedApplication].keyWindow.bounds.size.height-DeltaBottom);
                } completion:nil];
            }
        }
    }
}

#pragma mark - UMComScrollViewDelegate
- (void)customScrollViewDidScroll:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    [self scrollEditButtonWithScrollView:scrollView lastPosition:lastPosition];
}

- (void)customScrollViewDidEnd:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    [self scrollEditButtonWithScrollView:scrollView lastPosition:lastPosition];
}

#pragma mark - UMComClickActionDelegate
- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    NSString *topicName = @"";
    if (topic.name) {
        topicName = topic.name;
    }
    if ([topicName isEqualToString:self.topic.name]) {
        return;
    }
    UMComTopicFeedViewController *oneFeedViewController = [[UMComTopicFeedViewController alloc] initWithTopic:topic];
    [self.navigationController  pushViewController:oneFeedViewController animated:YES];
}

- (void)removeUserFromUsers:(UMComUser *)user
{
    if (user) {
        [self.hotUsersTableView.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj uid] isEqualToString:user.uid]) {
                [self.hotUsersTableView.dataArray removeObject:obj];
                *stop = YES;
                [_hotUsersTableView reloadData];
            }
        }];
    }
}

- (void)customObj:(id)obj clickOnFollowUser:(UMComUser *)user
{
    __weak UMComUserTableViewCell *weakCell = (UMComUserTableViewCell *)obj;;
    [[UMComAction action] performActionAfterLogin:nil viewController:self completion:^(NSArray *data, NSError *error) {
        if ([weakCell isKindOfClass:[UMComUserTableViewCell class]]) {
            [weakCell focusUserAfterLoginSucceedWithResponse:^(NSError *error) {
                if (!error) {
                    if ([user.atype intValue] == 3) {
                        [self removeUserFromUsers:user];
                    }
                }
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
