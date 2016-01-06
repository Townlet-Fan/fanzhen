#import "KBMyVIewController.h"
#import "KBLoginSingle.h"
#import "KBMyCollectionViewController.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "FBGlowLabel.h"
#import "KBAboutKuiBuViewController.h"
#import "KBMyTableViewCell.h"
#import "ChatListViewController.h"
#import "KBProgressHUD.h"
#import "KBInfoWebViewController.h"
#import "KBPersonalDataViewController.h"
#import "KBBaseNavigationController.h"
#import "rootViewController.h"
#import "KB_RegisterAndLoginViewController.h"
#import "KBMessageViewController.h"
#import "KBMyFooterViewController.h"
#import "KBSystemSettingViewController.h"
#import "KBMainFeedBackViewController.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
#import "KBHTTPTool.h"
#import "KBPostParametersModel.h"
#import "KBMyView.h"
#import "KBWhetherLoginModel.h"
#import "UMCommunity.h"
@interface KBMyVIewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,KBMyViewDelegate>
{
    rootViewController *root; //root
    
    KBLoginSingle *loginSingle;//用户的单例
    
    KBMessageViewController *messageVC;//消息
    
    KBSystemSettingViewController *systemSettingVC;//系统设置
    
    AppDelegate *appDelegate;
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    UIView *newMessage;//有新消息的view 红点
    
    FBGlowLabel *FBGlabel;//用户昵称的Label
    
    NSTimer * timer;//定时器 定时请求服务器获取用户的新消息
    
    KBMyView * myView;//Menu上方的View
   
}
@end

@implementation KBMyVIewController

//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

float DEVICE_WIDTH,DEVICE_HEIGHT;
float VIEW_WIDTH;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化
    appDelegate=[UIApplication sharedApplication].delegate;
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
    DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
    VIEW_WIDTH=0.75*kWindowSize.width;
    //menu的整个view
    myView = [[KBMyView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    myView.delegate=self;
    myView.backgroundColor=[UIColor whiteColor];
    self.view=myView;
    [self setupLabel];//用户昵称
    //判断是否登录了
    if(loginSingle.isLogined)
    {   //用户有头像
        if (loginSingle.userPhoto)
        {
            [myView.headViewButton setBackgroundImage:loginSingle.userPhoto  forState:UIControlStateNormal];
             myView.headImageView.image=[self applyBlurRadius:4 toImage:loginSingle.userPhoto ];
        }
        else {
            [myView.headViewButton setBackgroundImage:[UIImage imageNamed:@"默认头像-大有阴影"] forState:UIControlStateNormal];
            [myView.headImageView setBackgroundColor:KColor_246];
        }
        [myView.headViewButton addTarget:self action:@selector(pushPersonal) forControlEvents:UIControlEventTouchDown];
        FBGlabel.text=loginSingle.userName;
    }
    else
    {
        [myView.headViewButton addTarget:self action:@selector(pushLogin) forControlEvents:UIControlEventTouchDown];
        [myView.headViewButton setBackgroundImage:[UIImage imageNamed:@"默认头像-大有阴影"] forState:UIControlStateNormal];
        FBGlabel.text= @"点击登录";
    }
    //menu的tableView
    self.menuTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0.47*kWindowSize.height, 0.75*kWindowSize.width, 0.5*kWindowSize.height)];
    self.menuTableView.delegate=self;
    self.menuTableView.dataSource=self;
    self.menuTableView.rowHeight=0.12*kWindowSize.height;
    self.menuTableView.bounces=NO;
    self.menuTableView.scrollEnabled=NO;
    self.menuTableView.showsVerticalScrollIndicator=NO;
    self.menuTableView.scrollsToTop=NO;
    self.menuTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.menuTableView];
    //新消息通知的view 红点
    newMessage=[[UIView alloc]initWithFrame:CGRectMake(self.menuTableView.left+120, 15, 8, 8)];
    newMessage.layer.bounds=CGRectMake(0, 0, 8, 8);
    newMessage.layer.cornerRadius=4;
    
    //消息
    messageVC=[[KBMessageViewController alloc]init];
    //系统设置
    systemSettingVC=[[KBSystemSettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    //定时请求服务器获取新消息
    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(newMessage) userInfo:nil repeats:YES];
    //刷新登录用户的头像
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuRefreshViewUSER_RELOGIN) name:@"USER_RELOGIN_SUCCEED" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuRefreshViewUSER_RELOGIN) name:@"REFRESH_HEAD" object:nil];
    //刷新未登录用户的头像
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuRefreshViewLOCAL_RELOGIN) name:@"LOCAL_RELOGIN" object:nil];
    //消息状态的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMessage) name:@"CHANGE_MESSAGE" object:nil];
    //接收友盟通知 在menu下点击
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReceiveRomote) name:@"ClickOneRemote" object:nil];
    //消息的未登录 点击登录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushLogin) name:@"chongxindenglu" object:nil];
}
#pragma mark - 用户昵称
- (void)setupLabel
{
    CGRect frame = CGRectMake(0, 0, myView.userNameLabelButton.frame.size.width, myView.userNameLabelButton.frame.size.height);
    FBGlowLabel *v = [[FBGlowLabel alloc] initWithFrame:frame];
    v.textAlignment = NSTextAlignmentCenter;
    v.clipsToBounds = YES;
    v.backgroundColor = [UIColor clearColor];
    v.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    v.alpha = 1.0;
    v.glowSize = 20;
    //v.innerGlowSize = 4;
    v.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    v.shadowColor=[UIColor whiteColor];
    v.glowColor = UIColorFromRGB(0xffffff);
    v.innerGlowColor = UIColorFromRGB(0x333333);
    FBGlabel = v;
    [myView.userNameLabelButton addSubview:v];
}
#pragma mark - 消息状态的改变
-(void)changeMessage
{
    if (!commonSingleValueModel.hasMessage) {
        newMessage.backgroundColor=[UIColor whiteColor];
        [self.menuTableView addSubview:newMessage];
    }
}
#pragma mark - 有新消息
-(void)newMessage
{
    if([KBWhetherLoginModel userWhetherLogin])
    {
        [KBHTTPTool getRequestWithUrlStr:KUserMessageChangeUrl(kBaseUrl, loginSingle.userID) parameters:nil completionHandr:^(id responseObject) {
            int inthasMessage=[[responseObject objectForKey:@"hasMessage"] intValue];
            int inthasPraise=[[responseObject objectForKey:@"hasPraise"]intValue];
            int inthasReply=[[responseObject objectForKey:@"hasReply"]intValue];
            int inthasSysMessag=[[responseObject objectForKey:@"hasSysMessage"]intValue];
            if(inthasMessage==1)
            {
                commonSingleValueModel.hasMessage=YES;
                newMessage.backgroundColor=[UIColor redColor];
                [self.menuTableView addSubview:newMessage];
                if(inthasPraise)
                    commonSingleValueModel.hasPraise=YES;
                if(inthasReply)
                    commonSingleValueModel.hasRely=YES;
            }
            else
            {
                commonSingleValueModel.hasMessage=NO;
            }
        } error:^(NSError *error) {
            KBLog(@"消息状态获取服务器错误");
            
        }];
    }
    if (commonSingleValueModel.hasMessage)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HAVE_NEWMESSAGE" object:nil];
    }
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated{
    root=self.rootDelegate;
    systemSettingVC.rootDelegate=self.rootDelegate;
    messageVC.rootDelegate=root;
}
#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 4;
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBMyTableViewCell *cell;
    cell=[[KBMyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil
          ];
    switch (indexPath.row) {
        case 0:
        {
            cell.leftLabel.text=@"消息";
            cell.leftIconImage.image=[UIImage imageNamed:@"消息.png"];
        }
            break;
        case 1:
        {
            cell.leftLabel.text=@"反馈";
            cell.leftIconImage.image=[UIImage imageNamed:@"反馈.png"];
        }
            break;
            
        case 2:
        {
            cell.leftLabel.text=@"设置";
            cell.leftIconImage.image=[UIImage imageNamed:@"设置.png"];
        }
            break;
        case 3:
        {
            cell.leftLabel.text=@"关于";
            cell.leftIconImage.image=[UIImage imageNamed:@"关于.png"];
        }
            break;
        case 4:
        {
            cell.leftLabel.text=@"单聊";
            cell.leftIconImage.image=[UIImage imageNamed:@"关于.png"];
        }
            
        default:
            break;
    }
    //自带箭头
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //系统设置
    if(indexPath.row==2)
    {
        [root.nav pushViewController:systemSettingVC animated:NO];
        [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
    }
    else
    {
        //消息
        if (indexPath.row==0) {
            if(loginSingle.isLogined){
                [self message];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请登录查看消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                alert.tag=20;
                [alert show];
            }
            
            
        }
        //反馈
        else if(indexPath.row==1)
        {
            [self pushFeedBack];
        }
        //关于
        else if(indexPath.row==3)
        {
            [self pushAboutKuibu];
        }
        else if (indexPath.row==4)
        {
            [self singleChat];
        }
    }
    
}
#pragma mark - 单聊
-(void)singleChat
{
    ChatListViewController *chatListViewController = [[ChatListViewController alloc]init];
    chatListViewController.rootDelegate=root;
    [root.nav  pushViewController:chatListViewController animated:NO];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
}
#pragma mark - 关于
-(void)pushAboutKuibu
{
    //KBAboutKuiBuViewController * aboutKuiBuVC=[[KBAboutKuiBuViewController alloc]init];
    //aboutKuiBuVC.rootDelegate=root;
    UIViewController *aboutKuiBuVC = [UMCommunity getFeedsViewController];
    [root.nav pushViewController:aboutKuiBuVC animated:NO];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
}
#pragma mark - 接收到友盟通知
-(void)ReceiveRomote
{
    KBInfoWebViewController * titView=[[KBInfoWebViewController alloc]init];
    [root.nav pushViewController:titView animated:YES];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
}
#pragma mark - alertView 登录
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1&alertView.tag==20)
    {
        KB_RegisterAndLoginViewController *registerAndLoginVC=[[KB_RegisterAndLoginViewController alloc]init];
        registerAndLoginVC.view.backgroundColor=[UIColor whiteColor];
        [self presentViewController:registerAndLoginVC animated:YES completion:^{
            registerAndLoginVC.rootDelegate=root;
            [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
        }];
        
    }
}
#pragma mark - 消息
-(void)message
{
    KBMessageViewController * message=[[KBMessageViewController alloc]init];
    message.rootDelegate=root;
    [root.nav pushViewController:message animated:NO];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
}
#pragma mark - 登录
-(void)pushLogin{
    
    KB_RegisterAndLoginViewController *registerAndLoginVC=[[KB_RegisterAndLoginViewController alloc]init];
    registerAndLoginVC.view.backgroundColor=[UIColor whiteColor];
    [self presentViewController:registerAndLoginVC animated:YES completion:^{
        registerAndLoginVC.rootDelegate=root;
        [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
    }];
}
#pragma mark - 反馈
-(void)pushFeedBack{
    KBMainFeedBackViewController *feedBackVC=[[KBMainFeedBackViewController alloc]init];
    feedBackVC.rootDelegate=root;
    [root.nav  pushViewController:feedBackVC animated:NO];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 收藏
-(void)pushCollection{
    KBMyCollectionViewController *newCollection=[[KBMyCollectionViewController alloc]init];
    newCollection.rootDelegate=root;
    [root.nav pushViewController:newCollection animated:NO];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
}
#pragma mark - 个人信息
-(void)pushPersonal
{
    myView.headViewButton.userInteractionEnabled=NO;
    KBPersonalDataViewController *personDataVC=[[KBPersonalDataViewController alloc]init];
    personDataVC.rootDelegate=root;
    personDataVC.pushBtn=myView.headViewButton;
    [root.nav pushViewController:personDataVC animated:NO];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES  ];
}
#pragma mark - 足迹
-(void)pushFooter
{
    KBMyFooterViewController *footerTable=[[KBMyFooterViewController alloc]init];
    footerTable.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    footerTable.rootDelegate=root;
    [root.nav pushViewController:footerTable animated:NO];
    [root.scView setContentOffset:CGPointMake(0.75*kWindowSize.width-0.1, 0)animated:YES];
}
#pragma mark - 刷新登录用户的头像
-(void)menuRefreshViewUSER_RELOGIN
{
    [myView.headViewButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    [myView.headViewButton addTarget:self action:@selector(pushPersonal) forControlEvents:UIControlEventTouchDown];
    loginSingle = [KBLoginSingle newinstance];
    if (loginSingle.userPhoto)
    {
        [myView.headViewButton setBackgroundImage:loginSingle.userPhoto forState:UIControlStateNormal];
        myView.headImageView.image=[self applyBlurRadius:4 toImage:loginSingle.userPhoto];
    }
    else {
        [myView.headViewButton setBackgroundImage:[UIImage imageNamed:@"默认头像-大有阴影"] forState:UIControlStateNormal];}
    
    if (loginSingle.userName.length==0){
        loginSingle.userName=@"匿名用户";
    }
    FBGlabel.text= loginSingle.userName ;
}
#pragma mark - 刷新未登录用户的头像
-(void)menuRefreshViewLOCAL_RELOGIN{
    loginSingle=[KBLoginSingle newinstance];
    [myView.headViewButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [myView.headViewButton addTarget:self action:@selector(pushLogin) forControlEvents:UIControlEventTouchUpInside];
    [myView.headViewButton setBackgroundImage:[UIImage imageNamed:@"默认头像-大有阴影"] forState:UIControlStateNormal];
    [myView.headImageView setImage:nil];
    [myView.headImageView setBackgroundColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
    FBGlabel.text= @"点击登录";
}
#pragma mark - 用户头像模糊阴影
- (UIImage *)applyBlurRadius:(CGFloat)radius toImage:(UIImage *)image
{
    if (radius < 0) radius = 0;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc]initWithImage:image];
    // Setting up gaussian blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
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

