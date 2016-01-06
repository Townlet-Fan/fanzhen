//
//  NameEditVC.m
//  UIScroll1
//
//  Created by kuibu technology on 15/7/24.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBChangeNameViewController.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "KBPersonalDataViewController.h"
#import "KBProgressHUD.h"
#import "KBBaseNavigationController.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"

//cell的高度
#define USUAL_ROW_HEIGHT 45
//最大昵称输入长度
#define kMaxLength 14

@interface KBChangeNameViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    UITableView *nameEditTableview;//tableView
    
    KBLoginSingle *loginSingle;//用户的单例
    
    UITextField * nameTextField;//输入昵称的textField
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    UILabel * countLabel;//计数用户昵称输入的长度
}
@end

@implementation KBChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    
    //导航栏的title
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"昵称";
    titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //导航栏右侧
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges)];
    //导航栏的左侧返回
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popPersonal) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    //tableView
    nameEditTableview =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    nameEditTableview.dataSource=self;
    nameEditTableview.delegate=self;
    nameEditTableview.scrollsToTop=NO;
    nameEditTableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 15)];
    [self.view addSubview:nameEditTableview];
    
    //手势点击键盘消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    // Do any additional setup after loading the view.
    //计数用户昵称输入长度的Label
    countLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWindowSize.width-100, 130, 100, 20)];
    countLabel.textAlignment=NSTextAlignmentCenter;
    countLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self.view addSubview:countLabel];
    
    //接收textField输入的变化的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextFieldTextDidChangeNotification"object:nameTextField];
}
#pragma mark - textField输入长度的变化
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length>0) {
                countLabel.text=[NSString stringWithFormat:@"%lu/%d",(unsigned long)toBeString.length-1,kMaxLength];
            }
            else
            {
                countLabel.text=[NSString stringWithFormat:@"0/%d",kMaxLength];

            }
            if (toBeString.length >kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length>0) {
            countLabel.text=[NSString stringWithFormat:@"%lu/%d",(unsigned long)toBeString.length-1,kMaxLength];
        }
        else
        {
            countLabel.text=[NSString stringWithFormat:@"0/%d",kMaxLength];
            
        }
        if (toBeString.length >kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
#pragma mark - tableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(indexPath.section==0&&indexPath.row==0)
    {
        [cell setFrame:CGRectMake(0, 0, tableView.width, USUAL_ROW_HEIGHT)];
        [cell.contentView setFrame:cell.frame];
        nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-20, USUAL_ROW_HEIGHT)];
        nameTextField.delegate=self;
        nameTextField.text=commonSingleValueModel.userName;
        nameTextField.clearButtonMode=UITextFieldViewModeAlways;
        nameTextField.textAlignment = NSTextAlignmentLeft;
        if (nameTextField.text.length>0) {
            countLabel.text=[NSString stringWithFormat:@"%lu/%d",(unsigned long)nameTextField.text.length,kMaxLength];
        }
        else
        {
            countLabel.text=[NSString stringWithFormat:@"0/%d",kMaxLength];
        }
       [cell.contentView addSubview:nameTextField];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [nameTextField becomeFirstResponder];
}
#pragma mark- 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - 视图消失移除通知
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:nameTextField];
}
#pragma mark - 保存用户更改的昵称
-(void)saveChanges
{
    [nameTextField resignFirstResponder];
    if (nameTextField.text.length==0) {
        [KBProgressHUD setHud:self.view withText:@"不能为空" AndWith:0.375];
    }
    else
    {
        commonSingleValueModel.namechangeBool=YES;
        commonSingleValueModel.userName=nameTextField.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -手势方法
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [nameTextField resignFirstResponder];
}
#pragma mark - 返回Personal
-(void)popPersonal
{
    [self.navigationController popViewControllerAnimated:YES];
}/*
  #pragma mark - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */

@end
