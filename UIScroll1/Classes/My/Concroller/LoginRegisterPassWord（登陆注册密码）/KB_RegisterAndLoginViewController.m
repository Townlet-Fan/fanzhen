//
//  KB_RegisterAndLoginViewController.m
//  UIScroll1
//
//  Created by kuibu on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KB_RegisterAndLoginViewController.h"
#import "KBRegisterView.h"
#import "KBRegisterAndLoginView.h"
#import "KBPersonInfoSetView.h"
#import "KBLoginView.h"
#import "KBForgetPasswordView.h"
#import "KBSetNewPasswordView.h"
#import "KBLogoAndBackView.h"
#import "KBCustomButton.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBHTTPTool.h"
#import "KBPostParametersModel.h"
#import "rootViewController.h"
#import "KBProgressHUD.h"
#import "MBProgressHUD.h"
#import "KBCommonSingleValueModel.h"
#import "KBLoginSingle.h"
#import "KBLoginModel.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import "KBWhetherReachableModel.h"
#import "KBAllTypeInfoModel.h"
#import "UMComUserAccount.h"
#import "KBLoginSingle.h"
#import "UMComPushRequest.h"
@interface KB_RegisterAndLoginViewController ()<UIScrollViewDelegate,KBLogoAndBackViewDelegte,KBRegisterDelegte,KBRegisterAndLoginDelegte,KBPersonInfoSetDelegte,KBLoginDelegte,KBForgetPasswordDelegte,KBSetNewPasswordDelegte,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    KBRegisterView *registerView;//注册界面
   
    KBRegisterAndLoginView *registerAndLoginView; //注册登录界面
    
    KBLoginView *loginView;//登录界面
    
    KBForgetPasswordView *forgetPasswordView;//忘记密码
    
    KBSetNewPasswordView *setPasswordView;//修改密码
    
    KBPersonInfoSetView *personInfoSetView;//个人信息设置
    
    MBProgressHUD * hud; //提示
    
    NSTimer *timer;//定时器
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    KBLoginSingle * loginSingle;//用户的单例
    
    //写plist文件
    NSArray *paths;
    NSString *path;
    NSString *filename;
    NSMutableDictionary *data;
    
    //验证码 第三方
    NSMutableArray* _areaArray;
    NSString *areaCode;
    
    UIImage * userHeadImage;//用户头像的Image
    
    NSString * userPhotoString;//用户头像压缩后的字符串
    
    NSString * forgetUserTel;//保存用户忘记密码的手机号
    
}

@end

@implementation KB_RegisterAndLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    //短信验证
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    loginSingle=[KBLoginSingle newinstance];
    data = [[NSMutableDictionary alloc]init];
    // 验证码的设置
    //[self setIdentifyCode];
    //plist文件的路径
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    path=[paths objectAtIndex:0];
    filename=[path stringByAppendingPathComponent:@"login.plist"];
    //滑动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, kWindowSize.width, kWindowSize.height + 20)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(6*kWindowSize.width,0);
    self.scrollView.contentOffset = CGPointMake(2*kWindowSize.width, 0);
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    //背景图
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"system_login_bg.jpg"]];
    [backgroundImageView setFrame:CGRectMake(0, 0, 6*kWindowSize.width, kWindowSize.height+20)];
    [self.scrollView addSubview:backgroundImageView];
    
    //个人信息设置
    personInfoSetView = [[KBPersonInfoSetView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height) andViewController:self];
    personInfoSetView.delegate = self;
    personInfoSetView.tag = 0;
    [self.scrollView addSubview:personInfoSetView];
    
    //注册界面
    registerView = [[KBRegisterView alloc] initWithFrame:CGRectMake(kWindowSize.width, 0, kWindowSize.width, kWindowSize.height) andViewController:self];
    registerView.delegate = self;
    registerView.tag = 1;
    [self.scrollView addSubview:registerView];
    
    //注册登录界面
    registerAndLoginView = [[KBRegisterAndLoginView alloc] initWithFrame:CGRectMake(2*kWindowSize.width, 0, kWindowSize.width, kWindowSize.height) andViewController:self];
    registerAndLoginView.delegate = self;
    registerAndLoginView.tag = 2;
    [self.scrollView addSubview:registerAndLoginView];
    
    //登录界面
    loginView = [[KBLoginView alloc] initWithFrame:CGRectMake(3*kWindowSize.width, 0, kWindowSize.width, kWindowSize.height) andViewController:self];
    loginView.delegate = self;
    loginView.tag = 3;
    [self.scrollView addSubview:loginView];
    
    //忘记密码 验证手机
    forgetPasswordView = [[KBForgetPasswordView alloc] initWithFrame:CGRectMake(4*kWindowSize.width, 0, kWindowSize.width, kWindowSize.height) andViewController:self];
    forgetPasswordView.delegate = self;
    forgetPasswordView.tag = 4;
    [self.scrollView addSubview:forgetPasswordView];
    
    //设置新密码
    setPasswordView = [[KBSetNewPasswordView alloc] initWithFrame:CGRectMake(5*kWindowSize.width, 0, kWindowSize.width, kWindowSize.height) andViewController:self];
    setPasswordView.delegate = self;
    setPasswordView.tag = 5;
    [self.scrollView addSubview:setPasswordView];
}

#pragma mark - 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark - 视图已经消失
-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 验证码的设置
-(void)setIdentifyCode
{
    _areaArray= [NSMutableArray array];
    //设置本地区号
    [self setTheLocalAreaCode];
    //获取支持的地区列表
    [SMSSDK getCountryZone:^(NSError *error, NSArray *zonesArray) {
        if (!error) {
            NSLog(@"get the area code sucessfully");
            //区号数据
            _areaArray = [NSMutableArray arrayWithArray:zonesArray];
            NSLog(@"_areaArray_%@",_areaArray);
        }
        else
        {
            NSLog(@"failed to get the area code _%@",[error.userInfo objectForKey:@"getZone"]);
        }
    }];
}
#pragma mark -设置本地区号
-(void)setTheLocalAreaCode
{
    NSLocale *locale = [NSLocale currentLocale];
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt=[locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode=[dictCodes objectForKey:tt];
    areaCode=[NSString stringWithFormat:@"+86"];
    //@"+%@",defaultCode];
//    NSString* defaultCountryName=[locale displayNameForKey:NSLocaleCountryCode value:tt];
//    defaultCode=defaultCode;
//    defaultCountryName=defaultCountryName;
}
#pragma mark - textField开始编辑代理
- (void)startEdit:(float)bottomOffsetY
{
    float keyBoardHeight = 271;//暂时取所有型号键盘最大值
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x,keyBoardHeight + bottomOffsetY -kWindowSize.height) animated:YES];
}
#pragma mark - textField完成编辑
- (void)endEdit
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x,0) animated:YES];
}
#pragma mark - 实现返回按钮代理
- (void)popToSuperNavigation:(NSInteger)buttonTag
{
    switch (buttonTag) {
        case 0:
            [self.scrollView setContentOffset:CGPointMake(2*kWindowSize.width, 0) animated:NO];
            break;
        case 1:
            [self.scrollView setContentOffset:CGPointMake(2*kWindowSize.width, 0) animated:YES];
            break;
        case 2:
        {
            rootViewController *root=self.rootDelegate;
            [root scrollToMenu];
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }
            break;
        case 3:
            [self.scrollView setContentOffset:CGPointMake(2*kWindowSize.width, 0) animated:YES];
            break;
        case 4:
            [self.scrollView setContentOffset:CGPointMake(3*kWindowSize.width, 0) animated:YES];
            break;
            
        case 5:
            [self.scrollView setContentOffset:CGPointMake(4*kWindowSize.width, 0) animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - 点击页面跳转
- (void)pushToOtherView:(KBCustomButton*)button
{
    switch (button.tag) {
        case 22:
        {
            [self.scrollView setContentOffset:CGPointMake(kWindowSize.width, 0) animated:YES];
        }
            break;
        case 23:
        {
            [self.scrollView setContentOffset:CGPointMake(3*kWindowSize.width, 0) animated:YES];
        }
            break;
        case 24:
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        //有账号,跳到登录
        case 25:
        {
            [self.scrollView setContentOffset:CGPointMake(3*kWindowSize.width, 0) animated:NO];
        }
            break;
        //没有账号,跳到注册
        case 26:
        {
            [self.scrollView setContentOffset:CGPointMake(kWindowSize.width, 0) animated:NO];
        }
            break;
        //忘记密码
        case 27:
        {
            [self.scrollView setContentOffset:CGPointMake(loginView.left+kWindowSize.width, 0) animated:YES];
        }
            break;
        //修改密码
        case 28:
        {
            [self.scrollView setContentOffset:CGPointMake(forgetPasswordView.left+kWindowSize.width, 0) animated:YES];
        }
        default:
            break;
    }
}
#pragma mark - 登录
-(void)loginJugde:(NSString *)userTel withPassWord:(NSString *)passWord
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x,0) animated:NO];
    if(userTel != nil && userTel.length ==11
       && passWord != nil && passWord.length > 5)
    {
        if (![timer isValid]) {
            //定时器 用来判断请求超时
            timer=[NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(overTime) userInfo:nil repeats:NO];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在登录...";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
        }
        NSDictionary * loginPostDic = [KBPostParametersModel setLoginParameters:-1 withMail:@"" withTelNumber:userTel withPassWord:passWord];
        [KBHTTPTool postRequestWithUrlStr:KUserLoginUrl(kBaseUrl) parameters:loginPostDic completionHandr:^(id responseObject) {
            NSString* userId=[responseObject objectForKey:@"userId"];
            NSLog(@"useid:%@",userId);
            //隐藏Progresshud
            if ([userId intValue]!=-1) {
                [self stopTimer];
                [hud hide:YES];
                path=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
                
                [KBLoginModel loginSingleModelWithDictionary:responseObject];
                commonSingleValueModel.remainUserName=userTel;//用户注销账号时保存
                loginSingle.userCounter=userTel;
                NSData *  ImageData   = [NSData dataWithContentsOfURL:[NSURL URLWithString:responseObject[@"userPhoto"]]];
                UIImage *Image  =[UIImage imageWithData:ImageData];
                loginSingle.userPhoto=Image;

                //用户名和密码写入plist文件
                [data setObject:passWord forKey:@"pass"];
                [data setObject:userTel forKey:@"name"];
                
                [data writeToFile:filename atomically:YES];
                [NSKeyedArchiver archiveRootObject:loginSingle toFile:path];
                //提示
                [KBProgressHUD setHud:self.view withText:@"登陆成功" AndWith:0.375];
                //通知登录成功
                [[NSNotificationCenter defaultCenter]postNotificationName:@"USER_RELOGIN_SUCCEED" object:nil];
                [self succeedLogin];
            }
            else
            {
                NSString *typestr=responseObject[@"errorType"];
                int inttype=[typestr intValue];
                switch (inttype) {
                    case 0:
                        [self hudHide:@"用户名不存在"];
                        break;
                    case 1:
                        [self hudHide:@"密码错误"];
                        break;
                    case 2:
                        [self hudHide:@"未获取到客户端JSON参数"];
                        break;
                    default:
                        break;
                }
            }
        } error:^(NSError *error) {
            
        }];
    }
    else
    {
        if ([userTel isEqualToString:@""]&&[passWord isEqualToString:@""])
            [KBProgressHUD setHud:self.view withText:@"手机号和密码同时为空" AndWith:0.375];
        else if ([userTel isEqualToString:@""])
            [KBProgressHUD setHud:self.view withText:@"手机号为空" AndWith:0.375];
        else if ([passWord isEqualToString:@""])
            [KBProgressHUD setHud:self.view withText:@"密码为空" AndWith:0.375];
        else if (userTel.length!=11)
            [KBProgressHUD setHud:self.view withText:@"手机号长度不正确" AndWith:0.375];
        else if (![userTel isEqualToString:@""]&&passWord.length<6)
            [KBProgressHUD setHud:self.view withText:@"密码长度应大于6位" AndWith:0.375];
    }
}
#pragma mark - 获取验证码
-(void)getIdentifyCode:(NSString *)userTel
{
    if (![KBWhetherReachableModel whetherReachable]) {
        [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
    }
    else
    {
        if (userTel.length!=11) {
            [KBProgressHUD setHud:self.view withText:@"手机号不正确，请重新填写" AndWith:0.375];
            return;
        }
        else
        {
            [KBHTTPTool getRequestWithUrlStr:KWhetherUserCounterHasRegisterUrl(kBaseUrl, userTel) parameters:nil completionHandr:^(id responseObject) {
                NSString * checkUserCounter=responseObject[@"isExisted"];
                NSLog(@"checkUserCounter:%@",checkUserCounter);
                if (!commonSingleValueModel.isForgetPw)
                {
                    
                    if ([checkUserCounter intValue]==1) {
                        [KBProgressHUD setHud:self.view withText:@"该手机号已被注册,请换个号码重新注册" AndWith:0.375];
                        return ;
                    }
                    else if([checkUserCounter intValue]==0)
                    {
                        [self identifyCodeSend:userTel];
                    }
                }
                else
                {
                    if([checkUserCounter intValue]==1)
                    {
                        [self identifyCodeSend:userTel];
                        forgetUserTel=userTel;
                    }
                    else if ([checkUserCounter intValue]==0) {
                        [KBProgressHUD setHud:self.view withText:@"该手机号还没注册,请前去注册" AndWith:0.375];
                        return ;
                    }
                }
                
            } error:^(NSError *error) {
                NSLog(@"error:%@",error);
                [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
            }];
        }
    }
}
#pragma mark - 验证码发送
-(void)identifyCodeSend:(NSString *)userTel
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:userTel zone:@"86" customIdentifier:nil result:^(NSError *error)
     {
         if (!error)
         {
             [KBProgressHUD setHud:self.view withText:@"验证码发送成功" AndWith:0.375];
             //NSLog(@"验证码发送成功");
         }
         else
         {
             [KBProgressHUD setHud:self.view withText:@"验证码发送失败" AndWith:0.375];
         }
     }];
}
#pragma mark - 注册
-(void)registerJudge:(NSString *)userTel withPassWord:(NSString *)passWord withIdentifyCode:(NSString *)identifyCode
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if(userTel != nil && userTel.length ==11
       && passWord != nil && passWord.length > 5
       && identifyCode.length == 4)
    {
        [SMSSDK commitVerificationCode:identifyCode phoneNumber:userTel zone:@"86" result:^(NSError *error) {
            if (!error) {
                NSLog(@"验证成功");
                if (![timer isValid]) {
                    //定时器 用来判断请求超时
                    timer=[NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(overTime) userInfo:nil repeats:NO];
                    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText = @"正在注册...";
                    // 隐藏时候从父控件中移除
                    hud.removeFromSuperViewOnHide = YES;
                }
                
                [KBHTTPTool getRequestWithUrlStr:KUserPhoneRegisterUrl(kBaseUrl, userTel, passWord) parameters:nil completionHandr:^(id responseObject) {
                    NSString* userId=[responseObject objectForKey:@"userId"];
                    NSLog(@"useid:%@",userId);
                    //隐藏Progresshud
                    if ([userId intValue]!=-1) {
                        [self stopTimer];
                        [hud hide:YES];
                        path=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
                        [NSKeyedArchiver archiveRootObject:loginSingle toFile:path];
                        
                        commonSingleValueModel.remainUserName=userTel;//用户注销账号时保存
                        loginSingle.userCounter=userTel;
                        loginSingle.userID=[userId intValue];
                        
                        //用户名和密码写入plist文件
                        [data setObject:passWord forKey:@"pass"];
                        [data setObject:userTel forKey:@"name"];
                        [data writeToFile:filename atomically:YES];
                        
                        [self.scrollView setContentOffset:CGPointMake(kWindowSize.width, 0) animated:YES];
                    }
                    
                } error:^(NSError *error) {
                    ;
                }];
            }
            else
              [KBProgressHUD setHud:self.view withText:@"验证码不正确" AndWith:0.375];
        }];
    }
    else
    {
        if ([userTel isEqualToString:@""])
            [KBProgressHUD setHud:self.view withText:@"手机号为空" AndWith:0.375];
        else if ([passWord isEqualToString:@""])
            [KBProgressHUD setHud:self.view withText:@"密码为空" AndWith:0.375];
        else if(identifyCode.length ==0)
            [KBProgressHUD setHud:self.view withText:@"验证码为空" AndWith:0.375];
        else if (![userTel isEqualToString:@""]&&passWord.length<6)
            [KBProgressHUD setHud:self.view withText:@"密码长度应大于6位" AndWith:0.375];
        else if(identifyCode.length != 4)
            [KBProgressHUD setHud:self.view withText:@"验证码为4位" AndWith:0.375];
    }
}
#pragma mark - 个人信息界面选择头像
- (void)choosePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [picker.navigationBar setBarTintColor:KColor_15_86_192];
    
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

#pragma mark - imagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"info:%@",info);
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage *img= [self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];
        [personInfoSetView.logoImageButton setBackgroundImage:image forState:UIControlStateNormal];
        NSData * userPhotoData = UIImagePNGRepresentation(img);//UIImageJPEGRepresentation(img,1.0f);
        userPhotoString= [userPhotoData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        userHeadImage=img;
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
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
#pragma mark - 压缩图片
-(UIImage *) scaleFromImage: (UIImage *) image1 toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 完善用户信息登录
-(void)pushMainView:(NSString *)userName withUserSchool:(NSString *)userSchool withUserSex:(NSString *)userSex
{
    if (userName.length!=0&&userSchool.length!=0&&userSex.length!=0) {
        //post参数
        
        NSDictionary * updateInfoString=[KBPostParametersModel setSaveUserInfoParameters:loginSingle.userID withUserName:userName withUserPhoto:userPhotoString withUserSex:userSex withUserSchool:userSchool withUserSchoolYear:@""];
        NSLog(@"updateInfoString:%@",updateInfoString);
        [KBHTTPTool postRequestWithUrlStr:KSaveUserInfoUrl(kBaseUrl) parameters:updateInfoString completionHandr:^(id responseObject) {
            NSString* updateResult =responseObject[@"updateResult"];
            int updateresult = [updateResult intValue];
            NSLog(@"updatesult:%d",updateresult);
            if (updateresult==1){
                path=[path stringByAppendingPathComponent:@"LocalLoginSingle.data"];
                [NSKeyedArchiver archiveRootObject:loginSingle toFile:path];
                loginSingle.userPhoto=userHeadImage;
                loginSingle.userName=userName;
                loginSingle.userSex=userSex;
                loginSingle.userSchool=userSchool;
                
                KBAllTypeInfoModel * allTypeInfoModel=[KBAllTypeInfoModel resetinstance];
                //初始化关注的列表Array结构
                loginSingle.userInterestStructArray  =  [allTypeInfoModel useFocuArrayReturnInterestStruct:loginSingle.userFocusId];
                loginSingle.userInterestNoStructArray=[allTypeInfoModel ReturnInterestNoStruct];
                loginSingle.userAllTypeArray=allTypeInfoModel.allTypeArray;

                //通知登录成功
                [[NSNotificationCenter defaultCenter]postNotificationName:@"USER_RELOGIN_SUCCEED" object:nil];
                [self succeedLogin];
            }

        } error:^(NSError *error) {
            
           [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
        }];
    }
}
#pragma mark - 忘记密码的下一步
-(void)nextStep:(NSString *)userTel withIdentifyCode:(NSString *)identifyCode
{
    [self.scrollView setContentOffset:CGPointMake(forgetPasswordView.left+kWindowSize.width, 0) animated:YES];
    if(userTel != nil && userTel.length ==11
       && identifyCode.length == 4)
    {
        [SMSSDK commitVerificationCode:identifyCode phoneNumber:userTel zone:areaCode result:^(NSError *error) {
            if (!error) {
                NSLog(@"验证成功");
                 [self.scrollView setContentOffset:CGPointMake(forgetPasswordView.left+kWindowSize.width, 0) animated:YES];
            }
            else
                 [KBProgressHUD setHud:self.view withText:@"验证码不正确" AndWith:0.375];
            
        }];
    }
    if ([userTel isEqualToString:@""])
        [KBProgressHUD setHud:self.view withText:@"手机号为空" AndWith:0.375];
    else if(identifyCode.length ==0)
        [KBProgressHUD setHud:self.view withText:@"验证码为空" AndWith:0.375];
    else if(userTel.length ==0)
        [KBProgressHUD setHud:self.view withText:@"手机号不正确，请重新填写" AndWith:0.375];
    else if(identifyCode.length != 4)
        [KBProgressHUD setHud:self.view withText:@"验证码为4位" AndWith:0.375];
}
#pragma mark - 忘记密码修改成功跳到登录界面
-(void)setPasswordSuccess:(NSString *)newPassWord withConfirmPassWord:(NSString *)confirmPassWord
{
    if( newPassWord != nil && newPassWord.length >=6
       && confirmPassWord!=nil && confirmPassWord.length>=6)
    {
        if([newPassWord isEqualToString:confirmPassWord]==NO)
        {
            [KBProgressHUD setHud:self.view withText:@"新密码两次不一致" AndWith:0.375];
        }
        else if([newPassWord isEqualToString:confirmPassWord])
        {
            
           [KBHTTPTool postRequestWithUrlStr:KUserForgetPassWordUrl(kBaseUrl, forgetUserTel, confirmPassWord) parameters:nil completionHandr:^(id responseObject) {
               NSString* upDate=responseObject[@"forgetPassResult"];
               int intUpdate = [upDate intValue];
               if (intUpdate==1)
               {
                   commonSingleValueModel.isForgetPw=NO;
                   [KBProgressHUD setHud:self.view withText:@"修改密码成功" AndWith:0.375];
                   [self.scrollView setContentOffset:CGPointMake(3*kWindowSize.width, 0) animated:NO];
               }
               else
               {
                   [KBProgressHUD setHud:self.view withText:@"修改密码失败" AndWith:0.375];
               }
           } error:^(NSError *error) {
               [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
           }];
    }
    }
    else
    {
        if (([newPassWord isEqualToString:@""])&&([confirmPassWord isEqualToString:@""]))
        {
            [KBProgressHUD setHud:self.view withText:@"新密码和确认密码同时为空" AndWith:0.375];
        }
        else if ([newPassWord isEqualToString:@""])
        {
            [KBProgressHUD setHud:self.view withText:@"新密码为空" AndWith:0.375];
        }
        else if ([confirmPassWord isEqualToString:@""])
        {
            [KBProgressHUD setHud:self.view withText:@"确认密码为空" AndWith:0.375];
        }
        else if (newPassWord != nil && newPassWord.length<6)
        {
            [KBProgressHUD setHud:self.view withText:@"新密码长度应大于6位" AndWith:0.375];
        }
        else if (confirmPassWord != nil && confirmPassWord.length<6)
        {
            [KBProgressHUD setHud:self.view withText:@"确认密码长度应大于6位" AndWith:0.375];
        }
    }
}
#pragma mark - 微社区 友盟账户登录
- (void)UMengLogin
{
    //开发者使用自己账号系统uid登录到友盟微社区并通过自己的UID获取用户信息使用示例（无跳转逻辑）
    UMComUserAccount *userAccount = [[UMComUserAccount alloc]initWithSnsType:UMComSnsTypeSelfAccount];
    userAccount.usid = [NSString stringWithFormat:@"%ld",(long)[KBLoginSingle newinstance].userID];//自己账号UID（本方服务器生成的）
    userAccount.name = [KBLoginSingle newinstance].userName;
    if ([[KBLoginSingle newinstance].userSex isEqualToString:@"男"]) {
        userAccount.gender = [NSNumber numberWithInt:1];
        NSLog(@"[KBLoginSingle newinstance].userSex:%@----%@",[KBLoginSingle newinstance].userSex,userAccount.gender);
    }else{
        userAccount.gender = [NSNumber numberWithInt:0];
    }
    //userAccount.icon_url = [KBLoginSingle newinstance].userPhotoURL; //登录用户头像
    [UMComPushRequest loginWithUser:userAccount completion:^(id responseObject, NSError *error) {
        NSLog(@"<<<<<<<%@--------->%@",responseObject,error);
    }];
}

#pragma mark - 登录成功
-(void)succeedLogin
{
    //友盟登录
    [self UMengLogin];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - 登录的提示和隐藏
-(void)hudHide:(NSString * )hudText
{
    [hud hide:YES];
    [KBProgressHUD setHud:self.view withText:hudText AndWith:0.375];
    [self stopTimer];
}
#pragma mark - 停止计时器
-(void)stopTimer{
    [timer invalidate];
    timer=nil;
}
#pragma mark - 超时
-(void)overTime
{
    [hud hide:YES];
    [KBProgressHUD setHud:self.view withText:@"登录超时,请检查你的网络状态" AndWith:0.375];
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
