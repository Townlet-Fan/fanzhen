//
//  KBNewColumnViewController.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBColumnTableViewController.h"
#import "KBConstant.h"
#import "KBHTTPTool.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "KBColumnAllData.h"
#import "UIView+ITTAdditions.h"
#import "KBColumnScrollerView.h"
#import "KBColumnHeadView.h"
#import "KBColumnUsualViewCell.h"
#import "KBLoginSingle.h"
#import "KBJudgeTwoSortIdModel.h"
#import "KBCommonSingleValueModel.h"
#import "KBColor.h"
#import "KBWebviewInfoModel.h"
#import "KBColumnModel.h"
#import "KBTwoSortModel.h"
#import "KBInfoWebViewController.h"
#import "KBPostParametersModel.h"
#import "KBWhetherReachableModel.h"
#import "KBNoSubscriptionImageView.h"
#import "KBWhetherLoginModel.h"
#import "KBDefineGifView.h"
#import "KBUserWhetherSubscriptionModel.h"
#import "KBSortDetailViewControl.h"
#import "AppDelegate.h"
//cell的高度
#define USUAL_CELL_HEIGHT 107
//sectionHead的高度
#define sectionHeadHeight 36

@interface KBColumnTableViewController ()<SDCycleScrollViewDelegate,ColumnUsualCellDelegate>
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
    
    AppDelegate * appDelegate;
    
    //用plist文件写缓存
    NSArray *pathArray;
    NSString *pathStr;
    NSString *filename;
    NSMutableDictionary * cacheDictionary;//用于写缓存的字典
}
@end

@implementation KBColumnTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化正文的单例
    webViewInfoModel=[KBWebviewInfoModel newinstance];
//    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    
    //从新定义tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height) style:UITableViewStylePlain];
    //去除剩余的分割线
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    //取消置顶
    self.tableView.scrollsToTop=NO;
    //去掉滑动的线条
    self.tableView.showsVerticalScrollIndicator = NO;
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
    
    //接收通知，刷新阅读量
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshReadNum:) name:@"REFRESH_READNUMBER" object:nil];
    // Do any additional setup after loading the view.
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
            [KBHTTPTool postRequestWithUrlStr:url parameters:mainFocusList completionHandr:^(id responseObject) {
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
                    KBLog(@"columnTypeArray:%@",columnTypeArray);
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
                [defineGifView removeFromSuperview];//移除动画
                [self.tableView.header endRefreshing];
            }];
            //请求服务器
            /*
           [appDelegate.manager
            POST:url
            parameters:mainFocusList
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSString *jsonString=[[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
                
                NSError *er;
                if(jsonString!=nil){
                   NSMutableDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&er];
                    NSString * isLastStr=jsondic[@"isLast"];
                    //是否到最后一页，无数据
                    if ([isLastStr intValue]==0)
                    {
                        //处理数据
                        columnTypeArray=nil;
                        columnTypeArray=[[NSMutableArray alloc]init];
                        columnScrollerImageArray=nil;
                        columnScrollerImageArray=[[NSMutableArray alloc]init];
                        [columnAllData setDataWithDictionary:jsondic addTypeArray:columnTypeArray];
                        columnTypeArray=[NSMutableArray arrayWithArray:columnAllData.columnTypeData];
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

                }
           }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               KBLog(@"error:%@",error);
               [defineGifView removeFromSuperview];//移除动画
               [self.tableView.header endRefreshing];

           }];
             */
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
         [KBHTTPTool postRequestWithUrlStr:KTypeHaveCacheNoLoginedUrl(kBaseUrl,_itemNumber,pageNumber) parameters:mainFocusList completionHandr:^(id responseObject) {
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
             KBLog(@"error:%@",error);
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
#pragma mark - 点击cell上的三级分类的button跳转到指定的界面
-(void)pushTypeThreeDelegate:(KBColumnModel *)typeButtonColumnModel
{
    KBSortDetailViewControl *sortDetailVC=[[KBSortDetailViewControl alloc]init];
    sortDetailVC.thirdTypeName=typeButtonColumnModel.thirdTypeName;
    sortDetailVC.secondTypeID=[typeButtonColumnModel.secondType integerValue];
    
    [self.navigationController pushViewController:sortDetailVC animated:YES];
}
#pragma mark - 接收通知，刷新阅读量
-(void)refreshReadNum:(NSNotification *)aNotification{
    
    NSString *pageId=[aNotification object];
    for (int i=0; i<columnTypeArray.count; i++) {
        KBJudgeTwoSortIdModel *data=[[KBJudgeTwoSortIdModel alloc]init];
         data= [columnTypeArray objectAtIndex:i];
        for (int j=0; j<data.subArticleArray.count; j++)
        {
            KBColumnModel *columnModel=[[KBColumnModel alloc]init];
            columnModel=[data.subArticleArray objectAtIndex:j];
            
            if ([pageId isEqualToString:[NSString stringWithFormat:@"%@",columnModel.pageId]])
            {
                NSIndexPath * indexpath=[NSIndexPath indexPathForItem:j inSection:i];
                
                columnModel.readNumber=[NSNumber numberWithInt:[columnModel.readNumber intValue]+1];
               
                NSArray *indexArray=[NSArray arrayWithObject:indexpath];
                                
                KBColumnUsualViewCell *usualCell=(KBColumnUsualViewCell *)[self.tableView cellForRowAtIndexPath:indexpath ];
                usualCell.readNumLabel.text=[columnModel.readNumber stringValue];
                
                [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
}
#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBColumnUsualViewCell * usualCell;
    static NSString * usualIdentifier=@"UsualIdentifier";
    usualCell=[tableView dequeueReusableCellWithIdentifier:usualIdentifier];
    if (usualCell==nil) {
        usualCell=[[KBColumnUsualViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:usualIdentifier];
    }
    [usualCell setSelected:NO];
    
    KBJudgeTwoSortIdModel * twoSortIdData= columnTypeArray[indexPath.section];
    
    [usualCell setUsualCellWithModel:twoSortIdData.subArticleArray[indexPath.row] withIndex:indexPath withArray:columnTypeArray ];
    usualCell.delegate=self;
    
    return usualCell;      
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return USUAL_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [columnTypeArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   
    KBJudgeTwoSortIdModel * twoSortIdData= columnTypeArray[section];
//    NSLog(@"twosotIddata:%lu",(unsigned long)[twoSortIdData.subArticleArray count]);
    return [twoSortIdData.subArticleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeadHeight;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KBJudgeTwoSortIdModel * twoSortIdData= columnTypeArray[section];
    UIView * returnView=[[KBColumnHeadView alloc]initWithFrame:CGRectMake(0, 0, kWindowSize.width,sectionHeadHeight) addSectionLabel:twoSortIdData];

    return  returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBJudgeTwoSortIdModel * twoSortIdData=[[KBJudgeTwoSortIdModel alloc]init]  ;
    twoSortIdData=columnTypeArray[indexPath.section];
    KBColumnModel * columnModel=twoSortIdData.subArticleArray[indexPath.row];
    [webViewInfoModel setWebviewInfoColumnModel:columnModel];
    columnModel.readNumber=[NSNumber numberWithInt:[columnModel.readNumber intValue]+1];
    KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
   [self.navigationController pushViewController:tc animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
