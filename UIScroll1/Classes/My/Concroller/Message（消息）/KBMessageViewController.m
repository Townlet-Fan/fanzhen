//
//  MessageViewController.m
//  UIScroll1
//
//  Created by eddie on 15-4-12.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMessageViewController.h"
#import "rootViewController.h"
#import "KBCommonSingleValueModel.h"
#import "KBMyMessageReplyViewController.h"
#import "KBMyMessageThumbupViewController.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
//回复和点赞 button的View的高度
#define HEIGHT_BARVIEW 50

@interface KBMessageViewController ()<UIScrollViewDelegate>

{
    UIView *barView;//回复和点赞 button的View
    
    NSMutableArray *barSubviews;//回复和点赞 button的View的数组
    
    UIScrollView *tabScroll;//回复和点赞所处的scrollView
    
    UIView *sliderView;//上方的滑动条
    
    UIButton *oldButton; //点击的button
    
    UIView * ReplyMessage;//回复红点的View
    
    UIView * ThumpMessage;//点赞红点的View
    
    KBCommonSingleValueModel *commonSingleValueModel;//传值的单例
    
    UIButton *respondBtn;//回复的button
    
    UIButton *thumbupBtn;//点赞的button
    
    KBMyMessageReplyViewController *messageTable;//消息回复的table
    
    KBMyMessageThumbupViewController *thumbUpTable;//消息点赞的table
   
}
@end

@implementation KBMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //导航栏的title
    self.navigationItem.titleView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"消息";
    titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    //导航栏的左侧返回
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    //回复和点赞 button的View
    barView =[[UIView alloc]initWithFrame:CGRectMake(self.navigationController.navigationBar.left,self.navigationController.navigationBar.bottom, self.view.width, HEIGHT_BARVIEW)];
    [barView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:barView];
    
    //barView回复的button
    respondBtn=[[UIButton alloc]init];
    [respondBtn setTitle:@"回复" forState:UIControlStateNormal];
    //barView点赞的button
    thumbupBtn=[[UIButton alloc]init];
    [thumbupBtn setTitle:@"点赞" forState:UIControlStateNormal];
    
    //回复和点赞 button的View的数组
    barSubviews=[NSMutableArray arrayWithObjects:respondBtn,thumbupBtn, nil];
    for (int i=0; i<barSubviews.count; i++) {
        UIButton *btn=[barSubviews objectAtIndex:i];
        [btn setTitleColor:KColor_102 forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(i*self.view.width/2.0, 0, self.view.width/2.0, HEIGHT_BARVIEW)];
        [btn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchDown];
        btn.titleLabel.adjustsFontSizeToFitWidth=YES;
        [barView addSubview:btn];
    }
    //回复红点view
    ReplyMessage=[[UIView alloc]initWithFrame: CGRectMake(respondBtn.width/2.0+30, 12, 8, 8)];
    ReplyMessage.backgroundColor=[UIColor redColor];
    ReplyMessage.layer.bounds=CGRectMake(0, 0, 8, 8);
    ReplyMessage.layer.cornerRadius=4;
    //点赞红点view
    ThumpMessage=[[UIView alloc]initWithFrame: CGRectMake(thumbupBtn.width/2.0+30, 12, 8, 8)];
    ThumpMessage.backgroundColor=[UIColor redColor];
    ThumpMessage.layer.bounds=CGRectMake(0, 0, 8, 8);
    ThumpMessage.layer.cornerRadius=4;
    
    //回复有新消息
    if (commonSingleValueModel.hasRely==YES) {
        [respondBtn addSubview:ReplyMessage];
    }
    //点赞有新消息
    if (commonSingleValueModel.hasPraise==YES) {
        [thumbupBtn addSubview:ThumpMessage];
    }
    
    //上方的滑动条
    sliderView =[[UIView alloc]initWithFrame:CGRectMake(40, barView.height-5,(barView.width-160)/2.0, 5)];
    [sliderView setBackgroundColor:KColor_15_86_192];
    [barView addSubview:sliderView];
    
    //回复和点赞所处的scrollView
    tabScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, barView.bottom, barView.width, self.view.height-barView.bottom)];
    [tabScroll setBackgroundColor:[UIColor whiteColor]];
    tabScroll.pagingEnabled=YES;
    tabScroll.bounces=NO;
    tabScroll.delegate=self;
    tabScroll.showsHorizontalScrollIndicator=NO;
    tabScroll.scrollsToTop=NO;
    [tabScroll setContentSize:CGSizeMake(2*tabScroll.frame.size.width, 0)];
    [self.view addSubview:tabScroll];
    
    //添加回复表
    messageTable=[[KBMyMessageReplyViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [messageTable.tableView setFrame:CGRectMake(0,0,tabScroll.width  ,tabScroll.height)];
    messageTable.parentVCDelegate=self;
    [tabScroll addSubview:messageTable.tableView];
    [self addChildViewController:messageTable];
    
    //点赞列表
    thumbUpTable=[[KBMyMessageThumbupViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [ thumbUpTable.tableView setFrame:CGRectMake(tabScroll.contentSize.width/2.0,0, tabScroll.width  ,tabScroll.height)];
    [tabScroll addSubview:thumbUpTable.tableView];
    [self addChildViewController:thumbUpTable];
    
    //通知 消息界面滚动和不滚动
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enable) name:@"MESSAGE_ENABLE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noEnable) name:@"MESSAGE_NO_ENABLE" object:nil];
    //有新消息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveNewMessage) name:@"HAVE_NEWMESSAGE" object:nil];
    //改变消息状态的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeMessage) name:@"CHANGE_MESSAGE" object:nil];

}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    //监听tabScroll的位置变化
    [tabScroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width+0.5, 44)];
    self.navigationController.navigationBarHidden=NO;
    
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - 有新消息
-(void)haveNewMessage
{
    if (commonSingleValueModel.hasRely==YES) {
       [respondBtn addSubview:ReplyMessage];
    }
    if (commonSingleValueModel.hasPraise==YES) {
        [thumbupBtn addSubview:ThumpMessage];
    }
}
#pragma mark - 消息状态的改变
-(void)ChangeMessage
{
    if(!commonSingleValueModel.hasPraise){
        [ThumpMessage removeFromSuperview];
    }
    if(!commonSingleValueModel.hasRely){
        [ReplyMessage removeFromSuperview];
    }
}
#pragma mark - 监听位置的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(tabScroll.contentOffset.x>0)
        [sliderView setFrame:CGRectMake(tabScroll.contentOffset.x/2+40, sliderView.top, sliderView.width, 5)];
    int i=(int)(tabScroll.contentOffset.x/tabScroll.width+0.5);
    [oldButton setTitleColor:KColor_102 forState:UIControlStateNormal];
    oldButton=[barSubviews objectAtIndex:i];
    [oldButton setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
    UIButton * scroll;
    scroll=[barSubviews objectAtIndex: (int)(tabScroll.contentOffset.x/tabScroll.width+0.5)];
    //当到达此位置的时候存在红点,刷新,红点消失
    if (scroll.subviews.count>1) {
        if ([scroll isEqual:respondBtn]) {
            [ReplyMessage removeFromSuperview];
            [messageTable myMessageReplyInit];
            commonSingleValueModel.hasRely=NO;
        }
        else if ([scroll isEqual:thumbupBtn]){
            [ThumpMessage removeFromSuperview];
            [thumbUpTable myMessageThumbupInit];
            commonSingleValueModel.hasPraise=NO;
        }
    }
    //置顶
    if (i==0) {
        messageTable.tableView.scrollsToTop=YES;
        thumbUpTable.tableView.scrollsToTop=NO;
    }
    else if (i==1) {
        messageTable.tableView.scrollsToTop=NO;
        thumbUpTable.tableView.scrollsToTop=YES;
    }
}
-(void)hasMessage
{
    if (!commonSingleValueModel.hasRely&&!commonSingleValueModel.hasPraise) {
        commonSingleValueModel.hasMessage=NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_MESSAGE" object:nil];
    }
}
#pragma mark - 回复和点赞button的点击切换
-(void)changeView:(UIButton *)btn{
    NSInteger btnI=[barSubviews indexOfObject:btn];
    [tabScroll setContentOffset:CGPointMake(btnI*tabScroll.frame.size.width, 0) animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    [tabScroll removeObserver:self forKeyPath:@"contentOffset"];
    [self hasMessage];
}
#pragma mark - 消息界面操作
-(void)enable{
    barView.userInteractionEnabled=YES;
    tabScroll.scrollEnabled=YES;
}
#pragma mark - 消息界面不可操作
-(void)noEnable{
    barView.userInteractionEnabled=NO;
    tabScroll.scrollEnabled=NO;
}
#pragma mark - 返回
-(void)popMessage{
    rootViewController *root=self.rootDelegate;
    [root scrollToMenu];
    [self.navigationController popViewControllerAnimated:NO];
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
