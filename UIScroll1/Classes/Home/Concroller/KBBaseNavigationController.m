//
//  navController.m
//  UIScroll1
//
//  Created by eddie on 15-3-23.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBBaseNavigationController.h"
#import "KBMainViewController.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "KBInfoWebViewController.h"
#import "KBCommonSingleValueModel.h"
#define SYSTEM_VERSION    [[[UIDevice currentDevice] systemVersion] doubleValue]
// 标准系统状态栏高度

#define SYS_STATUSBAR_HEIGHT                        20
// 热门栏高度
#define HOTSPOT_STATUSBAR_HEIGHT            20
// 导航栏（UINavigationController.UINavigationBar）高度
#define NAVIGATIONBAR_HEIGHT                44
// 工具栏（UINavigationController.UIToolbar）高度
#define TOOLBAR_HEIGHT                              44
// 标签栏（UITabBarController.UITabBar）高度
#define TABBAR_HEIGHT                              44
// APP_STATUSBAR_HEIGHT=SYS_STATUSBAR_HEIGHT+[HOTSPOT_STATUSBAR_HEIGHT]
#define APP_STATUSBAR_HEIGHT                (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
// 根据APP_STATUSBAR_HEIGHT判断是不是存在热门栏
#define IS_HOTSPOT_CONNECTED                (APP_STATUSBAR_HEIGHT==(SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO)
// 无热门栏时，标准系统状态栏高度+导航栏高度
#define NORMAL_STATUS_AND_NAV_BAR_HEIGHT    (SYS_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)
// 实时系统状态栏高度+导航栏高度，如有热门栏，其高度包括在APP_STATUSBAR_HEIGHT中。
#define STATUS_AND_NAV_BAR_HEIGHT                    (APP_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)

@interface KBBaseNavigationController ()
{
    KBCommonSingleValueModel * transport;
}
@end

@implementation KBBaseNavigationController
@synthesize delegatemain;
@synthesize delegateroot;
float DEVICE_WIDTH,DEVICE_HEIGHT;
- (void)viewDidLoad
{
    [super viewDidLoad];
    transport=[KBCommonSingleValueModel newinstance];
    KBMainViewController *mc=[[KBMainViewController alloc]init];
    mc.navdelegate=self;
    transport.navcontrolDelegate=self;
    self.delegatemain=mc;
    DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
    DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
    AppDelegate *appDelegate= [UIApplication sharedApplication].delegate;
    appDelegate.NavigationController=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    
    
}
-(void)DidFinishLaunching
{
    //NSLog(@"isffffffyeyeyeyeyeyesssss");
    transport.isFinishLaunching=YES;
}

-(void)DidChangeStatusBarFrame
{  // NSLog(@"isFinishLaunching;%d",isFinishLaunching);
    if (transport.isFinishLaunching) {
        
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,20, self.view.frame.size.width, self.view.frame.size.height+20);
            
            transport.isFinishLaunching=NO;
            //  NSLog(@"4440404040404isFinishLaunchingend;%d",isFinishLaunching);
        }
        else
        {
            self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
            
            transport.isFinishLaunching=NO;
            // NSLog(@"202020202020isFinishLaunchingend;%d",isFinishLaunching);
        }
        
    }
    
    else if(!transport.isFinishLaunching)
    {
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            // NSLog(@"440404040");
            self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height+20);
        }
        else
        {
            //NSLog(@"22222202020202020");
            self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        }
        
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    //    if ([UIApplication sharedApplication].statusBarFrame.size.height==40) {
    //        NSLog(@"400040040");
    //            NSLog(@"[UIApplication sharedApplication].statusBarFrame.origin.y:%f",[UIApplication sharedApplication].statusBarFrame.origin.y);
    //        self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,[UIApplication sharedApplication].statusBarFrame.origin.y+40+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    //
    //    }
    //    else
    //    {   NSLog(@"222020202020");
    //        NSLog(@"[UIApplication sharedApplication].statusBarFrame.origin.y:%f",[UIApplication sharedApplication].statusBarFrame.origin.y);
    //        self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    //    }
    
    
    //    self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    
}
- (void)didReceiveMemoryWarning
{
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
