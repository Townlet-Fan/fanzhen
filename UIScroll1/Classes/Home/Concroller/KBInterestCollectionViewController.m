//
//  KBInterestCollectionViewController.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBInterestCollectionViewController.h"
#import "KBConstant.h"
#import "KBInterestViewCell.h"
#import "WaterFLayout.h"
#import "KBLoginSingle.h"
#import "KBPostParametersModel.h"
#import "MJRefresh.h"
#import "KBHTTPTool.h"
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
#import "KBColumnScrollerView.h"
#import "SDCycleScrollView.h"
#import "KBInfoWebViewController.h"
//一个Itme的宽度
#define cellW  ([UIScreen mainScreen].bounds.size.width-10)/2

@interface KBInterestCollectionViewController()<UICollectionViewDataSource,KBInterestViewCellDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    KBColumnScrollerView *_scrollerView;//顶部轮播大图
    
    NSInteger pageNumber;//分页数
    
    NSMutableArray * columnTypeArray;//存储当前分类的数据
    
    NSMutableArray * columnScrollerImageArray;//存储当前分类滑图的数据
    
    KBColumnAllData * columnAllData;//所有分类的数据
    
    KBWebviewInfoModel * webViewInfoModel;//正文的单例
    
    MJRefreshAutoNormalFooter * footer;//上拉加载更多footer
    
    KBNoSubscriptionImageView * noSubscriptionImageview;//无订阅分类的默认图ImageView
    
    KBDefineGifView * defineGifView;//加载动画
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    //用plist文件写缓存
    NSArray *pathArray;
    NSString *pathStr;
    NSString *filename;
    NSMutableDictionary * cacheDictionary;//用于写缓存的字典
}
@end

@implementation KBInterestCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化
    webViewInfoModel=[KBWebviewInfoModel newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    
    //界面UI
    [self buildInterstedView];
    //顶部轮播视图
    [self setTopScrollerView];
    
    //下拉刷新控件
    [self addMJRefresh];
    
    //初始化无订阅分类的ImageView
    [self addNoSubscriptionImageView];
    

    //对responseObject写入plist文件
    pathArray=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    pathStr=[pathArray objectAtIndex:0];
    filename=[pathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.plist",(long)_itemNumber]];
    cacheDictionary=[[NSMutableDictionary alloc]init];
}

#pragma mark - 首页轮播视图
- (void)setTopScrollerView
{
    _scrollerView = [[KBColumnScrollerView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 9*kWindowSize.width/16.0) andTableView:self];
}

#pragma mark - 懒加载数组
- (NSMutableArray *)resultArray
{
    if (!columnTypeArray) {
        columnTypeArray = [NSMutableArray array];
    }
    return columnTypeArray;
}
#pragma mark - 创建UI
- (void)buildInterstedView
{
    WaterFLayout *layout = [[WaterFLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //初始化
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollsToTop=NO;
    self.collectionView.scrollEnabled=YES;
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerClass:[KBInterestViewCell class] forCellWithReuseIdentifier:@"INTERESTCLL"];
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaterFallSectionHeader"];
    
    //[self.view addSubview:self.collectionView];
}
#pragma mark - 加入下拉 上拉加载
- (void)addMJRefresh
{
    //下拉刷新
    MJRefreshNormalHeader *header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateFocus)];
    self.collectionView.header = header;
    
    //上拉加载
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTypeData)];
}
#pragma mark -无订阅分类的ImageView
-(void)addNoSubscriptionImageView
{
    noSubscriptionImageview=[[KBNoSubscriptionImageView alloc]initWithFrame:CGRectMake(kWindowSize.width/2.0-80, kWindowSize.height/2.0-170, 160,200) withItemNumber:_itemNumber];
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
        [_scrollerView buildScrollerViewImagesWith:columnAllData.columnTopData];
        
        pageNumber++;
        //刷新表格
        self.collectionView.footer=footer;
        [self.collectionView reloadData];
    }
    else
    {
        [self showGifView];
    }
}
#pragma mark - 滚动到当前的分类加载数据,更新分类的数据，由通知调用或者下拉刷新调用
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
            [_scrollerView buildScrollerViewImagesWith:columnScrollerImageArray];
            [footer removeFromSuperview];
            [self.collectionView addSubview:noSubscriptionImageview];
            self.collectionView.backgroundColor=[UIColor whiteColor];
            self.collectionView.bounces=NO;
            [self.collectionView reloadData];
        }
        else
        {
            [noSubscriptionImageview removeFromSuperview];
            self.collectionView.bounces=YES;
            NSString *url;
            //判断是否更新了订阅的分类
            if (commonSingleValueModel.isChangeInterest) {
                url=KTypeClearCacheNoLoginedUrl(kBaseUrl,_itemNumber, pageNumber);
                commonSingleValueModel.isChangeInterest=NO;
            }
            else
                url=KTypeHaveCacheNoLoginedUrl(kBaseUrl, _itemNumber,pageNumber);
            //请求的参数
            NSDictionary * mainFocusList=[KBPostParametersModel setNoLoginParameters: [[KBLoginSingle newinstance].userInterestNoStructArray objectAtIndex:_itemNumber-2] addItemNumber:_itemNumber];
            //NSLog(@"mainFocus:%@",mainFocusList);
            [KBHTTPTool postRequestWithUrlStr:url parameters:mainFocusList completionHandr:^(id responseObject) {
                KBLog(@"responset:%@",responseObject);
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
                    self.collectionView.backgroundColor=KColor_230;//背景色
                    columnScrollerImageArray=[[NSMutableArray alloc ]initWithArray:columnAllData.columnTopData];
                    NSLog(@"COLU:%@",columnScrollerImageArray);
                    if (columnScrollerImageArray.count!=0) {
                        [self.collectionView addSubview: _scrollerView];
                    }

                    //刷新顶部的轮播视图
                    [_scrollerView buildScrollerViewImagesWith:columnAllData.columnTopData];
                    pageNumber++;
                    //刷新表格
                    [defineGifView removeFromSuperview];//移除动画
                    self.collectionView.footer=nil;
                    self.collectionView.footer=footer;
                    [self.collectionView reloadData];
                    [self.collectionView.header endRefreshing];

                }
                else
                {
                    [defineGifView removeFromSuperview];//移除动画
                    [self.collectionView.header endRefreshing];
                }
                
            } error:^(NSError *error) {
                KBLog(@"兴趣error:%@",error);
                [defineGifView removeFromSuperview];//移除动画
                [self.collectionView.header endRefreshing];
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
            self.collectionView.bounces=YES;
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
                    [_scrollerView buildScrollerViewImagesWith:columnAllData.columnTopData];
                    if (columnScrollerImageArray.count!=0) {
                        [self.collectionView addSubview: _scrollerView];
                    }
                    [cacheDictionary setObject:responseObject forKey:[NSString stringWithFormat:@"%ld",(long)_itemNumber]];
                    [cacheDictionary writeToFile:filename atomically:YES];
                    pageNumber++;
                    //刷新表格
                    [defineGifView removeFromSuperview];//移除动画
                    self.collectionView.footer=nil;
                    self.collectionView.footer=footer;
                    [self.collectionView reloadData];
                    [self.collectionView.header endRefreshing];
                }
                else
                {
                    [defineGifView removeFromSuperview];//移除动画
                    [self.collectionView.header endRefreshing];
                }
            } error:^(NSError *error) {
                NSLog(@"error:%@",error);
                [defineGifView removeFromSuperview];//移除动画
                [self.collectionView.header endRefreshing];
            }];
            
        }
        else
        {
            columnTypeArray=[[NSMutableArray alloc]init];
            columnScrollerImageArray=[[NSMutableArray alloc]init];
            //刷新顶部的轮播视图
            [_scrollerView buildScrollerViewImagesWith:columnScrollerImageArray];
            [footer removeFromSuperview];
            
            [self.collectionView addSubview:noSubscriptionImageview];
            self.collectionView.bounces=NO;
            [self.collectionView reloadData];
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
                [self.collectionView reloadData];
                [self.collectionView.footer endRefreshing];
                
            }
            else
            {
                [self.collectionView.footer endRefreshing];
            }
        } error:^(NSError *error) {
            [self.collectionView.footer endRefreshing];
        }];
        
    }
    else
    {
        NSDictionary * mainFocusList=[KBPostParametersModel setNoLoginParameters:[[KBLoginSingle newinstance].userInterestNoStructArray objectAtIndex:_itemNumber-2] addItemNumber:_itemNumber];
        [KBHTTPTool postRequestWithUrlStr:KTypeHaveCacheNoLoginedUrl(kBaseUrl, _itemNumber,pageNumber) parameters:mainFocusList completionHandr:^(id responseObject) {
            NSString * isLastStr=responseObject[@"isLast"];
            //是否到最后一页，无数据
            if ([isLastStr intValue]==0)
            {
                //处理数据
                [columnAllData setDataWithDictionary:responseObject addTypeArray:columnTypeArray withItemNumber:_itemNumber
                 ];
                columnTypeArray=[NSMutableArray arrayWithArray:columnAllData.columnTypeData];
                pageNumber++;
                //刷新表格
                [self.collectionView reloadData];
                [self.collectionView.footer endRefreshing];
                
            }
            else
            {
                [self.collectionView.footer endRefreshing];
            }
            
        } error:^(NSError *error) {
            KBLog(@"error:%@",error);
            [self.collectionView.footer endRefreshing];
        }];
    }
}
#pragma mark - 轮播视图 点击 代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //取出model
    KBColumnModel * scrollerModel =columnScrollerImageArray [index];
    [webViewInfoModel setWebviewInfoColumnModel:scrollerModel];
    
    KBInfoWebViewController * infoWebVC=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:infoWebVC animated:YES];
    
}

#pragma mark - cell的代理
- (void)setCellSizeWithIndexPath:(NSIndexPath *)indexPath
{
    //更新cell的大小
   dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
   });
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [columnTypeArray count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KBInterestViewCell *cell = (KBInterestViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"INTERESTCLL"
                                                                           forIndexPath:indexPath];
    cell.delegate = self;
    [cell setSelected:NO];
    [cell setInterestCellWithModel:columnTypeArray[indexPath.row] andIndexPath:indexPath ];
    return cell;
}
#pragma mark - 返回每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KBColumnModel *model = columnTypeArray[indexPath.row];
    
    if (!CGSizeEqualToSize(model.imageSize,CGSizeZero)) {
        return model.imageSize;
    }
    return CGSizeMake(150, 185);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _scrollerView.height;
    }
    return 0 ;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 0.00000001;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KBColumnModel * columnModel=columnTypeArray[indexPath.row];
    [webViewInfoModel setWebviewInfoColumnModel:columnModel];
    KBInfoWebViewController *infoWebVC=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:infoWebVC animated:YES];
}
@end
