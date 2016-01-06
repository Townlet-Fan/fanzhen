//
//  TitleViewController.m
//  UIScroll1
//
//  Created by eddie on 15-3-31.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBInfoWebViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "MobClick.h"
#import "WeiboSDK.h"
#import "KBMyCollectionDataModel.h"
#import <sqlite3.h>
#import "KBConstant.h"
#import "KBHTTPTool.h"
#import "UIView+ITTAdditions.h"
#import "KBWebviewInfoModel.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "KKNavigationController.h"
#import "KBColor.h"
#import "KBWebviewFootAndCollectModel.h"
#import "KBWhetherReachableModel.h"
#import "KBInfoTableViewController.h"
#import "KBProgressHUD.h"
#import "KBWhetherLoginModel.h"
#import "KBMyCollectionViewController.h"
#import "KBPostParametersModel.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
//toolbar里控件的间隔
#define spaceInToolbar (kWindowSize.width - 150)/5
//手势开始
#define GESTURE_STATE_START 1
//手势移动
#define GESTURE_STATE_MOVE 2
//手势结束
#define GESTURE_STATE_END 3


@interface KBInfoWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>

{
    int  _gesState; //手势状态
    
    BOOL canHandleLong; //是否能都长按
    
    BOOL didScroll; //是否滚动
    
    KBWebviewInfoModel * webviewInfoModel; //webview的model
    
    KBLoginSingle * loginSingle;//单例
    
    KBCommonSingleValueModel *commonSingleValueModel;//传值单例
    
    NSString *webviewPageId;//当前页面的pageId
    
    KBMyCollectionDataModel *collection;//收藏对象
    
    sqlite3 *db;//db数据库
    
    KBInfoTableViewController *infoTableVC;//承载webview的controller
    //保存的图片,图片的感应位置
    float ptX;
    float ptY;
    NSString *imgURL; //保存图片的url
    
    NSTimer *timer;//长按保存图片的定时器
    
    AppDelegate * appDelegate;
    
}

/**
 *  返回按钮
 */
@property (nonatomic,strong) UIButton * backButton;

/**
 *  评论按钮
 */
@property (nonatomic,strong)UIButton * commentButton;

/**
 *  收藏按钮
 */
@property (nonatomic,strong) UIButton * collectButton;

/**
 *  分享按钮
 */
@property (nonatomic,strong) UIButton * shareButton;

/**
 *  设置按钮
 */
@property (nonatomic ,strong) UIButton * settingButton;
@end

@implementation KBInfoWebViewController
/**
 *  收藏执行的动作，
 */
integer_t actionType=-1;
//保存图片需要使用的Js
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


-(void)viewDidLoad
{
    [super viewDidLoad];
    //初始化webview的单例
    webviewInfoModel=[KBWebviewInfoModel newinstance];
    
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    //初始化
    canHandleLong=NO;
    didScroll=NO;
    //初始化用户的单例
    loginSingle=[KBLoginSingle newinstance];
    //设置view的背景色
    self.view.backgroundColor=[UIColor whiteColor];
    //隐藏导航栏
    self.navigationController.navigationBarHidden=YES;
    //隐藏导航栏的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    //设置webview的高度
    self.theWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    //调用combineWebAndDiscuss 将webview加入到InfoTableView里
    [self combineWebAndComment:self.theWebView.height];
    //设置delegate
    self.theWebView.delegate = self;
    //不能缩放
    self.theWebView.scalesPageToFit =NO;
    //取消弹性效果
    self.theWebView.scrollView.bounces = NO;
    //不可滚动
    self.theWebView.scrollView.scrollEnabled=NO;
    //webveiw的背景色
    self.theWebView.backgroundColor = [UIColor whiteColor];
    //显示右边的滚动条
    self.theWebView.scrollView.showsVerticalScrollIndicator = YES;
    //设置置顶为No
    self.theWebView.scrollView.scrollsToTop=NO;
    
    //调用js代码设置webview
    [self.theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"iosPageScript" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
    [self.theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"changeSrc" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
    //设置toolbar
    [self setToolBar];
    [self sendRequest];
    
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canHandlelong) name:@"CANLONGHANG" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didScroll) name:@"DidScrollCANLONGHANG" object:nil];
    
}
#pragma mark - 根据状态栏的高度，设置toolBar的高度
-(void)DidChangeStatusBarFrame
{
    
    if (commonSingleValueModel.isFinishLaunching) {
        
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            
            commonSingleValueModel.isFinishLaunching=NO;
            [_toolBar setFrame:CGRectMake(0,kWindowSize.height-70, kWindowSize.width, 50 )];
        }
        else
        {
            [_toolBar setFrame:CGRectMake(0,kWindowSize.height-50, kWindowSize.width, 50 )];
            
            commonSingleValueModel.isFinishLaunching=NO;
        }
    }
    else if(!commonSingleValueModel.isFinishLaunching)
    {
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            
            [_toolBar setFrame:CGRectMake(0,kWindowSize.height-70, kWindowSize.width, 50 )];
        }
        else
        {
            [_toolBar setFrame:CGRectMake(0,kWindowSize.height-50, kWindowSize.width, 50 )];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidChangeStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    //设置属性初值
    canHandleLong=NO;
    didScroll=NO;
    
    [self DidChangeStatusBarFrame];
    //隐藏导航栏
    self.navigationController.navigationBarHidden=YES;
    //禁止拖拽
    KKNavigationController *nav=(KKNavigationController *)self.navigationController;
    nav.canDragBack=NO;
    //状态栏恢复默认，即白底黑字
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //侧滑不可滚动
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    
}
#pragma  mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated{
    //设置属性初值
    canHandleLong=NO;
    didScroll=NO;
    
    [self DidChangeStatusBarFrame];
    //隐藏导航栏
    self.navigationController.navigationBarHidden=YES;
    //禁止拖拽
    KKNavigationController *nav=(KKNavigationController *)self.navigationController;
    nav.canDragBack=NO;
    //状态栏恢复默认，即白底黑字
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //侧滑不可滚动
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
}

#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    //侧滑可滚动
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    //置顶属性为No
    self.theWebView.scrollView.scrollsToTop=NO;
    //状态栏回复成黑底白字
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - 初始化toolbar 控件的状态
-(void)setToolBar
{
    
    //评论
    self.commentButton=[[UIButton alloc]initWithFrame:CGRectMake(30, 10, 25, 25)];
    [self.commentButton setImage:KReplyImage forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏
    self.collectButton=[[UIButton alloc]initWithFrame:CGRectMake(self.commentButton.right+40, 8, 25, 25)];
    webviewPageId=[NSString stringWithFormat:@"%ld",(long)webviewInfoModel.pageId];
    if (loginSingle.userCollect!=NULL) {
        if([loginSingle.userCollect rangeOfString:webviewPageId].location != NSNotFound)
        {
            actionType=0;
            [self.collectButton setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];}
        else{
            actionType=1;
            [self.collectButton setImage:[UIImage imageNamed:@"收藏空心"] forState:UIControlStateNormal];}
    }
    else{
        
        actionType=1;
        [self.collectButton setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
    }
    [self.collectButton addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    
    //分享
    self.shareButton=[[UIButton alloc]initWithFrame:CGRectMake(self.collectButton.right+40, 10, 25, 25)];
    [self.shareButton setImage:[UIImage imageNamed:@"分享白"]forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    //设置
    self.settingButton=[[UIButton alloc]initWithFrame:CGRectMake(self.shareButton.right+38, 10, 25, 25)];
    [self.settingButton setImage:[UIImage imageNamed:@"字号"] forState:UIControlStateNormal];
    [self.settingButton addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    //返回
    self.backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * backButtonImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 35, 20)];
    backButtonImageView.image=[UIImage imageNamed:@"正文返回"];
    [self.backButton addSubview:backButtonImageView];
    
    //toolbar
    
    self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,kWindowSize.height-50, kWindowSize.width, 50)];
    self.toolBar.translucent=NO;
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    UIBarButtonItem *commentItem=[[UIBarButtonItem alloc] initWithCustomView:self.commentButton];
    UIBarButtonItem *collectItem=[[UIBarButtonItem alloc] initWithCustomView:self.collectButton];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    UIBarButtonItem *settingItem=[[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    //控件之间的间隔
    UIBarButtonItem *flexItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];//固定宽度
    UIBarButtonItem *fixedItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    UIBarButtonItem *fixedItem1=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedItem.width=(kWindowSize.width-140)/5.0;
    fixedItem1.width=(kWindowSize.width-140)/10.0;//自定义宽度
    
    NSArray *itemsArray = [NSArray arrayWithObjects:backItem,fixedItem,fixedItem1,commentItem,flexItem,collectItem,flexItem,shareItem,flexItem,settingItem,nil];
    [self.toolBar setItems:itemsArray animated:YES];
    [self.view addSubview:self.toolBar];
    
}
#pragma  mark - 请求webveiw的内容
-(void)sendRequest
{
    NSString * originHTMLStr;
    //写缓存
    NSArray * cachepaths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachesDir=[cachepaths objectAtIndex:0];
    NSString  *cachefilename=[cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)webviewInfoModel.pageId]];
    //    [failLabel removeFromSuperview];
    //    [failButton removeFromSuperview];
    if(![KBWhetherReachableModel whetherReachable])
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
            [KBWebviewFootAndCollectModel deleteFooter];
            [KBWebviewFootAndCollectModel insertFootMaskSQL];
            KBLog(@"读取缓存成功");
        }
        else
            
        {
            //            [self showFail];
            self.theWebView.scrollView.scrollEnabled=NO;
            
        }
    }
    else{
        [KBHTTPTool getRequestWithUrlStr:webviewInfoModel.shareURL parameters:nil completionHandr:^(id responseObject) {
            [responseObject writeToFile:cachefilename atomically:YES];
        } error:^(NSError *error) {
            ;
        }];
        self.theWebView.scrollView.scrollEnabled=YES;
        
        NSURL *url =[[NSURL alloc] initWithString:webviewInfoModel.shareURL];
        NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
        [self.theWebView loadRequest:request];
        
        [KBWebviewFootAndCollectModel deleteFooter];
        [KBWebviewFootAndCollectModel insertFootMaskSQL];
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_READNUMBER" object:webviewPageId];
    }
    
}
#pragma mark - 将webview加入到InfoTableVC中
-(void)combineWebAndComment:(float)height{
    if (infoTableVC==nil) {
        //设置webview的frame
        self.theWebView.frame=CGRectMake(0, 0, self.theWebView.width, height) ;
        //设置InfoTableVC
        infoTableVC=[[KBInfoTableViewController alloc]init];
        [infoTableVC.view setFrame:CGRectMake(0, 0, infoTableVC.view.width, infoTableVC.view.height)];
        
        infoTableVC.parentDelegate=commonSingleValueModel.navcontrolDelegate;
        infoTableVC.pageId=webviewInfoModel.pageId;
        
        //调用infoTableVC的otherInfo,加载webview下的信息
        [infoTableVC webviewOtherInfo];
        //置顶为No
        infoTableVC.commentTableView.scrollsToTop=NO;
        self.theWebView.scrollView.scrollsToTop=NO;
        
        self.theWebView.scrollView.delegate=infoTableVC;
        self.theWebView.scrollView.tag=222;
        infoTableVC.webview=self.theWebView;
        
        [self.view addSubview:infoTableVC.view];
        [self addChildViewController:infoTableVC];
    }
}
#pragma mark - webview加载完成
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //在app中隐藏webveiw的下载条
    [webView stringByEvaluatingJavaScriptFromString:@"$(\"#download\").hide()"];
    //改变webview的字体
    [webView stringByEvaluatingJavaScriptFromString:@"Function()"];
    //保存图片需要的js
    [webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    
    if ([commonSingleValueModel.fontSizeStr isEqualToString:@"中号字体"])
    {
        
        [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.035em;font-size: 1.152em;\");"];
    }
    else if([commonSingleValueModel.fontSizeStr isEqualToString:@"小号字体"]){
        [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.05em;font-size: 1.0em;\");"];
    }
    else if ([commonSingleValueModel.fontSizeStr isEqualToString:@"大号字体"]){
        
        [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.65em;letter-spacing:-0.09em;font-size: 1.4em;\");"];
        
    }
}
#pragma mark - webview加载失败
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //[self showFail];
}
#pragma mark - 加载请求中处理保存图片
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
#pragma mark - 可滚动 不可长按
-(void)didScroll
{
    didScroll=YES;
    canHandleLong=NO;
}
#pragma mark- 可长按，不可滚动
-(void)canHandlelong
{
    canHandleLong=YES;
    didScroll=NO;
}
#pragma mark - 长按提示保存图片
-(void)handleLong{
    if (imgURL && _gesState == GESTURE_STATE_START&&canHandleLong&&!didScroll){
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        sheet.tag=666;
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
#pragma  mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    //判断是从一个正文的返回， 还是从多个的返回
    if (commonSingleValueModel.navCount) {
        self.navigationController.navigationBarHidden=YES;
        commonSingleValueModel.navCount--;
        
    }
    else
    {
        self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
    }
}
#pragma  mark - 弹出actionSheet 保存图片和字体的改变
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //保存图片
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
    //选择字体
    else {
        switch (buttonIndex) {
            case 0:
            {
                [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.05em;font-size: 1.0em;\");"];
                commonSingleValueModel.fontSizeStr=@"小号字体";
            }
                break;
            case 1:
            {
                //[self.theWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='100%'"];
                [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.55em;letter-spacing:-0.035em;font-size: 1.152em;\");"];
                commonSingleValueModel.fontSizeStr=@"中号字体";
            }
                break;
            case 2:{
                [self.theWebView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute(\"style\",\"line-height:1.65em;letter-spacing:-0.09em;font-size: 1.4em;\");"];
                commonSingleValueModel.fontSizeStr=@"大号字体";
                
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - 保存图片成功和失败的提示
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL){
        [KBProgressHUD setHud:self.view withText:@"保存失败" AndWith:0.375];
    }
    else{
        [KBProgressHUD setHud:self.view withText:@"保存成功" AndWith:0.375];
    }
}
#pragma mark - 友盟分享
-(void)share{
    
    if(![KBWhetherReachableModel whetherReachable])
    {
        [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:-0.375];
    }
    else
    {
        WBAuthorizeRequest * wbauthorizerequest;
        wbauthorizerequest.shouldShowWebViewForAuthIfCannotSSO=YES;
        
        [UMSocialConfig setTheme:UMSocialThemeBlack];
        [UMSocialWechatHandler setWXAppId:KYouMengWXCounter appSecret:KYouMengWXSecretCounter url:webviewInfoModel.shareURL];
        
        //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
        [UMSocialQQHandler setQQWithAppId:KYouMengQQCounter appKey:KYouMengQQSecretCounter url:webviewInfoModel.shareURL];
        
        
        //隐藏
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
        
        //设置分享完成时“发送完成”或者分享错误等提示
        // [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionBottom];
        
        [UMSocialConfig setShareGridViewTheme:^(CGContextRef ref, UIImageView *backgroundView,UILabel *label){
            //改变背景颜色
            backgroundView.backgroundColor = [UIColor whiteColor];
            //改变文字标题的文字颜色
            label.textColor = KColor_102;
            
        }];
        
        
        
        
        NSArray * shareArray=[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToRenren,UMShareToSina, nil];
        
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:KYouMengCounterTest
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
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"12312312"}];
}
#pragma mark - 分享成功的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shareClose" object:nil];
    [self navigationBarHidden];
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
        //得到分享到的微博平台名
        [KBHTTPTool getRequestWithUrlStr:KWebviewShareSuccessUrl(kBaseUrl, webviewInfoModel.pageId) parameters:nil completionHandr:^(id responseObject)
         {
             NSString* doTransmitResult=responseObject[@"doTransmitResult"];
             int intdoReadResult=[doTransmitResult intValue];
             if (intdoReadResult==1)
             {
                 [KBProgressHUD setHud:self.view withText:@"分享成功" AndWith:0.375];
             }
         } error:^(NSError *error) {
             
         }];
    }
    
}
#pragma  mark - 隐藏导航栏
-(void)navigationBarHidden
{
    self.navigationController.navigationBarHidden=YES;
}
#pragma mark - actionSheet提示字体选择
-(void)setting{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"设置字体" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小号字体",@"中号字体",@"大号字体", nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark - 评论
-(void)comment{

    if ([KBWhetherLoginModel userWhetherLogin]) {
        self.toolBar.hidden=YES;
    }
    else
    {
        [KBProgressHUD setHud:self.view withText:@"请先登录再评论" AndWith:0.375];
        
    }
}
#pragma mark - 收藏
-(void)collect
{
    if (![KBWhetherLoginModel userWhetherLogin]) {
        {
            if(actionType==1)
            {
                //避免多次收藏
                [KBWebviewFootAndCollectModel deleteHavecollect];
                
                
                if ([KBWebviewFootAndCollectModel insertCollect]) {
                    actionType=0;
                    [self.collectButton setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
                    [KBProgressHUD setHud:self.view withText:@"收藏成功" AndWith:0.375];
                    [loginSingle.userCollect appendString:[NSString stringWithFormat: @"%ld,",(long)webviewInfoModel.pageId ]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_NUMBER" object:nil];
                    
                }
                else
                    [KBProgressHUD setHud:self.view withText:@"收藏失败" AndWith:0.375];
            }
            else{
                if ([KBWebviewFootAndCollectModel deleteCollect]) {
                    actionType=1;
                    [self.collectButton setImage:[UIImage imageNamed:@"收藏空心"] forState:UIControlStateNormal];
                    [KBProgressHUD setHud:self.view withText:@"取消收藏" AndWith:0.375];
                    loginSingle.userCollect=[NSMutableString stringWithString:   [loginSingle.userCollect stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%ld,",(long)webviewInfoModel.pageId] withString:@""]];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_NUMBER" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_COLLECT" object:nil];
                    
                }
                else
                    [KBProgressHUD setHud:self.view withText:@"取消收藏失败" AndWith:0.375];
            }
        }
    }
    //服务器收藏
    else
    {
        if(![KBWhetherReachableModel whetherReachable])
        {
            [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:-0.375];
        }
        else
        {
            
            if (actionType==1) {
                actionType=0;
                [self.collectButton setImage:[UIImage imageNamed:@"收藏实心"] forState:UIControlStateNormal];
                [KBProgressHUD setHud:self.view withText:@"收藏成功" AndWith:0.375];
                [loginSingle.userCollect appendString:[NSString stringWithFormat:@"%@,",webviewPageId]];
            }
            else
            {
                if(actionType==0)
                {
                    
                    loginSingle.userCollect=[NSMutableString stringWithString:   [loginSingle.userCollect stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",webviewPageId] withString:@""]];
                    [self.collectButton setImage:[UIImage imageNamed:@"收藏空心"] forState:UIControlStateNormal];
                    [KBProgressHUD setHud:self.view withText:@"取消收藏" AndWith:0.375];
                    KBMyCollectionViewController * newCollectionVC=[[KBMyCollectionViewController alloc]init];
                    
                    [newCollectionVC CancelCollect:_cancelCollectIndexPath];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_COLLECT" object:nil];
                    
                    actionType=1;
                    
                }
            }


            [KBHTTPTool postRequestWithUrlStr:KWebviewCollectUrl(kBaseUrl) parameters:[KBPostParametersModel setCollectParameters:webviewInfoModel.pageId withActionType:actionType==0?1:0] completionHandr:^(id responseObject) {
                NSString *collectResult=responseObject [@"collectResult"];
                int intcollectResult=[collectResult intValue];
                KBLog(@"intcollectResult:%d",intcollectResult);
                if(intcollectResult==1)
                {
                    
                }
            } error:^(NSError *error) {
                KBLog(@"收藏error:%@",error);
                [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:-0.375];
            }];
        }
    }
}
@end
