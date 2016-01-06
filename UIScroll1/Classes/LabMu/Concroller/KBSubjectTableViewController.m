//
//  KBSubjectTableViewController.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/29.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSubjectTableViewController.h"
#import "KBConstant.h"
#import "KBLoginSingle.h"
#import "KBPostParametersModel.h"
#import "MJRefresh.h"
#import "KBHTTPTool.h"
#import "KBHomeScrollerView.h"
#import "UIView+ITTAdditions.h"
#import "KBWebviewInfoModel.h"
#import "KBNoSubscriptionImageView.h"
#import "KBDefineGifView.h"
#import "KBCommonSingleValueModel.h"
#import "KBColumnAllData.h"
#import "KBWhetherLoginModel.h"
#import "KBUserWhetherSubscriptionModel.h"
#import "KBJudgeTwoSortIdModel.h"
#import "KBColumnModel.h"
#import "KBColor.h"
#import "SDCycleScrollView.h"
#import "KBColumnScrollerView.h"
#import "KBInfoWebViewController.h"
#import "KBSubjectViewCell.h"
#import "KBThreeSortModel.h"
//cell的大小
#define USUAL_CELL_HEIGHT 95

@interface KBSubjectTableViewController ()<KBSubjectViewCellDelegate>

@end

@interface KBSubjectTableViewController()
{
    KBColumnScrollerView * scrollerView;//顶部轮播视图
    
    KBWebviewInfoModel * webViewInfoModel;//正文的单例
    
    NSMutableArray * columnTypeArray;//存储当前分类的数据
    
    NSMutableArray * columnScrollerImageArray;//存储当前分类滑图的数据
    
    NSInteger pageNumber;//请求的当前的分页数
    
    MJRefreshAutoNormalFooter * footer;//上拉加载更多footer
    
    KBNoSubscriptionImageView * noSubscriptionImageview;//无订阅分类的默认图ImageView
    
    KBDefineGifView * defineGifView;//加载动画
    
    KBColumnAllData * columnAllData;//所有分类的数据
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    //用plist文件写缓存
    NSArray *pathArray;
    NSString *pathStr;
    NSString *filename;
    NSMutableDictionary * cacheDictionary;//用于写缓存的字典
}

@end
@implementation KBSubjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化正文的单例
    webViewInfoModel=[KBWebviewInfoModel newinstance];
    //    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    
    //从新定义tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //去除剩余的分割线
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    //取消置顶
    self.tableView.scrollsToTop=NO;
    //去掉滑动的线条
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //顶部轮播
    [self addTopView];
    //加入下拉刷新
    [self addMjRefreshInTableHeadView];
    //加入上拉加载更多
    [self addMjRefreshInTableFooterView];
    //初始化无订阅分类的ImageView
    [self addNoSubscriptionImageView];
    
    //对responseObject写入plist文件
    pathArray=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    pathStr=[pathArray objectAtIndex:0];
    filename=[pathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.plist",(long)_itemNumber]];
    cacheDictionary=[[NSMutableDictionary alloc]init];

}
#pragma mark - 顶部轮播视图
- (void)addTopView
{
    scrollerView = [[KBColumnScrollerView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 9*kWindowSize.width/16.0) andTableView:self];
}
#pragma mark -无订阅分类的ImageView
-(void)addNoSubscriptionImageView
{
    noSubscriptionImageview=[[KBNoSubscriptionImageView alloc]initWithFrame:CGRectMake(kWindowSize.width/2.0-80, kWindowSize.height/2.0-170, 160,200) withItemNumber:_itemNumber];
}
#pragma mark - 加入下拉刷新
- (void)addMjRefreshInTableHeadView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateFocus)];
    self.tableView.header = header;
}
#pragma mark - 加入上拉加载更多
-(void)addMjRefreshInTableFooterView
{
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTypeData)];
}
#pragma mark - 无缓存的时候加载动画
-(void)addGifView
{
    defineGifView=[[KBDefineGifView alloc]initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height) withStartTop:-100];
    [self.view addSubview:defineGifView];
}
#pragma mark - 显示动画
-(void)showGifView
{
    [self addGifView];
}
#pragma  mark - 加载数据前先读取缓存
-(void)cacheRead
{
    //初始化所有分类的数据
    columnAllData=[[KBColumnAllData alloc]init];
    NSDictionary * cacheDict = [NSDictionary dictionaryWithContentsOfFile:filename];//读取数据
    NSDictionary * responseObject =[cacheDict objectForKey:[NSString stringWithFormat:@"%ld",(long)_itemNumber]];
    if (responseObject!=nil) {
        
        columnTypeArray=[[NSMutableArray alloc]init];
        columnScrollerImageArray=[[NSMutableArray alloc]init];
        //处理数据
        [columnAllData setDataWithDictionary:responseObject addTypeArray:columnTypeArray withItemNumber:_itemNumber];
        columnTypeArray=[NSMutableArray arrayWithArray:columnAllData.columnTypeData];
        columnScrollerImageArray=[[NSMutableArray alloc ]initWithArray:columnAllData.columnTopData];
        //刷新顶部的轮播视图
        [scrollerView buildScrollerViewImagesWith:columnAllData.columnTopData];
        if (columnScrollerImageArray.count!=0) {
            self.tableView.tableHeaderView=scrollerView;
        }
        pageNumber++;
        //刷新表格
        self.tableView.footer=footer;
        [self.tableView reloadData];
    }
    else
    {
        [self showGifView];
    }
}
#pragma mark - 滚动到当前的分类的tableController加载数据,更新分类的数据，由通知调用或者下拉刷新调用
-(void)updateFocus{
    //先读缓存在刷新数据信息
    if([KBWhetherLoginModel userWhetherLogin])
    {
        if (self.isFirstAddTable) {
            if([KBUserWhetherSubscriptionModel loginUserWhetherSubscription:_itemNumber])
                [self cacheRead];
            self.isFirstAddTable=NO;
        }
        
    }
    else
    {
        if (self.isFirstAddTable) {
            if ([KBUserWhetherSubscriptionModel noLoginUserWhetherSubscription:_itemNumber])
                [self cacheRead];
            self.isFirstAddTable=NO;
        }
    }
    
    //判断用户是否登录
    if([KBWhetherLoginModel userWhetherLogin])
    {
        [self loginTypeInfo];
    }
    else
    {
        [self noLoginTypeInfo];
    }
    
}
#pragma mark - 请求未登录分类的信息
- (void)noLoginTypeInfo
{
    pageNumber=1;
    columnAllData=[[KBColumnAllData alloc]init];
    {
        
        if(![KBUserWhetherSubscriptionModel noLoginUserWhetherSubscription:_itemNumber])
        {
            columnTypeArray=[[NSMutableArray alloc]init];
            columnScrollerImageArray=[[NSMutableArray alloc]init];
            //刷新顶部的轮播视图
            [scrollerView buildScrollerViewImagesWith:columnScrollerImageArray];
            [footer removeFromSuperview];
            self.tableView.backgroundColor= [UIColor whiteColor];
            [self.tableView addSubview:noSubscriptionImageview];
            self.tableView.bounces=NO;
            [self.tableView reloadData];
        }
        else
        {
            [noSubscriptionImageview removeFromSuperview];
            self.tableView.bounces=YES;
            NSString *url;
            //判断是否更新了订阅的分类
            if (commonSingleValueModel.isChangeInterest) {
                url=KTypeClearCacheNoLoginedUrl(kBaseUrl,_itemNumber,pageNumber);
                commonSingleValueModel.isChangeInterest=NO;
            }
            else
                url=KTypeHaveCacheNoLoginedUrl(kBaseUrl,_itemNumber,pageNumber);
            //请求的参数
            NSDictionary * mainFocusList=[KBPostParametersModel setNoLoginParameters: [[KBLoginSingle newinstance].userInterestNoStructArray objectAtIndex:_itemNumber-2] addItemNumber:_itemNumber];
            NSLog(@"mainFocusList:%@",mainFocusList);
            [KBHTTPTool postRequestWithUrlStr:url parameters:mainFocusList completionHandr:^(id responseObject) {
                //KBLog(@"resposeobject:%@",responseObject);
                //处理数据
                NSString   * isLastStr=responseObject[@"isLast"];
                if ([isLastStr intValue]==0)
                {
                    columnTypeArray=nil;
                    columnTypeArray=[[NSMutableArray alloc]init];
                    columnScrollerImageArray=nil;
                    columnScrollerImageArray=[[NSMutableArray alloc]init];
                    [columnAllData setDataWithDictionary:responseObject addTypeArray:columnTypeArray withItemNumber:_itemNumber];
                    columnTypeArray=[NSMutableArray arrayWithArray:columnAllData.columnTypeData];
                    self.tableView.backgroundColor=KColor_230;
                    columnScrollerImageArray=[[NSMutableArray alloc ]initWithArray:columnAllData.columnTopData];
                    //刷新顶部的轮播视图
                    [scrollerView buildScrollerViewImagesWith:columnAllData.columnTopData];
                    if (columnScrollerImageArray.count!=0) {
                        self.tableView.tableHeaderView=scrollerView;
                    }
                    
                    pageNumber++;
                    //刷新表格
                    [defineGifView removeFromSuperview];//移除动画
                    self.tableView.footer=nil;
                    self.tableView.footer=footer;
                    [self.tableView reloadData];
                    [self.tableView.header endRefreshing];
                }
                else
                {
                    [defineGifView removeFromSuperview];//移除动画
                    [self.tableView.header endRefreshing];
                }
                
            } error:^(NSError *error) {
                KBLog(@"error;%@",error);
                [defineGifView removeFromSuperview];//移除动画
                [self.tableView.header endRefreshing];
            }];
        }
    }
}
#pragma mark - 请求登录分类的信息
-(void)loginTypeInfo
{
    columnAllData=[[KBColumnAllData alloc]init];
    {
        if ([KBUserWhetherSubscriptionModel loginUserWhetherSubscription:_itemNumber])
        {
            pageNumber=1;
            NSString *url;
            if (commonSingleValueModel.isChangeInterest) {
                url=KTypeClearCacheLoginedUrl(kBaseUrl, _itemNumber,[KBLoginSingle newinstance].userID, pageNumber);
                commonSingleValueModel.isChangeInterest=NO;
            }
            else
                url=KTypeHaveCacheLoginedUrl(kBaseUrl, _itemNumber,[KBLoginSingle newinstance].userID, pageNumber);
            [noSubscriptionImageview removeFromSuperview];
            self.tableView.bounces=YES;
            [KBHTTPTool getRequestWithUrlStr:url parameters:nil completionHandr:^(id responseObject) {
                NSString   * isLastStr=responseObject[@"isLast"];
                if ([isLastStr intValue]==0) {
                    //处理数据
                    columnTypeArray=nil;
                    columnTypeArray=[[NSMutableArray alloc]init];
                    columnScrollerImageArray=nil;
                    columnScrollerImageArray=[[NSMutableArray alloc]init];
                    [columnAllData setDataWithDictionary:responseObject addTypeArray:columnTypeArray withItemNumber:_itemNumber];
                    
                    columnTypeArray=[NSMutableArray arrayWithArray:columnAllData.columnTypeData];
                    
                    columnScrollerImageArray=[[NSMutableArray alloc ]initWithArray:columnAllData.columnTopData];
                    //刷新顶部的轮播视图
                    [scrollerView buildScrollerViewImagesWith:columnAllData.columnTopData];
                    if (columnScrollerImageArray.count!=0) {
                        self.tableView.tableHeaderView=scrollerView;
                    }
                    
                    [cacheDictionary setObject:responseObject forKey:[NSString stringWithFormat:@"%ld",(long)_itemNumber]];
                    [cacheDictionary writeToFile:filename atomically:YES];
                    pageNumber++;
                    //刷新表格
                    [defineGifView removeFromSuperview];//移除动画
                    self.tableView.footer=nil;
                    self.tableView.footer=footer;
                    [self.tableView reloadData];
                    [self.tableView.header endRefreshing];
                }
                else
                {
                    [defineGifView removeFromSuperview];//移除动画
                    [self.tableView.header endRefreshing];
                }
            } error:^(NSError *error) {
                NSLog(@"error:%@",error);
                [defineGifView removeFromSuperview];//移除动画
                [self.tableView.header endRefreshing];
            }];
            
        }
        else
        {
            columnTypeArray=[[NSMutableArray alloc]init];
            columnScrollerImageArray=[[NSMutableArray alloc]init];
            //刷新顶部的轮播视图
            [scrollerView buildScrollerViewImagesWith:columnScrollerImageArray];
            [footer removeFromSuperview];
            
            [self.tableView addSubview:noSubscriptionImageview];
            self.tableView.bounces=NO;
            [self.tableView reloadData];
        }
    }
}
#pragma mark - 请求多页的分类信息
-(void)loadMoreTypeData
{
    if ([KBWhetherLoginModel userWhetherLogin])
    {
        [KBHTTPTool getRequestWithUrlStr:KTypeHaveCacheLoginedUrl(kBaseUrl,_itemNumber, [KBLoginSingle newinstance].userID, pageNumber) parameters:nil completionHandr:^(id responseObject) {
            //处理数据
            NSString   * isLastStr=responseObject[@"isLast"];
            if ([isLastStr intValue]==0)
            {
                [columnAllData setDataWithDictionary:responseObject addTypeArray:columnTypeArray withItemNumber:_itemNumber];
                
                columnTypeArray= [NSMutableArray arrayWithArray:columnAllData.columnTypeData];
                pageNumber++;
                //刷新表格
                [self.tableView reloadData];
                [self.tableView.footer endRefreshing];
            }
            else
            {
                [self.tableView.footer endRefreshing];
            }
        } error:^(NSError *error) {
            [self.tableView.footer endRefreshing];
        }];
    }
    else
    {
        NSDictionary * mainFocusList=[KBPostParametersModel setNoLoginParameters:[[KBLoginSingle newinstance].userInterestNoStructArray objectAtIndex:_itemNumber-2] addItemNumber:_itemNumber];
        [KBHTTPTool postRequestWithUrlStr:KTypeHaveCacheNoLoginedUrl(kBaseUrl, _itemNumber, pageNumber)parameters:mainFocusList completionHandr:^(id responseObject){
            NSString * isLastStr=responseObject[@"isLast"];
            //是否到最后一页，无数据
            if ([isLastStr intValue]==0)
            {
                //处理数据
                [columnAllData setDataWithDictionary:responseObject addTypeArray:columnTypeArray withItemNumber:_itemNumber];
                columnTypeArray=[NSMutableArray arrayWithArray:columnAllData.columnTypeData];
                pageNumber++;
                //刷新表格
                [self.tableView reloadData];
                [self.tableView.footer endRefreshing];
                
            }
            else
            {
                [self.tableView.footer endRefreshing];
            }
            
        } error:^(NSError *error) {
            KBLog(@"学科error:%@",error);
            [self.tableView.footer endRefreshing];
        }];
    }
}
#pragma mark - 轮播视图 点击 代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //取出model
    KBColumnModel * scrollerModel =columnScrollerImageArray [index];
    [webViewInfoModel setWebviewInfoColumnModel:scrollerModel];
    
    KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:tc animated:YES];
    
}
#pragma mark - 置顶交换数据
-(void)touchToTopButton:(NSIndexPath *)indexPath
{
    //先保存原数据
    KBJudgeTwoSortIdModel * twoSortIdModel  = columnTypeArray[indexPath.section];
    //获取该Indexpath所在的cell
    KBSubjectViewCell * subjectViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
    //将置顶变为取消置顶
    [subjectViewCell.TopButtonWithIndexpath setTitle:@"取消置顶" forState:UIControlStateNormal];
    //数据从数组中移除和插入
    [columnTypeArray removeObjectAtIndex:indexPath.section];
    [columnTypeArray insertObject:twoSortIdModel atIndex:0];
    //刷新tableView
    [self.tableView reloadData];
    [self toTopDataRequest];
}
#pragma mark - 置顶发送服务器
-(void)toTopDataRequest
{
    NSDictionary * dicSend  = [KBPostParametersModel setThirdTypeToTopParameters:1 withItemNumber:_itemNumber withThirdType:@"16"];
    [KBHTTPTool postRequestWithUrlStr:KThirdTypeToTopUrl(kBaseUrl) parameters:dicSend completionHandr:^(id responseObject) {
        NSString * toTopStr = responseObject[@"topThirdTypeResult"];
        if ([toTopStr intValue]) {
            KBLog(@"置顶成功");
        }
        else
            KBLog(@"置顶失败");
    } error:^(NSError *error) {
        KBLog(@"error:%@",error);
    }];
}
#pragma mark - 取消置顶 交换数据
-(void)touchCancelToTopButton:(NSIndexPath *)indexPath
{
    //先保存原数据
    KBJudgeTwoSortIdModel * twoSortIdModel  = columnTypeArray[indexPath.section];
    //获取该Indexpath所在的cell
    KBSubjectViewCell * subjectViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
    //将取消置顶变为置顶
    [subjectViewCell.TopButtonWithIndexpath setTitle:@"置顶" forState:UIControlStateNormal];
    //数据从数组中移除和插入
    [columnTypeArray removeObjectAtIndex:indexPath.section];
    [columnTypeArray insertObject:twoSortIdModel atIndex:1];
    //刷新tableView
    [self.tableView reloadData];
}
#pragma mark - 点击cell里的文章的图
-(void)viewTapActionWithColumnModel:(KBColumnModel *)columnModel
{
    [webViewInfoModel setWebviewInfoColumnModel:columnModel];
    //columnModel.num=[NSNumber numberWithInt:[columnModel.num intValue]+1];
    KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:tc animated:YES];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"subjectIdentifier";
    KBSubjectViewCell * subjectCell=[tableView dequeueReusableCellWithIdentifier:ID];
    KBJudgeTwoSortIdModel * twoSortIdData= columnTypeArray[indexPath.section];
    if (!subjectCell) {
        subjectCell=[[KBSubjectViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID withIndexpathArray:twoSortIdData.subArticleArray];
    }
    if (indexPath.section==0)
    {
        subjectCell.TopButtonWithIndexpath.whetherTotTop=YES;
    }
    else
        subjectCell.TopButtonWithIndexpath.whetherTotTop=NO;
    subjectCell.delegate=self;
    subjectCell.selectionStyle= UITableViewCellSelectionStyleNone;
    [subjectCell setSubjectCellWithModel:twoSortIdData.subArticleArray withIndexPath:indexPath
     ];
    return subjectCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBJudgeTwoSortIdModel * twoSortIdData= columnTypeArray[indexPath.section];
   
    switch (twoSortIdData.subArticleArray.count) {
        case 0:
            return 0;
        case 1:
        {
             KBColumnModel * colunmnModel = twoSortIdData.subArticleArray[0];
            return colunmnModel.infoImgType?(kWindowSize.width-24)*5/12+44:USUAL_CELL_HEIGHT+41;
        }
        case 2:
        {
            KBColumnModel * colunmnModel = twoSortIdData.subArticleArray[0];
            return colunmnModel.infoImgType?(kWindowSize.width-24)*5/12+44+USUAL_CELL_HEIGHT+5:USUAL_CELL_HEIGHT+41+USUAL_CELL_HEIGHT+5;
        }
        case 3:
        {
            KBColumnModel * colunmnModel = twoSortIdData.subArticleArray[0];
            return colunmnModel.infoImgType?(kWindowSize.width-24)*5/12+44+2*(USUAL_CELL_HEIGHT+5):USUAL_CELL_HEIGHT+41+2*(USUAL_CELL_HEIGHT+5);
        }
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [columnTypeArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0000001;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
