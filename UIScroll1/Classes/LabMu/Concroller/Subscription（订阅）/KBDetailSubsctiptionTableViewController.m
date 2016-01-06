//
//  NewFindTableViewController.m
//  UIScroll1
//
//  Created by 樊振 on 15/10/11.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBDetailSubsctiptionTableViewController.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBSortDetailViewControl.h"
#import "KBCommonSingleValueModel.h"
#import "KBTwoSortSubscriptionCell.h"
#import "KBThreeSortSubscriptionViewCell.h"
#import "KBColumnSortButton.h"
#import "KBLoginSingle.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBSubcriptionMainViewController.h"
#import "KKNavigationController.h"
#import "KBBaseNavigationController.h"
#import "KBWhetherReachableModel.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
//右边tableView的cell的高度
#define rightTableRowHeight 60
//右边tableView的setionHead的高度
#define rightTableHeaderHeight 40
//左边tableView的sectionHead的高度
#define leftTableSectionHeight 60

@interface KBDetailSubsctiptionTableViewController ()<KBthreeSortSubscriptionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *leftTableView;//左边的tableView 二级分类
    
    KBLoginSingle *loginSingle;//用户单例
    
    BOOL isRefresh;//是否刷新tableView
    
    UIAlertView *alterview;//提示
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    bool isLeftTableViewTouchDown;//是否点击了左边的tableView
}
@end

@implementation KBDetailSubsctiptionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    alterview =[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法连接到网络,请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    isRefresh=YES;
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    KBBaseNavigationController *navVC =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FEFRASH_NOT) name:@"FEFRASH_NOT" object:nil];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    //isRefresh在点击进入三级分类的时候是No，commonSingleValueModel.istouchDownInterest点击订阅的时候是YES
    if (isRefresh||commonSingleValueModel.istouchDownInterest) {
        isLeftTableViewTouchDown=true;
        //左边的tableView
        leftTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWindowSize.width*0.25, self.view.height) style:UITableViewStylePlain];
        leftTableView.backgroundColor=KColor_246;
        leftTableView.scrollsToTop=NO;
        leftTableView.tag=99;
        leftTableView.bounces=NO;
        leftTableView.showsVerticalScrollIndicator=NO;
        leftTableView.dataSource=self;
        leftTableView.delegate=self;
        leftTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        leftTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:leftTableView];
        
        //右边的tableView
        self.rightTableView=[[UITableView alloc] initWithFrame:CGRectMake(leftTableView.right, leftTableView.top, kWindowSize.width-leftTableView.width, self.view.height) style:UITableViewStylePlain];
        self.rightTableView.tag=101;
        self.rightTableView.scrollsToTop=NO;
        self.rightTableView.showsVerticalScrollIndicator=NO;
        self.rightTableView.dataSource=self;
        self.rightTableView.delegate=self;
        [self.view addSubview:self.rightTableView];
        //默认选中左边tableView的第一个
        NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
        [leftTableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}
#pragma mark - 视图已经消失
-(void)viewDidDisappear:(BOOL)animated{
    
    [alterview removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 设置刷新状态
-(void)FEFRASH_NOT
{
    isRefresh=YES;
}
#pragma mark - 加关注代理
-(void)addInterestCell:(KBColumnSortButton *) buton{
    if (![KBWhetherReachableModel whetherReachable]) {
        [alterview show];
    }
    else
    {
        self.isChanged=YES;
        [buton removeTarget:self action:@selector(addInterestCell:) forControlEvents:UIControlEventTouchUpInside];
        KBThreeSortModel *find_3=buton.findType_3Delegate;
        KBTwoSortModel *find_2=find_3.parentFind_2Delegate;
        [self.interestOneArray addObject:find_3];
        find_3.isIntrest=YES;//三级分类变为关注
        for (int i=0; i<self.typeOneInterestStructArray.count ; i++)
        {
            KBTwoSortModel *find2Interest=[self.typeOneInterestStructArray objectAtIndex:i];
            if (find2Interest.TypeTowID==find_2.TypeTowID)
            {
                [find2Interest.subArray addObject:find_3];
            }
        }
        [buton addTarget:self action:@selector(removecell:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightTableView reloadData];
    }
    
}
#pragma mark - 取消关注代理
-(void)removecell:(KBColumnSortButton *) buton
{
    if (![KBWhetherReachableModel whetherReachable]) {
        [alterview show];
    }
    else
    {
        self.isChanged=YES;
        [buton removeTarget:self action:@selector(removecell:) forControlEvents:UIControlEventTouchUpInside];
        KBThreeSortModel *find_3=buton.findType_3Delegate;
        KBTwoSortModel *find_2=find_3.parentFind_2Delegate;
        
        [self.interestOneArray removeObject:find_3];
        find_3.isIntrest=NO;//三级分类变为未关注
        for (int i=0; i<self.typeOneInterestStructArray.count ; i++)
        {
            KBTwoSortModel *find2Interest=[self.typeOneInterestStructArray objectAtIndex:i];
            if (find2Interest.TypeTowID==find_2.TypeTowID) {
                
                [find2Interest.subArray removeObject:find_3];
            }
        }
        
        [buton addTarget:self action:@selector(addInterestCell:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rightTableView reloadData];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.typeOneArray1.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag==99)
    {
        return 1;
    }
    else
    {
        KBTwoSortModel *find2=[self.typeOneArray1 objectAtIndex:section];
        return find2.subArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==leftTableView)
    {
        KBTwoSortSubscriptionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"leftCellIdentifier"];
        if (!cell) {
            cell=[[KBTwoSortSubscriptionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"leftCellIdentifier"];
        }
        KBTwoSortModel *find2=[self.typeOneArray1 objectAtIndex:indexPath.section];
        [cell setTwoSortSubscriptionCellWith:find2 andIndexPath:indexPath];
        return cell;
    }
    else {
        
        KBThreeSortSubscriptionViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"rightCellIndentifier"];
        if (cell==nil) {
            cell=[[KBThreeSortSubscriptionViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rightCellIndentifier"];
            cell.delegate = self;
        }
        KBTwoSortModel *find2=[self.typeOneArray1 objectAtIndex:indexPath.section];
        KBThreeSortModel *find3=[find2.subArray objectAtIndex:indexPath.row];
        [cell setThreeSortSubscriptionWithModel:find3 andTwoSortModel:find2];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==leftTableView)
    {
        return leftTableSectionHeight;
    } else {
        return rightTableRowHeight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.rightTableView)
    {
        return rightTableHeaderHeight;
    } else {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView==self.rightTableView) {
        
        KBTwoSortModel *find2=[self.typeOneArray1 objectAtIndex:section];
        static NSString *FindAllIdentifier=@"FindAllIdentifier";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FindAllIdentifier];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FindAllIdentifier];
        }
        [cell setFrame:CGRectMake(0, 0, self.rightTableView.frame.size.width, rightTableHeaderHeight)];
        cell.textLabel.text=find2.name;
        cell.textLabel.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        cell.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        KBColumnSortButton * oneKeyConcernBut=[[KBColumnSortButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-100, cell.frame.size.height*0.5-10, 100, 20)];
        
        oneKeyConcernBut.section=section;
        [oneKeyConcernBut setTitle:@"一键订阅" forState:UIControlStateNormal];
        oneKeyConcernBut.titleLabel.font=[UIFont systemFontOfSize:15];
        [oneKeyConcernBut addTarget:self action:@selector(onekeyConcern:) forControlEvents:UIControlEventTouchDown];
        [oneKeyConcernBut setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
        oneKeyConcernBut.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:oneKeyConcernBut];
        return cell;
    }
    else
        return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==leftTableView)
    {
        isLeftTableViewTouchDown=false;
        float scrollHeight=0;
        int i=0;
        //计算点击的cell之前的所有二级分类包含三级分类的高度之和
        for (; i<indexPath.section; i++) {
            KBTwoSortModel *find2=[self.typeOneArray1 objectAtIndex:i];
            for (int j=0; j<find2.subArray.count; j++) {
                scrollHeight+=rightTableRowHeight;
            }
            scrollHeight+=rightTableHeaderHeight;
        }
        //被点击二级分类后面剩下的三级分类高度之和
        float theRestHeightOfType2=0;
        for (; i<self.typeOneArray1.count; i++) {
            KBTwoSortModel *find2=[self.typeOneArray1 objectAtIndex:i];
            for (int j=0; j<find2.subArray.count; j++) {
                theRestHeightOfType2+=rightTableRowHeight;
            }
            theRestHeightOfType2+=rightTableHeaderHeight;
        }
        //如果tableview触底，则显示到底部即可
        CGPoint offset = CGPointMake(0, scrollHeight);
        [self.rightTableView setContentOffset:offset animated:YES];
        
        KBTwoSortSubscriptionCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        for (int j=0 ; j<self.typeOneArray1.count; j++) {
            if (j!=indexPath.section) {
                cell=[leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(j)]];
                [cell setTitleColor:KColor_102];
            }
            else
            {
                cell=[leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(j)]];
                [cell setTitleColor:KColor_15_86_192];
            }
            
        }
        
    }
    else{
        KBTwoSortModel *find2 = [self.typeOneArray1 objectAtIndex:indexPath.section];
        KBThreeSortModel *find_3=[find2.subArray objectAtIndex:indexPath.row];
        
        KBSortDetailViewControl *nttVC=[[KBSortDetailViewControl alloc]init];
        nttVC.thirdTypeName=find_3.name;
        nttVC.secondTypeID=find_3.TypeTowID;
        KBThreeSortSubscriptionViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
        isRefresh=NO;
        commonSingleValueModel.istouchDownInterest=NO;
        [self.navigationController pushViewController:nttVC animated:YES];
    }
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==leftTableView) {
        
        //加这个判断，左边tableview才能滑动
    } else {
        
        int i=0;
        float scrollHeight=0;
        while (true) {
            
            KBTwoSortModel *find2=[self.typeOneArray1 objectAtIndex:i];
            for (int j=0; j<find2.subArray.count; j++) {
                scrollHeight+=rightTableRowHeight;
            }
            scrollHeight+=rightTableHeaderHeight;
            i++;
            if (scrollHeight>self.rightTableView.contentOffset.y) {
                break;
            }
            
            
        }
        
        if (isLeftTableViewTouchDown) {
            //i-1为should选中的cell,滑动至leftTableView相应cell
            NSIndexPath *scrollIndexPath=[NSIndexPath indexPathForRow:0 inSection:(i-1)];
            [leftTableView selectRowAtIndexPath:scrollIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];//选中某行
            
            KBTwoSortSubscriptionCell *cell;
            
            for (int j=0 ; j<self.typeOneArray1.count; j++) {
                if (j!=(i-1)) {
                    cell=[leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(j)]];
                    [cell setTitleColor:KColor_102];
                }
                else
                {
                    cell=[leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(j)]];
                    [cell setTitleColor:KColor_15_86_192];
                }
                
            }
        }
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    isLeftTableViewTouchDown=true;
}
#pragma mark - 一建订阅
-(void)onekeyConcern:(KBColumnSortButton *) buton
{
    if (![KBWhetherReachableModel whetherReachable]) {
        [alterview show];
    }
    else
    {
        KBTwoSortModel *find2=[self.typeOneArray1  objectAtIndex:buton.section];
        KBTwoSortModel *find2Interest=[self.typeOneInterestStructArray  objectAtIndex:buton.section];
        
        for (int j=0; j<find2.subArray.count; j++) {
            self.isChanged=YES;
            KBThreeSortModel *find_3=[find2.subArray objectAtIndex:j];
            if ([self.interestOneArray containsObject:find_3]){
                continue;
            }
            else
            {
                [self.interestOneArray addObject:find_3];
                find_3.isIntrest=YES;
                [find2Interest.subArray addObject:find_3];
            }
            
        }
        
    }
    [self.rightTableView reloadData];
    
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
