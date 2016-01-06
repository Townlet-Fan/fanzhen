//
//  SystemSettingTVC.m
//  UIScroll1
//
//  Created by kuibu technology on 15/5/19.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBSystemSettingViewController.h"
#import "rootViewController.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import <QuartzCore/QuartzCore.h>
#import "KBPersonalDataViewController.h"
#import "MBProgressHUD.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBWhetherLoginModel.h"
//cell的高度
#define USUAL_ROW_HEIGHT 70

@interface KBSystemSettingViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

{
    rootViewController *root; //
    
    UIView *blackView;
    
    UILabel *fontLable;//字体
    
    UILabel *nameLable;//我的账号
    
    UILabel *cacheLable;//缓存
    
    UILabel *versionLable;//版本
    
    BOOL isOnlyImageInWiFi;//是否只在WiFi下加载文字
    
    NSString *fontSizeStr;//字体的大小
    
    UIActionSheet *setFontAS;//设置字体的ActionSheet
    
    MBProgressHUD *hud;
    
    KBLoginSingle * loginSingle;//用户的单例
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
}
@end

@implementation KBSystemSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化用户的单例
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];

    //设置置顶为No
    self.tableView.scrollsToTop=NO;
    
    //导航栏的title
    self.navigationItem.titleView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"系统设置";
    titleLable.font =KFont_20;
    self.navigationItem.titleView=titleLable;
    //导航栏的左侧按钮
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:KBackImage forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popSystem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;

    
    [self.view setFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height)];
    
    blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width , self.view.height)];
    blackView.userInteractionEnabled=NO;
    // [blackView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:blackView];
    
    
    
    //设置字体的actionSheet
    setFontAS=[[UIActionSheet alloc]initWithTitle:@"设置字体" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小号字体",@"中号字体",@"大号字体", nil];
    
    //初始化单例的isOnlyImageInWiFi和fontSizeStr值
    isOnlyImageInWiFi  =[KBCommonSingleValueModel newinstance].isOnlyImageInWiFi;
    fontSizeStr=[KBCommonSingleValueModel newinstance].fontSizeStr;
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section==0)return 1;
    else if(section ==1)
        return 2;
    else  return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return USUAL_ROW_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, USUAL_ROW_HEIGHT)];
    [cell.contentView setFrame:cell.frame];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0&&indexPath.row==0) {
        cell.textLabel.text=@"  我的账号";
        nameLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.width-100-30  , cell.height)];
        if ([KBWhetherLoginModel userWhetherLogin]) {
            nameLable.text=loginSingle.userCounter;
        }
        else
            nameLable.text=@"您还未登录";
        if (loginSingle.isLogined)
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        else
            ;
        nameLable.textAlignment=NSTextAlignmentRight;
        nameLable.textColor=[UIColor grayColor];
        [cell.contentView addSubview:nameLable];
    }
    else if(indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text=@"  文章字体大小";
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                fontLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.frame.size.width-100-30  , cell.frame.size.height)];
                
                [fontLable setText:fontSizeStr];
                fontLable.textAlignment=NSTextAlignmentRight;
                fontLable.textColor=[UIColor grayColor];
                [cell.contentView addSubview:fontLable];
            }
                break;
            case 1:
            {
                cell.textLabel.text=@"  清理缓存";
                NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
                NSFileManager* manager = [NSFileManager defaultManager];
                if (![manager fileExistsAtPath:path]) return 0;
                NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
                NSString* fileName;
                long long folderSize = 0;
                while ((fileName = [childFilesEnumerator nextObject]) != nil){
                    NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
                    folderSize += [self fileSizeAtPath:fileAbsolutePath];
                }
                NSString * cacheStr=[NSString stringWithFormat:@"%.2fMB",folderSize/(1024.0*1024.0)];
                cacheLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.frame.size.width-100-30  , cell.frame.size.height)];
                cacheLable.textAlignment=NSTextAlignmentRight;
                cacheLable.text=cacheStr;
                cacheLable.textColor=[UIColor grayColor];
                [cell.contentView addSubview:cacheLable];
                
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
                
                break;
            default:
                break;
        }
    }
    //版本更新
    else
    {
        cell.textLabel.text=@"当前版本";
        versionLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0,cell.frame.size.width-100-30  , cell.frame.size.height)];
        versionLable.textAlignment=NSTextAlignmentRight;
        versionLable.text=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        versionLable.textColor=[UIColor grayColor];
        [cell.contentView addSubview:versionLable];
    }
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 27;
    else
        return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==0) {
        [setFontAS showInView:blackView];
    }
    else if (indexPath.section==1&&indexPath.row==1){
        [self cleaning:indexPath];
    }
    if (indexPath.section==0) {
        if (loginSingle.isLogined) {
            KBPersonalDataViewController *personDataVC=[[KBPersonalDataViewController alloc]init];
            personDataVC.rootDelegate=root;
            [self.navigationController pushViewController:personDataVC animated:YES];
        }
    }
    
}
#pragma mark - 只在wifi下加载文章的网络图片
-(void)onlyImageInWiFiSwich:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
    }
    else
    {
    }
    isOnlyImageInWiFi=!isOnlyImageInWiFi;
    
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, kWindowSize.width+0.5, 44)];
    //NSLog(@"%@name,%ld",loginsingle.userCounter,(long)transport.islogined);
    if ([KBWhetherLoginModel userWhetherLogin]) {
        nameLable.text=loginSingle.userCounter;
    }
    else{
        nameLable.text=@"您还未登录";
    }
    [self.tableView reloadData];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isOnlyImageInWiFi forKey:@"isOnlyImageInWiFi"];
    [userDefaults setObject:fontSizeStr forKey:@"fontSizeStr"];
    [userDefaults synchronize];
    [KBCommonSingleValueModel newinstance].isOnlyImageInWiFi=isOnlyImageInWiFi;
    [KBCommonSingleValueModel newinstance].fontSizeStr=fontSizeStr;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - 清理缓存
-(int)cleaning:(NSIndexPath *)indexPath
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在清理...";
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess:) withObject:indexPath waitUntilDone:YES];});
    return 1;
}
#pragma mark - 清除缓存
-(long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(void)clearCacheSuccess:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    [self performSelector:@selector(refreshLable:) withObject:cell afterDelay:1];
}
-(void)refreshLable:(UITableViewCell *)cel{
    cacheLable.text=@"0.00MB";
    [hud hide:YES];
    MBProgressHUD *hudComplete=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hudComplete];
    hudComplete.customView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"勾.png"]];
    hudComplete.mode=MBProgressHUDModeCustomView;
    hudComplete.labelText=@"清除缓存成功";
    [hudComplete show:YES];
    [hudComplete hide:YES afterDelay:1];
}
#pragma mark - 弹出选择字体的actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        fontLable.text=@"小号字体";
    }
    else if(buttonIndex==1)
    {
        fontLable.text=@"中号字体";
    }
    else if(buttonIndex==2)
    {
        fontLable.text=@"大号字体";
    }
    fontSizeStr=fontLable.text;
}
#pragma mark - 返回Menu
-(void)popSystem{
    rootViewController *root1=self.rootDelegate;
    [root1 scrollToMenu];
    [self.navigationController popViewControllerAnimated:NO];
    
}
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
