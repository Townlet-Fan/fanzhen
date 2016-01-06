//
//  FindViewController.m
//  UIScroll1
//
//  Created by eddie on 15-4-2.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBSubcriptionMainViewController.h"
#import "KBSearchViewController.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBColumnSortButton.h"
#import "KBLoginSingle.h"
#import "KBAllTypeInfoModel.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "UIView+Layout.h"
#import "KBSubscriptionDrawTriangle.h"
#import "rootViewController.h"
#import "KBDetailSubsctiptionTableViewController.h"
#import "KBMySubcriptionViewController.h"
#import "KBThreeSortModel.h"
#import "KBTwoSortModel.h"
#import "KBSubscriptionTypeOneImageView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBPostParametersModel.h"
#import "KBHTTPTool.h"
@interface KBSubcriptionMainViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate,UIScrollViewAccessibilityDelegate,UIScrollViewDelegate,KBSubscriptionTypeOneDelegate>
{
    NSMutableArray *allArray; //所有分类的数组
    
    AppDelegate* appDelegate;
    
    KBLoginSingle *loginSingle;//用户单例
    
    NSMutableArray *interestArray;//关注的数组里面是直接三级分类
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    BOOL isItemChangeArray[5];//某个一级分类下三级分类的订阅是否发生改变
    
    BOOL isInterestItemChangeArray[5];//在我的订阅里是否删除了某个三级分类
    
    UISearchBar *searchBar;//搜索栏
    
    NSMutableArray *tableVCArray;//订阅频道tableView的数组
    
    NSMutableArray *interestCollectArray;//我的订阅的tableView的数组
    
    UIScrollView *findScroll;//scrollView
    
    KBDetailSubsctiptionTableViewController *newFindTableVC;//订阅频道的tableView
    
    KBMySubcriptionViewController *interestedCollectionViewVC;//我的订阅的tableView
    
    UIViewController *currentViewController;//当前的子控制器
    
    NSMutableArray *allInterestedViewController;//我的订阅的tableView的数组
    
    NSMutableArray *allImageButton; //所有一级分类button的数组
    
    KBSubscriptionDrawTriangle *triangleView;//三角形的View
    
    bool isNewFindView;//是否显示订阅频道
    
    UIBarButtonItem *leftButtonItem;//导航栏的左边返回
    
    UISegmentedControl *segmentedControl;//segment
    
    UIBarButtonItem *rightButtonItem;//导航栏的右侧
    
    KBSubscriptionTypeOneImageView *typeOneImageView;
    
    NSMutableDictionary *triangleViewColor;//三角形的color
    
    UIView * guideView;//引导的阴影的View
    
    UIButton *okButton;//okbutton
}
@end

@implementation KBSubcriptionMainViewController
//搜索只搜索当前大类中的，所以在搜索中关注或取消会根据TypeOneInteger刷新主页面
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    tableVCArray=[[NSMutableArray alloc]init];
    loginSingle=[KBLoginSingle newinstance];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    interestArray=loginSingle.userInterestNoStructArray ;
    allArray=loginSingle.userAllTypeArray;
    interestCollectArray=[[NSMutableArray alloc]init];
    isNewFindView = true;
    allInterestedViewController = [NSMutableArray arrayWithCapacity:5];
    allImageButton = [NSMutableArray arrayWithCapacity:1];
    
    //设置导航栏
    [self setNavigationBar];
    
    //设置一级分类切换图标
    [self setTypeOneChangeView];
    
    //scrollView
    findScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, typeOneImageView.bottom, kWindowSize.width, kWindowSize.height-typeOneImageView.bottom)];
    findScroll.delegate=self;
    findScroll.bounces=NO;
    findScroll.scrollsToTop=NO;
    findScroll.contentSize=CGSizeMake(kWindowSize.width*4, 0);
    findScroll.showsHorizontalScrollIndicator=NO;
    findScroll.showsVerticalScrollIndicator=NO;
    findScroll.directionalLockEnabled=YES;
    //在主界面的停留的分类 直接进入订阅频道相对应的分类
    if (commonSingleValueModel.FindContentOffSet==0) {
        [findScroll setContentOffset:CGPointMake(kWindowSize.width*(0), 0)];
    }
    else
        [findScroll setContentOffset:CGPointMake(kWindowSize.width*(commonSingleValueModel.FindContentOffSet), 0)];
    findScroll.pagingEnabled=YES;
    [self.view addSubview:findScroll];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //添加子控制器
    for (int i=0; i<4; i++) {
        newFindTableVC=[[KBDetailSubsctiptionTableViewController alloc] init];
        [newFindTableVC.view setFrame:CGRectMake(kWindowSize.width*i, 0, kWindowSize.width, findScroll.frame.size.height)];
        newFindTableVC.typeOneArray1=[allArray objectAtIndex:i];//一级分类
        newFindTableVC.typeOneInterestStructArray=[loginSingle.userInterestStructArray objectAtIndex:i];//一级分类下包含的二级分类
        newFindTableVC.interestOneArray=[loginSingle.userInterestNoStructArray objectAtIndex:i];//关注的三级分类
        [tableVCArray addObject:newFindTableVC];
        [findScroll addSubview:newFindTableVC.view];
        [self addChildViewController:newFindTableVC];
    }
    currentViewController=[self.childViewControllers objectAtIndex:0];//当前显示子控制器
    for (int i=0; i<4; i++) {
        //---------我的订阅控制器－－－－－－－－－－
        UICollectionViewFlowLayout *collectionViewFlowLayout=[[UICollectionViewFlowLayout alloc] init];
        //        InterestedCollectionViewLayout *collectionViewFlowLayout = [[InterestedCollectionViewLayout alloc] init];
        interestedCollectionViewVC=[[KBMySubcriptionViewController alloc] initWithCollectionViewLayout:collectionViewFlowLayout];
        interestedCollectionViewVC.view.frame = CGRectMake(i*kWindowSize.width, 0,kWindowSize.width , findScroll.frame.size.height);
        interestedCollectionViewVC.collectionView.scrollsToTop=NO;
        interestedCollectionViewVC.typeOneInterestStruct=[loginSingle.userInterestStructArray objectAtIndex:i];
        interestedCollectionViewVC.typeThreeInterestedStruct = [loginSingle.userInterestNoStructArray objectAtIndex:i];
        [interestCollectArray addObject:interestedCollectionViewVC];
        [allInterestedViewController addObject:interestedCollectionViewVC];
        [self addChildViewController:interestedCollectionViewVC];
    }
    
    // 用数组来保存更改的大类
    for (int i=0; i<tableVCArray.count; i++) {
        isItemChangeArray[i]=NO;
    }
    for (int i=0; i<interestCollectArray.count; i++) {
        isInterestItemChangeArray[i]=NO;
    }
    
    self.allType3StringArray=[[NSMutableArray alloc]init];
    self.allType3Array=[[NSMutableArray alloc]init];
    //初始化allType3Array和allType3StringArray,以备查询用
    for (int i=0; i<allArray.count-1; i++)
    {
        NSMutableArray *typeOneArray=[[NSMutableArray alloc]initWithArray:[allArray objectAtIndex:i]];
        for (int j=0; j<typeOneArray.count; j++)
        {
            KBTwoSortModel *find2=[typeOneArray objectAtIndex:j];
            
            for (int k=0; k<find2.subArray.count; k++)
            {
                KBThreeSortModel *find3=[find2.subArray objectAtIndex:k];
                [self.allType3Array addObject:find3];
                [self.allType3StringArray addObject:find3.name];
            }
        }
    }
    
    for (int i=0; i<interestArray.count; i++)
    {
        NSMutableArray *typeOneInterestArray=[[NSMutableArray alloc]initWithArray:[interestArray objectAtIndex:i]];
        
        for (int j=0; j<typeOneInterestArray.count; j++) {
            KBThreeSortModel *find3=[typeOneInterestArray objectAtIndex:j];
            [self.allType3Array addObject:find3];
            [self.allType3StringArray addObject:find3.name];
        }
        
    }
    //分类发生变化的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doSomeWithItem:) name:@"IS_ITEM_CHANGE" object:nil];
    //添加上导航栏右侧的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRightButtonItem) name:@"addRightButton" object:nil];
    //编辑没完成  通知编辑完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editComplete) name:@"IntersetedEditNotComplete" object:nil];
    
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    KBBaseNavigationController *navVC =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
    for (KBMySubcriptionViewController *vc in allInterestedViewController) {
        [self addChildViewController:vc];
    }
    [findScroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCROLL_DISABLE" object:nil];
    [self guideView];
}
#pragma mark - 引导View
-(void)guideView
{
    //引导的阴影的View
    guideView = [[UIView alloc]initWithFrame:self.view.frame];
    guideView.backgroundColor = [UIColor blackColor];
    guideView.alpha=0.71;
    
    //okbutton
    okButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
    [okButton setImage:[UIImage imageNamed:@"okBtn"] forState:UIControlStateNormal];
    [okButton sizeToFit];
    [okButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [guideView addSubview: okButton];
    [self.view addSubview:guideView];
}
-(void)dismiss
{
    //引导的阴影的View消失
    
    [UIView animateWithDuration:0.5 animations:^{
        guideView.alpha=0;
    } completion:^(BOOL finished) {
        [guideView removeFromSuperview];;
    }];
    //改变图片
//    [okButton setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
}
#pragma mark - touch阴影view的任意地方
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    for (int i=0; i<self.childViewControllers.count/2; i++) {
        
        KBDetailSubsctiptionTableViewController *tableVC=[self.childViewControllers objectAtIndex:i];
        //当前的table的三级分类的订阅发生改变
        if(tableVC.isChanged){
            isItemChangeArray[i+1]=YES;
        }
        KBMySubcriptionViewController * interestedCollectionVC=[self.childViewControllers objectAtIndex:i+4];
        //我的订阅当前的table的三级分类的订阅发生改变
        if (interestedCollectionVC.isChanged) {
            isInterestItemChangeArray[i+1]=YES;
        }
    }
    
    if (loginSingle.isLogined)
    {
        NSLog(@"消失");
        NSDictionary *willSendDic=[KBPostParametersModel setUserSubscriptionChangeParameters :interestArray withUserId:loginSingle.userID];
//        KBLog(@"willsendic:%@",willSendDic);
//        KBLog(@"loginSingle:%ld",(long)loginSingle.userID);
        [KBHTTPTool postRequestWithUrlStr:KUserSubscriptionChangeUrl(kBaseUrl) parameters:willSendDic completionHandr:^(id responseObject) {
            for (int i=0; i<tableVCArray.count; i++) {
                
                if (isItemChangeArray[i+1]||isInterestItemChangeArray[i+1])
                {
                    commonSingleValueModel.isChangeInterest=YES;
                    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i+1] object:nil];
                }
                else
                    commonSingleValueModel.isChangeInterest=NO;
            }
            
        } error:^(NSError *error) {
            NSLog(@"fail:%@",error);
        }];
    }
    else{
        for (int i=0; i<tableVCArray.count; i++) {
            
            if (isItemChangeArray[i+1]||isInterestItemChangeArray[i+1])
            {
                NSLog(@"%@",[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i+1]);
                commonSingleValueModel.isChangeInterest=YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",i+1] object:nil];
            }
            else
                commonSingleValueModel.isChangeInterest=NO;
        }
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_DRAG"] object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    
}
#pragma mark - 视图已经消失
-(void)viewDidDisappear:(BOOL)animated
{
    [findScroll removeObserver:self forKeyPath:@"contentOffset"];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomMethods
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int i=(int)(findScroll.contentOffset.x/findScroll.frame.size.width+0.5);
    //置顶
    if (interestCollectArray.count==4)
    {
        for (int j=0; j<4; j++) {
            if (j==i) {
                KBMySubcriptionViewController *interestScrollToTop=[interestCollectArray objectAtIndex:j];
                interestScrollToTop.collectionView.scrollsToTop=YES;
            }
            else
            {
                KBMySubcriptionViewController *interestScrollToTop=[interestCollectArray objectAtIndex:j];
                interestScrollToTop.collectionView.scrollsToTop=NO;
            }
        }
    }
    
    
}
#pragma mark - 接收到通知 改变某个一级分类的三级分类的订阅改变为YES
-(void)doSomeWithItem:(NSNotification *)notify
{
    isItemChangeArray[[[[notify userInfo] objectForKey:@"IS_ITEM_CHANGE"] integerValue]+1]=YES;
}
#pragma mark - 添加导航栏和搜索框
- (void)setNavigationBar
{
    UIButton *leftBarBtn = [[UIButton alloc]init];
    leftBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11, 19)];
    [leftBarBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    //分段控件
    NSArray *array=[[NSArray alloc] initWithObjects:@"订阅频道",@"我的订阅", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    searchBar=[[UISearchBar alloc] init];
    searchBar.frame=CGRectMake(0, 64, kWindowSize.width, 40);
    searchBar.placeholder=@"搜索你感兴趣的分类或文章";
    searchBar.backgroundColor=[UIColor whiteColor];
    searchBar.delegate=self;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
    [self.view addSubview:searchBar];
}
#pragma mark - 一级分类切换图标
- (void)setTypeOneChangeView
{
    NSMutableArray *images = [NSMutableArray arrayWithObjects:@"学科1.png",@"能力2.png",@"规划3.png",@"兴趣4.png", nil];
    triangleViewColor = [[NSMutableDictionary alloc]initWithCapacity:4];
    [triangleViewColor setObject:[UIColor colorWithRed:55/255.0 green:114/255.0 blue:211/255.0 alpha:1] forKey:@"color_1"];
    [triangleViewColor setObject:[UIColor colorWithRed:57/255.0 green:192/255.0 blue:240/255.0 alpha:1] forKey:@"color_2"];
    [triangleViewColor setObject:[UIColor colorWithRed:24/255.0 green:147/255.0 blue:150/255.0 alpha:1] forKey:@"color_3"];
    [triangleViewColor setObject:[UIColor colorWithRed:96/255.0 green:191/255.0 blue:174/255.0 alpha:1] forKey:@"color_4"];
    NSString* str = @"color_";
    for (int i = 0; i < 4; i++) {
        KBSubscriptionTypeOneImageView *view = [[KBSubscriptionTypeOneImageView alloc] initWithFrame:CGRectMake(i * kWindowSize.width/4.0, searchBar.bottom, kWindowSize.width*0.25, 60)];
        [view setImageViewWithTag:(i + 1) andImageString:[images objectAtIndex:i] andColor:triangleViewColor[[str stringByAppendingString:[NSString stringWithFormat:@"%d",i+1]]]];
        view.delegate = self;
        [self.view addSubview:view];
        [allImageButton addObject:view];
    }
    //进入 直接在对应分类加三角形
    NSLog(@"startoffset:%d",commonSingleValueModel.FindContentOffSet);
    if (commonSingleValueModel.FindContentOffSet>0) {
        commonSingleValueModel.FindContentOffSet = commonSingleValueModel.FindContentOffSet-1;
    }
    typeOneImageView = [allImageButton objectAtIndex:commonSingleValueModel.FindContentOffSet];
    //设置标志三角形
    triangleView = [[KBSubscriptionDrawTriangle alloc] initWithFrame:CGRectMake(0.5*typeOneImageView.width-5, typeOneImageView.height-10, 10, 10)];
    triangleView.backgroundColor = triangleViewColor[[str stringByAppendingString:[NSString stringWithFormat:@"%d",commonSingleValueModel.FindContentOffSet+1]]];
    [typeOneImageView addSubview:triangleView];
}
#pragma mark - 返回
- (void)popself
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 切换视图
- (void)segmentAction:(UISegmentedControl*)segmented
{
    NSInteger Index = segmented.selectedSegmentIndex;
    int number=findScroll.contentOffset.x/kWindowSize.width;
    UIViewController *oldViewController=currentViewController;
    switch (Index) {
        case 0:{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FEFRASH_NOT" object:nil];
            
            if (!isNewFindView) {
                isNewFindView=true;
                for (int i=0; i<4; i++) {
                    interestedCollectionViewVC = [self.childViewControllers objectAtIndex:i+4];
                    [interestedCollectionViewVC.view removeFromSuperview];//移出的目的是在滑动的时候订阅界面与我的订阅一致
                    
                    newFindTableVC=[self.childViewControllers objectAtIndex:i];
                    [findScroll addSubview:newFindTableVC.view];
                }
            }
            self.navigationItem.rightBarButtonItem=nil;
            newFindTableVC=[self.childViewControllers objectAtIndex:number];
            
            [self transitionFromViewController:currentViewController toViewController:newFindTableVC duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=newFindTableVC;
                } else {
                    currentViewController=oldViewController;
                }
            }];
            [newFindTableVC.rightTableView reloadData];
            break;
        }
        default:{
            if (isNewFindView) {
                isNewFindView=false;
                
                for (int i=0; i<4; i++) {
                    newFindTableVC = [self.childViewControllers objectAtIndex:i];
                    [newFindTableVC.view removeFromSuperview];
                    
                    interestedCollectionViewVC=[self.childViewControllers objectAtIndex:i+4];
                    [findScroll addSubview:interestedCollectionViewVC.view];
                }
                
            }
            interestedCollectionViewVC=[self.childViewControllers objectAtIndex:number+4];
            [self transitionFromViewController:currentViewController toViewController:interestedCollectionViewVC duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=interestedCollectionViewVC;
                } else {
                    currentViewController=oldViewController;
                }
            }];
            [interestedCollectionViewVC.collectionView reloadData];
            break;
        }
    }
    
}
#pragma mark - 右上角添加button
-(void)addRightButtonItem{
    
    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editComplete) forControlEvents:UIControlEventTouchUpInside];
    rightButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    findScroll.scrollEnabled=NO;
    
    for (KBSubscriptionTypeOneImageView *view in allImageButton) {
        [view setUserInteractionEnabled:NO];
    }
}
#pragma mark - 点击右上角完成按钮时 通知响应
-(void)editComplete{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editComplete" object:nil userInfo:nil];
    self.navigationItem.rightBarButtonItem=nil;
    
    findScroll.scrollEnabled = YES;
    
    for (KBSubscriptionTypeOneImageView *view in allImageButton) {
        [view setUserInteractionEnabled:YES];
    }
}
#pragma mark - scrollView滑动时，指示标志也随着滑动
- (void)changeOffset:(NSInteger)tag{
    
    [findScroll setContentOffset:CGPointMake((tag-1)*kWindowSize.width, 0) animated:YES];
}

#pragma mark - searchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar1{
    
    KBSearchViewController *searchVC=[[KBSearchViewController alloc]init];
    searchVC.allType3StringArray=self.allType3StringArray;
    searchVC.allType3Array=self.allType3Array;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1{
    
    searchBar1.text=@"";
    [searchBar1 resignFirstResponder];
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self signScroll];
}
#pragma mark - 已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self signScroll];
}
#pragma mark - 将要开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [searchBar resignFirstResponder];
}
#pragma mark - 滑动处理结果(标志位移动)
- (void)signScroll
{
    int number=findScroll.contentOffset.x/kWindowSize.width;
    [triangleView removeFromSuperview];
    
    KBSubscriptionTypeOneImageView * view=[allImageButton objectAtIndex:number];
    //    [triangleView setFrame:CGRectMake(0.5*view.frame.size.width-5, view.frame.size.height-10, 10, 10)];
    NSString* str = @"color_";
    triangleView.backgroundColor = triangleViewColor[[str stringByAppendingString:[NSString stringWithFormat:@"%d",number+1]]];
    [view addSubview:triangleView];
    
    if (isNewFindView) {
        
        currentViewController=[self.childViewControllers objectAtIndex:number];
        KBDetailSubsctiptionTableViewController *newFindTableVC1=(KBDetailSubsctiptionTableViewController*)currentViewController;
        [newFindTableVC1.rightTableView reloadData];
    } else {
        currentViewController=[self.childViewControllers objectAtIndex:4+number];
        KBMySubcriptionViewController *interestedCollectionVC=(KBMySubcriptionViewController *)currentViewController;
        [interestedCollectionVC.collectionView reloadData];
    }
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
