//
//  mainViewController.m
//  UIScroll1
//
//  Created by eddie on 15-3-21.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMainViewController.h"
#import "rootViewController.h"
#import "navViews.h"
#import "KBBaseNavigationController.h"
#import "KBSubcriptionMainViewController.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "Reachability.h"
#import "UIView+Layout.h"
#import "KBInfoWebViewController.h"
#import "KBColumnTableViewController.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBHomeMainTableViewController.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBWhetherReachableModel.h"
#import "MBProgressHUD.h"
#import "KBInterestCollectionViewController.h"
#import "WaterFLayout.h"
#import "KBPlanTableViewController.h"
#import "KBSubjectTableViewController.h"
//上方的横向滚动条的边距
#define MARGIN_SLIDER 5

@interface KBMainViewController ()
{
    navViews *navView; //上方的点击的button的View

    UIView *sliderView;//上方的滑动的View
    
    UIButton *leftBtn;//左侧按钮
    
//    UILabel *titleLable;//导航栏的title
    
    KBLoginSingle *loginSingle;//用户单例

    KBHomeMainTableViewController * recViewController;//推荐tableVC
    
    NSMutableArray *tableVCArray;//tableView的数组
    
    KBColumnTableViewController *tableController;//四个分类的tableVC
    
    KBCommonSingleValueModel * commonSingleValueModel;
    
    BOOL isFirstusing[5];//是否是登录第一次加入table
    
    BOOL isNoLoginFirstusing[5];//是否是没登录第一次加入table
    
    BOOL NotReachable[5];//没网的数组
    
    KBInterestCollectionViewController * interestCollectionVC;//兴趣的tableVC
    KBPlanTableViewController * planTableVC;//规划的tableVC
    
    KBSubjectTableViewController * subjectTableVC;//学科和规划的tableVC
    
}
@end

@implementation KBMainViewController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    //初始化单例
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    tableController=[[KBColumnTableViewController alloc]init];
    //接收通知的跳转
    if ([KBCommonSingleValueModel newinstance].TitleIsroot) {
        KBInfoWebViewController * infoWebVC=[[KBInfoWebViewController alloc]init];
        [self.navigationController pushViewController:infoWebVC animated:NO];
    }
    // Do any additional setup after loading the view from its nib.
  
    //上方的点击button的View
    navView=[[navViews alloc]initWithFrame:CGRectMake(self.navigationController.navigationBar.left,self.navigationController.navigationBar.bottom,kWindowSize.width, 36)];
    navView.delegate=self;
    //上方的滑动view
    sliderView=[[UIView alloc]initWithFrame:CGRectMake(0+MARGIN_SLIDER,navView.bottom-3, kWindowSize.width/5.0-2*MARGIN_SLIDER, 3)];
    sliderView.backgroundColor=KColor_15_86_192;
    sliderView.layer.masksToBounds=YES;
    sliderView.layer.cornerRadius=1.0;
   
    //默认选中第一个button
    _oldButton= [navView.subviews objectAtIndex:0];
    [_oldButton setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
    
    //scroll
    _scrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, (self.navigationController.navigationBar.bottom+navView.height), kWindowSize.width, kWindowSize.height-(self.navigationController.navigationBar.height+navView.height+20) )];
    [_scrol setContentSize:CGSizeMake(5*kWindowSize.width, 0)];
    
    _scrol.bounces=NO;
    _scrol.delegate=self;
    _scrol.pagingEnabled=YES;
    _scrol.showsHorizontalScrollIndicator=NO;
    _scrol.showsVerticalScrollIndicator=NO;
    [_scrol setContentOffset:CGPointMake(0, 0)];
    _scrol.directionalLockEnabled=YES;
    _scrol.scrollsToTop=NO;
    
    //加入五个table
    tableVCArray=[[NSMutableArray alloc]init];
    for(int i=0;i<5;i++)
    {
        
        if (i==0) {
            
            recViewController=[[KBHomeMainTableViewController alloc]init];
            [recViewController.tableView setFrame:CGRectMake(i*kWindowSize.width,0,kWindowSize.width,_scrol.height)];
            [tableVCArray addObject:recViewController];
            recViewController.itemNumber=i;
            //[[NSNotificationCenter defaultCenter]addObserver:tableController selector:@selector(refresh) name:[NSString stringWithFormat:@"REFESH"] object:nil];
            [_scrol addSubview:recViewController.tableView];
            //[parentScView addSubview:scView];
            
            [self addChildViewController:recViewController];
        }
        if (i==1 || i==3) {
            subjectTableVC=[[KBSubjectTableViewController alloc]init];
            subjectTableVC.itemNumber=i+1;
            subjectTableVC.isFirstAddTable=YES;
            [subjectTableVC.tableView setFrame:CGRectMake(i*kWindowSize.width,0,kWindowSize.width,_scrol.height)];
            [tableVCArray addObject:subjectTableVC];
            [[NSNotificationCenter defaultCenter]addObserver:subjectTableVC selector:@selector(updateFocus) name:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i] object:nil];
            
            [_scrol addSubview:subjectTableVC.tableView];
            [self addChildViewController:subjectTableVC];
        }
//        else if(i<3)
//        {
//            tableController=[[KBColumnTableViewController alloc]init];
//            tableController.itemNumber=i+1;
//            tableController.isFirstAddTable=YES;
//            [tableController.tableView setFrame:CGRectMake(i*kWindowSize.width,0,kWindowSize.width,_scrol.height)];
//            [tableVCArray addObject:tableController];
//            [[NSNotificationCenter defaultCenter]addObserver:tableController selector:@selector(updateFocus) name:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i] object:nil];
//        
//            [_scrol addSubview:tableController.tableView];
//            [self addChildViewController:tableController];
//        }
       else if(i == 2)
        {
            planTableVC=[[KBPlanTableViewController alloc]init];
            planTableVC.itemNumber=i+1;
            planTableVC.isFirstAddTable=YES;
            [planTableVC.tableView setFrame:CGRectMake(i*kWindowSize.width,0,kWindowSize.width,_scrol.height)];
            [tableVCArray addObject:planTableVC];
            [[NSNotificationCenter defaultCenter]addObserver:planTableVC selector:@selector(updateFocus) name:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i] object:nil];
            
            [_scrol addSubview:planTableVC.tableView];
            [self addChildViewController:planTableVC];
       }
        else 
        {
            WaterFLayout *layout = [[WaterFLayout alloc] init];
            interestCollectionVC = [[KBInterestCollectionViewController alloc]initWithCollectionViewLayout:layout];
            interestCollectionVC.itemNumber=i+1;
            interestCollectionVC.isFirstAddTable=YES;
            [interestCollectionVC.collectionView setFrame:CGRectMake(i*kWindowSize.width,0,kWindowSize.width,_scrol.height)];
            [tableVCArray addObject:interestCollectionVC];
            [[NSNotificationCenter defaultCenter]addObserver:interestCollectionVC selector:@selector(updateFocus) name:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i] object:nil];
            [_scrol addSubview:interestCollectionVC.collectionView];
            [self addChildViewController:interestCollectionVC];
        }
    }
    //导航栏的左侧按钮
    leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 25, 25)];
    leftBtn.layer.cornerRadius=12.5;
    leftBtn.clipsToBounds=YES;
    leftBtn.layer.borderWidth=1;
    leftBtn.backgroundColor=KColor_153_Alpha_1;
    leftBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    [leftBtn addTarget:self action:@selector(scroll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    //导航栏的右侧按钮
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn addTarget:self action:@selector(pushFindView) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"发现"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    //导航栏的title
    UILabel * titleLable=[[UILabel alloc]initWithFrame:CGRectMake(-5, -5, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentLeft;
    titleLable.text=@"跬步";
    titleLable.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    self.navigationItem.titleView =[[UIView alloc]initWithFrame: CGRectMake(0, 0, 30 , 30)];
    [self.navigationItem.titleView addSubview:titleLable];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.rightBarButtonItem=rightItem;
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
    
    [self.view addSubview:navView];
    [self.view addSubview:sliderView];
    [self.view addSubview:_scrol];
    
    //初始化没网的数组
    for (int i=0; i<5; i++) {
        NotReachable[i]=YES;
        
    }

    //监听scroll的位置变化
    [_scrol addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
    
    //刷新登录和没登录的头像
    if(loginSingle.isLogined){
        [self mainRefreshView_USER_RELOGIN];
    }
    else {
        [self mainRefreshView_LOCAL_RELOGIN];
    }
    //没登录头像的设置
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           selector(mainRefreshView_LOCAL_RELOGIN) name:@"LOCAL_RELOGIN" object:nil];
    //登录成功头像的刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mainRefreshView_USER_RELOGIN) name:@"USER_RELOGIN_SUCCEED" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mainRefreshView_USER_RELOGIN) name:@"REFRESH_HEAD" object:nil];
    //没网的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NotReachable) name:@"NotReachable" object:nil];
    
    
    
}
#pragma mark - 没网的数组
-(void)NotReachable
{
    for (int i=0; i<5; i++) {
        NotReachable[i]=YES;
        
    }
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [_scrol setFrame: CGRectMake(0, (self.navigationController.navigationBar.bottom+navView.height), kWindowSize.width, kWindowSize.height-(self.navigationController.navigationBar.height+navView.height+20) )];
    
    [navView setFrame:CGRectMake(self.navigationController.navigationBar.left,self.navigationController.navigationBar.bottom, kWindowSize.width, 36)];
}
#pragma mark -  右侧按钮
-(void)pushFindView{
    KBSubcriptionMainViewController *findCtr=[[KBSubcriptionMainViewController alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    [self.navigationController pushViewController:findCtr animated:YES];
    
}
#pragma mark - 左侧按钮的方法
-(void)scroll{
    KBBaseNavigationController *nan=  self.navdelegate;
    rootViewController *root=nan.delegateroot;
    [root scrollToMenu];
}
#pragma mark - 监听位置变化的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(_scrol.contentOffset.x>0)
    {
        [sliderView setFrame:CGRectMake(_scrol.contentOffset.x/5+MARGIN_SLIDER, sliderView.top, kWindowSize.width/5.0-2*MARGIN_SLIDER, 3)];
    }
    int i=(int)(_scrol.contentOffset.x/kWindowSize.width+0.5);
    commonSingleValueModel.FindContentOffSet=i;
    [_oldButton setTitleColor:KColor_102 forState:UIControlStateNormal];
    _oldButton=[navView.views objectAtIndex:i];
    [_oldButton setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
    //置顶
//    if (tableVCArray.count==5) {
//        if (i==0) {
//            KBHomeMainTableViewController * tableToTop=[tableVCArray objectAtIndex:i];
//            tableToTop.tableView.scrollsToTop=YES;
//            for (int j=1; j<5; j++) {
//                if (j<4) {
//                    KBColumnTableViewController * tableToTop=[tableVCArray objectAtIndex:j];
//                    tableToTop.tableView.scrollsToTop=NO;
//                }
//                else
//                {
//                    KBInterestCollectionViewController * interestCollectionToTop = [tableVCArray objectAtIndex:j];
//                    interestCollectionToTop.collectionView.scrollsToTop=NO;
//                }
//            }
//            
//        }
//        else
//            for (int k=1; k<5; k++) {
//                if (k==i) {
//                    if (k<4) {
//                        KBColumnTableViewController * tableToTop=[tableVCArray objectAtIndex:k];
//                        tableToTop.tableView.scrollsToTop=YES;
//                    }
//                    else
//                    {
//                        KBInterestCollectionViewController * interestCollectionToTop = [tableVCArray objectAtIndex:k];
//                        interestCollectionToTop.collectionView.scrollsToTop=YES;
//                    }
//                }
//                else
//                {
//                    if (k<4) {
//                        KBColumnTableViewController * tableToTop=[tableVCArray objectAtIndex:k];
//                        tableToTop.tableView.scrollsToTop=NO;
//                    }
//                    KBInterestCollectionViewController * interestCollectionToTop = [tableVCArray objectAtIndex:4];
//                    interestCollectionToTop.collectionView.scrollsToTop=YES;
//                    recViewController.tableView.scrollsToTop=NO;
//                }
//            }
//    }
    
   if ([KBWhetherReachableModel whetherReachable]) {
       //登录
        if (loginSingle.isLogined) {
            if (isFirstusing[i]) {
                {
                    if (i==0)
                        ;
                    else
                        [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i] object:nil];
                    //NSLog(@"focus :%@",[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i]);
                    isFirstusing[i]=NO;
                }
            }
        }
       //未登录
        else
        {
            if (isNoLoginFirstusing[i]) {
                {
                    if (i==0)
                        ;
                    else
                    {
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i] object:nil];
                    }
                    isNoLoginFirstusing[i]=NO;
                }
            }
        }
        
    }
    //没网
    if (![KBWhetherReachableModel whetherReachable])
    {
        
        if (NotReachable[i]) {
            if (i==0)
            {
            }
            else
                [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i] object:nil];
            NotReachable[i]=NO;
        }
        
    }
}
#pragma mark - 刷新登录头像
-(void)mainRefreshView_USER_RELOGIN{
    
    for (int i=0; i<5; i++) {
        isFirstusing[i]=YES;
    }
    if (loginSingle.userPhoto)
    {
        [leftBtn setBackgroundImage:loginSingle.userPhoto  forState:UIControlStateNormal] ;
    }
    else
    {
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"未登录.png"] forState:UIControlStateNormal] ;
    }

    
}
#pragma mark - 刷新没登录的头像
-(void)mainRefreshView_LOCAL_RELOGIN{
    for (int i=0; i<5; i++) {
        isNoLoginFirstusing[i]=YES;
    }
    
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"未登录.png"] forState:UIControlStateNormal] ;
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
