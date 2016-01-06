//
//  SexChooseVC.m
//  UIScroll1
//
//  Created by kuibu technology on 15/7/24.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBPersonalSexChooseViewController.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "KBPersonalDataViewController.h"
#import "KBBaseNavigationController.h"
#import "KBConstant.h"
//cell的高度
#define USUAL_ROW_HEIGHT 45

@interface KBPersonalSexChooseViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *SexChooseTableview;//tableView
    
    KBLoginSingle *loginSingle;//用户的单例
    
    KBCommonSingleValueModel *commonSingleValueModel;//传值的单例
}
@end

@implementation KBPersonalSexChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    
    //导航栏的title
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"性别";
    titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //导航栏的左侧的返回
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popPersonal) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    //tableView
    SexChooseTableview =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    SexChooseTableview.scrollsToTop=NO;
    SexChooseTableview.dataSource=self;
    SexChooseTableview.delegate=self;
    SexChooseTableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 15)];
    [self.view addSubview:SexChooseTableview];
    
    // Do any additional setup after loading the view.
}
#pragma mark -视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - tableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, USUAL_ROW_HEIGHT)];
    [cell.contentView setFrame:cell.frame];
    if(indexPath.section==0&&indexPath.row==0)
    {
        [cell.textLabel setText:@"男"];
        if([commonSingleValueModel.userSex isEqualToString:@"男"])
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    else
    {   [cell.textLabel setText:@"女"];
        if([commonSingleValueModel.userSex isEqualToString:@"女"])
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if (indexPath.row==0){
        if ([commonSingleValueModel.userSex isEqualToString:@"男"]) {
            
            commonSingleValueModel.sexchangeBool=NO;
        }
        else
        {
            commonSingleValueModel.sexchangeBool=YES;
            commonSingleValueModel.userSex=@"男";
        }
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([commonSingleValueModel.userSex isEqualToString:@"女"]) {
            
            commonSingleValueModel.sexchangeBool=NO;
        }
        else{
            commonSingleValueModel.sexchangeBool=YES;
            commonSingleValueModel.userSex=@"女";
        }
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return USUAL_ROW_HEIGHT;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 返回Personal
-(void)popPersonal
{
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
