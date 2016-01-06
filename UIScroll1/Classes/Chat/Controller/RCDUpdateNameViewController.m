//
//  RCDUpdateNameViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDUpdateNameViewController.h"

#import <RongIMLib/RongIMLib.h>
#import "UIColor+RCColor.h"
#import "MBProgressHUD.h"
#define USUAL_ROW_HEIGHT 45
#define kMaxLength 14
@implementation RCDUpdateNameViewController

{
    MBProgressHUD *hud;
}

float DEVICE_WIDTH,DEVICE_HEIGHT;
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"讨论组名称";
    titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(backBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClicked:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    
   
    self.tableView =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.scrollsToTop=NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 15)];
    
    //添加手势取消键盘的第一响应
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
//添加手势取消键盘的第一响应
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.tfName resignFirstResponder];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(indexPath.section==0&&indexPath.row==0)
    {
        
        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, USUAL_ROW_HEIGHT)];
        [cell.contentView setFrame:cell.frame];
        self.tfName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-20, USUAL_ROW_HEIGHT)];
        self.tfName.delegate=self;
        self.tfName.text = self.displayText;
        self.tfName.clearButtonMode=UITextFieldViewModeAlways;
        self.tfName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:self.tfName];
        
    }
    return  cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return USUAL_ROW_HEIGHT;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(void) backBarButtonItemClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//保存讨论组名称
-(void) rightBarButtonItemClicked:(id) sender
{
    
    if(self.tfName.text.length == 0){
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"请输入讨论组名称!";
        
        hud.minSize=CGSizeMake(120.0f, 20.0f);
        hud.margin=10.f;
        hud.removeFromSuperViewOnHide=YES;
        hud.yOffset=0.375*DEVICE_HEIGHT;
        hud.mode=MBProgressHUDModeText;
        [hud hide:YES afterDelay:1];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入讨论组名称!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //回传值
    if (self.setDisplayTextCompletion) {
        self.setDisplayTextCompletion(self.tfName.text);
    }
    
    //保存设置
    [[RCIMClient sharedRCIMClient] setDiscussionName:self.targetId name:self.tfName.text success:^{
        
    } error:^(RCErrorCode status) {
        
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    //弹出键盘
    [self.tfName becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //收起键盘
    [self.tfName resignFirstResponder];
}


@end
