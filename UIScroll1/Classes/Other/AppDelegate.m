//
//  AppDelegate.m
//  UIScroll1
//
//  Created by eddie on 15-3-20.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaSSOHandler.h"
#import "Reachability.h"
#import "KBLoginSingle.h"
#import "KBAllTypeInfoModel.h"
#import <SMS_SDK/SMSSDK.h>
#import "KBCommonSingleValueModel.h"
#import "rootViewController.h"
#import "MobClick.h"
#import "UMessage.h"
#import "KBInfoWebViewController.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBUserGuideViewController.h"
#import "KBMyVIewController.h"
#import <CoreLocation/CLLocationManager.h>
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "KBPersonalDataViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "KBConstant.h"
#import "KBHTTPTool.h"
#import "KBWebviewInfoModel.h"
#import "Reachability.h"
#import "KBPostParametersModel.h"
#import "KBLoginModel.h"
#import "UMCommunity.h"

#define UMengCommunityAppkey @"567ad8eee0f55afa43002e3e"
//#define UMengCommunityAppkey @"561f32d067e58eab640027d8"//勋哥的
#define UMengLoginAppkey UMengCommunityAppkey
//机型判断
#define iPhone6                                                                   \
([UIScreen instancesRespondToSelector:@selector(currentMode)]               \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                            \
[[UIScreen mainScreen] currentMode].size)        \
: NO)
#define iPhone6Plus                                                               \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)                            \
: NO)

@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMClientReceiveMessageDelegate>
{
    KBCommonSingleValueModel *commonSingleValueModel;//传值的单例

    NSMutableDictionary *json;//获取数据的json
    
    KBInfoWebViewController * InfoWebViewVC;//正文的实例
    
    AppDelegate* appDelegate;//
    
    NSString * userPhotoURL;//用户头像的url
    
    NSString * userName;//用户昵称
    
    KBWebviewInfoModel * webviewInfoModel;//正文的单例
    
    //融云获取的数据
    NSString* cType;
    NSString* fId;
    NSString* tId;
    NSString * tId_fId_userName;
}


@end

@implementation AppDelegate

BOOL isConnectedToInternet;//判断网络的连接的状态

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //初始化单例
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    KBLoginSingle *loginSingle=[KBLoginSingle newinstance];
    KBAllTypeInfoModel *type=[KBAllTypeInfoModel newinstance];
    webviewInfoModel=[KBWebviewInfoModel newinstance];

    
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer=[[AFCompoundResponseSerializer alloc]init];
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //判断是不是第一次启动应用
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        KBUserGuideViewController * userGuideViewController=[[KBUserGuideViewController alloc]init];
        self.window.rootViewController=userGuideViewController;
        commonSingleValueModel.isFirstUsing=YES;
        
    }
    else
    {
        NSLog(@"不是第一启动");
        commonSingleValueModel.isFirstUsing=NO;
        //                        UserGuideViewController * userGuideViewController=[[UserGuideViewController alloc]init];
        //                        self.window.rootViewController=userGuideViewController;
        rootViewController * rootviewController=[[rootViewController alloc]init];
        self.window.rootViewController=rootviewController;
    }
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //友盟分享
    [self shareSet];
    //短信验证
    [SMSSDK registerApp:KMessageVerifyCounter withSecret:KMessageVerifySecretCounter];
    //友盟统计
    [self youMengStatistics];
   
    
  
    //判断是否联网
    isConnectedToInternet=NO;
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable ||[[Reachability reachabilityForLocalWiFi]currentReachabilityStatus]!=NotReachable)
    {
        //请求服务器获取网络状态
        NSURL *url=[NSURL URLWithString:kHomeTopUrl(kBaseUrl)];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        NSError *err;
        NSData *responseObject = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
        NSString *jsonString=@"kuibu";
        jsonString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (jsonString.length==0) {
            
            isConnectedToInternet=NO;
        }
        else
            isConnectedToInternet=YES;
    }
    
    
    //判断是否存在login.plist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths;
    NSString *path;
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    path=[paths objectAtIndex:0];
    path=[path stringByAppendingPathComponent:@"login.plist"];
    

    {
        if([fileManager fileExistsAtPath:path]) //如果存在login.plist
        {
            
            NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
            NSString *userTel=[dic objectForKey:@"name"];
            NSString *passWord=[dic objectForKey:@"pass"];
            NSLog(@"userTel:%@,pass:%@",userTel,passWord);
            //如果联网直接自动登录，初始化loginSingle
            if (isConnectedToInternet){
                
                // NSLog(@"youwang!!");
                {
                    {
                        NSDictionary * loginPostDic = [KBPostParametersModel setLoginParameters:-1 withMail:@"" withTelNumber:userTel withPassWord:passWord];
                        [KBHTTPTool postRequestWithUrlStr:KUserLoginUrl(kBaseUrl) parameters:loginPostDic completionHandr:^(id responseObject) {
                            NSString* userId=[responseObject objectForKey:@"userId"];
                            NSLog(@"useid:%@",userId);
                        //
                        loginSingle.userID=[userId integerValue];
                        
                        if (loginSingle.userID==-1)//可能密码被其他手机修改
                        {
                            commonSingleValueModel.remainUserName=userTel;
                            [fileManager removeItemAtPath:path error:nil];
                            NSString *loginedLoginSinglePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"LocalLoginSingle.data"];
                            if ([fileManager fileExistsAtPath:loginedLoginSinglePath])//如果存在LocalLoginSingle.data
                            {

                                KBLoginSingle *loginSingle=[KBLoginSingle newinstance];
                                
                                loginSingle=[NSKeyedUnarchiver unarchiveObjectWithFile:loginedLoginSinglePath];
                            }
                            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                            alertV.tag=123;
                            [alertV show];
                        }
                        else
                        {
                            //本地存一份登录用户的数据
                            NSArray *paths;
                            NSString *path;
                            paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                            path=[paths    objectAtIndex:0];
                            path=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
                            //初始化用户单例
                            [KBLoginModel loginSingleModelWithDictionary:responseObject];
                            commonSingleValueModel.remainUserName=userTel;
                            loginSingle.userCounter=userTel;
                            
                            //头像设置
                            NSData *  ImageData   = [NSData dataWithContentsOfURL:[NSURL URLWithString:responseObject[@"userPhoto"]]];
                            UIImage *Image  =[UIImage imageWithData:ImageData];
                            loginSingle.userPhoto=Image;

                            [NSKeyedArchiver archiveRootObject:loginSingle toFile:path];
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"USER_RELOGIN_SUCCEED" object:nil];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_HEAD" object:nil];
                        }
                        } error:^(NSError *error) {
                             UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败，请检查网络设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                            [alertV show];
                        }];
                    }
                }
            }
            else
            {
                path=[paths objectAtIndex:0];
                NSString *loginedLoginSinglePath=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
                NSLog(@"%@",[fileManager fileExistsAtPath:loginedLoginSinglePath]?@"you!":@"meiyou!");
                if ([fileManager fileExistsAtPath:loginedLoginSinglePath])
                {
                    KBLoginSingle *loginSingle;
                    loginSingle=[NSKeyedUnarchiver unarchiveObjectWithFile:loginedLoginSinglePath];
                    [loginSingle newinstanceWith:loginSingle];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"USER_RELOGIN_SUCCEED" object:nil];
                }
            }
        }
        
        else
            //不存在login.plist,从来没有登录过或者注销登录了
        {
            NSLog(@"不存在login.plist,从来没有登录过或者注销登录了");
            path=[paths objectAtIndex:0];
            NSString *localLoginSinglePath=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
            NSLog(@"local;%@",localLoginSinglePath);
            if ([fileManager fileExistsAtPath:localLoginSinglePath])//如果存在LocalLoginSingle.data
            {
                
               //需要检查分类并进行处理或者删除重新初始化loginSingle
                if (![self isUpDatedType])
                {

                    [fileManager removeItemAtPath:path error:nil];
                    
                    loginSingle.userInterestStructArray =  [type useFocuArrayReturnInterestStruct:loginSingle.userFocusId];
                    //NSLog(@"loginsingle uersinters:%@",loginSingle.userInterestStructArray);
                    loginSingle.userInterestNoStructArray=[type ReturnInterestNoStruct];
                    loginSingle.userAllTypeArray=type.allTypeArray;
                    
                    [NSKeyedArchiver archiveRootObject:loginSingle toFile:path];
                    
                }
                //分类没变化
                else
                {
                    KBLoginSingle *loginSingle;
                    loginSingle=[NSKeyedUnarchiver unarchiveObjectWithFile:localLoginSinglePath];
                    
                    [loginSingle newinstanceWith:loginSingle];
                    
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LOCAL_RELOGIN" object:nil];
                
            }
            else
                //不存在LocalLoginSingle.data(第一次进入程序)
            {
                //第一次进入应用程序
                NSLog(@"不存在LocalLoginSingle.data(第一次进入程序");
                
                path=[paths    objectAtIndex:0];
                path=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
                
                
                // LoginSingle *loginSingle=[LoginSingle newinstance];
                //初始化关注的列表Array结构
                
                loginSingle.userInterestStructArray =  [type useFocuArrayReturnInterestStruct:loginSingle.userFocusId];
                //NSLog(@"loginsingle uersinters:%@",loginSingle.userInterestStructArray);
                loginSingle.userInterestNoStructArray=[type ReturnInterestNoStruct];
                loginSingle.userAllTypeArray=type.allTypeArray;
                
                [NSKeyedArchiver archiveRootObject:loginSingle toFile:path];
                
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                
                [userDefaults setBool:NO forKey:@"isOnlyImageInWiFi"];
                [userDefaults setObject:@"中号字体" forKey:@"fontSizeStr"];
                [userDefaults synchronize];
                
            }
            
        }
    }
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    commonSingleValueModel.isOnlyImageInWiFi=(bool)[userDefaults objectForKey:@"isOnlyImageInWiFi"];
    commonSingleValueModel.fontSizeStr=[userDefaults objectForKey:@"fontSizeStr"];
    
    //融云
    //[self RongCloud];
    
    //    [RCIM sharedRCIM].disableMessageNotificaiton=YES;
    //    [RCIM sharedRCIM].disableMessageAlertSound=YES;
    /*
     * 统计推送打开率1
     */
    //收到声音
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    
    [[RCIM sharedRCIM] connectWithToken:loginSingle.userToken success:^(NSString *userId) {
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"Login successfully with userId: %@.", userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"login error status: %ld.", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
    
    //友盟消息推送
    //[UMessage startWithAppkey:@"55be0ff1e0f55ac25500bc10" launchOptions:launchOptions];
    //友盟消息推送测试
    [UMessage startWithAppkey:KYouMengCounterTest launchOptions:launchOptions];
    [UMessage setLogEnabled:YES];
    NSDictionary* userInfo1 = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSLog(@"userinfo:%@",userInfo1);

    if([userInfo1 objectForKey:@"rc"])
    {
        [[RCIM sharedRCIM] connectWithToken:loginSingle.userToken success:^(NSString *userId) {
            //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            NSLog(@"Login successfully with userId: %@.", userId);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"login error status: %ld.", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
        }];
        
        
        NSDictionary* RC = [userInfo1 objectForKey:@"rc"];
        
        cType = [RC valueForKey:@"cType"];
        fId = [RC objectForKey:@"fId"];
        tId = [RC  valueForKey:@"tId"];
        NSLog(@"rc:%@  fid:%@,tid:%@",cType,fId,tId);
        [KBHTTPTool getRequestWithUrlStr:KRongYunGetUserInfoUrl(kBaseUrl, tId) parameters:nil completionHandr:^(id responseObject) {
            NSString *  code=responseObject[@"code"];
            int codeInt=[code intValue];
            if (codeInt==1) {
                
                tId_fId_userName=responseObject [@"userName"];
            }
            else
            {
                tId_fId_userName=@"跬步小伙伴";
            }

        } error:^(NSError *error) {
            ;
        }];
        RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
        
        // conversationVC.conversationType =model.conversationType; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        if ([cType isEqualToString:@"PR"]) {
            conversationVC.conversationType = ConversationType_PRIVATE;
        }
        else{
            
        }
        conversationVC.targetId = fId; // 接收者的 targetId，这里为举例。
        conversationVC.userName = tId_fId_userName; // 接受者的 username，这里为举例。
        conversationVC.title = tId_fId_userName; // 会话的 title。
        //conversationVC.hidesBottomBarWhenPushed = YES;
        
        [(UINavigationController *)self.NavigationController pushViewController:conversationVC animated:YES];
    }
    else if (userInfo1.count!=0)
    {
        [UMessage setBadgeClear:YES];
        [UMessage sendClickReportForRemoteNotification:userInfo1];
        NSInteger pageid=[[userInfo1 objectForKey:@"id"]intValue];
        webviewInfoModel.classString=[userInfo1 objectForKey:@"classString"];
        webviewInfoModel.pageId=pageid;
        webviewInfoModel.imagestr=[userInfo1 objectForKey:@"imageString"];
        webviewInfoModel.textString=[userInfo1 objectForKey:@"textString"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            webviewInfoModel.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:webviewInfoModel.imagestr]];
        });
        commonSingleValueModel.TitleIsroot=YES;
        //[(UINavigationController *)self.NavigationController pushViewController:titView animated:YES];
    }
    //开启监听网络
    ///开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self.reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [self.reach startNotifier]; //开始监听，会启动一个run loop
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged) name:@"REACH_INTERNET_CHANGE" object:nil];
    
    //设置友盟话题appkey
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [UMCommunity openLog:YES];
    //Message
    [UMCommunity setWithAppKey:UMengCommunityAppkey];//54d19091fd98c55a19000406
    
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"umwsq"]) {
        [UMComMessageManager startWithOptions:launchOptions];
        if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
        {
            [UMComMessageManager didReceiveRemoteNotification:notificationDict];
        }
    } else {
        [UMComMessageManager startWithOptions:nil];
        //使用你的消息通知处理
    }
    //下面实现自定义登录
    //KBLoginViewController *loginViewControler = [[KBLoginViewController alloc] init];
    //[UMComLoginManager setLoginHandler:loginViewControler];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx96110a1e3af63a39" appSecret:@"c60e3d3ff109a5d17013df272df99199" url:@"http://www.umeng.com/social"];
    //设置分享到QQ互联的appId和appKey
    [UMSocialQQHandler setQQWithAppId:@"1104606393" appKey:@"X4BAsJAVKtkDQ1zQ" url:@"http://www.umeng.com/social"];
    [UMComLoginManager setAppKey:UMengLoginAppkey];
    
    return YES;
}

#pragma mark - 友盟话题
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

#pragma mark - 融云
-(void)RongCloud
{
    [[RCIM sharedRCIM] initWithAppKey:@"82hegw5uh0g9x"];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        //NSLog(@"iPhone6 %d", iPhone6);
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource =self;
    [RCIM sharedRCIM].groupInfoDataSource = self;
    //    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
    //[RCIM sharedRCIM].groupUserInfoDataSource = self;
    
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    //圆角
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //统一导航条样式
    UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]
     setBarTintColor:[UIColor colorWithRed:49/255.0 green:110/255.0 blue:214/255.0 alpha:1.0]];//                    NSString*token=[NSString stringWithFormat:@"yCLIUaWwxHJhMtCb46a8xNlXo/nzV4xPE/VcqNg1ldpbfVUWn3gl6vQ4yzfBP/1NNAQFWGBOjcw="];

    
    
}
#pragma mark - 友盟统计
-(void)youMengStatistics
{
    //友盟后台统计
    // [MobClick startWithAppkey:@"55be0ff1e0f55ac25500bc10" reportPolicy:BATCH   channelId:@"nil"];
    //友盟后台统计测试
    [MobClick startWithAppkey:KYouMengCounterTest reportPolicy:BATCH   channelId:@"nil"];
    
    [MobClick setEncryptEnabled:YES];
    // [MobClick updateOnlineConfig];
    //   [MobClick getConfigParams];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);

}
#pragma mark - 获取融云消息列表用户的信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    [KBHTTPTool getRequestWithUrlStr:KRongYunGetUserInfoUrl(kBaseUrl, userId) parameters:nil completionHandr:^(id responseObject) {
        NSString *  code=[responseObject objectForKey:@"code"];
        int codeInt=[code intValue];
        if (codeInt==1) {
            userPhotoURL=[responseObject objectForKey:@"userPhoto"];
            userName=[responseObject objectForKey:@"userName"];
            if([userId isEqualToString:tId])
            {
                tId_fId_userName=userName;
            }
            RCUserInfo * user = [[RCUserInfo alloc]initWithUserId:userId name:userName portrait:userPhotoURL];
            [RCIMClient sharedRCIMClient].currentUserInfo = user;
            return completion(user);
        }
        else
        {
            userPhotoURL=nil;
            userName=@"跬步小伙伴";
            if([userId isEqualToString:tId])
            {
                tId_fId_userName=userName;
            }
            RCUserInfo * user = [[RCUserInfo alloc]initWithUserId:userId name:userName portrait:userPhotoURL];
            [RCIMClient sharedRCIMClient].currentUserInfo = user;
            return completion(user);
            
        }
    

    } error:^(NSError *error) {
        ;
    }];
}
#pragma mark - 融云判断用户登录是否唯一
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - 远程通知
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
}
// 获取苹果推送权限成功。

//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

//友盟推送通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    NSLog(@"push:%@",token);
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    [UMessage registerDeviceToken:deviceToken];
    
    [UMComMessageManager registerDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}
#pragma mark - 本地通知
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    NSLog(@"收到本地推送消息");
    NSDictionary* userInfo = [notification userInfo];
    
    NSDictionary* RC = [userInfo objectForKey:@"rc"];
    NSLog(@"userinfo:%@",userInfo);
    cType = [RC valueForKey:@"cType"];
    fId = [RC objectForKey:@"fId"];
    tId = [RC  valueForKey:@"tId"];
    NSLog(@"rc:%@  fid:%@,tid:%@",cType,fId,tId);
    [KBHTTPTool getRequestWithUrlStr:KRongYunGetUserInfoUrl(kBaseUrl, tId) parameters:nil completionHandr:^(id responseObject) {
        NSString *  code=[responseObject objectForKey:@"code"];
        int codeInt=[code intValue];
        if (codeInt==1) {
            
            tId_fId_userName=[responseObject objectForKey:@"userName"];
            NSLog(@"tidusername;%@",tId_fId_userName);
        }
        else
        {
            tId_fId_userName=@"跬步小伙伴";
        }
    } error:^(NSError *error) {
        ;
    }];
    RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
    
    // conversationVC.conversationType =model.conversationType; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    if ([cType isEqualToString:@"PR"]) {
        conversationVC.conversationType = ConversationType_PRIVATE;
    }
    else{
        
    }
    conversationVC.targetId = tId; // 接收者的 targetId，这里为举例。
    conversationVC.userName = tId_fId_userName;
    //    NSLog(@"conversation")// 接受者的 username，这里为举例。
    conversationVC.title = tId_fId_userName;  // 会话的 title。
    //conversationVC.hidesBottomBarWhenPushed = YES;
    
    [(UINavigationController *)self.NavigationController pushViewController:conversationVC animated:YES];
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
}

#pragma mark - 后台远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    /**
     * 统计推送打开率2
     *///融云
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    self.userInfo = userInfo;
    
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                            message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                           delegate:self
                                                  cancelButtonTitle:@"忽略"
                                                  otherButtonTitles:@"查看", nil];
        alertView.tag=122;
        [alertView show];
    }
    else
    {
        
        [UMessage setBadgeClear:YES];
        [UMessage sendClickReportForRemoteNotification:self.userInfo];
        NSInteger pageid=[[self.userInfo objectForKey:@"id"]intValue];
        webviewInfoModel.classString=[self.userInfo objectForKey:@"classString"];
        webviewInfoModel.pageId=pageid;
        webviewInfoModel.imagestr=[self.userInfo objectForKey:@"imageString"];
        webviewInfoModel.textString=[self.userInfo objectForKey:@"textString"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
            webviewInfoModel.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:webviewInfoModel.imagestr]];
        });
        [(UINavigationController *)self.NavigationController pushViewController:InfoWebViewVC animated:YES];
        
    }
    
    //********************话题************
    if ([userInfo valueForKey:@"umwsq"]) {
        [UMComMessageManager didReceiveRemoteNotification:userInfo];
    } else {
        //使用你自己的消息推送处理
    }
}
#pragma mark - 接收通知的点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //统计消息点击事件
    
    if (buttonIndex == 1&&alertView.tag==122) {
        // 如果不调用此方法，统计数据会拿不到，但是如果调用此方法，会再弹一次友盟定制的alertview显示推送消息
        // 所以这里根据需要来处理是否屏掉此功能
        [UMessage setBadgeClear:YES];
        [UMessage sendClickReportForRemoteNotification:self.userInfo];
        
        NSInteger pageid=[[self.userInfo objectForKey:@"id"]intValue];
        webviewInfoModel.classString=[self.userInfo objectForKey:@"classString"];
        webviewInfoModel.pageId=pageid;
        webviewInfoModel.imagestr=[self.userInfo objectForKey:@"imageString"];
        webviewInfoModel.textString=[self.userInfo objectForKey:@"textString"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            webviewInfoModel.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:webviewInfoModel.imagestr]];
        });
        commonSingleValueModel.TitleIsroot=YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ClickOneRemote" object:nil];
    }
    if(buttonIndex==1&alertView.tag==123)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chongxindenglu" object:nil];
        
    }
}

#pragma mark - 友盟分享
-(void)shareSet{
    
    //友盟分享上线
    //[UMSocialData setAppKey:@"55be0ff1e0f55ac25500bc10"];
    //友盟分享测试
    [UMSocialData setAppKey:@"5657d61667e58eacab000e3f"];
    //[UMSocialData openLog:YES];
    //[UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //[UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}
#pragma mark - 回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSLog(@"%@", url);
    
    if ([[url scheme] isEqualToString:@"KuiBu"])
    {
        //处理链接
        NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"新消息" message:text delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
        [myAlert show];
        
        return YES;
    }
    
    return  [UMSocialSnsService handleOpenURL:url];
}
#pragma mark - 程序进入活跃状态
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [UMSocialSnsService  applicationDidBecomeActive];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}
#pragma mark - 监听网络的方法
-(void)reachabilityChanged:(NSNotification*)note
{
    KBLoginSingle *loginSingle=[KBLoginSingle newinstance];
    Reachability * reach = [note object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reach currentReachabilityStatus];
    
    //    //用于检测是否是WIFI
    //    NSLog(@"%d",([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable));
    //    //用于检查是否是3G
    //    NSLog(@"%d",([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable));
    
    if (status == NotReachable) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NotReachable" object:nil];
         NSLog(@"Notification Says Unreachable");
    }else if(status == ReachableViaWWAN){
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/kuibuversion1/subscri/getNewSubscriPage",kBaseUrl]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        NSError *err;
        NSData *responseObject = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
        NSString *jsonString=@"kuibu";
        jsonString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (jsonString.length==0) {
           // NSLog(@"notreachable");
            status=NotReachable;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NotReachable" object:nil];
            
        }
        else
        {
            status = ReachableViaWWAN;
            if (loginSingle.isLogined)
            {
                // [[NSNotificationCenter defaultCenter]postNotificationName:@"mainloginrefesh" object:nil];
               // NSLog(@"从正在使用WWAN网络这里发的");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"USER_RELOGIN_SUCCEED" object:nil];
                
            }
            else
            {
               // NSLog(@"从正在使用WWAN网络这里发的");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LOCAL_RELOGIN" object:nil];
            }

        }
        //NSLog(@"Notification Says mobilenet");
    }else if(status == ReachableViaWiFi){
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/kuibuversion1/subscri/getNewSubscriPage",kBaseUrl]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        NSError *err;
        NSData *responseObject = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
        NSString *jsonString=@"kuibu";
        jsonString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (jsonString.length==0) {
            //NSLog(@"notreachable");
            status=NotReachable;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NotReachable" object:nil];
            
        }
        else
        {
            status = ReachableViaWiFi;
            if (loginSingle.isLogined)
            {
                // [[NSNotificationCenter defaultCenter]postNotificationName:@"mainloginrefesh" object:nil];
                //NSLog(@"从正在使用WWAN网络这里发的");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"USER_RELOGIN_SUCCEED" object:nil];
                
            }
            else
            {
               // NSLog(@"从正在使用WWAN网络这里发的");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LOCAL_RELOGIN" object:nil];
            }
            
        }
        //NSLog(@"Notification Says wifinet");
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
#pragma mark - 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}
#pragma mark  - 判断分类是否更新
-(BOOL)isUpDatedType
{
    //判断是否存在version.pilist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths;
    NSString *path;
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    path=[paths    objectAtIndex:0];
    
    path=[path stringByAppendingPathComponent:@"version.plist"];
    
    if([fileManager fileExistsAtPath:path]) //如果存在login.plist
    {
        NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
        
        NSString *version_data=[dic objectForKey:@"version"];
        
        NSString *version=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        
        if (![version_data isEqualToString:version]) {
            
            //写入当前版本
            [self writeVersionInfo];
            return NO;
        }
        
        
    }
    //写入当前版本
    [self writeVersionInfo];
    return YES;
    
    
}
#pragma mark - 将版本号写入plist文件
-(void)writeVersionInfo{
    NSArray *paths;
    NSString *path;
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    path=[paths    objectAtIndex:0];
    
    path=[path stringByAppendingPathComponent:@"version.plist"];
    
    NSString *version=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:version, @"version",nil];
    [dic writeToFile:path atomically:YES];
}
@end
