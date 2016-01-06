//
//  SearchViewController.m
//  UIScroll1
//
//  Created by xiaoxuehui on 15/8/23.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBSearchViewController.h"
#import "KBThreeSortModel.h"
#import "KBColumnSortButton.h"
#import "KBLoginSingle.h"
#import "KBSortDetailViewControl.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "MBProgressHUD.h"
#import "KBCommonSingleValueModel.h"
#import "KBSortDetailViewControl.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
#import "UIImageView+WebCache.h"
#import "KBSeachViewCell.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "KBHTTPTool.h"
#import "KBHomeArticleModel.h"
#import "KBSearchWebInfoAllData.h"
#import "KBWebviewInfoModel.h"
@interface KBSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *searchTypeArray;//搜索分类的数组
    
    UISearchBar *searchBar;//搜索栏
    
    UITableView *tableView; //tableView
    
    AppDelegate* appDelegate;
    
    NSMutableArray *titleArray;//文章的数组
    
    NSTimer *timer;//定时器
    
    UILabel *loadingLable;//正在加载的Label
    
    UILabel *loadingFailedLable;//加载失败的Label
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    UIActivityIndicatorView *indicator;//风火轮
    
    KBLoginSingle* loginSingle;//用户的单例
    
    KBSearchWebInfoAllData *searchWebInfoAllData;//搜索文章获取所有数据
    KBWebviewInfoModel * webviewInfoModel;//文章的Model
    
}
@end

@implementation KBSearchViewController
int timerControlInt;//
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    timerControlInt=0;
    loginSingle=[KBLoginSingle newinstance];
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    searchTypeArray=[[NSMutableArray alloc]init];
    titleArray=[[NSMutableArray alloc]init];
    searchWebInfoAllData=[[KBSearchWebInfoAllData alloc]init];
    webviewInfoModel=[KBWebviewInfoModel newinstance];
    //导航栏
    [self addNavigationItem];
    
    //搜索栏
    [self addSeachBar];
    
    //tableView
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.bottom, self.view.width, kWindowSize.height-(searchBar.bottom)) style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.scrollsToTop=NO;
    [self.view addSubview:tableView];
    
    //loadingLabel
    [self addLoadingLabel];
    
    //手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
#pragma mark - 加入导航栏
-(void)addNavigationItem
{
    //导航栏的左边
    UIButton * leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11, 19)];
    [leftBarBtn addTarget:self action:@selector(popsearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    //导航栏的title
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"搜索";
    titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;

}
#pragma mark - loadingLabel
-(void)addLoadingLabel
{
    loadingLable=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    loadingLable.text=@"正在搜索分类和文章列表";
    loadingLable.textColor=[UIColor blackColor];
    loadingLable.textAlignment=NSTextAlignmentCenter;
    loadingFailedLable=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    loadingFailedLable.textColor=[UIColor blackColor];
    loadingFailedLable.text=@"搜索文章失败,请检查网络设置";
    loadingFailedLable.adjustsFontSizeToFitWidth=YES;
    loadingFailedLable.textAlignment=NSTextAlignmentCenter;
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-125, 0, 40, 40)];
    indicator.color=[UIColor grayColor];

}
#pragma mark - 搜索栏
-(void)addSeachBar
{
    searchBar=[[UISearchBar alloc] init];
    searchBar.frame=CGRectMake(0, 64, self.view.frame.size.width, 40);
    searchBar.placeholder=@"搜索你感兴趣的分类或文章";
    searchBar.showsCancelButton=YES;
    searchBar.backgroundColor=[UIColor whiteColor];
    searchBar.delegate=self;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
    searchBar.returnKeyType=UIReturnKeySearch;
    [self.view addSubview:searchBar];

}
#pragma mark - 手势点击取消搜索
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [searchBar resignFirstResponder];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    tableView.scrollsToTop=YES;
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
}
#pragma mark - 视图已经消失
-(void)viewDidDisappear:(BOOL)animated
{
    tableView.scrollsToTop=NO;
}
#pragma mark - seachBar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self popsearch];
}
-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText{
    if ([timer isValid]) {
        [timer invalidate];
        timer=nil;
        timerControlInt=0;
    }
    if(searchText.length==0)
    {
        
        [searchTypeArray removeAllObjects];
        [titleArray removeAllObjects];
        [tableView reloadData];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"self contains [c] %@", searchBar1.text];
       
        NSArray *arr=  [self.allType3StringArray filteredArrayUsingPredicate:predicate];
        for(int i=0;i<arr.count;i++)
        {
            NSString *adaptString=[arr objectAtIndex:i];
            NSInteger adaptIndex=  [self.allType3StringArray indexOfObject:adaptString];
            KBThreeSortModel *find3=[self.allType3Array objectAtIndex: adaptIndex];
            if ([searchTypeArray indexOfObject:find3]==NSNotFound) {
                [searchTypeArray addObject:find3];
            }
        }
        [tableView reloadData];
        timer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendSearchRequest) userInfo:nil repeats:YES];
        [timer fire];
    }
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar1{
    return YES;
}
#pragma mark - 请求服务器获取搜索的文章
-(void)sendSearchRequest{
    if (timerControlInt==1) {
        tableView.tableHeaderView=loadingLable;
        [tableView.tableHeaderView addSubview:indicator];
        [indicator startAnimating];
        [KBHTTPTool getRequestWithUrlStr:KSearchWebInfoUrl(kBaseUrl, searchBar.text) parameters:nil completionHandr:^(id responseObject) {
            [searchWebInfoAllData setDataWithDictionary:responseObject];
            titleArray=[NSMutableArray arrayWithArray:searchWebInfoAllData.searchWebInfoArray];
            [self performSelector:@selector(searchComplete) withObject:nil afterDelay:1];
            [searchBar resignFirstResponder];
        } error:^(NSError *error) {
            tableView.tableHeaderView=loadingFailedLable;
        }];
    }
    timerControlInt++;
}
#pragma mark - 搜索完成
-(void)searchComplete{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    tableView.tableHeaderView=nil;
    [tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView dataSource
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"搜索到的分类：";
    }
    else {
        return @"搜索到的文章：";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return searchTypeArray.count;
    else
        return titleArray.count;
}
-(void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [searchBar resignFirstResponder];
        KBSortDetailViewControl *nttVC=[[KBSortDetailViewControl alloc]init];
        KBThreeSortModel *find_3=[searchTypeArray objectAtIndex:indexPath.row];
        nttVC.thirdTypeName=find_3.name;
        nttVC.secondTypeID=find_3.TypeTowID;
        nttVC.threeDelegate=self.searchdelegate;
        [self.navigationController pushViewController:nttVC animated:YES];
        [tableView reloadData];
    }
    else
    {
        KBHomeArticleModel * searchWebInfoModel=titleArray[indexPath.row];
        [webviewInfoModel setWebviewInfoArticleModel:searchWebInfoModel];
        [searchBar resignFirstResponder];
        [tableView reloadData];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell * cell=[[UITableViewCell alloc]init];
        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
        [cell.contentView setFrame:cell.frame];
        static NSString *FindAllIdentifier=@"FindAllIdentifier";
        cell=[tableView dequeueReusableCellWithIdentifier:FindAllIdentifier];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FindAllIdentifier];
            
        }
        KBThreeSortModel *threeSortModel=[searchTypeArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor=KColor_51;
        cell.textLabel.text=threeSortModel.name;
        UIImage *icon;
        if([UIImage imageNamed:threeSortModel.name]==NULL)
            icon=[UIImage imageNamed:@"载入中小图"];
        else
            icon = [UIImage imageNamed:threeSortModel.name];
        CGSize itemSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.detailTextLabel.text=@"点击进入分类";
        return cell;
    }
    else{
        KBSeachViewCell *searchViewcell;
        static NSString *UsualIdentifier=@"UsualIdentifier";
        searchViewcell=[tableView dequeueReusableCellWithIdentifier:UsualIdentifier];
        if(searchViewcell==nil)
        {
            searchViewcell=[[KBSeachViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UsualIdentifier];
            
        }
        KBHomeArticleModel * searchWebInfoModel=titleArray[indexPath.row];
        [searchViewcell setSearchCellWithModel:searchWebInfoModel];
        return searchViewcell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70;
    }
    else {
        return  107;
    }
}
#pragma mark - 返回
-(void)popsearch{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - scrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    timerControlInt=1;
    [self sendSearchRequest];
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
