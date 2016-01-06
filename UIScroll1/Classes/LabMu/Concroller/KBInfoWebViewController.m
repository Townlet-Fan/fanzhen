//
//  TitleViewController.m
//  UIScroll1
//
//  Created by eddie on 15-3-31.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBInfoWebViewController.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "KBCommonSingleValueModel.h"
#import "KBLoginSingle.h"
#import "JudgeInternet.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
#import "WeiboSDK.h"
#import "MBProgressHUD.h"
#import "KBWebViewBottomView.h"
#import "KBWebViewFeedBackView.h"
#import "KKNavigationController.h"
//#import "FeedCell.h"
#import "YYAnimationIndicator.h"
#import "MBProgressHUD.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WKWebViewJavascriptBridge.h"
#import "KBMyCollectionViewController.h"
#import "KBInfoTableViewController.h"
#import "KBWebviewInfoModel.h"
#import "KBMyCollectionDataModel.h"
#define HOTNUMBER 3
#define HOTLISTCELL_COUNT 3
#define GESTURE_STATE_START 1
#define GESTURE_STATE_MOVE 2
#define GESTURE_STATE_END 3

@interface KBInfoWebViewController ()
{
    AppDelegate *appDelegate;
    NSString *imgURL;
    NSString *originHTMLStr;
    NSString *middleStr;
    float ptX;
    float ptY;
    NSTimer *timer;
    KBCommonSingleValueModel *transport;
    sqlite3 *db;
    KBMyCollectionDataModel *collection;
    NSString  *cachefilename;
    NSArray * cachepaths;
    NSString * cachesDir;
    KBLoginSingle * loginsingle;
    UIButton *likeBtn;
    NSString *Pageid;
    
    MBProgressHUD *hud;
    JudgeInternet *judge;
    KBInfoTableViewController *VC;
    YYAnimationIndicator *loadingIndicator;
    UIToolbar *toolBar1;
    UINavigationBar *navigationBar;
    UIButton * failButton;
    UILabel  * failLabel;
     int  _gesState;
    BOOL canHandleLong;
    BOOL didScroll;
    KBWebviewInfoModel * webviewInfoModel;
    
}
@end

@implementation KBInfoWebViewController
@synthesize btn;
@synthesize toolBar1;
@synthesize cancelCollectIndexPath;
float DEVICE_WIDTH,DEVICE_HEIGHT;
float MARGIN;
integer_t actionType=-1;
static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";
static NSString * const excuteStr=  @"var myimg,oldwidth,oldheight;"
"var maxwidth = 280;"
"for(i=0;i <document.images.length;i++){"
"myimg =  document.getElementsByTagName(\"img\")[i];"

"oldwidth = myimg.width;"
"oldheight = myimg.height;"//
"myimg.style.width = \"280px\";"
"myimg.width = maxwidth;"

"}";



- (void)viewDidLoad {
    [super viewDidLoad];
    transport=[KBCommonSingleValueModel newinstance];
    webviewInfoModel=[KBWebviewInfoModel newinstance];
    canHandleLong=NO;
    didScroll=NO;
    loginsingle=[KBLoginSingle newinstance];
    appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    MARGIN = ([UIScreen mainScreen].bounds.size.width - 150)/5;
    self.view.backgroundColor=[UIColor whiteColor];
    
    {
        
       
        
    }

    self.navigationController.navigationBarHidden=YES;
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor=[UIColor whiteColor];
    self.theWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self combineWebAndDiscuss:self.theWebView.frame.size.height];
    
    self.theWebView.delegate = self;
    self.theWebView.scalesPageToFit =NO;
    self.theWebView.scrollView.bounces = NO;
    self.theWebView.scrollView.scrollEnabled=NO;
    self.theWebView.backgroundColor = [UIColor whiteColor];
    self.theWebView.scrollView.showsVerticalScrollIndicator = YES;
    self.theWebView.scrollView.scrollsToTop=NO;
    [self.theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"iosPageScript" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
    [self.theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"changeSrc" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
    [self UIinit];
    [self sendRequest];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canHandlelong) name:@"CANLONGHANG" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didScroll) name:@"DidScrollCANLONGHANG" object:nil];
 

    
}

-(void)DidChangeStatusBarFrame
{
    //NSLog(@"tktitittititititititititiisFinishLaunching;%d",transport.isFinishLaunching);
    
    if (transport.isFinishLaunching) {
        
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            //self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,20, self.view.frame.size.width, self.view.frame.size.height+20);
            
            transport.isFinishLaunching=NO;
            [toolBar1 setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-70, [UIScreen mainScreen].bounds.size.width, 50 )];
            // NSLog(@"4440404040404isFinishLaunchingend;%d",transport.isFinishLaunching);
        }
        else
        {
            // self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
            [toolBar1 setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50 )];
            
            transport.isFinishLaunching=NO;
            // NSLog(@"202020202020isFinishLaunchingend;%d",transport.isFinishLaunching);
        }
    }
    else if(!transport.isFinishLaunching)
    {
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            //NSLog(@"440404040");
            //self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,40, self.view.frame.size.width, self.view.frame.size.height);
            [toolBar1 setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-70, [UIScreen mainScreen].bounds.size.width, 50 )];
        }
        else
            
        {
            //NSLog(@"22222202020202020");
            // self.view.frame=CGRectMake(self.navigationController.navigationBar.frame.origin.x,20, self.view.frame.size.width, self.view.frame.size.height);
            [toolBar1 setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50 )];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidChangeStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if (transport.isThreeEnterTitle) {
        self.navigationController.navigationBarHidden=YES;
        
    }
    //[navigationBar setHidden:NO];
    //[UIApplication sharedApplication].statusBarHidden=NO;
    //self.theWebView.scrollView.scrollsToTop=NO;
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.theWebView.scrollView.scrollsToTop=NO;
    

    
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (transport.isThreeEnterTitle) {
        self.navigationController.navigationBarHidden=YES;
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    
    //    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:15/255.0 green:86/255.0 blue:208/255.0 alpha:1];
    //    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    //    NSString *pageurl=[NSString stringWithFormat:@"%@/kuibuversion1/page/read/%ld",transport.ip121,(long)transport.mainpageid];
    //    NSString * pageIDStr = [NSString stringWithFormat:@"{\"pageId\":\"%ld\"}",(long)transport.mainpageid];
    //    NSDictionary *pageIdDic=@{@"pageId":pageIDStr};
    //   // NSLog(@" pageurl:%@ pageIdstr : %@,pageIddic :%@",pageurl,pageIDStr,pageIdDic);
    //    [appDelegate.manager
    //     POST:pageurl
    //     parameters:pageIdDic
    //     success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //
    //
    ////         NSError *er;
    ////         NSMutableDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&er];
    //         //NSString* doReadResult=[jsondic objectForKey:@"doReadResult"];
    ////         NSLog(@"responseObject:%@",doReadResult);
    //         //int intdoReadResult=[doReadResult intValue];
    //         //                  if (intdoReadResult==1) {
    //         //                      NSLog(@"纪录阅读成功");
    //         //                  }
    //         //                  else
    //         //                      NSLog(@"纪录阅读失败");
    //     }
    //     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //         //NSLog(@"阅读服务器失败");
    //     }];
    
    self.theWebView.scrollView.scrollsToTop=NO;
    
}
-(void)UIinit{
    //    UIButton * Button=[[UIButton alloc]initWithFrame:CGRectMake(DEVICE_WIDTH/2.0-DEVICE_WIDTH*0.2,DEVICE_HEIGHT-100,DEVICE_WIDTH*0.4, 40)];
    //    Button.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    //    Button.layer.cornerRadius=10;
    //    [Button setTitle:@"请检查网络设置" forState:UIControlStateNormal];
    //    Button.titleLabel.textColor=[UIColor whiteColor];
    //    Button.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    [loadingIndicator removeFromSuperview];
    
    judge=[JudgeInternet newinstance];
    //    promptView=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-75,self.view.frame.size.height-100,150, 40)];
    //    promptView.tag=1;
    //    promptView.layer.cornerRadius=20;
    //    promptView.titleLabel.textColor=[UIColor whiteColor];
    //    promptView.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    
    //TitleWebView *webView=[[TitleWebView alloc]init];
    UIButton *discussBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 10, 25, 25)];
    // [discussBtn setTitle:@"评论" forState:UIControlStateNormal];
    
    [discussBtn setImage:[UIImage imageNamed:@"正文评论"] forState:UIControlStateNormal];
    [discussBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [discussBtn addTarget:self action:@selector(discuss) forControlEvents:UIControlEventTouchDown];
    
    
    likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(discussBtn.frame.origin.x+discussBtn.frame.size.width+40 , 8, 25, 25)];
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Pageid=[NSString stringWithFormat:@"%ld",(long)webviewInfoModel.pageId];
    NSLog(@"webviewInfoModel.pageId:%ld",(long)webviewInfoModel.pageId);
    if (loginsingle.userCollect!=NULL) {
        if([loginsingle.userCollect rangeOfString:Pageid].location != NSNotFound)
        {
            actionType=0;
            [likeBtn setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];}
        else{
            actionType=1;
            [likeBtn setImage:[UIImage imageNamed:@"收藏空心"] forState:UIControlStateNormal];}
    }
    else{
        
        actionType=1;
        [likeBtn setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
    }
    
    
    [likeBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchDown];
    
    
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(likeBtn.frame.origin.x+likeBtn.frame.size.width+40, 10, 25, 25)];
    
    //[shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchDown];
    [shareBtn setImage:  [UIImage imageNamed:@"分享白"]forState:UIControlStateNormal];
    
    
    UIButton *settingBtn=[[UIButton alloc]initWithFrame:CGRectMake(shareBtn.frame.origin.x+shareBtn.frame.size.width+38, 10, 25, 25)];
    // [settingBtn setTitle:@"..." forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"字号"] forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView * backButtonImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 35, 20)];
    backButtonImageView.image=[UIImage imageNamed:@"正文返回"];
    //[btn setTitle:@"返回" forState:UIControlStateNormal];
    //[btn setImage:[UIImage imageNamed:@"正文返回"] forState:UIControlStateNormal];
    //btn.backgroundColor=[UIColor redColor];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchDown];
    [btn addSubview:backButtonImageView];
    /*
     //    toolBar=[[UIView alloc]init];
     //    //    toolBar.tintColor=[UIColor blueColor];
     //    toolBar.backgroundColor=[UIColor grayColor];
     //    //
     //
     //    [toolBar setTranslatesAutoresizingMaskIntoConstraints:NO];
     //    toolBar.layer.masksToBounds=YES;
     //    //toolBar.layer.cornerRadius=6;
     //    toolBar.layer.borderWidth=1;
     //    //[self.view addSubview:webView];
     //    [self.view addSubview:btn];
     //    [toolBar addSubview:likeBtn];
     //    [toolBar addSubview:discussBtn];
     //    [toolBar addSubview:shareBtn];
     //    [toolBar addSubview:settingBtn];
     //    [self.view addSubview:toolBar];
     //
     //    NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:toolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1   constant:0];
     //    [self.view addConstraint:constraint];
     //
     //    constraint=[NSLayoutConstraint constraintWithItem:toolBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1   constant:0];
     //    [self.view addConstraint:constraint];
     //    constraint=[NSLayoutConstraint constraintWithItem:toolBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1   constant:0];
     //    [self.view addConstraint:constraint];
     //    constraint=[NSLayoutConstraint constraintWithItem:toolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1   constant:-50];
     //    [self.view addConstraint:constraint];
     */
    /*
     //弹出分享界面
     blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
     [blackView setBackgroundColor: [UIColor blackColor]];
     [blackView setAlpha:0.5];
     [blackView setHidden:YES];
     [self.view addSubview:blackView];
     blackView.userInteractionEnabled=NO;
     shareView=[[UIView alloc]initWithFrame:CGRectMake(0, 0.5*DEVICE_HEIGHT,DEVICE_WIDTH, 0.5*DEVICE_HEIGHT)];
     [shareView setHidden:YES];
     UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 0.4*DEVICE_HEIGHT, DEVICE_WIDTH-20, 0.07*DEVICE_HEIGHT)];
     [cancelBtn setTitle:@"取消分享" forState:UIControlStateNormal];
     [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     cancelBtn.layer.cornerRadius=8;
     [cancelBtn setBackgroundColor:[UIColor whiteColor]];
     [cancelBtn addTarget:self action:@selector(dismissShare) forControlEvents:UIControlEventTouchDown];
     [shareView addSubview:cancelBtn];
     UIView *subshare=[[UIView alloc]initWithFrame: CGRectMake(10, 10, DEVICE_WIDTH-20, 0.4*DEVICE_HEIGHT-20)];
     subshare.layer.cornerRadius=10;
     [subshare setBackgroundColor:[UIColor whiteColor]];
     
     //分享按钮
     
     UIShareButton *sinaShareBtn=[[UIShareButton alloc]initWithFrame:CGRectZero];
     //  sinaShareBtn.backgroundColor=[UIColor blackColor  ];
     //  [sinaShareBtn setTitle:@"新浪微博" forState:UIControlStateNormal];
     //[sinaShareBtn setImage:[UIImage imageNamed:@"UMS_sina_icon"] forState:UIControlStateNormal];
     [sinaShareBtn addTarget:self action:@selector(sinaShare) forControlEvents:UIControlEventTouchDown];
     [sinaShareBtn setFrame:CGRectMake(10, 10, subshare.frame.size.width/3-20, subshare.frame.size.height/2-20)];
     [sinaShareBtn setImage:[UIImage imageNamed:@"sina.jpg"] title:@"新浪微博" forState:UIControlStateNormal];
     
     
     UIShareButton *wechatShareBtn=[[UIShareButton alloc]initWithFrame:CGRectZero];
     [wechatShareBtn addTarget:self action:@selector(WechatTimelineShare) forControlEvents:UIControlEventTouchDown];
     [wechatShareBtn setFrame:CGRectMake(10+subshare.frame.size.width/3, 10, subshare.frame.size.width/3-20, subshare.frame.size.height/2-20)];
     
     [wechatShareBtn setImage:[UIImage imageNamed:@"wechat.jpg"] title:@"微信朋友圈" forState:UIControlStateNormal];
     
     
     
     
     
     UIShareButton *wechatFriendsShareBtn=[[UIShareButton alloc]initWithFrame:CGRectZero];
     
     
     
     [wechatFriendsShareBtn addTarget:self action:@selector(WechatSessionshare) forControlEvents:UIControlEventTouchDown];
     [wechatFriendsShareBtn setFrame:CGRectMake(10+2*subshare.frame.size.width/3, 10, subshare.frame.size.width/3-20, subshare.frame.size.height/2-20)];
     [wechatFriendsShareBtn  setImage:[UIImage imageNamed:@"wechatfriend.png"] title:@"微信好友" forState:UIControlStateNormal];
     
     UIShareButton *renrenShareBtn=[[UIShareButton alloc]initWithFrame:CGRectZero];
     
     [renrenShareBtn addTarget:self action:@selector(renrenShare) forControlEvents:UIControlEventTouchDown];
     [renrenShareBtn setFrame:CGRectMake(10, 10+subshare.frame.size.height/2, subshare.frame.size.width/3-20, subshare.frame.size.height/2-20)];
     [renrenShareBtn setImage:[UIImage imageNamed:@"renren.jpg"] title:@"人人" forState:UIControlStateNormal];
     UIShareButton *qqShareBtn=[[UIShareButton alloc]initWithFrame:CGRectZero];
     
     [qqShareBtn addTarget:self action:@selector(qqShare) forControlEvents:UIControlEventTouchDown];
     
     [qqShareBtn setFrame:CGRectMake(10+subshare.frame.size.width/3, 10+subshare.frame.size.height/2, subshare.frame.size.width/3-20, subshare.frame.size.height/2-20)];
     [qqShareBtn setImage:[UIImage imageNamed:@"qq.png"] title:@"QQ好友" forState:UIControlStateNormal];
     UIShareButton *qqZoneShareBtn=[[UIShareButton alloc]initWithFrame:CGRectZero];
     
     [qqZoneShareBtn addTarget:self action:@selector(qqZoneShare )forControlEvents:UIControlEventTouchDown];
     [qqZoneShareBtn setFrame:CGRectMake(10+2*subshare.frame.size.width/3, 10+subshare.frame.size.height/2, subshare.frame.size.width/3-20, subshare.frame.size.height/2-20)];
     [qqZoneShareBtn setImage:[UIImage imageNamed:@"qqZone.png"] title:@"QQ空间" forState:UIControlStateNormal];
     
     [subshare addSubview:qqShareBtn];
     [subshare addSubview:qqZoneShareBtn];
     [subshare addSubview:renrenShareBtn];
     [subshare addSubview:sinaShareBtn];
     [subshare addSubview:wechatFriendsShareBtn];
     [subshare addSubview:wechatShareBtn];
     for(UIButton *btnn in subshare.subviews)
     {
     [btnn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     }
     [shareView addSubview:subshare];
     
     [self.view addSubview:shareView];
     */
    toolBar1=[[UIToolbar alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50)];
    toolBar1.translucent=NO;
    [self.view addSubview:toolBar1];
    
    //    UIBarButtonItem *addItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *addItem=[[UIBarButtonItem alloc] initWithCustomView:discussBtn];
    UIBarButtonItem *saveItem=[[UIBarButtonItem alloc] initWithCustomView:likeBtn];
    UIBarButtonItem *editItem=[[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    UIBarButtonItem *replyItem=[[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    UIBarButtonItem *flexItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];//固定宽度
    UIBarButtonItem *fixedItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    UIBarButtonItem *fixedItem1=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedItem.width=(DEVICE_WIDTH-140)/5.0;
        fixedItem1.width=(DEVICE_WIDTH-140)/10.0;//自定义宽度
    NSArray *itemsArray = [NSArray arrayWithObjects:backItem,fixedItem,fixedItem1,addItem,flexItem,saveItem,flexItem,editItem,flexItem,replyItem,nil];
    [toolBar1 setItems:itemsArray animated:YES];
    
    
    
    
}
-(void)insertFootMaskSQL
{    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm  MM-dd"];
    collection=[[KBMyCollectionDataModel alloc]init];
    collection.time= [formatter stringFromDate:[NSDate date]];
    collection.articleTitle=webviewInfoModel.textString;
    collection.TypeName=webviewInfoModel.classString;
    // NSLog(@" transport.classString:%@", collection.TypeName);
    collection.pageID=webviewInfoModel.pageId;
    collection.imagestr=webviewInfoModel.imagestr;
    
    //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    //NSString *photo=[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Footer(ID INTEGER PRIMARY KEY AUTOINCREMENT,pageid INTEGER  , title TEXT, type TEXT, time TEXT,imagestr TEXT,imagedata TEXT,secondType TEXT)";
    char *err;
    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
    
    const char * sql="insert into Footer(pageid,title,type,time,imagestr,imagedata,secondType) values(?,?,?,?,?,?,?);";
    sqlite3_stmt *stmp;
    //在执行SQL语句之前检查SQL语句语法,-1代表字符串的长度
    int result= sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);
    if(result==SQLITE_OK){
        NSLog(@"插入SQL语句语法没有问题");
        //绑定参数,插入的参数的下标是从1开始
        sqlite3_bind_int(stmp, 1,  (int)collection.pageID);
        sqlite3_bind_text(stmp, 2, [collection.articleTitle UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 3, [collection.TypeName UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 4, [collection.time UTF8String], -1, nil);
        sqlite3_bind_text(stmp, 5, [collection.imagestr UTF8String], -1, nil);
        
        sqlite3_bind_blob(stmp, 6, [webviewInfoModel.imageData bytes], (int)[webviewInfoModel.imageData length], NULL);
        sqlite3_bind_int(stmp, 7, (int)webviewInfoModel.secondType);
        //执行参参数的SQL语句，不能有exec
        int result=sqlite3_step(stmp);
        //插入进行判断,要用sqLite_Done来判断
        if(result==SQLITE_DONE){
            NSLog(@"插入成功");
            
        }
        else{
            NSLog(@"插入失败") ;
        }
        
    }
    else{
        NSLog(@"插入SQL语句有问题");
    }
    sqlite3_close(db);
    
}
-(void)deleteFooter{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    //NSString *sqlQuery = @"SELECT * FROM Footer ";
    NSString * sqldel=@"DELETE FROM Footer WHERE pageid =?";
    sqlite3_stmt *stmp;
    //    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &stmp, nil) == SQLITE_OK) {
    //        while (sqlite3_step(stmp) == SQLITE_ROW) {
    //            int pageID = sqlite3_column_int(stmp, 1);
    //            NSLog(@"pageid1:%d,pageid2:%ld",pageID,(long)transport.mainpageid);
    //            if(pageID==transport.mainpageid)
    //            {
    int result= sqlite3_prepare_v2(db, [sqldel UTF8String], -1, &stmp, nil);
    if(result!=SQLITE_OK){
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(db);
        
    }
    else{
        sqlite3_bind_int(stmp, 1, (int)webviewInfoModel.pageId);
        int r = sqlite3_step(stmp);
        if (r==SQLITE_DONE) {
            NSLog(@"done!!!!");
        }
        else{
            NSLog(@"删除SQL语句有问题");
        }
    }
    
}
-(void)deleteHavelike
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    //NSString *sqlQuery = @"SELECT * FROM Footer ";
    NSString * sqldel=@"DELETE FROM Collection WHERE pageid =?";
    sqlite3_stmt *stmp;
    //    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &stmp, nil) == SQLITE_OK) {
    //        while (sqlite3_step(stmp) == SQLITE_ROW) {
    //            int pageID = sqlite3_column_int(stmp, 1);
    //            NSLog(@"pageid1:%d,pageid2:%ld",pageID,(long)transport.mainpageid);
    //            if(pageID==transport.mainpageid)
    //            {
    int result= sqlite3_prepare_v2(db, [sqldel UTF8String], -1, &stmp, nil);
    if(result!=SQLITE_OK){
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(db);
        
    }
    else{
        sqlite3_bind_int(stmp, 1, (int)transport.mainpageid);
        int r = sqlite3_step(stmp);
        if (r==SQLITE_DONE) {
            NSLog(@"done!!!!");
        }
        else{
            NSLog(@"删除SQL语句有问题");
        }
    }
    
}
-(void)sendRequest{
    cachepaths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    cachesDir=[cachepaths objectAtIndex:0];
    cachefilename=[cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)transport.mainpageid]];
    judge=[JudgeInternet newinstance];
    [failLabel removeFromSuperview];
    [failButton removeFromSuperview];
    if([judge.internetStatusStr isEqualToString:@"NotReachable"])
    {
        
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachefilename]) {
            //从本地读缓存文件
            NSData * data=[NSData dataWithContentsOfFile:cachefilename];
            originHTMLStr=[[NSString alloc] initWithData:
                           data encoding:NSUTF8StringEncoding];
            
            NSScanner *theScanner;
            NSString *text = nil;
            theScanner = [NSScanner scannerWithString:originHTMLStr];
            
            while ([theScanner isAtEnd] == NO)
            {
                // find start of tag
                [theScanner scanUpToString:@"<img" intoString:NULL] ;
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                originHTMLStr = [originHTMLStr stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@""];
            }
            self.theWebView.scrollView.scrollEnabled=YES;
            [self.theWebView loadHTMLString:originHTMLStr baseURL:nil];
            [self deleteFooter];
            [self insertFootMaskSQL];
            NSLog(@"读取缓存成功");
        }
        else
            
        {
            [self showFail];
            self.theWebView.scrollView.scrollEnabled=NO;
            
            //            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            hud.labelText=@"请检查网络设置";
            //            hud.minSize=CGSizeMake(120.0f, 20.0f);
            //            hud.margin=10.f;
            //            hud.removeFromSuperViewOnHide=YES;
            //            hud.yOffset=-0.375*DEVICE_HEIGHT;
            //
            //            hud.mode=MBProgressHUDModeText;
            //            [hud hide:YES afterDelay:1];
            
            
            
            
        }
    }
    else{
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"VIEWUNDERWEBVIEW" object:nil];
        self.theWebView.scrollView.scrollEnabled=YES;
        /*
        if (![judge.internetStatusStr isEqualToString:@"ReachableViaWiFi"]&&transport.isOnlyImageInWiFi)
            //NSLog(@"shareURL:%@",transport.shareURL);
        {
            [appDelegate.manager
             GET:transport.shareURL
             parameters:nil // 指定无需请求参数
             // 获取服务器响应成功时激发的代码块
             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 
                 // 当使用HTTP响应解析器时，服务器响应数据被封装在NSData中
                 originHTMLStr=[[NSString alloc] initWithData:
                                responseObject encoding:NSUTF8StringEncoding];
                 
                 {
                     NSString *text = nil;
                     NSScanner *theScanner;
                     theScanner = [NSScanner scannerWithString:originHTMLStr];
                     
                     while ([theScanner isAtEnd] == NO)
                     {
                         // find start of tag
                         [theScanner scanUpToString:@"<img" intoString:NULL] ;
                         // find end of tag
                         [theScanner scanUpToString:@">" intoString:&text] ;
                         // replace the found tag with a space
                         //(you can filter multi-spaces out later if you wish)
                         originHTMLStr = [originHTMLStr stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@""];
                     }
                     
                     
                 }
                 
                 [responseObject writeToFile:cachefilename atomically:YES];
                 
                 [self.theWebView loadHTMLString:originHTMLStr baseURL:nil];
                 //NSLog(@"%@",originHTMLStr);
                 [self deleteFooter];
                 [self insertFootMaskSQL];
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_LIKE" object:Pageid];
                 NSLog(@"服务器加载");
                 
             }
             // 获取服务器响应失败时激发的代码块
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [self showFail];
                 //                 hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 //                 hud.labelText=@"请检查网络设置";
                 //                 hud.minSize=CGSizeMake(120.0f, 20.0f);
                 //                 hud.margin=10.f;
                 //                 hud.removeFromSuperViewOnHide=YES;
                 //                 hud.yOffset=-0.375*DEVICE_HEIGHT;
                 //
                 //                 hud.mode=MBProgressHUDModeText;
                 //                 [hud hide:YES afterDelay:1];
                 
                 //             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 //             [alert show];
                 
             }];
        }
        else
         */
        {
           
           

            NSURL *url =[[NSURL alloc] initWithString:webviewInfoModel.shareURL];
            NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
            [self.theWebView loadRequest:request];
           
            [self deleteFooter];
            [self insertFootMaskSQL];
           [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_READNUMBER" object:Pageid];
            
            
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    canHandleLong=NO;
    didScroll=NO;
    [self DidChangeStatusBarFrame];
    self.navigationController.navigationBarHidden=YES;
    
    //[navigationBar setHidden:YES];
    //self.theWebView.scrollView.scrollsToTop=YES;
    KKNavigationController *nav=(KKNavigationController *)self.navigationController;
    nav.canDragBack=NO;
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];

}
-(void)navigationBarHidden
{
    //    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    self.navigationController.navigationBarHidden=YES;
}
-(void)combineWebAndDiscuss:(float)height{
    if (VC==nil) {
        self.theWebView.frame=CGRectMake(0, 0, self.theWebView.frame.size.width, height) ;
        
        //    [VC.hotTableView reloadData];
        //NSLog(@"webView.frame:%f",self.theWebView.scrollView.contentSize.height);
        VC=[[KBInfoTableViewController alloc]init];
        [VC.view setFrame:CGRectMake(0, 0, VC.view.frame.size.width, VC.view.frame.size.height)];
        
        
        
        VC.parentDelegate=transport.navcontrolDelegate;
        VC.pageId=transport.mainpageid;
        [VC firstpage];
        
        
        //        [viewUnderWeb.feedBackBtn addTarget:self action:@selector(changeFeedBackView) forControlEvents:UIControlEventTouchUpInside];
        //        NSLog(@"viewUnderWeb.feedBackBtn:%@",viewUnderWeb.feedBackBtn);
        VC.commentTableView.scrollsToTop=NO;
        self.theWebView.scrollView.scrollsToTop=NO;
        self.theWebView.scrollView.delegate=VC;
        self.theWebView.scrollView.tag=222;
        VC.webview=self.theWebView;
        
        //        FeedCell *feedCell=[[FeedCell alloc]init];
        //        VC.subView=feedCell;
        
        //
        //        SubView *subView=[[SubView alloc]init];
        //        VC.subView=subView;
        //
        //        FeedCell *feedCell=[[FeedCell alloc]init];
        //        VC.subView=feedCell;
        
        [self.view addSubview:VC.view];
        [self addChildViewController:VC];
        
        //[self UIinit];
        
        
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    //    if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
    //    {
    //        [self.view setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT+40)];
    //    }
    //    else
    //    {
    //        [self.view setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    //    }
    
    
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=NO;
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //[UIApplication sharedApplication].statusBarHidden=YES;
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_FOOTER" object:nil];
    // self.navigationController.navigationBar.barTintColor=[UIColor clearColor];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView

{
    
    [loadingIndicator startAnimation];
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"$(\"#download\").hide()"];
   
//    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
//    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    imagePath = [NSString stringWithFormat:@"file:/%@//%@",imagePath,@"载入中大图.png"];
//    //拦截网页图片  并修改图片大小
//    NSString * Image=[NSString stringWithFormat:@"var script = document.createElement('script');"
//                      "script.type = 'text/javascript';"
//                      "script.text = \"function ResizeImages() { "
//                      "var myimg,oldwidth;"
//                      "var maxwidth=380;" //缩放系数
//                      "for(i=0;i <document.images.length;i++){"
//                      "myimg = document.images[i];"
//                      "myimg.src=%@"
//                      "}"
//                      "}\";"
//                      "document.getElementsByTagName('head')[0].appendChild(script);",imagePath];
    
//    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
//    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    imagePath = [NSString stringWithFormat:@"file:/%@//%@",imagePath,@"载入中大图.png"];
//    NSLog(@"imagepath:%@",imagePath);
//    NSString * js=[NSString stringWithFormat:@"changeSrc(%@)",imagePath];
//    NSLog(@"jsjsjs:%@",js);
//    NSString * jss=[NSString stringWithFormat:@"var imgs = document.getElementsByTagName(\"img\");\
//                    for(var i = 3; i<imgs.length-2;i++){\
//                        document.images[%d].src=%@;\
//                    }",4,imagePath];
//    NSLog(@"jsssss:%@",jss);
//    [webView stringByEvaluatingJavaScriptFromString:jss];

    [webView stringByEvaluatingJavaScriptFromString:@"Function()"];
    [webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
//    NSString * jsss = [NSString stringWithFormat:@"document.images[3].src='%@'",imagePath];
//    [webView stringByEvaluatingJavaScriptFromString:jsss];
      //[self.theWebView stringByEvaluatingJavaScriptFromString:resultString];
//    NSLog(@":%@",resultString);
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.p.style"];
//    //    NSLog(@"title = %@",title);
//    NSLog(@"style:%@",title);
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""];
//    [self.theWebView stringByEvaluatingJavaScriptFromString:meta];
    
    //(initial-scale是初始缩放比,minimum-scale=1.0最小缩放比,maximum-scale=5.0最大缩放比,user-scalable=yes是否支持缩放)
    //    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    //    NSLog(@"currentURL = %@",currentURL);
    //
//        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        NSLog(@"title = %@",title);
    //
//        NSString *body = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"img\").length"];
//       for ( int i=3 ; i<body.length; i++) {
//           NSString * jsss = [NSString stringWithFormat:@"document.images[%d].src='%@'",i,imagePath];
//           [webView stringByEvaluatingJavaScriptFromString:jsss];
//           NSLog(@"iiiii,%d",i);
//
//    }
//        NSLog(@"body = %@",body);
    //
    //    NSString *lJs = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    //    NSLog(@"lJs = %@",lJs);
    //
//        NSString *images = [webView stringByEvaluatingJavaScriptFromString:@"document.images"];
//        NSLog(@"images;%@",images);
    //
    //
    
    //  NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    
    
    
//        NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//        NSLog(@"currentURL = %@",currentURL);
//        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        NSLog(@"title = %@",title);
    
//        NSString *body = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];
//       NSLog(@"body = %@",body);
    
//        NSString *lJs = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//        NSLog(@"lJs = %@",lJs);
    
//        NSString *images = [webView stringByEvaluatingJavaScriptFromString:@"document.images"];
//        NSLog(@"images = %@",images);
    
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f",16.0];
//    
//    [self.theWebView stringByEvaluatingJavaScriptFromString:jsString];
    
    
    if ([transport.fontSizeStr isEqualToString:@"中号字体"])
    {
        
        [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.035em;font-size: 1.152em;\");"];
//        [self.theWebView stringByEvaluatingJavaScriptFromString: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
        
        
        
    }
    else if([transport.fontSizeStr isEqualToString:@"小号字体"]){
//        [self.theWebView stringByEvaluatingJavaScriptFromString: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
        [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.05em;font-size: 1.0em;\");"];

       
        
        
    }
    else if ([transport.fontSizeStr isEqualToString:@"大号字体"]){
        
//        [self.theWebView stringByEvaluatingJavaScriptFromString: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'"];
        [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.65em;letter-spacing:-0.09em;font-size: 1.4em;\");"];
        
    }
    [loadingIndicator stopAnimationWithLoadText:@"加载成功" withType:YES];
    
    
    //    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    //    CGRect newFrame = webView.frame;
    //    newFrame.size.height = actualSize.height;
    //    webView.frame = newFrame;
    //    CGSize newsize=CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT+webView.frame.size.height);
    //    webView.scrollView.contentSize=newsize;
    //加入UI
//        NSString *scrollHeight=[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//       transport.WebviewHight=0;
//      transport.WebviewHight=[scrollHeight intValue];
//    NSLog(@"transp:%f",transport.WebviewHight);
    
    //[self combineWebAndDiscuss:[scrollHeight floatValue]];
    //
}
-(void)showFail
{
    failLabel=[[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WIDTH/2.0-60, DEVICE_HEIGHT/2-15,80 ,30)];
    failLabel.text=@"加载失败";
    failLabel.textColor=[UIColor grayColor];
    failLabel.textAlignment=NSTextAlignmentCenter;
    failButton=[[UIButton alloc]initWithFrame:CGRectMake(failLabel.frame.origin.x+failLabel.frame.size.width+1, failLabel.frame.origin.y,50 ,30)];
    failButton.layer.borderWidth=1;
    failButton.layer.borderColor=[UIColor grayColor].CGColor;
    [failButton setTitle:@"重试" forState:UIControlStateNormal];
    [failButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [failButton addTarget:self action:@selector(sendRequestAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:failLabel];
    [self.view addSubview:failButton];
    
    
}
-(void)sendRequestAgain{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddLoadingIndicator" object:nil];
    cachepaths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    cachesDir=[cachepaths objectAtIndex:0];
    cachefilename=[cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)transport.mainpageid]];
    judge=[JudgeInternet newinstance];
    [failLabel removeFromSuperview];
    [failButton removeFromSuperview];
    if([judge.internetStatusStr isEqualToString:@"NotReachable"])
    {
        
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachefilename]) {
            //从本地读缓存文件
            NSData * data=[NSData dataWithContentsOfFile:cachefilename];
            originHTMLStr=[[NSString alloc] initWithData:
                           data encoding:NSUTF8StringEncoding];
            
            NSScanner *theScanner;
            NSString *text = nil;
            theScanner = [NSScanner scannerWithString:originHTMLStr];
            
            while ([theScanner isAtEnd] == NO)
            {
                // find start of tag
                [theScanner scanUpToString:@"<img" intoString:NULL] ;
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                originHTMLStr = [originHTMLStr stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@""];
            }
            self.theWebView.scrollView.scrollEnabled=YES;
            [self.theWebView loadHTMLString:originHTMLStr baseURL:nil];
            [self deleteFooter];
            [self insertFootMaskSQL];
            NSLog(@"读取缓存成功");
        }
        else
            
        {
            [self showFail];
            self.theWebView.scrollView.scrollEnabled=NO;
            
            //            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            hud.labelText=@"请检查网络设置";
            //            hud.minSize=CGSizeMake(120.0f, 20.0f);
            //            hud.margin=10.f;
            //            hud.removeFromSuperViewOnHide=YES;
            //            hud.yOffset=-0.375*DEVICE_HEIGHT;
            //
            //            hud.mode=MBProgressHUDModeText;
            //            [hud hide:YES afterDelay:1];
            
            
            
            
        }
    }
    else{
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"VIEWUNDERWEBVIEW" object:nil];
        self.theWebView.scrollView.scrollEnabled=YES;
        /*
         if (![judge.internetStatusStr isEqualToString:@"ReachableViaWiFi"]&&transport.isOnlyImageInWiFi)
         //NSLog(@"shareURL:%@",transport.shareURL);
         {
         [appDelegate.manager
         GET:transport.shareURL
         parameters:nil // 指定无需请求参数
         // 获取服务器响应成功时激发的代码块
         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
         
         // 当使用HTTP响应解析器时，服务器响应数据被封装在NSData中
         originHTMLStr=[[NSString alloc] initWithData:
         responseObject encoding:NSUTF8StringEncoding];
         
         {
         NSString *text = nil;
         NSScanner *theScanner;
         theScanner = [NSScanner scannerWithString:originHTMLStr];
         
         while ([theScanner isAtEnd] == NO)
         {
         // find start of tag
         [theScanner scanUpToString:@"<img" intoString:NULL] ;
         // find end of tag
         [theScanner scanUpToString:@">" intoString:&text] ;
         // replace the found tag with a space
         //(you can filter multi-spaces out later if you wish)
         originHTMLStr = [originHTMLStr stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@""];
         }
         
         
         }
         
         [responseObject writeToFile:cachefilename atomically:YES];
         
         [self.theWebView loadHTMLString:originHTMLStr baseURL:nil];
         //NSLog(@"%@",originHTMLStr);
         [self deleteFooter];
         [self insertFootMaskSQL];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_LIKE" object:Pageid];
         NSLog(@"服务器加载");
         
         }
         // 获取服务器响应失败时激发的代码块
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
         [self showFail];
         //                 hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
         //                 hud.labelText=@"请检查网络设置";
         //                 hud.minSize=CGSizeMake(120.0f, 20.0f);
         //                 hud.margin=10.f;
         //                 hud.removeFromSuperViewOnHide=YES;
         //                 hud.yOffset=-0.375*DEVICE_HEIGHT;
         //
         //                 hud.mode=MBProgressHUDModeText;
         //                 [hud hide:YES afterDelay:1];
         
         //             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
         //             [alert show];
         
         }];
         }
         else
         */
        {
            
            
            
            NSURL *url =[[NSURL alloc] initWithString:transport.shareURL];
            NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
            [self.theWebView loadRequest:request];
            
            [self deleteFooter];
            [self insertFootMaskSQL];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_LIKE" object:Pageid];
            
        }
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showFail];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                 _gesState = GESTURE_STATE_START;
                //NSLog(@"touch start!");
                
                ptX = [[components objectAtIndex:3]floatValue];
                ptY = [[components objectAtIndex:4]floatValue];
                //NSLog(@"touch point (%f, %f)", ptX, ptY);
                imgURL=nil;
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.theWebView stringByEvaluatingJavaScriptFromString:js];
                if ([tagName isEqualToString:@"IMG"]) {
                    imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                    timer  =[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(handleLong) userInfo:nil repeats:NO];
                    
                }
                else
                {
                    imgURL=nil;
                }
                
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                imgURL=nil;
                //NSLog(@"you are move");
            }
            else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
                //NSLog(@"touch end");
                _gesState = GESTURE_STATE_END;
                [timer invalidate];
                timer=nil;
            }
        }
        return NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loadingSuccess" object:nil];
    return YES;
   
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//-(void)handleSingleTap:(UITapGestureRecognizer *)sender
//{
//    NSString *urlToSave = [self.theWebView stringByEvaluatingJavaScriptFromString:imgURL];
//
//    CGPoint pt = CGPointMake(ptX, ptY);
//    if (urlToSave.length > 0) {
//        [self showImageURL:urlToSave point:pt];
//    }
//}
//-(void)showImageURL:(NSString *)url point:(CGPoint)point
//{
//    UIImageView *showView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    showView.center = point;
//    [UIView animateWithDuration:0.5f animations:^{
//        CGPoint newPoint = self.view.center;
//        newPoint.y += 20;
//        showView.center = newPoint;
//    }];
//
//    showView.backgroundColor = [UIColor blackColor];
//
//    showView.userInteractionEnabled = YES;
//    [self.view addSubview:showView];
//
//    [showView sd_setImageWithURL:[NSURL URLWithString:url]];
//
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleViewTap:)];
//    [showView addGestureRecognizer:singleTap];
//
//
//}
//-(void)handleSingleViewTap:(UITapGestureRecognizer *)sender
//{
//    for (id obj in self.view.subviews) {
//        if ([obj isKindOfClass:[UIImageView class]])
//        {
//            [obj removeFromSuperview];
//        }
//    }
//
//}
-(void)didScroll
{
    didScroll=YES;
    canHandleLong=NO;
}
-(void)canHandlelong
{
    canHandleLong=YES;
    didScroll=NO;
}
-(void)handleLong{
    //NSLog(@"didscrooll:%d",didScroll);
     if (imgURL && _gesState == GESTURE_STATE_START&&canHandleLong&&!didScroll){
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        sheet.tag=666;
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

-(void)pop{
    //    navController *nav=self.navdelegate;
    //
    //    [nav popViewControllerAnimated:YES];
    //
    //    CATransition *transition = [CATransition animation];
    //    transition.duration = 0.5;
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    transition.type = kCATransitionPush;
    //    transition.subtype = kCATransitionFromLeft;
    //    transition.delegate = self;
    //    //[self.navigationController.view.layer addAnimation:transition forKey:nil];
    //    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    //    [self.view.layer addAnimation:transition forKey:nil];
    //
    
    
    
    
    
    
    //    [navVC.screenShotsList removeLastObject];
    //    [navVC.lastScreenShotView removeFromSuperview];
    //
    [self.navigationController popViewControllerAnimated:YES];
    if (transport.navCount) {
        self.navigationController.navigationBarHidden=YES;
        transport.navCount--;
        
    }
    else
    {
        self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:15/255.0 green:86/255.0 blue:208/255.0 alpha:1];
    }
    
    
    //    [self dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
    // [self.webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==666) {
        
        if (actionSheet.numberOfButtons - 1 == buttonIndex) {
            return;
        }
        NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"保存图片"]) {
            if (imgURL) {
                //NSLog(@"imgurl = %@", imgURL);
            }
            NSString *urlToSave = [self.theWebView stringByEvaluatingJavaScriptFromString:imgURL];
            //NSLog(@"image url=%@", urlToSave);
            
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
            UIImage* image = [UIImage imageWithData:data];
            
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else {
        switch (buttonIndex) {
            case 0:
            {
//                [self.theWebView stringByEvaluatingJavaScriptFromString: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='80%'"];
                  [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.05em;font-size: 1.0em;\");"];
                transport.fontSizeStr=@"小号字体";
               
                
                //                NSString *scrollHeight=[self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
                //                [self.theWebView setFrame:CGRectMake(self.theWebView.frame.origin.x, self.theWebView.frame.origin.y, self.theWebView.frame.size.width, [scrollHeight floatValue])];
                //                [VC.hotTableView reloadData];
            }
                break;
            case 1:
            {
                //[self.theWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='100%'"];
                [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.035em;font-size: 1.152em;\");"];
                transport.fontSizeStr=@"中号字体";
            }
                break;
            case 2:{
                
               // [self.theWebView stringByEvaluatingJavaScriptFromString: @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='130%'"];
                [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.65em;letter-spacing:-0.09em;font-size: 1.4em;\");"];
                transport.fontSizeStr=@"大号字体";
                
            }
                break;
            default:
                break;
        }
        
        
        
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL){
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"保存失败";
        hud.minSize=CGSizeMake(120.0f, 20.0f);
        hud.margin=10.f;
        hud.removeFromSuperViewOnHide=YES;
        hud.yOffset=0.375*DEVICE_HEIGHT;
        
        hud.mode=MBProgressHUDModeText;
        [hud hide:YES afterDelay:1];

    }
    else{
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"保存成功";
        hud.minSize=CGSizeMake(120.0f, 20.0f);
        hud.margin=10.f;
        hud.removeFromSuperViewOnHide=YES;
        hud.yOffset=0.375*DEVICE_HEIGHT;
        
        hud.mode=MBProgressHUDModeText;
        [hud hide:YES afterDelay:1];
    }
}

-(void)share{
    
    if([judge.internetStatusStr isEqualToString:@"NotReachable"])
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"请检查网络设置";
        hud.minSize=CGSizeMake(120.0f, 20.0f);
        hud.margin=10.f;
        hud.removeFromSuperViewOnHide=YES;
        hud.yOffset=-0.375*DEVICE_HEIGHT;
        
        hud.mode=MBProgressHUDModeText;
        [hud hide:YES afterDelay:1];
        
        
    }
    else
    {
        
        
        WBAuthorizeRequest * wbauthorizerequest;
        wbauthorizerequest.shouldShowWebViewForAuthIfCannotSSO=YES;
        
        [UMSocialConfig setTheme:UMSocialThemeBlack];
        [UMSocialWechatHandler setWXAppId:@"wxea87cda5461e6902" appSecret:@"76c0827f75312d410869410e4ebb6792" url:transport.shareURL];
        
        //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
        [UMSocialQQHandler setQQWithAppId:@"1104745162" appKey:@"iCw8CuDzeSpk58wB" url:transport.shareURL];
        
        
        
        //隐藏
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
        
        //设置分享完成时“发送完成”或者分享错误等提示
       // [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionBottom];
        
        [UMSocialConfig setShareGridViewTheme:^(CGContextRef ref, UIImageView *backgroundView,UILabel *label){
            //改变背景颜色
            backgroundView.backgroundColor = [UIColor whiteColor];
            //改变文字标题的文字颜色
            label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            
        }];
        
        
        
        
        NSArray * shareArray=[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToRenren,UMShareToSina, nil];
        
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"5657d61667e58eacab000e3f"//@"55be0ff1e0f55ac25500bc10"
                                          shareText:@""
                                         shareImage:webviewInfoModel.imageData
                                    shareToSnsNames:shareArray
                                           delegate:self];
        
        
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"[%@]详情请见:%@",webviewInfoModel.textString,webviewInfoModel.shareURL];
        [UMSocialData defaultData].extConfig.renrenData.shareText=[NSString stringWithFormat:@"[%@]详情请见:[%@]",webviewInfoModel.textString,webviewInfoModel.shareURL];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = webviewInfoModel.textString;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText=@"新鲜·新潮·心意—跬步为你每日精选";
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = webviewInfoModel.textString;
        [UMSocialData defaultData].extConfig.qqData.title =webviewInfoModel.textString;
        [UMSocialData defaultData].extConfig.qzoneData.title = webviewInfoModel.textString;
        [self navigationBarHidden];
    }
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response){
    }];
    //    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],NO);
    //    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToRenren].snsClickHandler(self,[UMSocialControllerService defaultControllerService],NO);
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"12312312"}];
    /*
     //    CATransition *transition = [CATransition animation];
     //    transition.duration = 0.5;
     //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     //    transition.type = kCATransitionPush;
     //    transition.subtype = kCATransitionFromTop;
     //    transition.delegate = self;
     //    [shareView.layer addAnimation:transition forKey:nil];
     //    [shareView setHidden:NO];
     //
     //
     //    CATransition *transition1 = [CATransition animation];
     //    transition1.duration = 0.5;
     //    transition1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     //    transition1.type = kCATransitionFade;
     //    transition1.subtype = kCATransitionFade;
     //    transition1.delegate = self;
     //    [blackView.layer addAnimation:transition1 forKey:nil];
     //    [blackView setHidden:NO];
     //
     //    CATransition *transition2 = [CATransition animation];
     //    transition2.duration = 0.5;
     //    transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     //    transition2.type = kCATransitionPush;
     //    transition2.subtype = kCATransitionFromBottom;
     //    transition2.delegate = self;
     //    [toolBar.layer addAnimation:transition1 forKey:nil];
     //    [toolBar setHidden:YES];
     */
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //    UMSocialBar * socialBar;
    //    UMSocialButton *socialButton1 =  [socialBar.barButtons objectAtIndex:0];
    //    socialButton1 .clickHandler = ^(){
    //        NSLog(@"ddddddddddddhsahfhfashfhasfhashfash");
    //        [self navigationBarHidden];
    //    };
    //
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shareClose" object:nil];
    [self navigationBarHidden];
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
        //得到分享到的微博平台名
        NSString *pageurl=[NSString stringWithFormat:@"%@/kuibuversion1/page/transmit/%ld",transport.ip121,(long)transport.mainpageid];
//        NSString * pageIDStr = [NSString stringWithFormat:@"{\"pageId\":\"%ld\"}",(long)transport.mainpageid];
//        NSDictionary *pageIdDic=@{@"pageId":pageIDStr};
        // NSLog(@" pageurl:%@ pageIdstr : %@,pageIddic :%@",pageurl,pageIDStr,pageIdDic);
        [appDelegate.manager
         POST:pageurl
         parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             
                          NSError *er;
                          NSMutableDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&er];
             NSString* doTransmitResult=[jsondic objectForKey:@"doTransmitResult"];
              NSLog(@"doTransmitResult:%@",doTransmitResult);
             int intdoReadResult=[doTransmitResult intValue];
                               if (intdoReadResult==1) {
                                   hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                   hud.labelText=@"分享成功";
                                   hud.minSize=CGSizeMake(120.0f, 20.0f);
                                   hud.margin=10.f;
                                   hud.removeFromSuperViewOnHide=YES;
                                   hud.yOffset=0.375*DEVICE_HEIGHT;
                                   
                                   hud.mode=MBProgressHUDModeText;
                                   [hud hide:YES afterDelay:1];
                                   NSLog(@"分享成功");
                               }
                               else
                               {
//                                   hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                                   hud.labelText=@"分享失败";
//                                   hud.minSize=CGSizeMake(120.0f, 20.0f);
//                                   hud.margin=10.f;
//                                   hud.removeFromSuperViewOnHide=YES;
//                                   hud.yOffset=-0.375*DEVICE_HEIGHT;
//                                   
//                                   hud.mode=MBProgressHUDModeText;
//                                   [hud hide:YES afterDelay:1];
                                   NSLog(@"分享失败");
                               }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // NSLog(@"阅读服务器失败");
         }];
        
        
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    
}
-(void)like
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm  MM-dd"];
    collection=[[KBMyCollectionDataModel alloc]init];
    collection.time= [formatter stringFromDate:[NSDate date]];
    collection.articleTitle=transport.textString;
    collection.TypeName=transport.classString;
   // NSLog(@" transport.classString:%@", collection.TypeName);
    collection.pageID=transport.mainpageid;
    collection.imagestr=transport.imagestr;
    
    if (!loginsingle.isLogined) {
        //        if([judge.internetStatusStr isEqualToString:@"NotReachable"])
        //        {
        //            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //            hud.labelText=@"请检查网络设置";
        //            hud.minSize=CGSizeMake(120.0f, 20.0f);
        //            hud.margin=10.f;
        //            hud.removeFromSuperViewOnHide=YES;
        //            hud.yOffset=-0.375*DEVICE_HEIGHT;
        //
        //            hud.mode=MBProgressHUDModeText;
        //            [hud hide:YES afterDelay:3];
        //
        //        }
        //        else
        {
            
            
            
            if(actionType==1){
                [self deleteHavelike];
                actionType=0;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documents = [paths objectAtIndex:0];
                NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
                
                
                
                if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
                    sqlite3_close(db);
                    NSLog(@"数据库打开失败");
                }
                NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS Collection(ID INTEGER PRIMARY KEY AUTOINCREMENT,pageid INTEGER , title TEXT, type TEXT, secondType TEXT,time TEXT,imagestr TEXT,imagedata TEXT)";
                char *err;
                if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
                    sqlite3_close(db);
                    NSLog(@"数据库操作数据失败!");
                }
                const char * sql=
                "insert into Collection(pageid,title,type,secondType,time,imagestr,imagedata) values(?,?,?,?,?,?,?);";
                
                sqlite3_stmt *stmp;
                //在执行SQL语句之前检查SQL语句语法,-1代表字符串的长度
                int result= sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);
                if(result==SQLITE_OK){
                    
                    
                    
                    
                    sqlite3_bind_int(stmp, 1,  (int)collection.pageID);
                    sqlite3_bind_text(stmp, 2, [collection.articleTitle UTF8String], -1, nil);
                    sqlite3_bind_text(stmp, 3, [collection.TypeName UTF8String], -1, nil);
                    sqlite3_bind_text(stmp, 4, [transport.secondType UTF8String], -1, nil);
                    sqlite3_bind_text(stmp, 5, [collection.time UTF8String], -1, nil);
                    sqlite3_bind_text(stmp, 6, [collection.imagestr UTF8String], -1, nil);
                    sqlite3_bind_blob(stmp, 7, [transport.imageData bytes], (int)[transport.imageData length], nil);
                   // NSLog(@"transport.imagedata;%@",transport.imageData);
                    //sqlite3_bind_text(stmp, 6, [collection.imagedata UTF8String], -1, nil);
                    
                    //sqlite3_bind_blob(stmp, 6, [collection.imagedata bytes], collection.imagedata.length, NULL);
                    //绑定参数,插入的参数的下标是从1开始
                    
                    //执行参参数的SQL语句，不能有exec
                    
                    int result=sqlite3_step(stmp);
                    //插入进行判断,要用sqLite_Done来判断
                    if(result==SQLITE_DONE){
                        
                        
                        [likeBtn setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
                        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.labelText=@"收藏成功";
                        hud.removeFromSuperViewOnHide=YES;
                        hud.minSize=CGSizeMake(120.0f, 20.0f);
                        hud.margin=10.f;
                        
                        hud.yOffset=0.375*DEVICE_HEIGHT;
                        
                        hud.mode=MBProgressHUDModeText;
                        [hud hide:YES afterDelay:1];
                        
                        
                        
                        //   loginsingle.userCollect=     [loginsingle.userCollect stringByAppendingString:];
                        [loginsingle.userCollect appendString:[NSString stringWithFormat: @"%ld,",(long)collection.pageID ]];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_NUMBER" object:nil];
                    }
                    else{
                        NSLog(@"插入失败");
                    }
                    
                }
                else{
                    NSLog(@"插入SQL语句有问题");
                }
                sqlite3_close(db);
                
                
            }
            
            
            else{
                actionType=1;
                //    //删除数据库里的内容
                //
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documents = [paths objectAtIndex:0];
                NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
                
                
                if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
                    sqlite3_close(db);
                    NSLog(@"数据库打开失败");
                }
                
                const char * sql="delete from Collection   where pageid=?";
                sqlite3_stmt *stmp;
                //根据ID删除，根据PageID？
                
                int result= sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);
                if(result==SQLITE_OK){
                    int ID;
                    
                    
                    
                    ID=(int)transport.mainpageid;
                    
                    sqlite3_bind_int(stmp, 1, ID );
                    //            NSLog(@"----------%d-----------------------------------------------",ID);
                    
                    int r=  sqlite3_step(stmp);
                    if (r==SQLITE_DONE) {
                        loginsingle.userCollect=[NSMutableString stringWithString:   [loginsingle.userCollect stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d,",ID] withString:@""]];
                        actionType=1;
                        
                        [likeBtn setImage:[UIImage imageNamed:@"收藏空心"] forState:UIControlStateNormal];
                        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.labelText=@"取消收藏";
                        hud.minSize=CGSizeMake(120.0f, 20.0f);
                        hud.margin=10.f;
                        hud.removeFromSuperViewOnHide=YES;
                        hud.yOffset=0.375*DEVICE_HEIGHT;
                        
                        hud.mode=MBProgressHUDModeText;
                        [hud hide:YES afterDelay:1];
                        
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_NUMBER" object:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_COLLECT" object:nil];
                        
                    }
                    
                    
                    
                    //
                    //插入进行判断,要用sqLite_Done来判断
                }
                else{
                    NSLog(@"插入SQL语句有问题");
                }
                
                sqlite3_close(db);
                
                
            }
        }
    }
    
    
    
    
    //    //服务器收藏
    if (loginsingle.isLogined)
    {
        
        if([judge.internetStatusStr isEqualToString:@"NotReachable"])
        {
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"请检查网络设置";
            hud.minSize=CGSizeMake(120.0f, 20.0f);
            hud.margin=10.f;
            hud.removeFromSuperViewOnHide=YES;
            hud.yOffset=-0.375*DEVICE_HEIGHT;
            
            hud.removeFromSuperViewOnHide=YES;
            
            hud.mode=MBProgressHUDModeText;
            [hud hide:YES afterDelay:1];
        }
        else
        {
            
            if (actionType==1) {
                actionType=0;
                [likeBtn setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
                hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText=@"收藏成功";
                hud.minSize=CGSizeMake(120.0f, 20.0f);
                hud.margin=10.f;;
                hud.removeFromSuperViewOnHide=YES;
                hud.yOffset=0.375*DEVICE_HEIGHT;
                hud.mode=MBProgressHUDModeText;
                [hud hide:YES afterDelay:1];
                
                
                actionType=0;
                //            if ([loginsingle.userCollect isEqualToString:@""]) {
                //             [loginsingle.userCollect stringByAppendingString:Pageid];
                //            }
                //            else
                
                //            [loginsingle.userCollect insertString:[NSString stringWithFormat:@"%@,",Pageid] atIndex:loginsingle.userCollect.length];
                [loginsingle.userCollect appendString:[NSString stringWithFormat:@"%@,",Pageid]];
                //     NSLog(@"userCollect:%@",loginsingle.userCollect);
                //            [loginsingle.userCollect substringToIndex:loginsingle.userCollect.length-1];
                //            NSLog(@"userCollect%@",loginsingle.userCollect);
            }
            else
                if(actionType==0)
                {
                    
                    loginsingle.userCollect=[NSMutableString stringWithString:   [loginsingle.userCollect stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",Pageid] withString:@""]];
                    [likeBtn setImage:[UIImage imageNamed:@"收藏空心"] forState:UIControlStateNormal];
                    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText=@"取消收藏";
                    
                    hud.minSize=CGSizeMake(120.0f, 20.0f);
                    hud.margin=10.f;
                    hud.removeFromSuperViewOnHide=YES;
                    hud.yOffset=0.375*DEVICE_HEIGHT;
                    hud.mode=MBProgressHUDModeText;
                    [hud hide:YES afterDelay:1];
                    KBMyCollectionViewController * newCollectionVC=[[KBMyCollectionViewController alloc]init];
                   
                    [newCollectionVC CancelCollect:cancelCollectIndexPath];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_COLLECT" object:nil];
                    
                    
                    actionType=1;
                    
                }
            // NSLog(@"usercollect%@",loginsingle.userCollect);
            
            NSString *collectString1=[NSString stringWithFormat:@"{\"userId\":\"%ld\",\"pageId\":\"%ld\",\"actionType\":\"%d\"}",(long)loginsingle.userID,(long)transport.mainpageid,actionType==0?1:0];
            NSDictionary *collectString=@{@"collectString":collectString1};
            
            NSString *urlstr=[NSString stringWithFormat:@"%@/kuibuversion1/user/doCollect",transport.ip121];
            [appDelegate.manager
             POST:urlstr
             parameters:collectString
             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSError *er;
                 NSMutableDictionary *json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&er];
                 NSString *collectResult=[json objectForKey:@"collectResult"];
                 int intcollectResult=[collectResult intValue];
                 if(intcollectResult==1)
                 {
                     
                 }
                 else
                 {
                     hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.labelText=@"操作失败";
                     
                     hud.minSize=CGSizeMake(120.0f, 20.0f);
                     hud.margin=10.f;
                     hud.removeFromSuperViewOnHide=YES;
                     hud.yOffset=0.375*DEVICE_HEIGHT;
                     hud.mode=MBProgressHUDModeText;
                     [hud hide:YES afterDelay:1];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.labelText=@"请检查网络设置";
                 hud.removeFromSuperViewOnHide=YES;
                 hud.yOffset=-0.375*DEVICE_HEIGHT;
                 hud.mode=MBProgressHUDModeText;
                 [hud hide:YES afterDelay:1];
                 
             }];
        }
        
    }
    
    
}
//-(void)dismisss
//{
//    for(id tmpView in self.view.subviews)
//    {
//        //找到要删除的子视图的对象
//        if([tmpView isKindOfClass:[UIButton class]])
//        {
//            UIButton * promptbutton = (UIButton *)tmpView;
//            if(promptbutton.tag == 1)   //判断是否满足自己要删除的子视图的条件
//            {
//                NSLog(@"判断是否满足自己要删除的子视图的条件");
//                [promptbutton removeFromSuperview];
//                
//                
//                
//                //删除子视图
//                
//                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
//            }
//        }
//    }
//    
//    //   promptView.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
//    //    [self.view addSubview:promptView];
//}


-(void)discuss{
    if (loginsingle.isLogined) {
        toolBar1.hidden=YES;
        
    }
    else
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText=@"请先登录再评论";
        hud.removeFromSuperViewOnHide=YES;
        hud.minSize=CGSizeMake(120.0f, 20.0f);
        hud.margin=10.f;
        
        hud.yOffset=0.375*DEVICE_HEIGHT;
        
        hud.mode=MBProgressHUDModeText;
        [hud hide:YES afterDelay:1];
    }
    
    
    //    VC.parentDelegate=self;
    //    VC.pageId=transport.mainpageid;
    //    [self.navigationController pushViewController:VC animated:YES];
    //    recommend *Recommend=[[recommend alloc]init];
    //    [self.navigationController pushViewController:Recommend animated:YES];
}
-(void)setting{
    UIActionSheet *actonSheet=[[UIActionSheet alloc]initWithTitle:@"设置字体" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小号字体",@"中号字体",@"大号字体", nil];
    [actonSheet showInView:self.view];
    
}
@end
