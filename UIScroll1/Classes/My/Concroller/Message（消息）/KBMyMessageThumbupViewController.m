
//
//  ThumbUpTVC.m
//  UIScroll1
//
//  Created by eddie on 15-4-29.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMyMessageThumbupViewController.h"
#import "KBCommonSingleValueModel.h"
#import "KBLoginSingle.h"
#import "KBMyMessageThumbUpViewCell.h"
#import "MBProgressHUD.h"
#import "KBWhetherReachableModel.h"
#import "MJRefresh.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "KBHTTPTool.h"
#import "KBPostParametersModel.h"
#import "KBMyMessagePraiseModel.h"
#import "KBMyMessagePraiseAllData.h"

//距离上边的距离
#define MARGIN_HEIGHT 20
//距离左边的距离
#define MARGIN_WIDTH 15
//头像的高度
#define HEADVIEW_WIDTH 50
//原来自己回复内容View的高度
#define HEIGHT_ORIGN_RESPOND_VIEW 40

#define MARGIN_SOURCE_LABLE 3
#define HEIGHT_SOURCE_RESPOND_VIEW 10
#define HEIGHT_SYSTEM_RESPOND 20
#define HEIGHT_USERNAME_LABLE 20
@interface KBMyMessageThumbupViewController ()<UITextViewDelegate>
{
    NSMutableArray * praiseArray;//点赞的数组
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    KBLoginSingle * loginSingle;//用户的单例
    
    NSInteger pageNumber;//分页数
    
    MBProgressHUD * hud;//提示
    
    MJRefreshAutoNormalFooter *footer;//自动加载更多
    
    KBMyMessagePraiseAllData * myMessagePraiseAllData; //我的消息回复的所有数据
}
@end

@implementation KBMyMessageThumbupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    myMessagePraiseAllData=[[KBMyMessagePraiseAllData alloc]init];
    loginSingle=[KBLoginSingle newinstance];
    //tableView
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollsToTop=NO;
    self.tableView.bounces=YES;
    
    //加入下拉刷新
    [self addMjRefreshInTableHeadView];
    //加入上拉加载更多
    [self addMjRefreshInTableFooterView];
    
    //加载数据
    [self performSelector:@selector(myMessageThumbupInit) withObject:nil afterDelay:0.5];
    
}
#pragma mark - 加入下拉刷新
- (void)addMjRefreshInTableHeadView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(myMessageThumbupInit)];
    self.tableView.header = header;
}
#pragma mark - 加入上拉加载更多
-(void)addMjRefreshInTableFooterView
{
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
#pragma mark - 获取点赞的数据
-(void)myMessageThumbupInit
{
    pageNumber=1;
    if(praiseArray.count!=0)
        [praiseArray removeAllObjects];
    [KBHTTPTool getRequestWithUrlStr:KUserMessagePraiseUrl(kBaseUrl, loginSingle.userID, pageNumber) parameters:nil completionHandr:^(id responseObject) {
        NSString * isLastStr = responseObject[@"isLast"];
        if ([isLastStr intValue]) {
            [self.tableView.header endRefreshing];
        }
        else
        {
            [myMessagePraiseAllData setDataWithDictionary:responseObject];
            praiseArray=[NSMutableArray arrayWithArray:myMessagePraiseAllData.myMessagePraiseAllDataArray];
            self.tableView.footer=footer;
            if (commonSingleValueModel.hasPraise) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_MESSAGE" object:nil];
            }
            commonSingleValueModel.hasPraise=NO;
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            pageNumber++;
        }

    } error:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    return praiseArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KBMyMessageThumbUpViewCell *myMessageThumbUpViewcell ;
    static NSString *cellIdentifier=@"messageCellIdentifier";
    myMessageThumbUpViewcell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(myMessageThumbUpViewcell==nil)
    {
        myMessageThumbUpViewcell=[[KBMyMessageThumbUpViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    KBMyMessagePraiseModel * myMessagePraiseModel = praiseArray[indexPath.section];
    //加载cell的数据
    [myMessageThumbUpViewcell setMessagePraiseCellWithModel:myMessagePraiseModel];
    return myMessageThumbUpViewcell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return MARGIN_HEIGHT+150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 27;
    else
        return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
#pragma mark - 加载更多数据
-(void)loadMoreData
{
    [KBHTTPTool getRequestWithUrlStr:KUserMessagePraiseUrl(kBaseUrl,loginSingle.userID, pageNumber) parameters:nil completionHandr:^(id responseObject) {
        NSString * isLastStr = responseObject[@"isLast"];
        if ([isLastStr intValue]) {
            [self.tableView.footer endRefreshing];
        }
        else
        {
            [myMessagePraiseAllData setDataWithDictionary:responseObject];
            [praiseArray addObjectsFromArray:myMessagePraiseAllData.myMessagePraiseAllDataArray];
            [self.tableView reloadData];
            pageNumber++;
            [self.tableView.footer endRefreshing];
            
        }
    } error:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
}
@end
