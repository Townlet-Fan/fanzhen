//
//  NewTypeThreeViewControl.m
//  UIScroll1
//
//  Created by kuibu technology on 15/9/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSortDetailViewControl.h"
#import "KBThreeSortDetailViewCell.h"
#import "KBThreeSortEllipseView.h"
#import "KBInfoWebViewController.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperation.h"
#import "KBCommonSingleValueModel.h"
#import "KBBaseNavigationController.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBProgressHUD.h"
#import "KBWhetherReachableModel.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
#import "KBConstant.h"
#import "KBHTTPTool.h"
#import "KBSortDetailModel.h"
#import "KBSortDetailAllData.h"
#import "MJRefresh.h"
#import "KBWebviewInfoModel.h"
@interface KBSortDetailViewControl ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,UICollectionViewDelegateFlowLayout>

{
    AppDelegate* appDelegate;
    
    KBThreeSortEllipseView * topView;//上方弧线的View
    
    NSInteger pageNumber;//分页数
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
  
    NSMutableArray* threeArray;//三级分类界面所有数据的数组
    
    KBLoginSingle * loginSingle;//用户的单例
    
    UIAlertView *alterView;//提示
    
    UIButton * rightBarButton;//导航栏右侧button
    
    NSMutableArray * interestallTypeArray;//关注的所有分类的数组 有结构的 二级和三级之间相对应的结构
    
    NSMutableArray * interestNoallTypeArray;//关注的所有分类的数组 里面存的三级分类的
    
    NSMutableArray * allTypeArray;//所有分类的数组
    
    BOOL isInterest;//该三级分类是否订阅
    
    int interestItemNumber;//该三级分类对应的一级分类
    
    KBSortDetailAllData * sortDetailAllData;//三级分类界面所有数据的Model
    
    MJRefreshAutoNormalFooter * footer;//上拉加载更多footer
    
    KBWebviewInfoModel * webviewInfoModel;//正文的Modl
}
@end

@implementation KBSortDetailViewControl
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    loginSingle=[KBLoginSingle newinstance];
    interestallTypeArray=loginSingle.userInterestStructArray;
    interestNoallTypeArray=loginSingle.userInterestNoStructArray;
    allTypeArray=loginSingle.userAllTypeArray;
    pageNumber=1;
    sortDetailAllData=[[KBSortDetailAllData alloc]init];
    webviewInfoModel=[KBWebviewInfoModel newinstance];
    //提示
    alterView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法连接到网络,请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //导航栏
    [self addNavgationItem];
    
    //collectionViewFlowLayout
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(kWindowSize.width, 190);
    flowLayout.footerReferenceSize=CGSizeMake(kWindowSize.width, 5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor=KColor_52;
    
    //设置代理
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.scrollsToTop=NO;
    self.collectionView.bounces = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled=YES;
    [self.view addSubview:self.collectionView];

    //顶部弧线View
    [self addTopView];
    //加入下拉刷新
    [self addMjRefreshInTableHeadView];
    //加入上拉加载更多
    [self addMjRefreshInTableFooterView];
    
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[KBThreeSortDetailViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewHead"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReusableViewFooter"];

    //加载第一页数据
    [self threeTypeDetailData];
}
#pragma mark - 导航栏
-(void)addNavgationItem
{
    self.navigationController.navigationBarHidden=YES;
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    [navigationBar setBarTintColor:KColor_163_128_216];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    //右侧的button
    rightBarButton=[[UIButton alloc]init];
    [rightBarButton setFrame:CGRectMake(kWindowSize.width-60, 30, 58, 25)];
    rightBarButton.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBarButton.layer.borderWidth=2;
    rightBarButton.layer.cornerRadius=12.5;
    rightBarButton.contentMode=UIViewContentModeScaleAspectFit;
    rightBarButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    rightBarButton.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    rightBarButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    if ([KBSortDetailModel whetherThreeTypeSubscription:self.thirdTypeName]) {
        rightBarButton.backgroundColor=[UIColor clearColor];
        [rightBarButton setTitle:@"已订阅" forState:UIControlStateNormal];
        [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBarButton addTarget:self action:@selector(typeThreeInterestNo) forControlEvents:UIControlEventTouchDown];
    }
    else
    {
        [rightBarButton setTitle:@"订阅" forState:UIControlStateNormal];
        rightBarButton.backgroundColor=[UIColor whiteColor];
        [rightBarButton setTitleColor:KColor_163_128_216 forState:UIControlStateNormal];
        [rightBarButton addTarget:self action:@selector(typeThreeInterest) forControlEvents:UIControlEventTouchDown];
    }
    //左侧button
    UIButton * leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popTypeThree) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    //设置导航栏title
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=self.thirdTypeName;
    titleLable.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    [navigationItem setTitleView:titleLable];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftBackItem];
    [navigationItem setRightBarButtonItem:rightItem];
    [self.view addSubview:navigationBar];
}
#pragma mark - 顶部弧线View
-(void)addTopView
{
    topView=[[KBThreeSortEllipseView alloc ]initWithFrame:CGRectMake(0, 64, kWindowSize.width,70)];
    topView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:topView];
}
#pragma mark - 加入下拉刷新
- (void)addMjRefreshInTableHeadView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(threeTypeDetailData)];
    self.collectionView.header = header;
}
#pragma mark - 加入上拉加载更多
-(void)addMjRefreshInTableFooterView
{
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTypeData)];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.collectionView.scrollsToTop=YES;
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
    self.navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    self.collectionView.scrollsToTop=NO;
    self.navigationController.navigationBarHidden=NO;
    commonSingleValueModel.isThreeEnterTitle=NO;
    if (commonSingleValueModel.istouchDownInterest) {
        [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",interestItemNumber+1] object:nil];
    }
}

#pragma mark - 视图已经消失
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    [alterView removeFromSuperview];
}
#pragma mark - 加载第一页数据
-(void)threeTypeDetailData
{
    pageNumber=1;
    [KBHTTPTool getRequestWithUrlStr:KTheeTypeDetailUrl(kBaseUrl, self.secondTypeID, self.thirdTypeName, pageNumber) parameters:nil completionHandr:^(id responseObject) {
        NSString   * isLastStr=responseObject[@"isLast"];
        if ([isLastStr intValue]==0)
        {
            [sortDetailAllData setDataWithDictionary:responseObject];
            threeArray=[NSMutableArray arrayWithArray:sortDetailAllData.threeTypeAllArray];
            pageNumber++;
            self.collectionView.footer=nil;
            self.collectionView.footer=footer;
            [self.collectionView reloadData];
            [self.collectionView.header endRefreshing];
        }
        else
            [self.collectionView.header endRefreshing];
        
    } error:^(NSError *error) {
       [self.collectionView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kWindowSize.width,10};
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={kWindowSize.width,5};
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return threeArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentify=@"cell";
    KBThreeSortDetailViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        ;
    }
    KBColumnModel * threeTypeDetailModel = threeArray[indexPath.row];
    [cell setThreeSortDetailViewCellWithModel:threeTypeDetailModel];
    return cell;
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kWindowSize.width/2)-2, ([[UIScreen mainScreen] bounds].size.width-10)/2);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 2);//分别为上、左、下、右
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KBColumnModel * threeTypeDetailModel = threeArray[indexPath.row];
    [webviewInfoModel setWebviewInfoColumnModel:threeTypeDetailModel];
    KBInfoWebViewController *infoWebVC=[[KBInfoWebViewController alloc]init];
    infoWebVC.navdelegate=self.threeDelegate;
    [commonSingleValueModel.navcontrolDelegate pushViewController:infoWebVC animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - 三级分类的订阅
-(void)typeThreeInterest
{
    if (![KBWhetherReachableModel whetherReachable]) {
        [alterView show];
    }
    else
    {
        commonSingleValueModel.istouchDownInterest=YES;
        if (loginSingle.isLogined) {
            [KBHTTPTool postRequestWithUrlStr:KThreeTypeSingleSubscriptionUrl(kBaseUrl,loginSingle.userID,self.secondTypeID,self.thirdTypeName) parameters:nil completionHandr:^(id responseObject) {
                NSString * subscriResultstr= [responseObject valueForKey:@"subscriResult"];
                NSLog(@"[jsondic valueForKey:]:%@",[responseObject valueForKey:@"subscriResult"]);
                if ([subscriResultstr intValue]==1) {
                    NSLog(@"订阅成功");
                    [self subscriptionSuccess];
                }

            } error:^(NSError *error) {
                
            }];
        }
        else
        {
            [self subscriptionSuccess];
        }
    }
}
-(void)typeThreeInterestNo
{
    if (![KBWhetherReachableModel whetherReachable]) {
        [alterView show];
    }
    else
    {
        commonSingleValueModel.istouchDownInterest=YES;
        if (loginSingle.isLogined) {
            [KBHTTPTool postRequestWithUrlStr:KThreeTypeSingleCancelSubscriptionUrl(kBaseUrl, loginSingle.userID, self.secondTypeID, self.thirdTypeName) parameters:nil completionHandr:^(id responseObject) {
                NSString * removeSubscriResultstr= [responseObject valueForKey:@"removeSubscriResult"];
                if ([removeSubscriResultstr intValue]==1) {
                    NSLog(@"取消订阅成功");
                    [self subscriptionCancel];
                }

            } error:^(NSError *error) {
                ;
            }];
        }
        else
        {
            [self subscriptionCancel];
        }
    }
}
#pragma mark - 订阅后rightBarButton的改变
-(void)subscriptionSuccess
{
    interestItemNumber=[KBSortDetailModel threeTypeSubcription:self.thirdTypeName];
    rightBarButton.backgroundColor=[UIColor clearColor];
    [rightBarButton setTitle:@"已订阅" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarButton removeTarget:self action:@selector(typeThreeInterest) forControlEvents:UIControlEventTouchDown];
    [rightBarButton addTarget:self action:@selector(typeThreeInterestNo) forControlEvents:UIControlEventTouchDown];
}
#pragma mark - 取消订阅后rightBarButton的改变
-(void)subscriptionCancel
{
    interestItemNumber=[KBSortDetailModel threeTypeCancelSubcription:self.thirdTypeName];
    [rightBarButton setTitle:@"订阅" forState:UIControlStateNormal];
    rightBarButton.backgroundColor=[UIColor whiteColor];
    [rightBarButton setTitleColor:KColor_163_128_216 forState:UIControlStateNormal];
    [rightBarButton removeTarget:self action:@selector(typeThreeInterestNo) forControlEvents:UIControlEventTouchDown];
    [rightBarButton addTarget:self action:@selector(typeThreeInterest) forControlEvents:UIControlEventTouchDown];
}
-(void)loadMoreTypeData
{
    [KBHTTPTool getRequestWithUrlStr:KTheeTypeDetailUrl(kBaseUrl, self.secondTypeID, self.thirdTypeName, pageNumber) parameters:nil completionHandr:^(id responseObject) {
        NSString   * isLastStr=responseObject[@"isLast"];
        if ([isLastStr intValue]==0)
        {
            [sortDetailAllData setDataWithDictionary:responseObject];
            [threeArray addObjectsFromArray: sortDetailAllData.threeTypeAllArray];
            pageNumber++;
            [self.collectionView reloadData];
            [self.collectionView.footer endRefreshing];
        }
        else
            [self.collectionView.footer endRefreshing];
        
    } error:^(NSError *error) {
        [self.collectionView.footer endRefreshing];
    }];
}
#pragma mark - 返回
-(void)popTypeThree{
    [self.navigationController popViewControllerAnimated:YES];
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
