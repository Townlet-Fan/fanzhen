//
//  KBHomeMainTableViewController.m
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeMainTableViewController.h"
#import "KBConstant.h"
#import "KBHTTPTool.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "KBHomeScrollerView.h"
#import "UIView+ITTAdditions.h"
#import "KBHomeAllData.h"
#import "KBHomeThreeViewTableViewCell.h"
#import "KBHomeHeadView.h"
#import "KBHomeArticleModel.h"
#import "KBHomeFiveViewTableViewCell.h"
#import "KBHomeCommonTableViewCell.h"
#import "UIImageView+KBAddView.h"
#import "KBWebviewInfoModel.h"
#import "KBInfoWebViewController.h"
#import "KBDefineGifView.h"
#import "KBWhetherReachableModel.h"
#import "MBProgressHUD.h"
#import "KBHomeFooterView.h"
#define rowHeight (0.58*kWindowSize.width/1.8)*2+2

@interface KBHomeMainTableViewController()<SDCycleScrollViewDelegate,RecommendThreeDelegate,RecommendFiveDelegate,KBHomeHeadViewDelegate>
{
    KBHomeScrollerView *scrollerView;//顶部轮播视图
    
    KBWebviewInfoModel * webViewInfoModel;//正文的单例
    
    NSIndexPath *sectionIndexPath;//记录选中的cell
    
    KBDefineGifView * defineGifView;//加载动画
    
    BOOL isHaveCache;//判断是否有缓存
    
    //用plist文件写缓存
    NSArray *pathArray;
    NSString *pathStr;
    NSString *filename;
    NSMutableDictionary * cacheDictionary;//用于写缓存的字典

}

/**
 *  头视图的数组
 */
@property(nonatomic,strong) NSMutableArray *sectionHeadArr;

@end

@implementation KBHomeMainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化正文的单例
    webViewInfoModel=[KBWebviewInfoModel newinstance];
    
    isHaveCache=NO;
    
    //从新定义tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height) style:UITableViewStyleGrouped];
    //
    self.tableView.backgroundColor=[UIColor whiteColor];
    //取消置顶
    self.tableView.scrollsToTop=NO;
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去掉滑动的线条
    self.tableView.showsVerticalScrollIndicator = NO;
    //顶部轮播
    [self addTopView];
    //加入下拉刷新                                                                                              
    [self addMjRefresh];
    
    //对responseObject写入plist文件的初始化
    pathArray=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    pathStr=[pathArray objectAtIndex:0];
    filename=[pathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.plist",(long)_itemNumber]];
    cacheDictionary=[[NSMutableDictionary alloc]init];
    
    //读取缓存
   // [self cacheRead];
    
    //判断网络状态
    if (![KBWhetherReachableModel whetherReachable]) {
        MBProgressHUD * notReachability=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:notReachability];
        notReachability.customView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"关于.png"]];
        notReachability.mode=MBProgressHUDModeCustomView;
        notReachability.labelText=@"漏网了";
        [notReachability show:YES];
        [notReachability hide:YES afterDelay:2];
    }
}
#pragma mark - 加载动画
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
    NSDictionary * cacheDict = [NSDictionary dictionaryWithContentsOfFile:filename];//读取数据
    NSDictionary * responseObject =[cacheDict objectForKey:[NSString stringWithFormat:@"%ld",(long)_itemNumber]];
    if (responseObject!=nil) {
        isHaveCache=YES;
        //处理数据
        [[KBHomeAllData shareInstance] setDataWithDictionary:responseObject];
        
        //刷新顶部的轮播视图
        [scrollerView buildScrollerViewImagesWith:[KBHomeAllData shareInstance].homeTopData];
        if ([KBHomeAllData shareInstance].homeTopData.count!=0) {
            self.tableView.tableHeaderView=scrollerView;
        }
        //刷新表格
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        //刷新数据
        [self loadNewData];
    }
    else
    {
        [self showGifView];
        //刷新数据
        [self loadNewData];
    }
}

#pragma mark - 懒加载头视图的数组
- (NSMutableArray *)sectionHeadArr
{
    if (!_sectionHeadArr)
    {
        _sectionHeadArr = [NSMutableArray array];
        for (int i = 0; i<7; i++) {
            KBHomeHeadView *headView = [[KBHomeHeadView alloc] initWithFrame:CGRectMake(0,0, kWindowSize.width,kWindowSize.width*9/16.0+5)];
            if (i==2||i==4||i==6) {
            [self setDimViewWithView:headView andImageName:@"夏洛克"];
               
            }
            
            [_sectionHeadArr addObject:headView];
        }
    }
    return _sectionHeadArr;
}
#pragma mark - 蒙版
- (void)setDimViewWithView:(KBHomeHeadView *)view andImageName:(NSString *)imageName
{
    [UIImageView addDimImageViewWithImageName:imageName toView:view];
    [view addSubview:view.sectionHeadLabel];
}
#pragma mark - 第一个cell 3个的 代理
- (void)artViewTapActionWithartModel:(KBHomeArticleModel *)artModel
{
    //取出model
    [webViewInfoModel setWebviewInfoArticleModel:artModel];
    
    KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:tc animated:YES];

}

#pragma mark - 第二个cell 5个的  代理
- (void)fiveViewTapActionWithartModel:(KBHomeArticleModel *)fiveModel
{
    
    [webViewInfoModel setWebviewInfoArticleModel:fiveModel];
    
    KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:tc animated:YES];
}
#pragma mark - 轮播视图 点击 代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    //取出model
    KBHomeArticleModel * scrollerModel =[KBHomeAllData shareInstance].homeTopData [index];
    [webViewInfoModel setWebviewInfoArticleModel:scrollerModel];
    
    KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:tc animated:YES];
    
}
#pragma mark - headSection 点击 代理
-(void)headViewTapActionWithartModel:(KBHomeArticleModel *)headViewModel
{
    [webViewInfoModel setWebviewInfoArticleModel:headViewModel];
    
    KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
    [self.navigationController pushViewController:tc animated:YES];

}
#pragma mark - 顶部轮播视图
- (void)addTopView
{
   scrollerView = [[KBHomeScrollerView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 9*kWindowSize.width/16.0) andTableView:self];
}
#pragma mark - 加入下拉刷新
- (void)addMjRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.header = header;
}
#pragma mark - 下拉刷新方法
- (void)loadNewData
{
    [KBHTTPTool getRequestWithUrlStr:kHomeTopUrl(kBaseUrl) parameters:nil completionHandr:^(id responseObject) {
        //处理数据
       
        [[KBHomeAllData shareInstance] setDataWithDictionary:responseObject];
        
//        [[KBHomeAllData shareInstance] getHomeTopDataWithBlock:^(NSArray *topData) {
//            NSLog(@"topdata == %@",topData);
//        }];

        
        //刷新顶部的轮播视图
        [scrollerView buildScrollerViewImagesWith:[KBHomeAllData shareInstance].homeTopData];
        if ([KBHomeAllData shareInstance].homeTopData.count!=0) {
            self.tableView.tableHeaderView=scrollerView;
        }
        [cacheDictionary setObject:responseObject forKey:[NSString stringWithFormat:@"%ld",(long)_itemNumber]];
        [cacheDictionary writeToFile:filename atomically:YES];
        //刷新表格
        [defineGifView removeFromSuperview];//移除动画
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } error:^(NSError *error) {
        [defineGifView removeFromSuperview];//移除动画
        [self.tableView.header endRefreshing];
    }];
}
#pragma mark - 判断是否有广告图
- (BOOL)isHaveImage:(NSInteger)section
{
    KBHomeArticleModel *artModel = [KBHomeAllData shareInstance].breakList[section - 1];
    if ([artModel.breakNum intValue] == 0) {
        return NO;
    }
    //前两个如果有  breakNum应该为-1
    if (section<3 && [artModel.breakNum intValue]<0) {
        return YES;
    }else if (section>=3 && (section - 2 == [artModel.breakNum intValue])){
        //下面的五个如果有  breakNum的值应该为 section-2
         return YES;
    }else
        return NO;
}
#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        //第一个cell
        KBHomeThreeViewTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
        if (!oneCell) {
            oneCell = [[KBHomeThreeViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oneCell"];
            oneCell.delegate = self;
            oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //创建cell里的视图
        if ([KBHomeAllData shareInstance].chosenList.count == 3) {
            [oneCell setAcrticleViewWithArray:[KBHomeAllData shareInstance].chosenList];
        }
        
        return oneCell;
    }else if (indexPath.section == 1){
        //第二个cell
        KBHomeFiveViewTableViewCell *fiveCell = [tableView dequeueReusableCellWithIdentifier:@"fiveCell"];
        if (!fiveCell) {
            fiveCell = [[KBHomeFiveViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fiveCell"];
            fiveCell.delegate = self;
            fiveCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if([KBHomeAllData shareInstance].confirmList.count == 5){
            [fiveCell setFiveViewWithArray:[KBHomeAllData shareInstance].confirmList];
        }
        return fiveCell;
    }else
    {
        //防止重用 第一个 cell
        NSString *ID = @"commonCell";
        if (indexPath.row == 0) {
            ID = @"OneCommonCell";
        }
        KBHomeCommonTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!commonCell) {
            commonCell = [[KBHomeCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID andIndexPath:indexPath];
            commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [commonCell setCommonCellWithModel:[KBHomeAllData shareInstance].subJectList[indexPath.section-2][indexPath.row]];
        if(indexPath.row>=1)
            commonCell.selectionStyle=UITableViewCellSelectionStyleGray;
        return commonCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if ([KBHomeAllData shareInstance].chosenList.count==3)
            {
                return rowHeight;
            }
            else
                return 0;

            break;
        case 1:
        {
            if ([KBHomeAllData shareInstance].confirmList.count==5)
            {
                return kWindowSize.width/2.35+kWindowSize.width/1.5+94;
            }
            else
                return 0;
        }
        default:
            if (indexPath.row == 0) {
                return kWindowSize.width/2.727+5;
            }else{
                return 95;
            }
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 )
    {
        return [KBHomeAllData shareInstance].chosenList.count/3.0;

    }
    if (section==1) {
        return [KBHomeAllData shareInstance].confirmList.count/5.0;
    }
    else
    {
        NSArray *list = [KBHomeAllData shareInstance].subJectList[section-2];
        return list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else
    {
        //先判断有没有图
        if ([self isHaveImage:section]) {
            KBHomeHeadView *headView = self.sectionHeadArr[section-1];
            [headView setSectionImageWith:[KBHomeAllData shareInstance].breakList[section -1] andSection:section withBreakArray:[KBHomeAllData shareInstance].breakList withKbHomeHeadView:headView];
            CGFloat scale = [[KBHomeAllData shareInstance].scaleNum[section-1] floatValue];
            if(scale==16)
            {
                headView.delegate=self;
            }
        
            if (section==1 ) {
                return scale<16?kWindowSize.width/scale+10:9*kWindowSize.width/scale + 10;

            }
            else
            {
                return scale<16?kWindowSize.width/scale+5:9*kWindowSize.width/scale+5;
            }
        }
        
        else{

            return 0.000001;
        }
    }
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==7) {
        return  40;
    }
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        if ([self isHaveImage:section]) {
            return self.sectionHeadArr[section-1];
        }
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==7) {
        UIView * tableFooterView = [[KBHomeFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40) withText:@"今日的推荐暂告一段落,请到其他的分类继续浏览吧!"];
        return tableFooterView;
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section>=2)
    {
        if(indexPath.row>=1)
        {
        
            sectionIndexPath=indexPath;
           KBHomeArticleModel * articleModel =[KBHomeAllData shareInstance].subJectList[indexPath.section-2][indexPath.row];
            [webViewInfoModel setWebviewInfoArticleModel: articleModel];
            KBInfoWebViewController *tc=[[KBInfoWebViewController alloc]init];
            [self.navigationController pushViewController:tc animated:YES];
            articleModel.readNumber=[NSNumber numberWithInt:[articleModel.readNumber intValue]+1];
        }
    }
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
@end
