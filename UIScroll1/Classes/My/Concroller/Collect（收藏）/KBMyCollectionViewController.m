//
//  NewCollectionVC.m
//  UIScroll1
//
//  Created by xiaoxuehui on 15/7/31.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMyCollectionViewController.h"
#import "KBJudgeTwoSortIdModel.h"
#import "AppDelegate.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "KBInfoWebViewController.h"
#import "rootViewController.h"
#import "KBTwoSortModel.h"
#import "KBMyFooterViewCell.h"
#import "UIImageView+WebCache.h"
#import "KGStatusBar.h"
#import "KBMyCollectionDataModel.h"
#import "KBWhetherReachableModel.h"
#import "KBBaseNavigationController.h"
#import "MJRefresh.h"
#import <sqlite3.h>
#import "KBMyCollectBottomView.h"
#import "KBMyCollectionDeleteView.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBMyCollectionSecondTypeSelectView.h"
#import "KBHTTPTool.h"
#import "KBMyCollectionAllDataModel.h"
#import "KBWebviewInfoModel.h"
//cell的高度
#define ROW_HEIGHT 85

@interface KBMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,KBMyCollentBottomViewDelegate,KBMyCollectionDeleteViewDelegate,KBMyCollectionSecondTypeSelectViewDelegate>
{
    NSMutableArray *dataSourceArray;//最后经过处理的收藏的数组
    
    UIBarButtonItem *rightRefreshItem;//右侧的刷新

    NSMutableArray *selectedIndexpathArray;//选中的Indexpath的数组
    
    NSMutableIndexSet *selectedRowIndexes;//选中的行数
    
    NSMutableArray *deleteArray;//删除的数组
    
    NSMutableArray *deleteIDArray;//删除的ID的数组
    
    sqlite3 *db;//数据库
    
    AppDelegate* appDelegate;
    
    KBLoginSingle * loginSingle;//用户的单例
    
    KBCommonSingleValueModel * commomSingleValueModel;//传值的单例
    
    NSMutableArray * collectArray;//收藏的数组
    
    NSInteger pageNumber;//分页数
    
    NSString * deletedstr;//删除字符串
    
    KBMyCollectBottomView * underView;//收藏下的UIView 删除和筛选
    
    MJRefreshAutoNormalFooter * footer;//上拉加载更多footer
    
    KBMyCollectionSecondTypeSelectView *selectView; //点击筛选出现的view
    
    UITableView *selectTableView;//右侧的筛选的tableview
    
    KBJudgeTwoSortIdModel *judgeTwoSortIdModel;//判断二级分类的Model
    
    NSMutableArray *typeStructArray;//二级分类Id相等的数组
    
    NSMutableArray *selectViewSecondTypeDataArray;//右侧筛选二级分类的数组
    
    NSMutableArray *allDataArray;//所有未登录收藏总的数组
    
    UILabel *titleLable; // 导航栏的标题
    
    int allcount;//所有收藏的总数

    NSMutableArray *secondArray;//二级分类的数组
    
    NSIndexPath *selectedIndex;//选中二级分类的indexpath
    
    NSInteger secondtype;//二级分类的Id
    
    NSTimer  *timer;//定时器
    
    BOOL isdelete;//是否在删除
    
    KBMyCollectionDeleteView * deleteView;//底部删除view
    
    NSIndexPath * cancelPath;//取消收藏的indexpath
    
    KBMyCollectionAllDataModel * allDataModel;//所有数据的Model
    
    KBWebviewInfoModel * webViewInfoModel;//正文数据的Model
}
@end

@implementation KBMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    pageNumber=1;
    isdelete=YES;
    allcount=0;
    dataSourceArray=[[NSMutableArray alloc]init];
    typeStructArray=[[NSMutableArray alloc]init];
    allDataArray=[[NSMutableArray alloc]init];
    selectViewSecondTypeDataArray =[[NSMutableArray alloc]init];
    deleteArray=[[NSMutableArray alloc]init];
    deleteIDArray=[[NSMutableArray alloc]init];
    judgeTwoSortIdModel=[[KBJudgeTwoSortIdModel alloc]init];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    loginSingle=[KBLoginSingle newinstance];
    commomSingleValueModel=[KBCommonSingleValueModel newinstance];
    deletedstr=[[NSString alloc]init];
    selectedRowIndexes =[[NSMutableIndexSet alloc]init];
    selectedIndexpathArray=[[NSMutableArray alloc]init];
    selectedIndex=nil;
    allDataModel=[[KBMyCollectionAllDataModel alloc]init];
    webViewInfoModel = [KBWebviewInfoModel newinstance];
    
    //导航栏
    [self addNavigationItem];
    //收藏下的UIView 删除和筛选
    [self addUnderCollectionView];
    
    //分割的View
    UIView * sepratorView=[[UIView alloc]initWithFrame:CGRectMake(0, underView.frame.origin.y+underView.frame.size.height, kWindowSize.width, 5)];
    sepratorView.backgroundColor=KColor_235;
    [self.view addSubview: sepratorView];
    
    //初始化设置tableview
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, sepratorView.bottom, kWindowSize.width, kWindowSize.height-(sepratorView.bottom)) style:UITableViewStylePlain];
    self.tableView.scrollsToTop=NO;
    self.tableView.bounces=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight=ROW_HEIGHT;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        self.tableView.allowsMultipleSelectionDuringEditing=YES;
    
    //底部出现删除view
    [self addBottomDeleteView];
    
    //点击筛选的出现的view
    [self addRightSeleteView];

    //加入上拉加载更多 登录下
    if (loginSingle.isLogined) {
        [self addMjRefreshInTableFooterView];
    }
    
    
    //手势点击收起筛选的view
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGr];
    
    //接收通知刷新操作删除后的收藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshFormCancelCollect) name:@"REFRESH_COLLECT" object:nil];
    //判断登录还是未登录
    if (!loginSingle.isLogined)
    {
        [self unloginedcollect];
    }
    if (loginSingle.isLogined)
    {
        [self performSelector:@selector(loginedcollect) withObject:nil afterDelay:0.3];
    }
}
#pragma mark - 导航栏的设置
-(void)addNavigationItem
{
    //导航栏设置
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
    //标题
    titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"收藏";
    titleLable.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    
    //右边刷新按钮
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(refreshCollect) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * rightImageView=[[UIImageView alloc]initWithFrame:rightBtn.frame];
    rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    rightImageView.image=[UIImage imageNamed:@"刷新"];
    [rightBtn addSubview:rightImageView];
    rightRefreshItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightRefreshItem setTitle:@""];
    [rightRefreshItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=rightRefreshItem;
    
    //左边的返回按钮
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:KBackImage forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popMyCollection) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem=leftBackItem;
}
#pragma mark - 收藏下的UIView 删除和筛选
-(void)addUnderCollectionView
{
    //收藏下的UIView 删除和筛选
    underView=[[KBMyCollectBottomView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom,kWindowSize.width, 40)];
    underView.delegate=self;
    underView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:underView];
}
#pragma mark - 底部出现删除view
-(void)addBottomDeleteView
{
    deleteView=[[KBMyCollectionDeleteView alloc]initWithFrame:CGRectMake(0,kWindowSize.height, kWindowSize.width, 64)];
    deleteView.delegate=self;
    deleteView.backgroundColor=KColor_240;
    [self.view addSubview:deleteView];
}
#pragma mark - 点击删除，出现底部删除view
-(void)beginDelete{
    if (isdelete) {
        [UIView animateWithDuration:0.3 animations:^{
            underView.deleteLabel.textColor=KColor_15_86_192;
            underView.deleteImageView.image=[UIImage imageNamed:@"删除小蓝"];
            [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
            [deleteView setFrame:CGRectMake(0,kWindowSize.height-64,kWindowSize.width,64)];
            isdelete=NO;
            [self.tableView setEditing:YES animated:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            underView.deleteLabel.textColor=[UIColor grayColor];
            underView.deleteImageView.image=[UIImage imageNamed:@"删除小灰"];
            [deleteView setFrame:CGRectMake(0,kWindowSize.height,kWindowSize.width,64)];
            [self.tableView setEditing:NO animated:YES];
            isdelete=YES;
            [selectedIndexpathArray removeAllObjects];
            [selectedRowIndexes removeAllIndexes];
        }];
    }
}
#pragma mark - 点击筛选的出现的view
-(void)addRightSeleteView
{
    selectView=[[KBMyCollectionSecondTypeSelectView alloc]initWithFrame:CGRectMake(kWindowSize.width, 64, kWindowSize.width/3.0+kWindowSize.width*0.03, kWindowSize.height-64)];
    selectView.delegate=self;
    [selectView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:selectView];
    
    //筛选的tableview
    selectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 63, selectView.width, selectView.height-63) style:UITableViewStylePlain];
    selectTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    selectTableView.backgroundColor=[UIColor whiteColor];
    selectTableView.delegate=self;
    selectTableView.dataSource=self;
    selectTableView.tag=99;
    selectTableView.scrollsToTop=NO;
    selectTableView.rowHeight=40;
    [selectView addSubview:selectTableView];
}
#pragma mark - 加入上拉加载更多
-(void)addMjRefreshInTableFooterView
{
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTypeData)];
    self.tableView.footer=footer;
}
#pragma mark -  全选
-(void)allDelelte
{
    if ([deleteView.allDeteleButton.titleLabel.text isEqualToString:@"全选"]) {
        for (int i=0; i<dataSourceArray.count;i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [selectedIndexpathArray addObject:indexPath];
            [selectedRowIndexes addIndex:indexPath.row ];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }
        if (selectedIndexpathArray.count!=0) {
            [deleteView.allDeteleButton setTitle:@"取消全选" forState:UIControlStateNormal];
        }
    }
    else
    {
        for (int i=0; i<dataSourceArray.count;i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [selectedIndexpathArray removeObject:indexPath];
            [selectedRowIndexes removeIndex:indexPath.row];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
    }
}
#pragma mark - 删除
-(void)deleteCollect
{
    //添加到删除的数组
    if (loginSingle.isLogined) {
        [deleteArray addObjectsFromArray:[dataSourceArray objectsAtIndexes:selectedRowIndexes]];
    }
    else
        [deleteArray addObjectsFromArray:[dataSourceArray objectsAtIndexes:selectedRowIndexes]];
    //收藏文章的pageId的数组
    [deleteIDArray addObjectsFromArray:deleteArray];
    [dataSourceArray removeObjectsAtIndexes:selectedRowIndexes];
    [self.tableView deleteRowsAtIndexPaths:selectedIndexpathArray withRowAnimation:UITableViewRowAnimationFade];
    //登录与未登录的删除
    if(loginSingle.isLogined)
        [self loginedDelete];
    else
        [self unloginedDelete];
    //数组清空 恢复
    [selectedIndexpathArray removeAllObjects];
    [selectedRowIndexes removeAllIndexes];
    [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
}
#pragma mark - 刷新收藏
-(void)refreshCollect
{
    if (!loginSingle.isLogined)
    {
        [self unloginedcollect];
    }
    else
    {
        if (selectedIndex!=nil) {
            [self loginedcollectWithSecondType:secondtype];
            [self cancelCollection];
        }
        else
        {
            [self loginedcollect];
        }
    }
}
#pragma mark - 取消收藏的IndexPath
-(void)CancelCollect:(NSIndexPath *)indexpath
{
    cancelPath=indexpath;
}
#pragma mark - 取消收藏后的刷新
-(void)refreshFormCancelCollect
{
    if (loginSingle.isLogined) {
        NSLog(@"datasourcearray:%lu",(unsigned long)dataSourceArray.count
              );
        NSLog(@"indexpath:%ld",(long)cancelPath);
        [dataSourceArray removeObjectAtIndex:cancelPath.row];
        [self.tableView reloadData];
        [self cancelCollection];
    }
    else
        [self unloginedcollect];
}
#pragma mark - 没登录的收藏
-(void)unloginedcollect
{
    {
        NSMutableArray * myCollectionArray = [[NSMutableArray alloc]init];
        dataSourceArray=nil;
        dataSourceArray=[[NSMutableArray alloc]init];
        typeStructArray=nil;
        typeStructArray=[[NSMutableArray alloc]init];
        selectViewSecondTypeDataArray=nil;
        selectViewSecondTypeDataArray=[[NSMutableArray alloc]init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
        if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
        }
        
        NSString *sqlQuery = @"SELECT * FROM Collection order by ID DESC";
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                KBMyCollectionDataModel *myData=[[KBMyCollectionDataModel alloc]init];
                int ID=sqlite3_column_int(statement, 0);
                int pageID = sqlite3_column_int(statement, 1);
                char *title = (char*)sqlite3_column_text(statement, 2);
                char *type=(char *)sqlite3_column_text(statement, 3);
                char *secondType=(char *)sqlite3_column_text(statement, 4);
                char *time=(char *)sqlite3_column_text(statement, 5);
                char *imagestr=(char *)sqlite3_column_text(statement, 6);
                Byte *imagedata=(Byte *)sqlite3_column_blob(statement, 7);
                int length=sqlite3_column_bytes(statement, 7);
//                //模型初始化
//                allDataModel = [[KBMyCollectionAllDataModel alloc]init];
//               //封装成字典
//                NSDictionary * myCollectionDic=[allDataModel setDictionaryWithData:[[NSString alloc]initWithUTF8String:title] withDate:[[NSString alloc]initWithUTF8String:time] withTypeName:[[NSString alloc]initWithUTF8String:type] withSecondType:[[NSString alloc]initWithUTF8String:secondType] withPageId:[NSNumber numberWithInt:pageID] withImageStr:[[NSString alloc]initWithUTF8String:imagestr] withImageData:[UIImage imageWithData:[NSData dataWithBytes: imagedata   length:length]]];
//                [myCollectionArray addObject:myCollectionDic];
                myData.ID=ID;
                
                
                myData.TypeName=[[NSString alloc]initWithUTF8String:type];
                // myData.secondType=
                myData.pageID=[NSNumber numberWithInt:pageID];
                
                myData.time=[[NSString alloc]initWithUTF8String:time];
                myData.articleTitle=[[NSString alloc]initWithUTF8String:title];
                myData.secondType=[[NSString alloc]initWithUTF8String:secondType];
                
                myData.imagestr=[[NSString alloc]initWithUTF8String:imagestr];
                
                NSData *data = [NSData dataWithBytes: imagedata   length:length];
                
                myData.imageData=[UIImage imageWithData:data];
                [dataSourceArray addObject:myData];

            }
//            NSMutableDictionary * responseObject = [[NSMutableDictionary alloc]init];
//            [responseObject setObject:myCollectionArray forKey:@"collectList"];
//            [allDataModel setDataWithDictionary:responseObject];
//            dataSourceArray =[NSMutableArray arrayWithArray:allDataModel.collectArray];
            
        }
        sqlite3_close(db);
        
        //备份未登录的全部的收藏
        allDataArray =[[NSMutableArray alloc]initWithArray:dataSourceArray];
        //获得有结构的typeStructArray 和主界面四个分类的数据处理一样
        for (NSInteger i = 0; i < [dataSourceArray count]; i++)
        {
            BOOL isExist=NO;
            
            KBMyCollectionDataModel *myData=[dataSourceArray objectAtIndex:i];
            judgeTwoSortIdModel.ID=[myData.secondType intValue];
            
            for (int j=0; j<typeStructArray.count; j++) {
                KBJudgeTwoSortIdModel *data=[typeStructArray objectAtIndex:j];
                if (data.ID==judgeTwoSortIdModel.ID) {
                    isExist=YES;
                    
                    [data.subArticleArray addObject:myData];
                }
            }
            if (isExist==NO) {
                [judgeTwoSortIdModel.subArticleArray addObject:myData];
                [typeStructArray addObject:judgeTwoSortIdModel];
                judgeTwoSortIdModel=[[KBJudgeTwoSortIdModel alloc]init];
                
            }
        }
        
        //筛选列表数据
        for (int i=0; i<typeStructArray.count; i++) {
            KBJudgeTwoSortIdModel *data= [typeStructArray objectAtIndex:i];
            for (int j=0; j<5; j++) {
                NSArray *typeOneInterestArray=[loginSingle.userAllTypeArray objectAtIndex:j];
                for (int i=0; i<typeOneInterestArray.count; i++) {
                    KBTwoSortModel *find_2=[typeOneInterestArray objectAtIndex:i];
                    if (data.ID==find_2.TypeTowID) {
                        [selectViewSecondTypeDataArray addObject:find_2.name];
                    }
                }
                
            }
        }
        selectView.btnLabel.text=[NSString stringWithFormat:@"全 部  %lu",(unsigned long)dataSourceArray.count];
        [selectTableView setFrame:CGRectMake(selectTableView.left,selectTableView.top, selectTableView.width, selectTableView.rowHeight*selectViewSecondTypeDataArray.count)];
        [self.tableView reloadData];
        [selectTableView reloadData];
        
    }
    
}
#pragma mark - 登录后的收藏
-(void)loginedcollect
{
    pageNumber=1;
    [KBHTTPTool getRequestWithUrlStr:KCollectLoginUrl(kBaseUrl,loginSingle.userID,pageNumber) parameters:nil completionHandr:^(id responseObject) {
        KBLog(@"responseonject;%@",responseObject);
        allDataModel=[[KBMyCollectionAllDataModel alloc]init];
        [allDataModel setDataWithDictionary:responseObject];
        dataSourceArray=nil;
        dataSourceArray=[[NSMutableArray alloc]init];
        dataSourceArray =[NSMutableArray arrayWithArray: allDataModel.collectArray];
        
        KBLog(@"collectArray:%@",dataSourceArray);
        
        allcount=allDataModel.allcount;
        
        selectView.btnLabel.text=[NSString stringWithFormat:@"全 部  %d",allcount];
        
        selectViewSecondTypeDataArray=nil;
        selectViewSecondTypeDataArray=[[NSMutableArray alloc]init];
        
        NSDictionary *secondTypeDic=[responseObject[@"secondTypeList"] objectAtIndex:0];
        KBLog(@"secondTypeDic:%@",secondTypeDic);
        selectViewSecondTypeDataArray=(NSMutableArray *)[self useSecondListReturnSelectData:secondTypeDic];
        
        [selectTableView setFrame:CGRectMake(selectTableView.left,selectTableView.top, selectTableView.width, selectTableView.rowHeight*selectViewSecondTypeDataArray.count)];
        pageNumber++;
        [self.tableView reloadData];
        [selectTableView reloadData];
    } error:^(NSError *error) {
        ;
    }];
}
#pragma mark - 加载更多
-(void)loadMoreTypeData
{
    if (loginSingle.isLogined) {
        {
            //根据二级分类单独加载更多
            if (selectedIndex)
            {
                [KBHTTPTool postRequestWithUrlStr:KCollectLoginSelectSecondTypeUrl(kBaseUrl, loginSingle.userID, secondtype, pageNumber) parameters:nil completionHandr:^(id responseObject) {
                    NSString   * isLastStr=responseObject[@"isLast"];
                    if ([isLastStr intValue]==0)
                    {
                        allDataModel=[[KBMyCollectionAllDataModel alloc]init];
                        [allDataModel setDataWithDictionary:responseObject];
                        [dataSourceArray addObjectsFromArray:allDataModel.secondTypeArray];
                        pageNumber++;
                        [self.tableView reloadData];
                        [self.tableView.footer endRefreshing];
                    }
                    else
                        [self.tableView.footer endRefreshing];
                } error:^(NSError *error) {
                    [self.tableView.footer endRefreshing];
                }];
            }
            else{
                [KBHTTPTool getRequestWithUrlStr:KCollectLoginUrl(kBaseUrl,loginSingle.userID,pageNumber) parameters:nil completionHandr:^(id responseObject) {
                    NSString   * isLastStr=responseObject[@"isLast"];
                    if ([isLastStr intValue]==0)
                    {
                        [allDataModel setDataWithDictionary:responseObject];
                        [dataSourceArray addObjectsFromArray: allDataModel.collectArray];
                        pageNumber++;
                        [self.tableView reloadData];
                        [self.tableView.footer endRefreshing];
                    }
                    else
                        [self.tableView.footer endRefreshing];
                } error:^(NSError *error) {
                    [self.tableView.footer endRefreshing];
                }];
            }
            
        }
    }
}

#pragma mark - 取消收藏获取二级分类列表的新数据
-(void)cancelCollection
{
    [KBHTTPTool getRequestWithUrlStr:KCollectLoginUrl(kBaseUrl,loginSingle.userID,1) parameters:nil completionHandr:^(id responseObject) {
        allDataModel=[[KBMyCollectionAllDataModel alloc]init];
        [allDataModel setDataWithDictionary:responseObject];
        
        allcount=allDataModel.allcount;
        selectView.btnLabel.text=[NSString stringWithFormat:@"全 部  %d",allcount];
        
        NSDictionary *secondTypeDic=[responseObject[@"secondTypeList"] objectAtIndex:0];
        selectViewSecondTypeDataArray=nil;
        selectViewSecondTypeDataArray=[[NSMutableArray alloc]init];
        selectViewSecondTypeDataArray=(NSMutableArray *)[self useSecondListReturnSelectData:secondTypeDic];
        [selectTableView reloadData];

    } error:^(NSError *error) {
        ;
    }];
}
#pragma mark - 请求登录的某个二级分类
-(void)loginedcollectWithSecondType:(NSInteger)type
{
    pageNumber=1;
    [KBHTTPTool postRequestWithUrlStr:KCollectLoginSelectSecondTypeUrl(kBaseUrl, loginSingle.userID, type, pageNumber) parameters:nil completionHandr:^(id responseObject) {
        KBLog(@"response:%@",responseObject);
        allDataModel=[[KBMyCollectionAllDataModel alloc]init];
        [allDataModel setDataWithDictionary:responseObject];
        dataSourceArray=nil;
        dataSourceArray=[[NSMutableArray alloc]init];
        dataSourceArray =[NSMutableArray arrayWithArray: allDataModel.secondTypeArray];
        KBLog(@"dataSourceArray；%@",dataSourceArray);
        pageNumber++;
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } error:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}
#pragma mark - 对二级分类的数组进行处理
-(NSArray *)useSecondListReturnSelectData:(NSDictionary *)list
{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    NSEnumerator   *enumeratorKey = [list keyEnumerator];
    secondArray=[[NSMutableArray alloc]init];
    NSMutableArray *countArray=[[NSMutableArray alloc]init];
    //遍历所有KEY值
    for(NSString * key in enumeratorKey)
    {
        [secondArray addObject:key];
        // NSLog(@"遍历KEY的值: %@", key);
    }
    //将所有Value储存在 NSEnumerator 中
    NSEnumerator * enumeratorValue = [list objectEnumerator];
    
    //快速枚举遍历所有Value值
    for(NSString * value in enumeratorValue)
    {
        [countArray addObject:value];
        
        // NSLog(@"遍历Value的值: %@", value);
    }
    for (int i=0; i<secondArray.count; i++) {
        
        NSInteger secondID=[[secondArray objectAtIndex:i] integerValue];
        for (int j=0; j<5; j++) {
            NSArray *typeOneArr=[[KBLoginSingle newinstance].userAllTypeArray objectAtIndex:j];
            for (int k=0; k<typeOneArr.count;k++ )
            {
                KBTwoSortModel *find2=[typeOneArr objectAtIndex:k];
                if (find2.TypeTowID==secondID)
                {
                    // NSLog(@"secondId:%ld",(long)secondID);
                    [data addObject:[NSString stringWithFormat:@"%@(%@)",find2.name,[countArray objectAtIndex:i]]];
                }
                
            }
        }
    }
    return data;
}
#pragma mark - 显示全部收藏
-(void)showAll{
    if (loginSingle.isLogined) {
        selectView.btnLabel.textColor=KColor_15_86_192;
        [self loginedcollect];
        UITableViewCell *cell=[selectTableView cellForRowAtIndexPath:selectedIndex];
        cell.textLabel.textColor=KColor_102;
        selectedIndex=nil;
        titleLable.text=@"收藏";
    }
    else if(!loginSingle.isLogined){
        dataSourceArray=allDataArray;
        [self.tableView reloadData];
        if (dataSourceArray.count!=0) {
            selectView.btnLabel.textColor=KColor_15_86_192;
            UITableViewCell *cell=[selectTableView cellForRowAtIndexPath:selectedIndex];
            cell.textLabel.textColor=KColor_102;
            selectedIndex=nil;
            titleLable.text=@"收藏";
        }
    }
}
#pragma mark - 点击筛选
-(void)beginSelect{
    if ([rightRefreshItem.title isEqualToString:@""]) {
        [UIView animateWithDuration:0.3 animations:^{
            [selectView setFrame:CGRectMake(kWindowSize.width-(kWindowSize.width/3.0+kWindowSize.width*0.03), selectView.frame.origin.y, kWindowSize.width/3.0+kWindowSize.width*0.03, selectView.frame.size.height)];
        }];
        [rightRefreshItem setTitle:@"收起"];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            [selectView setFrame:CGRectMake(kWindowSize.width, selectView.frame.origin.y, selectView.frame.size.width, selectView.frame.size.height)];
        }];
        [rightRefreshItem setTitle:@""];
    }
}
#pragma mark - 手势点击空白，筛选view收起
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [UIView animateWithDuration:0.3 animations:^{
        [selectView setFrame:CGRectMake(kWindowSize.width, selectView.frame.origin.y, selectView.frame.size.width, selectView.frame.size.height)];
    }];
    [rightRefreshItem setTitle:@""];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, kWindowSize.width+0.5, 44)];
    KBBaseNavigationController *navVC =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated{
    [self.view setFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height+0.1)];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
    KBBaseNavigationController *navVC =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
   [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    self.tableView.scrollsToTop=YES;
}
#pragma mark - 视图已经消失
-(void)viewDidDisappear:(BOOL)animated
{
    self.tableView.scrollsToTop=NO;
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    //解决滑动返回的问题
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_LIKE" object:deletedstr];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        [selectedIndexpathArray removeObject:indexPath];
        [selectedRowIndexes removeIndex:indexPath.row];
        if (selectedIndexpathArray.count!=dataSourceArray.count) {
            [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
        }
        
    }
}

-(void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView1.tag==99){
        
        if ([KBLoginSingle newinstance].isLogined) {
            UITableViewCell *cell=[tableView1 cellForRowAtIndexPath:indexPath];
            [cell setSelected:NO];
            cell.textLabel.textColor=KColor_15_86_192;
            if (!(selectedIndex==indexPath)) {
                cell=[tableView1 cellForRowAtIndexPath:selectedIndex];
                cell.textLabel.textColor=KColor_102 ;
            }
            selectView.btnLabel.textColor=KColor_102;
            [self loginedcollectWithSecondType:[[secondArray objectAtIndex:indexPath.row] integerValue]];
            selectedIndex=indexPath;
        }
        else {
            
            KBJudgeTwoSortIdModel *data=[typeStructArray objectAtIndex:indexPath.row];
            UITableViewCell *cell=[tableView1 cellForRowAtIndexPath:indexPath];
            [cell setSelected:NO];
            cell.textLabel.textColor=KColor_15_86_192;
            if (!(selectedIndex==indexPath)) {
                cell=[tableView1 cellForRowAtIndexPath:selectedIndex];
                cell.textLabel.textColor=KColor_102;
            }
            selectView.btnLabel.textColor=KColor_102;
            selectedIndex=indexPath;
            dataSourceArray=data.subArticleArray;
            [self.tableView reloadData];
        }
    }
    else
    {
        if (self.tableView.editing) {
            [selectedIndexpathArray addObject:indexPath];
            [selectedRowIndexes addIndex:indexPath.row ];
            NSLog(@"selectedIndexpath:%lu",(unsigned long)selectedIndexpathArray.count);
            if (selectedIndexpathArray.count==dataSourceArray.count) {
                [deleteView.allDeteleButton setTitle:@"取消全选" forState:UIControlStateNormal];
            }
        }
        else{
        KBMyCollectionDataModel * myCollectionDataModel=[dataSourceArray objectAtIndex:indexPath.row];
        [webViewInfoModel setWebviewInfoMyCollectionDataModel:myCollectionDataModel];
        KBInfoWebViewController * infoWebVC=[[KBInfoWebViewController alloc]init];
        [self.navigationController pushViewController:infoWebVC animated:YES];
            [self.tableView reloadData];
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView1 numberOfRowsInSection:(NSInteger)section {
    if (tableView1.tag!=99) {
        return dataSourceArray.count;
    }
    else{
        return selectViewSecondTypeDataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%@-------------ddddd",selectViewData);
    if(tableView.tag!=99){
        KBMyFooterViewCell *cell;
        static NSString *UsualIdentifier=@"Cell";
        cell=[self.tableView dequeueReusableCellWithIdentifier:UsualIdentifier];
        if(cell==nil)
        {
            cell=[[KBMyFooterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UsualIdentifier];
            
        }
        [cell setSelected:NO];
        [cell setUsualCellWithModel:dataSourceArray[indexPath.row]];
        cell.backgroundColor= KColor_254;
        return cell;
        
    }
    else {
        if ([KBLoginSingle newinstance].isLogined) {
            UITableViewCell *cell;
            static NSString *collectionCellIdentifier = @"selectCell";
            cell = [tableView dequeueReusableCellWithIdentifier:collectionCellIdentifier];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectionCellIdentifier];
            }
            cell.textLabel.textColor=KColor_102;
            cell.textLabel.text=[selectViewSecondTypeDataArray objectAtIndex:indexPath.row];
            if(kWindowSize.width==320)
                cell.textLabel.font=[UIFont systemFontOfSize:15];
            return cell;
        }
        else{
            UITableViewCell *cell;
            static NSString *collectionCellIdentifier = @"selectCell";
            cell = [tableView dequeueReusableCellWithIdentifier:collectionCellIdentifier];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectionCellIdentifier];
            }
            
            KBJudgeTwoSortIdModel *data=[typeStructArray objectAtIndex:indexPath.row];
            cell.textLabel.textColor=KColor_102;
            cell.textLabel.text=[NSString stringWithFormat:@"%@(%lu)",[selectViewSecondTypeDataArray objectAtIndex:indexPath.row], (unsigned long)data.subArticleArray.count ];
            if(kWindowSize.width==320)
                cell.textLabel.font=[UIFont systemFontOfSize:15];
            return cell;
        }
    }
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==99) {
        return NO;
    }
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark - 登录请求服务器删除
-(void)loginedDelete
{
        for (int i=0; i<deleteArray.count; i++)
        {
            NSDictionary * deletedic=[deleteArray objectAtIndex:i];
            NSString * deleteIdStr=[deletedic objectForKey:@"collectId"];
            
            int deleteInt=[deleteIdStr intValue];
            if(i==0)
                
                deletedstr=[deletedstr stringByAppendingString:[NSString stringWithFormat:@"%d",deleteInt]];
            
            else
                deletedstr=[deletedstr stringByAppendingString:[NSString stringWithFormat:@",%d",deleteInt]];
        }
        //删除loginSing.userCollect
        for (int i=0; i<deleteArray.count; i++)
        {
            NSDictionary *dic=[deleteArray objectAtIndex:i];
            loginSingle.userCollect=[NSMutableString stringWithString:[loginSingle.userCollect stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d,",[[dic objectForKey:@"pageId"]intValue ]] withString:@""]];
        }
        if (![deletedstr isEqualToString:@""])
        {
            NSString * collectDelString1= [NSString stringWithFormat:@"{\"userId\":\"%ld\",\"deleteList\":\"%@\"}",(long)loginSingle.userID,deletedstr];
            
            NSDictionary *collectDelString = @{@"collectDelString":collectDelString1};
            // 使用AFHTTPRequestOperationManager发送POST请求
            NSString *url=[NSString stringWithFormat:@"%@/kuibuversion1/user/delCollect",kBaseUrl];
            [appDelegate.manager
             POST:url
             parameters:collectDelString  // 指定请求参数
             // 获取服务器响应成功时激发的代码块if
             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 // 当使用HTTP响应解析器时，服务器响应数据被封装在NSData中
                 // 此处将NSData转换成NSString、并使用UIAlertView显示登录结果
                 NSMutableDictionary *deletejson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                 // NSLog(@"---)))---%@",deletejson);
                 NSString* deleteResult =[deletejson objectForKey:@"delResult"];
                 int deleteresult = [deleteResult intValue];
                 if (deleteresult==1)
                 {
                    // NSLog(@"1---------");
                     [self cancelCollection];
                 }
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_LIKE" object:deletedstr];
             }
             // 获取服务器响应失败时激发的代码块
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSLog(@"获取服务器响应出错！");
             }];
            
        }
}
#pragma mark - 没登录删除数据库
-(void)unloginedDelete
{
    {
        //    //删除数据库里的内容
        //
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
        
        
        if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
        }
        const char * sql="delete from Collection   where pageid=?";
        sqlite3_stmt *stmp;
        //根据ID删除，根据PageID？
        for (int i=0; i<deleteIDArray.count; i++){
            int result= sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);
            if(result==SQLITE_OK){
                int ID;
                KBMyCollectionDataModel *data=[deleteIDArray objectAtIndex:i];
                ID=[data.pageID intValue];
                loginSingle.userCollect=[NSMutableString stringWithString:[loginSingle.userCollect stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d,",ID] withString:@""]];
                // NSLog(@"%@______++++++_____%d",  loginsingle.userCollect,ID);
                sqlite3_bind_int(stmp, 1, ID );
                int r=  sqlite3_step(stmp);
                if (r==SQLITE_DONE) {
                    NSLog(@"done!!!!");
                     [self unloginedcollect];
                }
                //插入进行判断,要用sqLite_Done来判断
            }
            else{
                NSLog(@"插入SQL语句有问题");
            }
        }
        sqlite3_close(db);
    }
}
#pragma mark - 返回
-(void)popMyCollection{
    rootViewController *root=self.rootDelegate;
    [root scrollToMenu];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
