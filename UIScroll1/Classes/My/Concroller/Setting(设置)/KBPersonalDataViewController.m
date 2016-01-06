
//
//  PersonalDataViewController.m
//  UIScroll1
//
//  Created by eddie on 15-4-12.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBPersonalDataViewController.h"
#import "AppDelegate.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "zlib.h"
#import  "rootViewController.h"
#import "KBSchoolLocationViewController.h"
#import "RCDHttpTool.h"
#import "KBWhetherReachableModel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "KBChangePassWordVIewController.h"
#import "KBChangeNameViewController.h"
#import "KBPersonalSexChooseViewController.h"
#import "KBSchoolChooseViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBWhetherReachableModel.h"
#import "KBPostParametersModel.h"
#import "KBProgressHUD.h"
#import "KBHTTPTool.h"
#import "UMComSession.h"
#import "UMComTools.h"
#import "UMComPullRequest.h"
#import "UMComPushRequest.h"
#import "UMComUserAccount.h"
//头像cell的高度
#define HEAD_ROW_HEIGHT 100
//其他cell的高度
#define USUAL_ROW_HEIGHT 70

@interface KBPersonalDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

{
    NSString *userphoto; //用户头像
    
    UILabel *sexLable;//性别的label

    UITableView *personDataTableView;//tableView
    
    UIImageView *headImageView;//头像的imgeView
    
    UITextField *currentTextfield;
    
    UILabel *nameLable;//昵称的label
    
    UILabel *Schoollable;//学校的label
    
    AppDelegate* appDelegate;
    
    UIImage *userImage;//用户的image
    
    KBLoginSingle *loginSingle;//用户的单例
    
    KBCommonSingleValueModel *commonSingleValueModel;//传值的单例
    
    BOOL isPickPhoto;//是否更新了头像
    
    MBProgressHUD *hud;//提示
    
    UIPickerView * yearPicker;//入学年份选择器
    
    UILabel * yearLabel;//入学年份的label
    
    NSMutableArray *pickerArray;//入学年份选择器的数据源的数组
    
    NSInteger selectRow;//选中的入学年份
}
@end

@implementation KBPersonalDataViewController

float DEVICE_WIDTH_SCALE,DEVICE_HEIGHT_SCALE;
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    commonSingleValueModel.userName=loginSingle.userName;
    if (loginSingle.userSex.length==0) {
        loginSingle.userSex=@"男";
    }
    if (loginSingle.userSchool.length==0) {
        loginSingle.userSchool=@"华东理工大学";//默认华东理工大学
    }
    //默认入学年份2012 所以选中的行数为112
    if(loginSingle.userYearComeINSchool==0)
        selectRow=112;
    else
      selectRow=loginSingle.userYearComeINSchool-1900;
   
    //选择器数组初始化
    pickerArray=[[NSMutableArray alloc]init];
    for (int i=0; i<=200; i++) {
        [pickerArray addObject:[[NSString alloc] initWithFormat:@"%d",i+1900]];
    }
    commonSingleValueModel.userSex=loginSingle.userSex;
    appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    DEVICE_WIDTH_SCALE=[UIScreen mainScreen].scale*kWindowSize.width;
    DEVICE_HEIGHT_SCALE=[UIScreen mainScreen].scale*kWindowSize.height;
    
    //导航栏的title
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"个人设置";
    titleLable.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    self.navigationItem.titleView=titleLable;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //导航栏右侧的保存按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveChanges)];
    //导航栏左侧返回按钮
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popPersonal) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    //tableView
    personDataTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    personDataTableView.scrollsToTop=NO;
    personDataTableView.dataSource=self;
    personDataTableView.delegate=self;
    personDataTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:personDataTableView];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, kWindowSize.width+0.5, 44)];
    [personDataTableView reloadData];
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    
    self.pushBtn.userInteractionEnabled=YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    
}
#pragma mark - tableView dataSouce
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 27;
    else
        return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0&&indexPath.row==0)
    {
        UITableViewCell *cell;
        static NSString *FindAllIdentifier=@"headView";
        cell=[tableView dequeueReusableCellWithIdentifier:FindAllIdentifier];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FindAllIdentifier];
        }
        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, HEAD_ROW_HEIGHT)];
        [cell.contentView setFrame:cell.frame];
        //设置头像的cell
        cell.textLabel.text=@"   头像";
        [cell.textLabel setTextColor:[UIColor blackColor]];
        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.width-HEAD_ROW_HEIGHT-10, 10, HEAD_ROW_HEIGHT-20, HEAD_ROW_HEIGHT-20)];
        if (loginSingle.userPhoto) {
            headImageView.image=loginSingle.userPhoto;
            userImage=loginSingle.userPhoto;
        }
        else
            headImageView.image=[UIImage imageNamed:@"默认头像-大有阴影"];
        [cell.contentView addSubview:headImageView];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return  cell;
    }
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, USUAL_ROW_HEIGHT)];
    [cell.contentView setFrame:cell.frame];
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 1:{
                [cell.textLabel setText:@"   昵称"];
                nameLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.width-100 -30,cell.height)];
                nameLable.text=commonSingleValueModel.userName;
                nameLable.textAlignment=NSTextAlignmentRight;
                nameLable.textColor=[UIColor grayColor];
                [cell.contentView addSubview:nameLable];
            }
                break;
            case 3:
            {
                [cell.textLabel setText:@"   学校"];
                Schoollable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.width-100-30  , cell.height)];
                Schoollable.text=loginSingle.userSchool;
                Schoollable.textColor=[UIColor grayColor];
                Schoollable.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:Schoollable];
            }
                break;
            case 2:
            {
                [cell.textLabel setText:@"   性别"];
                sexLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.width-100-30,cell.height)];
                [sexLable setText:commonSingleValueModel.userSex];
                sexLable.textAlignment=NSTextAlignmentRight;
                sexLable.textColor=[UIColor grayColor];
                [cell.contentView addSubview: sexLable];
                
            }
                break;
            case  4:
            {
                [cell.textLabel setText:@"   入学年份"];
                yearLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.frame.size.width-100-30  , cell.frame.size.height)];
                yearLabel.text=[NSString stringWithFormat:@"%ld",(long)loginSingle.userYearComeINSchool];
                yearLabel.textAlignment=NSTextAlignmentRight;
                yearLabel.textColor=[UIColor grayColor];
                [cell.contentView addSubview: yearLabel];
            }
            default:
                
                break;
        }
    }
    else{
        switch (indexPath.row)
        {
            case 0:
                [cell.textLabel setText:@"   更改密码"];
                break;
            case 1:
                [cell.textLabel setText:@"   注销登录"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
                
            default:
                
                break;
        }
    }
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)return 5;
    else return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
                return HEAD_ROW_HEIGHT;
                break;
                
                
            default:
                return USUAL_ROW_HEIGHT;
                break;
        }
    }
    else
    {
        return USUAL_ROW_HEIGHT;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //性别的选择
    if (indexPath.section==0&&indexPath.row==2) {
        KBPersonalSexChooseViewController *SexChoose=[[KBPersonalSexChooseViewController alloc]init];
        [self.navigationController pushViewController:SexChoose animated:YES];
    }
    //昵称的改变
    else if (indexPath.section==0&&indexPath.row==1)
    {
        KBChangeNameViewController *NameEdit=[[KBChangeNameViewController alloc]init];
        [self.navigationController pushViewController:NameEdit animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
    }
    //选择头像
    else if(indexPath.section==0&&indexPath.row==0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self pickHeadPhoto];
        [cell setSelected:NO];
        
    }
    //学校的选择
    else if(indexPath.section==0&&indexPath.row==3){
        KBSchoolChooseViewController * Schoolchoose=[[KBSchoolChooseViewController alloc]init];
        [self.navigationController pushViewController:Schoolchoose animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
//        NewSchoolChoose * newSchoolChoose=[[NewSchoolChoose alloc]init];
//        [self.navigationController pushViewController:newSchoolChoose animated:YES];
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        [cell setSelected:NO];
    }
    //入学年份的选择
    else if(indexPath.section==0&&indexPath.row==4)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
        [self customTime];
    }
    //更改密码
    else if(indexPath.section==1&&indexPath.row==0){
        KBChangePassWordVIewController *acountSafe=[[KBChangePassWordVIewController alloc]init];
        [self.navigationController pushViewController:acountSafe animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
    }
    //注销登录
    else if(indexPath.section==1&&indexPath.row==1){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定注销登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        alert.delegate=self;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        alert.tag=20;
    }
}
#pragma mark - 入学年份的选择
-(void)customTime
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    yearPicker = [[UIPickerView alloc] init];
    //yearPicker.backgroundColor=[UIColor redColor];
    yearPicker.delegate = self;
    yearPicker.dataSource = self;
    [yearPicker selectRow:selectRow inComponent:0 animated:YES];
    [alert.view addSubview:yearPicker];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        commonSingleValueModel.yearschoolchangeBool=YES;
        [self selectrow:selectRow];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alert addAction:ok];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{ }];
}
#pragma mark - 选中的入学年份
-(void)selectrow:(NSInteger)row
{
    NSString *dateString =[pickerArray objectAtIndex:row];
    yearLabel.text=dateString;
    commonSingleValueModel.yearschoolchangeBool=YES;
}
#pragma mark - pickerView dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *timeLabel = [[UILabel alloc] init];
    if (kWindowSize.width==320) {
        [timeLabel setFrame:CGRectMake(kWindowSize.width/2.0, 0, 100, 30)];
        timeLabel.textAlignment=NSTextAlignmentLeft;
        timeLabel.text = [[NSString alloc] initWithFormat:@"   %@",[pickerArray objectAtIndex:row]];
    }
    else if(kWindowSize.width==375)
    {
        [timeLabel setFrame:CGRectMake(kWindowSize.width/2.0, 0, 80, 30)];
        timeLabel.textAlignment=NSTextAlignmentRight;
        timeLabel.text = [[NSString alloc] initWithFormat:@"%@",[pickerArray objectAtIndex:row]];
    }
    else
    {
        [timeLabel setFrame:CGRectMake(kWindowSize.width/2.0, 0, 120, 30)];
        timeLabel.textAlignment=NSTextAlignmentRight;
        timeLabel.text = [[NSString alloc] initWithFormat:@"%@",[pickerArray objectAtIndex:row]];
    }
    timeLabel.textColor=[UIColor blackColor];
    return timeLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow=row;
}
#pragma mark - 导航栏的设置
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //状态栏的颜色改变
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //导航栏左右按钮变白
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //导航栏标题变白
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
#pragma mark - 选择头像
-(void)pickHeadPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [picker.navigationBar setBarTintColor:KColor_15_86_192];
    //    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage *img= [self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];
        NSData *data = UIImagePNGRepresentation(img);//UIImageJPEGRepresentation(img,1.0f);
        userphoto= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        userImage=[[UIImage alloc]init];
        userImage=img;
        loginSingle.userPhoto=userImage;
        headImageView.image=image;
        isPickPhoto=YES;
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
-(UIImage *) scaleFromImage: (UIImage *) image1 toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 微社区 友盟用户资料更新
- (void)UMengAccpuntUpdate
{
    //友盟用户更新
    if (isPickPhoto||commonSingleValueModel.namechangeBool||commonSingleValueModel.sexchangeBool) {
        UMComUserAccount *userAccount = [[UMComUserAccount alloc]initWithSnsType:UMComSnsTypeSelfAccount];
        userAccount.usid = [NSString stringWithFormat:@"%ld",(long)[KBLoginSingle newinstance].userID];//自己账号UID（本方服务器生成的）
        userAccount.name = [KBLoginSingle newinstance].userName;
        userAccount.iconImage = [KBLoginSingle newinstance].userPhoto;
        if ([[KBLoginSingle newinstance].userSex isEqualToString:@"男"]) {
            userAccount.gender = [NSNumber numberWithInt:1];
            NSLog(@"[KBLoginSingle newinstance].userSex:%@----%@",[KBLoginSingle newinstance].userSex,userAccount.gender);
        }else{
            userAccount.gender = [NSNumber numberWithInt:0];
        }
        [UMComPushRequest updateWithUser:userAccount completion:^(NSError *error) {
            NSLog(@"<<<<<<<--------->%@",error);
        }];
    }
}

#pragma mark - 保存用户更新的信息
-(void)saveChanges{
    if (isPickPhoto||commonSingleValueModel.namechangeBool||commonSingleValueModel.sexchangeBool||commonSingleValueModel.schoolchangeBool||commonSingleValueModel.yearschoolchangeBool)
    {
        if (!isPickPhoto) {
            UIImage *img= [self scaleFromImage:loginSingle.userPhoto toSize:CGSizeMake(80.0f, 80.0f)];
            NSData *data = UIImagePNGRepresentation(img);
            
            userphoto= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
        //post参数
        NSDictionary * updateInfoString=[KBPostParametersModel setSaveUserInfoParameters:loginSingle.userID withUserName:nameLable.text withUserPhoto:userphoto withUserSex:sexLable.text withUserSchool:Schoollable.text withUserSchoolYear:yearLabel.text];
        [KBHTTPTool postRequestWithUrlStr:KSaveUserInfoUrl(kBaseUrl) parameters:updateInfoString completionHandr:^(id responseObject) {
            KBLog(@"responserobject:%@",responseObject);
            NSString* updateResult =responseObject[@"updateResult"];
            int updateresult = [updateResult intValue];
            if (updateresult==1){
                if(isPickPhoto||commonSingleValueModel.namechangeBool)
                {
                    NSString * refreshUserInfoUserId=[responseObject objectForKey:@"userId"];
                    RCUserInfo * user = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",refreshUserInfoUserId] name:[responseObject objectForKey:@"userName"] portrait:[responseObject objectForKey:@"userPhoto"]];
                    NSLog(@"refresh:%@",refreshUserInfoUserId);
                    [RCIMClient sharedRCIMClient].currentUserInfo = user;
                    [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:[NSString stringWithFormat:@"%@",refreshUserInfoUserId]];
                }
                loginSingle.userPhoto=userImage;
                loginSingle.userName=nameLable.text;
                loginSingle.userSex=sexLable.text;
                loginSingle.userSchool=Schoollable.text;
                loginSingle.userYearComeINSchool=[yearLabel.text integerValue];
                commonSingleValueModel.namechangeBool=NO;
                commonSingleValueModel.sexchangeBool=NO;
                commonSingleValueModel.schoolchangeBool=NO;
                commonSingleValueModel.yearschoolchangeBool=NO;
                isPickPhoto=NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_HEAD" object:nil];
                [KBProgressHUD setHud:self.view withText:@"您的信息更新成功" AndWith:0.375];
            }
            else
            {
                [KBProgressHUD setHud:self.view withText:@"您的信息更新失败" AndWith:0.375];
            }
            
        } error:^(NSError *error) {
            NSLog(@"error:%@",error);
            [KBProgressHUD setHud:self.view withText:@"您的信息更新失败" AndWith:0.375];
        }];
        
        //友盟账户资料更新
        [self UMengAccpuntUpdate];
        
//        KBLog(@"updateInfoString:%@",updateInfoString);
//        // 使用AFHTTPRequestOperationManager发送POST请求
//        [appDelegate.manager
//         POST:KSaveUserInfoUrl(kBaseUrl)
//         parameters:updateInfoString  // 指定请求参数
//         // 获取服务器响应成功时激发的代码块
//         success:^(AFHTTPRequestOperation *operation, id responseObject)
//         {
//             // 当使用HTTP响应解析器时，服务器响应数据被封装在NSData中
//             // 此处将NSData转换成NSString、并使用UIAlertView显示登录结果
//             NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//             NSString* updateResult =[json objectForKey:@"updateResult"];
//             int updateresult = [updateResult intValue];
//             if (updateresult==1){
//                 if(isPickPhoto||commonSingleValueModel.namechangeBool)
//                 {
//                     NSString * refreshUserInfoUserId=[json objectForKey:@"userId"];
//                     RCUserInfo * user = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",refreshUserInfoUserId] name:[json objectForKey:@"userName"] portrait:[json objectForKey:@"userPhoto"]];
//                     NSLog(@"refresh:%@",refreshUserInfoUserId);
//                     [RCIMClient sharedRCIMClient].currentUserInfo = user;
//                     [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:[NSString stringWithFormat:@"%@",refreshUserInfoUserId]];
//                 }
//                 loginSingle.userPhoto=userImage;
//                 loginSingle.userName=nameLable.text;
//                 loginSingle.userSex=sexLable.text;
//                 loginSingle.userSchool=Schoollable.text;
//                 loginSingle.userYearComeINSchool=[yearLabel.text integerValue];
//                 commonSingleValueModel.namechangeBool=NO;
//                 commonSingleValueModel.sexchangeBool=NO;
//                 commonSingleValueModel.schoolchangeBool=NO;
//                 commonSingleValueModel.yearschoolchangeBool=NO;
//                 isPickPhoto=NO;
//                 [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_HEAD" object:nil];
//                 [KBProgressHUD setHud:self.view withText:@"您的信息更新成功" AndWith:0.375];
//             }
//             else
//             {
//                 [KBProgressHUD setHud:self.view withText:@"您的信息更新失败" AndWith:0.375];
//             }
//         }
//         // 获取服务器响应失败时激发的代码块
//         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//         {
//             KBLog(@"error:%@",error);
//            [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
//          }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1&alertView.tag==20)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths;
        NSString *path;
        paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        path=[paths    objectAtIndex:0];
        NSString *localLoginSinglePath=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
        if ([fileManager fileExistsAtPath:localLoginSinglePath])//如果存在LocalLoginSingle.data
        {
            //可能内存泄漏
            //删除login.plist
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths;
            NSString *path;
            paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            path=[paths    objectAtIndex:0];
            path=[path stringByAppendingPathComponent:@"login.plist"];
            
            if([fileManager fileExistsAtPath:path])
            {
                NSLog(@"删除删除login.plist");
                [fileManager removeItemAtPath:path error:nil];
            }
            //重新初始化用户的单例 未登录的数据
            KBLoginSingle *localLoginSingle=[KBLoginSingle newinstance];
            localLoginSingle.isLogined=NO;
            localLoginSingle= [localLoginSingle newinstanceWith:(KBLoginSingle *)[NSKeyedUnarchiver unarchiveObjectWithFile:localLoginSinglePath ]];
         
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LOCAL_RELOGIN" object:nil];
            
            //微社区退出登录
            [[UMComSession sharedInstance] userLogout];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSucceedNotification object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"注销失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    if (buttonIndex==1&alertView.tag==111) {
        [self saveChanges];
    }
    if (buttonIndex==0&alertView.tag==111) {
        commonSingleValueModel.namechangeBool=NO;
        commonSingleValueModel.sexchangeBool=NO;
        commonSingleValueModel.schoolchangeBool=NO;
        commonSingleValueModel.yearschoolchangeBool=NO;
        rootViewController *root=self.rootDelegate;
        [root scrollToMenu];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}
#pragma mark - 返回Menu
-(void)popPersonal{
    //判断退出时 是否有数据更新但是没保存（在有网的情况下）
    if( (isPickPhoto||commonSingleValueModel.namechangeBool||commonSingleValueModel.sexchangeBool||commonSingleValueModel.schoolchangeBool||commonSingleValueModel.yearschoolchangeBool)&&[KBWhetherReachableModel whetherReachable]){
        {//NSLog(@"%d,%d,%d",isPickPhoto,transport.namechangeBool,transport.sexchangeBool);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存对资料的修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
            alert.tag=111;
            [alert show];
        }
    }
    else
    {
        rootViewController *root=self.rootDelegate;
        [root scrollToMenu];
        [self.navigationController popViewControllerAnimated:NO];
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
