//
//  FeedBackViewController.m
//  UIScroll1
//
//  Created by eddie on 15-6-10.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMainFeedBackViewController.h"
#import "rootViewController.h"
#import "KBCommonSingleValueModel.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
#import "KBFeedBackViewController.h"
@interface KBMainFeedBackViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    KBCommonSingleValueModel* commonSingleValueModel;//传值的单例
    
    UITableView *listView;//tableView
}
@end

@implementation KBMainFeedBackViewController
@synthesize rootDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    // Do any additional setup after loading the view.
    listView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    listView.showsVerticalScrollIndicator=NO;
    listView.scrollsToTop=NO;
    listView.delegate=self;
    listView.dataSource=self;
    listView.rowHeight=80;
    [self.view addSubview:listView];
    
    //导航栏的title
    self.navigationItem.titleView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"反馈";
    titleLable.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    //导航栏的左侧返回
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popFeedback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    
}
#pragma mark - tableView dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 27;
    else
        return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"内容问题";
                    
                    break;
                case 1:
                    cell.textLabel.text=@"程序问题";
                    break;
                case 2:
                    cell.textLabel.text=@"使用问题";
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
            cell.textLabel.text=@"其他问题";
            break;
        case 2:
            cell.textLabel.text=@"对跬步的建议";
            break;
        default:
            
            break;
    }
    cell.detailTextLabel.text=@"点击进入反馈";
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    KBFeedBackViewController *feedBackTVC=[[KBFeedBackViewController alloc]initWithStyle:UITableViewStyleGrouped];
    feedBackTVC.proTypeStr=cell.textLabel.text;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    feedBackTVC.feedbackType=1;
                    break;
                case 1:
                    feedBackTVC.feedbackType=2;
                    break;
                case 2:
                    feedBackTVC.feedbackType=3;
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
            feedBackTVC.feedbackType=4;
            break;
        case 2:
            feedBackTVC.feedbackType=5;
            break;
        default:
            
            break;
    }
    [self.navigationController pushViewController:feedBackTVC animated:YES];
    
}
#pragma mark- 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    [listView reloadData];
}
#pragma mark - 返回Menu
-(void)popFeedback{
    rootViewController *root=self.rootDelegate;
    [root scrollToMenu];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
