//
//  AcountSafeVC.m
//  UIScroll1
//
//  Created by eddie on 15-4-22.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBChangePassWordVIewController.h"
#import "KBCommonSingleValueModel.h"
#import "AppDelegate.h"
#import "KBLoginSingle.h"
#import "KBProgressHUD.h"
#import "KBBaseNavigationController.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "KBPostParametersModel.h"
//cell的高度
#define USUAL_ROW_HEIGHT 45

@interface KBChangePassWordVIewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    UITextField *oldPassword;//旧密码
    
    UITextField *newPassword1;//新密码
    
    UITextField *newPassword2;//确认密码
    
    UITableView * accountSafeTableView;//tableView
    
    AppDelegate * appDelegate;
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    KBLoginSingle * loginSingle;//用户的单例
}
@end

@implementation KBChangePassWordVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    appDelegate = [UIApplication sharedApplication].delegate;
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    loginSingle=[KBLoginSingle newinstance];
    
    //tableView
    accountSafeTableView =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    accountSafeTableView.scrollsToTop=NO;
    accountSafeTableView.dataSource=self;
    accountSafeTableView .delegate=self;
    accountSafeTableView .tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 15)];
    [self.view addSubview:accountSafeTableView ];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //导航栏的右侧
    UIBarButtonItem *saveBarItem=[[UIBarButtonItem alloc]initWithTitle:@"更改" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndPop)];
    [saveBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=saveBarItem;
    
    //导航栏的标题
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"修改密码";
    titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    
    //导航栏的左侧返回
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:KBackImage forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popAccountSafe) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    //手势使键盘消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    //忘记密码
    UIButton * forgetBut=[[UIButton alloc]initWithFrame:CGRectMake(kWindowSize.width-0.3*self.view.width,210,0.25*self.view.width,0.1*self.view.height)];
    [forgetBut setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
    [forgetBut setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBut addTarget:self action:@selector(forgetPw) forControlEvents:UIControlEventTouchDown];
    forgetBut.titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:forgetBut];
}
#pragma mark - 忘记密码
-(void)forgetPw
{

}
#pragma mark - tableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, USUAL_ROW_HEIGHT)];
    [cell.contentView setFrame:cell.frame];
    if(indexPath.section==0&&indexPath.row==0)
    {
        [cell.textLabel setText:@"原密码"];
        oldPassword = [[UITextField alloc] initWithFrame:CGRectMake(105, 0, tableView.width-110, USUAL_ROW_HEIGHT)];
        oldPassword.placeholder=@"请输入密码";
        oldPassword.delegate=self;
        oldPassword.secureTextEntry=YES;
        oldPassword.returnKeyType=UIReturnKeyNext;
        oldPassword.clearButtonMode=UITextFieldViewModeWhileEditing;
        oldPassword.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:oldPassword];
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        [cell.textLabel setText:@"新密码"];
        newPassword1 = [[UITextField alloc] initWithFrame:CGRectMake(105, 0, tableView.width-110, USUAL_ROW_HEIGHT)];
        newPassword1.placeholder=@"请设置新密码";
        newPassword1.secureTextEntry=YES;
        newPassword1.delegate=self;
        newPassword1.clearButtonMode=UITextFieldViewModeWhileEditing;
        newPassword1.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:newPassword1];
        
    }
    else if(indexPath.section==0&&indexPath.row==2)
    {
        [cell.textLabel setText:@"确认密码"];
        newPassword2 = [[UITextField alloc] initWithFrame:CGRectMake(105, 0, tableView.width-110, USUAL_ROW_HEIGHT)];
        newPassword2.secureTextEntry=YES;
        newPassword2.delegate=self;
        newPassword2.placeholder=@"请再次输入新密码";
        newPassword2.clearButtonMode=UITextFieldViewModeWhileEditing;
        newPassword2.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:newPassword2];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return USUAL_ROW_HEIGHT;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
#pragma mark - 手势方法
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [oldPassword resignFirstResponder];
    [newPassword1 resignFirstResponder];
    [newPassword2 resignFirstResponder];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
    commonSingleValueModel.isForgetPw=NO;
}
#pragma mark - 返回
-(void)popAccountSafe{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 保存新密码
-(void)saveAndPop{
    if([oldPassword isFirstResponder])
    {
        [oldPassword resignFirstResponder];
    }
    else if([newPassword1 isFirstResponder])
    {
        [newPassword1 resignFirstResponder];
    }
    else
        [newPassword2 resignFirstResponder];
    NSString *nu=@"";
    NSString * oldPassWord=oldPassword.text;
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * path=[paths    objectAtIndex:0];
    NSString * filename=[path stringByAppendingPathComponent:@"login.plist"];
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];//读取数据
    NSString *pas=[dic2 objectForKey:@"pass"];
    NSString *name=[dic2 objectForKey:@"name"];
    NSString * newPassWord=newPassword1.text;
    NSString * newPassWordCheck=newPassword2.text;
    if(oldPassWord != nil && oldPassWord.length >=6
       && newPassWord != nil && newPassWord.length >=6
       && newPassWordCheck!=nil && newPassWordCheck.length>=6)
    {
        if([pas isEqualToString:oldPassWord]==NO)
        {
            if([newPassWord isEqualToString:newPassWordCheck]==NO)
            {
                [KBProgressHUD setHud:self.view withText:@"原密码不正确且新密码两次不一致" AndWith:0.375];
            }
            else
            {
                [KBProgressHUD setHud:self.view withText:@"原密码不正确" AndWith:0.375];
            }
        }
        else if([newPassWord isEqualToString:newPassWordCheck]==NO)
        {
             [KBProgressHUD setHud:self.view withText:@"两次新密码不一致" AndWith:0.375];
        }
        if([pas isEqualToString:oldPassWord]&&[newPassWord isEqualToString:newPassWordCheck])
        {
            // 使用NSDictionary封装请求参数
            NSDictionary * updatePasswdString=[KBPostParametersModel setSaveUserNewPassWordParameters:loginSingle.userID withOldPassWord:oldPassWord withNewPassWord:newPassWordCheck];
            
            // 使用AFHTTPRequestOperationManager发送POST请求
            [appDelegate.manager
             POST:KSaveUserNewPassWordUrl(kBaseUrl)
             parameters:updatePasswdString // 指定请求参数
             // 获取服务器响应成功时激发的代码块
             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 // 当使用HTTP响应解析器时，服务器响应数据被封装在NSData中
                 // 此处将NSData转换成NSString、并使用UIAlertView显示登录结果
                 NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                 NSString* upDate=[json objectForKey:@"updatePasswdResult"];
                 int intUpdate = [upDate intValue];
                 if (intUpdate==1)
                 {
                     [KBProgressHUD setHud:self.view withText:@"修改密码成功" AndWith:0.375];
                     NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
                     [data setObject:newPassWordCheck forKey:@"pass"];
                     [data setObject:name forKey:@"name"];
                     [data writeToFile:filename atomically:YES];
                     [self performSelector:@selector(popAccountSafe) withObject:nil afterDelay:1];
                 }
             }
             // 获取服务器响应失败时激发的代码块
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
             }];
        }
        
    }
    else
        if (([oldPassWord isEqualToString:nu])&& ([newPassWord isEqualToString:nu])&&([newPassWordCheck isEqualToString:nu]))
        {
            [KBProgressHUD setHud:self.view withText:@"原密码和新密码和新密码确认同时为空" AndWith:0.375];
        }
        else if ( ([newPassWord isEqualToString:nu])&&([newPassWordCheck isEqualToString:nu]))
        {
            [KBProgressHUD setHud:self.view withText:@"新密码和新密码确认同时为空" AndWith:0.375];
        }
        else if ([oldPassWord isEqualToString:nu])
        {
            [KBProgressHUD setHud:self.view withText:@"原密码为空" AndWith:0.375];
        }
        else if ([newPassWord isEqualToString:nu])
        {
           [KBProgressHUD setHud:self.view withText:@"新密码为空" AndWith:0.375];
        }
        else if ([newPassWordCheck isEqualToString:nu])
        {
           [KBProgressHUD setHud:self.view withText:@"新密码确认为空" AndWith:0.375];
        }
        else if (oldPassWord != nil && oldPassWord.length<6)
        {
            [KBProgressHUD setHud:self.view withText:@"原密码长度应大于6位" AndWith:0.375];
        }
        else if (newPassWord != nil && newPassWord.length<6)
        {
            [KBProgressHUD setHud:self.view withText:@"新密码长度应大于6位" AndWith:0.375];
        }
        else if (newPassWordCheck != nil && newPassWordCheck.length<6)
        {
            [KBProgressHUD setHud:self.view withText:@"新密码确认长度应大于6位" AndWith:0.375];
        }
}
#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0&alertView.tag==123)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}/*
  #pragma mark - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */

@end
