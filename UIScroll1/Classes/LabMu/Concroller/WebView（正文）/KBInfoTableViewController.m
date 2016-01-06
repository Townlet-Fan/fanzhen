//
//  HotTableVC.m
//  UIScroll1
//
//  Created by eddie on 15-4-19.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBInfoTableViewController.h"
#import "KBCommonSingleValueModel.h"
#import "KBLoginSingle.h"
#import "KBWebViewFeedBackView.h"
#import "KBWebViewBottomView.h"
#import "KBInfoWebViewController.h"
#import "WeiboSDK.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "MobClick.h"
#import "KBMyFooterViewController.h"
#import "KBProgressHUD.h"
#import "KBWebViewReferenceView.h"
#import "KBTwoSortModel.h"
#import "KBThreeSortModel.h"
#import "KBReplyViewController.h"
#import "KBMyCollectionViewController.h"
#import "GifView.h"
#import "KBWebviewInfoModel.h"
#import "KBConstant.h"
#import "KBHTTPTool.h"
#import "KBWhetherLoginModel.h"
#import "KBWebviewOtherInfoModel.h"
#import "KBWhetherReachableModel.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
#import "KBDefineGifView.h"
#import "KBWebViewCommentCell.h"
#import "YYWebImage.h"
#import "KBHomeArticleModel.h"
#import "KBPostParametersModel.h"
#import "KBCommentModel.h"
#import "KBBaseNavigationController.h"
//距离上边
#define HEIGHT_MARGIN 20
//距离左边
#define WIDTH_MARGIN 20
//头像的高度
#define HEAD_WIDTH 50
//button的高度
#define BTN_HEIGHT_INCELL 20
//webview可滚动的标志tag
#define WEBSCROLL 222
//下面的评论的标志tag
#define HOTTABLE  223

@interface KBInfoTableViewController ()
{
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    KBLoginSingle * loginSingle;//用户的单例
   
    CGRect textViewOriginRect;//textview的原始尺寸
    
    CGRect toolBarRect;//toolbar的原始尺寸
    
    NSInteger pageNumber;//请求分页的page
    
    KBWebViewBottomView * viewUnderWeb;//webview下面的View
    
    KBDefineGifView * defineGifView;//加载动画

    BOOL isTextViewShow; //是否显示textview
 
    //正文下面的数据
    NSString * praNum; //好文的点赞数
    
    NSString * criNum; //水文的点赞数
    
    int  userChoice; //用户是否点过赞
    
    NSString * adPicurl; //广告位的picturl
    
    NSString * adLink;  //广告位的链接
    
    NSString * isSubscri;//是否订阅该文章所属的三级分类
    
    NSArray * recomArray;//相关推荐的文章的数组
    
    NSString * comNum;//评论的数目
    
    BOOL isAddToTopButton;// 是否加入了置顶的button
    
    UIButton * toTopButton; //置顶的button
    
    UIWindow * statusWindow; // 新定义的状态的UIWindow
    
    UIButton *publishBtn; // 评论的button
    
    int countDrag;//拖拽的滑动的次数
    
    UIView  *titleView; //相关推荐文章的外层view
    
    UIButton * titleBtn1;//相关推荐文章第一个
    
    UIButton *titleBtn2;//相关推荐文章第二个
    
    UIButton * titleBtn3;//相关推荐文章第三个
    
    BOOL isSubscription; //是否订阅
    
    NSMutableArray * interestallTypeArray; //已经订阅的全部分类的数组
    
    NSMutableArray * interestNoallTypeArray;
    
    NSMutableArray * allTypeArray;//所有分类的数组
   
    int intesterItemNumber;// 订阅三级分类 所对应的一级分类的ItemNUmber;
    
    int discussNum;//评论数
    
    BOOL isFirstDrag; //是否第一次拖拽滑动
    
    NSIndexPath * discussSelectedIndex;//评论点击进入到回复的indexPath
   
    GifView * showGifView;//Gif动画
    
    KBWebviewOtherInfoModel * webViewOtherInfoModel;//正文下面的其他信息
    
    KBWebviewInfoModel * webviewInfoModel;//正文的信息Model
    
    BOOL islast;//加载是否到最后
    
    UILabel *loadMoreText;//加载更多的提示文字
    
    UIActivityIndicatorView *tableFooterActivityIndicator;//风火轮

    
}
@end

@implementation KBInfoTableViewController


float cell_1_height;
#pragma mark - viewDidLoad
-(void)viewDidLoad {
    [super viewDidLoad];
    //设置view的背景色
    self.view.backgroundColor=[UIColor whiteColor];
    //初始化单例
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    webviewInfoModel=[KBWebviewInfoModel newinstance];
    webViewOtherInfoModel=[KBWebviewOtherInfoModel shareInstance];
    //初始化
    pageNumber=2;
    cell_1_height = 540;
    
    _commentArray=[[NSMutableArray alloc]init];
    
    viewUnderWeb=[[KBWebViewBottomView alloc]init];
    //设置反馈的点击方法
    [viewUnderWeb.feedBackBtn addTarget:self action:@selector(changeFeedBackView:) forControlEvents:UIControlEventTouchUpInside];
    //设置微信分享的点击方法
    [viewUnderWeb.wxShareBtn addTarget:self action:@selector(WechatTimelineShare) forControlEvents:UIControlEventTouchUpInside];
    //设置新浪分享的点击方法
    [viewUnderWeb.sinaShareBtn addTarget:self action:@selector(sinaShare) forControlEvents:UIControlEventTouchUpInside];
    //设置QQ空间分享的点击方法
    [viewUnderWeb.qZoneShareBtn addTarget:self action:@selector(qqZoneShare) forControlEvents:UIControlEventTouchUpInside];

    //加入webview的toolbar
    KBInfoWebViewController *webviewInfo=(KBInfoWebViewController  *)self.parentViewController;
    [self.view addSubview:webviewInfo.toolBar];
    
    //重定义的UIWindow
    [self statusWindow];
    //评论的toolbar
    [self setToolBar];
    //隐藏导航栏
    self.navigationController.navigationBarHidden=YES;
    //隐藏返回按钮
    [self.navigationItem setHidesBackButton:YES];
    
    //初始化UItableview
    _commentTableView=[[UITableView alloc]init];
    
    _commentTableView.dataSource=self;
    _commentTableView.delegate=self;
    _commentTableView.scrollsToTop=NO;
    _commentTableView.bounces=NO;
    _commentTableView.tag=HOTTABLE;
    _commentTableView.backgroundColor=[UIColor whiteColor];
    //tableFootView
    [self addTableFooterView];

    //webview不置顶属性为No
    self.webview.scrollView.scrollsToTop=NO;
    //webview可滚动
    self.webview.scrollView.scrollEnabled=YES;
    //状态栏变化检测
    [self DidChangeStatusBarFrame];

    //分享结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareClose) name:@"shareClose" object:nil];
    //成功加载 动画结束 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeloadingIndicator) name:@"loadingSuccess" object:nil];
    //加载动画
    if(![KBWhetherReachableModel whetherReachable])
    {
        [self showGifView];
    }
    //加入加载动画的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddloadingIndicator) name:@"AddLoadingIndicator" object:nil];
    
    
}
#pragma  mark - 重定义UIWindow
-(void)statusWindow
{
    //重定义UiWindow 用于置顶用
    statusWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [statusWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    [statusWindow setBackgroundColor:[UIColor clearColor]];
    //置顶的button
    toTopButton=[[UIButton alloc]initWithFrame:CGRectMake(0,0, kWindowSize.width,20)];
    toTopButton.tag=1;
    toTopButton.backgroundColor=[UIColor clearColor];
    
    [statusWindow addSubview:toTopButton];
    
    [statusWindow makeKeyAndVisible];
}
#pragma mark - tableFooterView
-(void)addTableFooterView
{
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.commentTableView.width, 40.0f)];
    tableFooterView.backgroundColor=KColor_235;
    loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.commentTableView.width, 40.0f)];
    loadMoreText.backgroundColor=KColor_235;
    loadMoreText.textAlignment=NSTextAlignmentCenter;
    [loadMoreText setCenter:tableFooterView.center];
    [tableFooterView addSubview:loadMoreText];
    self.commentTableView.tableFooterView = loadMoreText;
    
    if(![KBWhetherReachableModel whetherReachable])
    {
        self.commentTableView.scrollEnabled=NO;
    }
    else
    {
        if (_commentArray.count==0)
        {
            loadMoreText.text=@"没有更多评论了";
        }
        self.commentTableView.scrollEnabled=YES;
    }

    tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.commentTableView.bounds.size.width/2.0-70, 10.0f, 20.0f, 20.0f)];
    [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.commentTableView.tableFooterView addSubview:tableFooterActivityIndicator];

}
#pragma mark - 加载动画
-(void)addGifView
{
    defineGifView=[[KBDefineGifView alloc]initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.height) withStartTop:-50];
    [self.view addSubview:defineGifView];
}
#pragma mark - 显示动画
-(void)showGifView
{
    
    [self addGifView];
}
#pragma  mark - 初始化toolbar工具栏
-(void)setToolBar
{
    //初始化toolbar
    _toolBar=[[UIView alloc]initWithFrame:CGRectMake(0,kWindowSize.height-50,self.view.width,50) ];
    _toolBar.layer.masksToBounds=YES;
    
    _toolBar.backgroundColor=KColor_223_224_226;
    _toolBar.layer.borderColor=KColor_235.CGColor;
    _toolBar.layer.borderWidth=1;
    
    //初始化textview
    textViewOriginRect=CGRectMake(10, 10, self.view.width*0.8-10, 30);
    _textView=[[UITextView alloc]initWithFrame:textViewOriginRect];
    _textView.bounces=NO;
    _textView.delegate=self;
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    _textView.layer.borderWidth=1;
    [_textView setBackgroundColor:[UIColor whiteColor]];
    _textView.layer.borderColor=KColor_235.CGColor;
    _textView.layer.cornerRadius=5;
    _textView.font=[UIFont systemFontOfSize:15];
    //    textView.layer.cornerRadius=8;
    
    //初始化默认字和默认label
    _placeHolderStr=@"说点什么吧...";
    _placeHolderLable=[[UILabel alloc]init];
    _placeHolderLable.text=_placeHolderStr;
    _placeHolderLable.numberOfLines=1;
    [_placeHolderLable setTextColor:[UIColor grayColor]];
    CGSize placeHolderSize=[_placeHolderLable sizeThatFits:CGSizeMake(_textView.width, _textView.height-10)];
    [_placeHolderLable setFrame:CGRectMake(5, 5, _textView.width, placeHolderSize.height)];
    [_textView addSubview:_placeHolderLable];
    
    //初始化评论的button
    publishBtn=[[UIButton alloc] initWithFrame:CGRectMake(0.8*self.view.width+10, 10, 0.2*self.view.width-20, 30)];
    [publishBtn setBackgroundColor:KColor_15_86_192];
    [publishBtn setTitle:@"评论" forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishComment) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:publishBtn];
    [_toolBar addSubview:_textView];
    
    [self.view addSubview: _toolBar];
}
#pragma mark - 评论选中的IndexPath 进入到回复中去得
-(void)discussSelectedIndex:(NSIndexPath *)selectedIndex
{
    discussSelectedIndex=selectedIndex;
    // NSLog(@"selectedIndex:%ld",(long)selectedIndex.row);
}
#pragma mark - 恢复评论的数组
-(void)discussArray:(NSMutableArray *)discussArr
{
    _commentArray=discussArr;
    
}
#pragma mark - 刷新的回复数
-(void)refreshReplyCount:(int)replynum
{
    
    NSMutableDictionary *dis=_commentArray[discussSelectedIndex.row-2];
    // NSLog(@"dis:%@",dis);
    [dis setObject:[NSNumber numberWithInt:replynum] forKey:@"replyNum"];
    [_commentTableView reloadData];
    //[hotTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    //
}
#pragma mark - 加入加载动画
-(void)AddloadingIndicator
{
    [self webviewOtherInfo];
    [self.view addSubview:self.commentTableView];
    [self.view addSubview:_toolBar];
}
#pragma mark - 移除加载动画
-(void)removeloadingIndicator
{
    
    [showGifView removeFromSuperview];
    [self.view addSubview:self.commentTableView];
    [self.view addSubview:_toolBar];
}
#pragma mark - 分享结束 接收到得通知方法
-(void)shareClose
{
    //左侧不可滑动
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    [statusWindow removeFromSuperview];
    [statusWindow resignKeyWindow];
    [self statusWindow];
    //状态栏默认,黑字白底
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    [self statusWindow];
    //状态栏的高度的变化
    if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
    {
        [_commentTableView setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height-30)];
    }
    else
    {
        [_commentTableView  setFrame:CGRectMake(0, -20,self.view.frame.size.width, self.view.frame.size.height-30)];
    }
    //view不可手势滑动
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=NO;
    self.navigationController.navigationBarHidden=YES;
    //监听键盘的升降
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyDown:) name:UIKeyboardWillHideNotification object:nil];
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [_commentTableView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    //是否从三级分类进入正文
    if (commonSingleValueModel.isThreeEnterTitle) {
        self.navigationController.navigationBarHidden=YES;
        
    }
    //是否点击了订阅
    if (commonSingleValueModel.istouchDownInterest) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"FOCUS_UPDATE_%d",intesterItemNumber+1] object:nil];
    }
    //左侧可滑动
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    _commentTableView.scrollsToTop=NO;
    //statusWindow 移除和注销 级别降低
    [self removeStatusWindow];
    
    
}
#pragma mark - 视图出现
-(void)viewDidAppear:(BOOL)animated
{
    
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];

    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //是否从三级分类进入正文
    if (commonSingleValueModel.isThreeEnterTitle) {
        self.navigationController.navigationBarHidden=YES;
        
    }
    
    //[navigationBar setHidden:YES];
}
#pragma mark - 视图消失
-(void)viewDidDisappear:(BOOL)animated
{   //是否从三级分类进入正文
    if (commonSingleValueModel.isThreeEnterTitle) {
        self.navigationController.navigationBarHidden=YES;
    }
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    _commentTableView.scrollsToTop=NO;
    //statusWindow 移除和注销 级别降低
    [self removeStatusWindow];
    
}
#pragma mark - statusWindow 移除和注销 级别降低 是为了退出正文时候，外面的状态栏，
-(void)removeStatusWindow
{
    [toTopButton removeFromSuperview];
    [statusWindow setWindowLevel:UIWindowLevelStatusBar-950];
    [statusWindow removeFromSuperview];
    [statusWindow resignKeyWindow];
}
#pragma mark - scrollview滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当滚动scrollView.contentOffset.y大于一定值是状态栏覆盖上一层背景色白，这个值为正文上面大图的高度的
    if (scrollView.contentOffset.y>(kWindowSize.width*9/16+60))
    {
        [self AddToTopButton];
        //判断是否已经覆盖过一层背景白色了，就不再覆盖了
        if (!isAddToTopButton) {
            toTopButton.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:statusWindow];
        }
        
    }
    //当是webview滚动的时候，并且scrollView.contentOffset.y在正文上方的大图就把背景白色变为透明
    else
    {
        if(scrollView.tag==WEBSCROLL)
        {
            toTopButton.backgroundColor=[UIColor clearColor];
        }
        
    }
    //当是webview滚动的时候
    if(scrollView.tag==WEBSCROLL)
    {
        //置顶的button只有置顶到webview得顶部的方法
        [toTopButton removeTarget:self action:@selector(toTopHot:) forControlEvents:UIControlEventTouchUpInside];
        [toTopButton addTarget:self action:@selector(toTopWeb:) forControlEvents:UIControlEventTouchUpInside];
  
        //当滚动到scrollView.contentSize.height-1时，将要向下滚动，webview不可滚动，下面的评论可滚动
        if (scrollView.contentOffset.y+scrollView.frame.size.height>scrollView.contentSize.height-1)
        {
            scrollView.scrollEnabled=NO;
            self.commentTableView.scrollEnabled=YES;
            [toTopButton removeTarget:self action:@selector(toTopWeb:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        //发送通知，滚动的时候不促发长按手势
        else
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DidScrollCANLONGHANG" object:nil];
    }
    //当是下面的评论滚动时
    else if (scrollView.tag==HOTTABLE)
    {
        //置顶的button只有置顶到webview得底部的方法
        [toTopButton removeTarget:self action:@selector(toTopWeb:) forControlEvents:UIControlEventTouchUpInside];
        [toTopButton addTarget:self action:@selector(toTopHot:) forControlEvents:UIControlEventTouchUpInside];
        //当滚动到webview得底部时候，将要上滚的时候，webview可滚动，下面的评论不可滚动
        if (scrollView.contentOffset.y<=-20)
        {
            
            scrollView.scrollEnabled=NO;
            self.webview.scrollView.scrollEnabled=YES;
            [toTopButton removeTarget:self action:@selector(toTopHot:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}
#pragma mark - 同didScroll的方法，再次在写是为了让webview滑动底部时候，能够拖拽结束的时候顺畅的滑动下去或者上去
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(scrollView.tag==WEBSCROLL)
    {
        if (scrollView.contentOffset.y+scrollView.frame.size.height>scrollView.contentSize.height-1)
        {
            
            scrollView.scrollEnabled=NO;
            self.commentTableView.scrollEnabled=YES;
            
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CANLONGHANG" object:nil];
    }
    else if (scrollView.tag==HOTTABLE)
    {
        if (scrollView.contentOffset.y<=-20)
        {
            scrollView.scrollEnabled=NO;
            self.webview.scrollView.scrollEnabled=YES;
            [toTopButton removeTarget:self action:@selector(toTopHot:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}
#pragma mark -将要开始滑图时候，textview回到原来的位置
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([publishBtn.titleLabel.text isEqualToString:@"评论"]) {
        //当textview是第一响应者的时候
        if ([_textView isFirstResponder])
        {
            //设拖拽变量为1
            countDrag=1;
            //取消textview的第一响应 出现在底部
            [_textView resignFirstResponder];
            //当textview的输入长度为0，就恢复成最初的状态 并隐藏
            if (_textView.text.length==0)
            {
                
                _placeHolderStr=@"说点什么吧...";
                _placeHolderLable.text=_placeHolderStr;
                KBInfoWebViewController  *titleVC=(KBInfoWebViewController  *)self.parentViewController;
                titleVC.toolBar.hidden=NO;
                
                
            }
            //当textview的输入长度不为0的时候
            else if(_textView.text.length!=0)
            {
                //拖拽了一次，再次拖拽隐藏
               if (countDrag==1)
                {
                    KBInfoWebViewController  *titleVC=(KBInfoWebViewController  *)self.parentViewController;
                    titleVC.toolBar.hidden=YES;
                    //根据状态栏的高度设置toolbar的frame
                    if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
                    {
                        //NSLog(@"440404040");
                        [_toolBar setFrame:CGRectMake(0, kWindowSize.height-toolBarRect.size.height-20, self.view.width , toolBarRect.size.height+20)];
                    }
                    else
                    {
                        //NSLog(@"22222202020202020");
                        [_toolBar setFrame:CGRectMake(0,kWindowSize.height-toolBarRect.size.height, self.view.width , toolBarRect.size.height)];
                    }
                    
                    //toolBar.hidden=YES;
                }
            }
            
        }
        //当textview不是第一响应的时候，直接隐藏
        else if (![_textView isFirstResponder])
        {
            
            _textView.text=@"";
            _placeHolderStr=@"说点什么吧...";
            _placeHolderLable.text=_placeHolderStr;
           
            [_textView setFrame:textViewOriginRect];
            [publishBtn setFrame:CGRectMake(0.8*self.view.frame.size.width+10, 10, 0.2*self.view.frame.size.width-20, 30)];
            {
                if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
                {
                    [_toolBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, self.view.frame.size.width , 50)];
                }
                else
                {
                    
                    [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, self.view.frame.size.width , 50)];
                }
                
            }
            
            
            KBInfoWebViewController  *titleVC=(KBInfoWebViewController  *)self.parentViewController;
            titleVC.toolBar.hidden=NO;
            
        }
    }
    else
    {
        
        if ([_textView isFirstResponder])
        {
            countDrag=1;
            [_textView resignFirstResponder];
            if (_textView.text.length==0)
            {
                
                _placeHolderStr=@"输入回复内容...";
                _placeHolderLable.text=_placeHolderStr;
                KBInfoWebViewController  *titleVC=(KBInfoWebViewController  *)self.parentViewController;
                titleVC.toolBar.hidden=NO;
                [publishBtn setTitle:@"评论" forState:UIControlStateNormal];
                
                
            }
            
            
            else if(_textView.text.length!=0)
            {
              if (countDrag==1)
                {
                    KBInfoWebViewController *titleVC=(KBInfoWebViewController *)self.parentViewController;
                    titleVC.toolBar.hidden=YES;
                    
                    if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
                    {
                        //NSLog(@"440404040");
                        [_toolBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-toolBarRect.size.height-20, self.view.frame.size.width , toolBarRect.size.height+20)];
                    }
                    else
                    {
                        //NSLog(@"22222202020202020");
                        [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-toolBarRect.size.height, self.view.frame.size.width , toolBarRect.size.height)];
                    }
                    
                    //toolBar.hidden=YES;
                }
                
                
            }
            
        }
        else if (![_textView isFirstResponder])
        {
            
            _textView.text=@"";
            _placeHolderStr=@"输入回复内容...";
            _placeHolderLable.text=_placeHolderStr;
            //[toolBar setFrame:CGRectMake(0,self.view.frame.size.height-50,self.view.frame.size.width,50) ];
            [_textView setFrame:textViewOriginRect];
            [publishBtn setFrame:CGRectMake(0.8*self.view.frame.size.width+10, 10, 0.2*self.view.frame.size.width-20, 30)];
            {
                if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
                {
                    // NSLog(@"440404040");
                    [_toolBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, self.view.frame.size.width , 50)];
                }
                else
                {
                    //NSLog(@"22222202020202020");
                    [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, self.view.frame.size.width , 50)];
                }
                
            }
            
            
            KBInfoWebViewController  *titleVC=(KBInfoWebViewController  *)self.parentViewController;
            titleVC.toolBar.hidden=NO;
            [publishBtn setTitle:@"评论" forState:UIControlStateNormal];
            
        }
        
    }
    //当是反馈的textfield是第一响应者的时候
    if([viewUnderWeb.feedBackView.textField isFirstResponder])
    {
        [viewUnderWeb.feedBackView.textField resignFirstResponder];
        
    }
    if ([viewUnderWeb.feedBackView.textField1 isFirstResponder]){
        [viewUnderWeb.feedBackView.textField1 resignFirstResponder];
    }
}
#pragma mark - tableView heightForRow
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return  kWindowSize.height;
    }
    else if (indexPath.row==1)
    {
        return cell_1_height;
    }
    
    {
        KBCommentModel * commentModel=_commentArray[indexPath.row-2];
        UILabel *commentLabel=[[UILabel alloc]init];
        commentLabel.text=commentModel.comContent;
        commentLabel.numberOfLines=0;
        CGSize cellSize=[commentLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-2*WIDTH_MARGIN-HEAD_WIDTH-10, 500)];
        if(cellSize.height>(HEAD_WIDTH))
        {
            return cellSize.height+2*HEIGHT_MARGIN+BTN_HEIGHT_INCELL;
        }
        else{
            return HEAD_WIDTH+2*HEIGHT_MARGIN+BTN_HEIGHT_INCELL;
        }
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count+2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //webview
    if (indexPath.row==0) {
        UITableViewCell *cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.webview.frame.size.width, self.webview.scrollView.contentSize.height)];
        [cell addSubview:_webview];
        cell.selectionStyle=  UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    //相关推荐之类的
    if (indexPath.row==1) {
        
        UITableViewCell *cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.webview.frame.size.width, 540)];
        [cell.contentView addSubview:viewUnderWeb.view];
        cell.selectionStyle=  UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    //评论
    KBWebViewCommentCell *commentCell;
    static NSString *hotDiscussCellIdentifier = @"commentCell";
    commentCell = [tableView dequeueReusableCellWithIdentifier:hotDiscussCellIdentifier];
    
    if (commentCell==nil)
    {
        commentCell = [[KBWebViewCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotDiscussCellIdentifier];
    }
    [commentCell setCommentCellWithModel:_commentArray[indexPath.row]];
    commentCell.selectionStyle=UITableViewCellSelectionStyleGray;
    return commentCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=2) {
        
        KBWebViewCommentCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
        NSMutableDictionary *dis=[_commentArray objectAtIndex:indexPath.row-2];
        
        KBReplyViewController * replyVC=[[KBReplyViewController alloc]init];
        replyVC.discussTextL=[dis objectForKey:@"comContent"];
        replyVC.commentId=[[dis objectForKey:@"commentId"]intValue];
        replyVC.discussSelectedIndex=indexPath;
        replyVC.discuss_reply_Array=_commentArray;
        [self.parentDelegate pushViewController:replyVC animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag!=1)
        
        if (indexPath.row==_commentArray.count-1)
        {
            if(![KBWhetherReachableModel whetherReachable])
            {
                //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(promote) userInfo:nil repeats:NO];
            }
            else
            {
                if (!tableFooterActivityIndicator.isAnimating)
                {
                    [tableFooterActivityIndicator startAnimating];
                }
                loadMoreText.text=@"正在加载...";
                
//                [self performSelector:@selector(loadDataing) withObject:nil afterDelay:0.3];
            }
        }
}
#pragma mark - 请求正文下面的信息
-(void)webviewOtherInfo
{
    int userId;
    if ([KBWhetherLoginModel userWhetherLogin]) {
        userId=(int)loginSingle.userID;
    }
    else
        userId=-1;
    
    [KBHTTPTool getRequestWithUrlStr:KWebviewOtherInfoUrl(kBaseUrl,userId,webviewInfoModel.pageId) parameters:nil completionHandr:^(id responseObject) {
        [webViewOtherInfoModel setDataWithDictionary:responseObject];
        praNum=webViewOtherInfoModel.praNum;
        criNum=webViewOtherInfoModel.criNum;
        userChoice=[webViewOtherInfoModel.userChoice intValue];
        NSLog(@"userChoice:%d",userChoice);
        adPicurl=webViewOtherInfoModel.adPicurl;
        adLink=webViewOtherInfoModel.adLink;
        isSubscri=webViewOtherInfoModel.isSubscri;
        recomArray=webViewOtherInfoModel.recomArray;
        comNum=webViewOtherInfoModel.comNum;
        _commentArray=webViewOtherInfoModel.commentArray;
        [self viewUnderWeb];
        
    } error:^(NSError *error) {
        ;
    }];
}
#pragma mark - 初始化 第二行的cell
-(void)viewUnderWeb
{
    //已经点击了好文
    if (userChoice ==1) {
        //好文的button
        [viewUnderWeb.thumUpBtn setTitle:[NSString stringWithFormat:@"好文 %@",praNum] forState:UIControlStateNormal];
        [viewUnderWeb.thumUpBtn setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
        viewUnderWeb.thumUpBtn.layer.borderColor=KColor_15_86_192.CGColor;
        [viewUnderWeb.thumUpBtn addTarget:self action:@selector(thumUp) forControlEvents:UIControlEventTouchUpInside];
        //水文的button
        [viewUnderWeb.footDownBtn setTitle:[NSString stringWithFormat:@"水文 %@",criNum] forState:UIControlStateNormal];
        [viewUnderWeb.footDownBtn setTitleColor:KColor_102  forState:UIControlStateNormal];
        viewUnderWeb.footDownBtn.layer.borderColor=KColor_102.CGColor;
    }
    //已经点击了水文
    else if (userChoice==0)
    {
        //好文
        [viewUnderWeb.thumUpBtn setTitle:[NSString stringWithFormat:@"好文 %@",praNum] forState:UIControlStateNormal];
        [viewUnderWeb.thumUpBtn setTitleColor:KColor_102  forState:UIControlStateNormal];
        viewUnderWeb.thumUpBtn.layer.borderColor=KColor_102.CGColor;
        [viewUnderWeb.thumUpBtn addTarget:self action:@selector(thumUp) forControlEvents:UIControlEventTouchUpInside];
        //水文
        [viewUnderWeb.footDownBtn setTitle:[NSString stringWithFormat:@"水文 %@",criNum] forState:UIControlStateNormal];
        [viewUnderWeb.footDownBtn setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
        viewUnderWeb.footDownBtn.layer.borderColor=KColor_15_86_192.CGColor;
        [viewUnderWeb.footDownBtn addTarget:self action:@selector(footDown) forControlEvents:UIControlEventTouchUpInside];
    }
    //都没点击
    else if (userChoice==-1)
    {
        //好文
        [viewUnderWeb.thumUpBtn setTitle:[NSString stringWithFormat:@"好文 %@",praNum] forState:UIControlStateNormal];
        
        [viewUnderWeb.thumUpBtn setTitleColor:KColor_102  forState:UIControlStateNormal];
        viewUnderWeb.thumUpBtn.layer.borderColor=KColor_102.CGColor;
        [viewUnderWeb.thumUpBtn addTarget:self action:@selector(thumUp) forControlEvents:UIControlEventTouchUpInside];
        
        //水文
        [viewUnderWeb.footDownBtn setTitle:[NSString stringWithFormat:@"水文 %@",criNum] forState:UIControlStateNormal];
        [viewUnderWeb.footDownBtn setTitleColor:KColor_102  forState:UIControlStateNormal];
        viewUnderWeb.footDownBtn.layer.borderColor=KColor_102.CGColor;
        [viewUnderWeb.footDownBtn addTarget:self action:@selector(footDown) forControlEvents:UIControlEventTouchUpInside];
    }
    //
    if ([KBWebviewInfoModel newinstance].isHomeTypeClass) {
        
        CGRect typeViewFrame = viewUnderWeb.referenceView.typeThreeView.frame;
        [viewUnderWeb.referenceView.typeThreeView removeFromSuperview];
        
        //暂时使用随机数获取条数
        //        number = arc4random()%5 + 1;
        NSLog(@"**********%lu*******",(unsigned long)recomArray.count);
        if (recomArray.count == 0) {
            CGRect labelFrame = viewUnderWeb.referenceView.recommendLabel.frame;
            [viewUnderWeb.referenceView.recommendLabel removeFromSuperview];
            [viewUnderWeb.referenceView.recommendView removeFromSuperview];
            viewUnderWeb.referenceView.commentCountLabel.frame = CGRectMake(labelFrame.origin.x+10, labelFrame.origin.y, viewUnderWeb.referenceView.advertView.frame.size.width, 20);
        } else {
            viewUnderWeb.referenceView.recommendView.frame = CGRectMake(typeViewFrame.origin.x, typeViewFrame.origin.y, viewUnderWeb.referenceView.frame.size.width, 50 + 51 * (recomArray.count - 1));
            
            viewUnderWeb.referenceView.commentCountLabel.frame = CGRectMake(viewUnderWeb.referenceView.recommendView.left+10, viewUnderWeb.referenceView.recommendView.bottom+10, viewUnderWeb.referenceView.recommendView.width, 20);
        }
        
    }
    else {
        
        //暂时使用随机数获取条数
        //        number = arc4random()%5 + 1;
        //        NSLog(@"!!!!!!!!**********%d*******",number);
        if (recomArray.count == 0) {
            CGRect titleViewFrame = viewUnderWeb.referenceView.recommendView.frame;
            [viewUnderWeb.referenceView.recommendView removeFromSuperview];
            
            viewUnderWeb.referenceView.commentCountLabel.frame = CGRectMake(titleViewFrame.origin.x+10, titleViewFrame.origin.y, viewUnderWeb.referenceView.typeThreeButton.width, 20);
        }
        else {
            viewUnderWeb.referenceView.recommendView.frame = CGRectMake(viewUnderWeb.referenceView.recommendView.left, viewUnderWeb.referenceView.recommendView.top, viewUnderWeb.referenceView.width, 50 + 51 * (recomArray.count - 1));
            
            viewUnderWeb.referenceView.commentCountLabel.frame = CGRectMake(viewUnderWeb.referenceView.recommendView.left+10, viewUnderWeb.referenceView.recommendView.bottom+10, viewUnderWeb.referenceView.recommendView.width, 20);
        }
        [viewUnderWeb.referenceView.advertView yy_setImageWithURL:[NSURL URLWithString:adPicurl] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        }];
        viewUnderWeb.referenceView.typeThreeImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[KBWebviewInfoModel newinstance].classString]];
        viewUnderWeb.referenceView.typeThreeLable.text=[KBWebviewInfoModel newinstance].classString;
        interestallTypeArray=loginSingle.userInterestStructArray;
        interestNoallTypeArray=loginSingle.userInterestNoStructArray;
        allTypeArray=loginSingle.userAllTypeArray;
        if (loginSingle.isLogined) {
            
            if([isSubscri intValue])
                [viewUnderWeb.referenceView.subscriptionButton setTitle:@"已订阅" forState:UIControlStateNormal];
            else
            {
                [viewUnderWeb.referenceView.subscriptionButton setTitle:@"+订阅" forState:UIControlStateNormal];
                [viewUnderWeb.referenceView.subscriptionButton addTarget:self action:@selector(addInterest) forControlEvents:UIControlEventTouchDown];
            }
        }
        else
        {
            
            int i;
            for (i=0; i<4; i++) {
                NSArray *typeOneArray=[interestNoallTypeArray objectAtIndex:i];
                for (int j=0; j<typeOneArray.count; j++) {
                    KBThreeSortModel *find_3=[typeOneArray objectAtIndex:j];
                    if ([find_3.name isEqualToString:webviewInfoModel.classString]) {
                        if (find_3.isIntrest) {
                            isSubscription=YES;
                            [viewUnderWeb.referenceView.subscriptionButton setTitle:@"已订阅" forState:UIControlStateNormal];
                            break;
                        }
                        
                    }
                }
                if (isSubscription) {
                    break;
                }
            }
            if (i==4)
            {
                isSubscription=NO;
                [viewUnderWeb.referenceView.subscriptionButton setTitle:@"+订阅" forState:UIControlStateNormal];
                [viewUnderWeb.referenceView.subscriptionButton addTarget:self action:@selector(addInterest) forControlEvents:UIControlEventTouchDown];
            }
        }
    }
    for (int i = 0; i < recomArray.count; i++) {
        
        UIButton *titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 51 * i, viewUnderWeb.referenceView.recommendView.frame.size.width-20, 50)];
        
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        titleBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentLeft;
        titleBtn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        titleBtn.tag = i;
        KBHomeArticleModel * articleModel=recomArray [i];
        NSString *str =articleModel.firstTitle;
        
        [titleBtn setTitle:str forState:UIControlStateNormal];
        
        titleBtn.titleLabel.numberOfLines = 1;
        [titleBtn addTarget:self action:@selector(pushPage:) forControlEvents:UIControlEventTouchDown];
        
        [viewUnderWeb.referenceView.recommendView addSubview:titleBtn];
        
        if (i == recomArray.count - 1||recomArray.count == 1) {
            break;
        }
        
        UIView * horizon=[[UIView alloc]initWithFrame:CGRectMake(titleBtn.left,titleBtn.bottom, viewUnderWeb.referenceView.recommendView.width-10, 1)];
        horizon.backgroundColor=KColor_191;
        [viewUnderWeb.referenceView.recommendView addSubview:horizon];
    }
    
    viewUnderWeb.feedBackView.feedBackLabel.text=webviewInfoModel.classString;
    [viewUnderWeb.feedBackView.feedBackButton addTarget:self action:@selector(pageFeed) forControlEvents:UIControlEventTouchUpInside];
    
    
    viewUnderWeb.referenceView.commentCountLabel.text=[NSString stringWithFormat:@"评论(%@)",comNum];
    cell_1_height = viewUnderWeb.referenceView.commentCountLabel.frame.origin.y + viewUnderWeb.referenceView.commentCountLabel.frame.size.height+ viewUnderWeb.qZoneShareBtn.frame.origin.y + viewUnderWeb.qZoneShareBtn.frame.size.height + 30;//+ viewUnderWeb.referenceView.frame.origin.y - viewUnderWeb.qZoneShareBtn.frame.size.height - viewUnderWeb.qZoneShareBtn.frame.origin.y;
    //NSLog(@"cell_1_height:%f",cell_1_height);
    [viewUnderWeb.referenceView setFrame:CGRectMake(10, viewUnderWeb.feedBackView.frame.origin.y, kWindowSize.width-18, viewUnderWeb.referenceView.commentCountLabel.frame.origin.y + viewUnderWeb.referenceView.commentCountLabel.frame.size.height)];
    [viewUnderWeb.view setFrame:CGRectMake(0, 0,kWindowSize.width, cell_1_height)];
    
    // [viewUnderWeb.view setBackgroundColor:[UIColor redColor]];
    [self.commentTableView reloadData];
    
}
#pragma mark - 点击正文的反馈
-(void)changeFeedBackView:(UIButton *)btn{
    
    self.isFeedBackShow=!self.isFeedBackShow;
    btn.userInteractionEnabled=NO;
    if (self.isFeedBackShow) {
        [UIView animateWithDuration:0.5 animations:^{
            viewUnderWeb.view.frame=CGRectMake(viewUnderWeb.view.frame.origin.x, viewUnderWeb.view.frame.origin.y,viewUnderWeb.view.frame.size.width ,800 );
            [viewUnderWeb.referenceView setFrame:CGRectMake(viewUnderWeb.referenceView.frame.origin.x, viewUnderWeb.referenceView.frame.origin.y+viewUnderWeb.feedBackView.frame.size.height+10, viewUnderWeb.referenceView.frame.size.width, viewUnderWeb.referenceView.frame.size.height)];
            [viewUnderWeb.feedBackBtn setBackgroundImage:[UIImage imageNamed:@"反馈01"] forState:UIControlStateNormal];
        }completion:^(BOOL isfinished){
            btn.userInteractionEnabled=YES;
            
        }];
        cell_1_height = cell_1_height + 210;
        [self.commentTableView reloadData];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            viewUnderWeb.view.frame=CGRectMake(viewUnderWeb.view.frame.origin.x, viewUnderWeb.view.frame.origin.y,viewUnderWeb.view.frame.size.width ,600 );
            [viewUnderWeb.referenceView setFrame:CGRectMake(viewUnderWeb.referenceView.frame.origin.x, viewUnderWeb.referenceView.frame.origin.y-viewUnderWeb.feedBackView.frame.size.height-10, viewUnderWeb.referenceView.frame.size.width, viewUnderWeb.referenceView.frame.size.height)];
            [viewUnderWeb.feedBackBtn setBackgroundImage:[UIImage imageNamed:@"正文反馈"] forState:UIControlStateNormal];
            
        }completion:^(BOOL isfinished){
            btn.userInteractionEnabled=YES;
            cell_1_height = cell_1_height - 210;
            [self.commentTableView reloadData];
        }];
        
    }
    
}

#pragma mark - 点击好文的方法
-(void)thumUp
{
    NSLog(@"好文");
    if (userChoice==0) {
        [KBProgressHUD setHud:self.view withText:@"您已经点击过水文了" AndWith:0.375];
    }
    else if (userChoice==1)
    {
        [KBProgressHUD setHud:self.view withText:@"您已经点击过好文了" AndWith:0.375];
        
    }
    else if(userChoice==-1) {
        NSInteger userId;
        if ([KBWhetherLoginModel userWhetherLogin]) {
            userId=loginSingle.userID;
        }
        else
            userId=-1;
        [KBHTTPTool postRequestWithUrlStr:KWebviewThumbUpWebUrl(kBaseUrl,userId ,webviewInfoModel.pageId) parameters:nil completionHandr:^(id responseObject) {
            NSString* pageContentCommentResult=responseObject [@"pageContentCommentResult"];
            int intpageContentCommentResult=[pageContentCommentResult intValue];
            if (intpageContentCommentResult==1) {
                
                NSLog(@"好文成功");
                [viewUnderWeb.thumUpBtn setTitle:[NSString stringWithFormat:@"好文 %d",[praNum intValue]+1] forState:UIControlStateNormal];
                [viewUnderWeb.thumUpBtn setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
                viewUnderWeb.thumUpBtn.layer.borderColor=KColor_15_86_192.CGColor;
                viewUnderWeb.thumUpBtn.layer.cornerRadius=5;
                viewUnderWeb.thumUpBtn.layer.borderWidth=1;
                userChoice=1;
            }
            else
                NSLog(@"好文失败");
        } error:^(NSError *error) {
            [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
        }];
        
    }
    
}
#pragma mark - 点击水文的方法
-(void)footDown
{   NSLog(@"水文");
    if (userChoice==1) {
        [KBProgressHUD setHud:self.view withText:@"您已经点击过好文了" AndWith:0.375];
    }
    else if (userChoice==0) {
        [KBProgressHUD setHud:self.view withText:@"您已经点击过水文了" AndWith:0.375];
        
    }
    
    else if(userChoice==-1){
        
        NSInteger userId;
        if ([KBWhetherLoginModel userWhetherLogin]) {
            userId=loginSingle.userID;
        }
        else
            userId=-1;
        [KBHTTPTool postRequestWithUrlStr:KWebviewFootDownWebUrl(kBaseUrl,userId ,webviewInfoModel.pageId) parameters:nil completionHandr:^(id responseObject) {
            NSString* pageContentCommentResult=responseObject [@"pageContentCommentResult"];
            int intpageContentCommentResult=[pageContentCommentResult intValue];
            if (intpageContentCommentResult==1) {
                
                NSLog(@"水文成功");
                [viewUnderWeb.footDownBtn setTitle:[NSString stringWithFormat:@"水文 %d",[criNum intValue]+1] forState:UIControlStateNormal];
                [viewUnderWeb.footDownBtn setTitleColor:KColor_15_86_192 forState:UIControlStateNormal];
                viewUnderWeb.footDownBtn.layer.borderColor=KColor_15_86_192.CGColor;
                viewUnderWeb.footDownBtn.layer.cornerRadius=5;
                viewUnderWeb.footDownBtn.layer.borderWidth=1;
                userChoice=0;
                
            }
            else
                NSLog(@"水文失败");
        } error:^(NSError *error) {
            [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
        }];
    }
}
#pragma mark - 正文反馈
-(void)pageFeed
{
    if ([viewUnderWeb.feedBackView.textField isFirstResponder]) {
        [viewUnderWeb.feedBackView.textField resignFirstResponder];
    }
    else if ([viewUnderWeb.feedBackView.textField1 isFirstResponder]) {
        [viewUnderWeb.feedBackView.textField1 resignFirstResponder];
    }
    NSInteger userId;
    if ([KBWhetherLoginModel userWhetherLogin]) {
        userId=loginSingle.userID;
    }
    else
        userId=-1;
    NSDictionary * pageFeedBackDict=[KBPostParametersModel setFeedBackWebParameters:userId withTextField:viewUnderWeb.feedBackView.textField.text withTextField1:viewUnderWeb.feedBackView.textField1.text];
    NSLog(@"pageFeedBackDict:%@",pageFeedBackDict);
    if(viewUnderWeb.feedBackView.textField.text.length!=0||viewUnderWeb.feedBackView.textField1.text.length!=0)
    {
        [KBHTTPTool postRequestWithUrlStr:KWebviewFeedBackWebUrl(kBaseUrl) parameters:pageFeedBackDict completionHandr:^(id responseObject) {
            NSString* postComInPageResult=responseObject [@"postComInPageResult"];
            NSLog(@"postComInPageResult:%@",postComInPageResult);
            int intpostComInPageResult=[postComInPageResult intValue];
            if (intpostComInPageResult==1) {
                
                    NSLog(@"反馈成功");
                [KBProgressHUD setHud:self.view withText:@"反馈成功" AndWith:0.375];
                viewUnderWeb.feedBackView.textField.text=@"";
                viewUnderWeb.feedBackView.textField1.text=@"";
            }
            else
                
            {
                //             NSLog(@"反馈失败");
                [KBProgressHUD setHud:self.view withText:@"反馈失败" AndWith:0.375];
                
            }
            
        } error:^(NSError *error) {
            [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
        }];
    }
    else
    {
        [KBProgressHUD setHud:self.view withText:@"请填写反馈内容" AndWith:0.375];
    }

}
#pragma mark - 订阅三级分类
-(void)addInterest
{
    if (![KBWhetherReachableModel whetherReachable]) {
        [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
    }
    else
    {
        isSubscription=NO;
        commonSingleValueModel.istouchDownInterest=YES;
        if ([KBWhetherLoginModel userWhetherLogin])
        {
              [KBHTTPTool postRequestWithUrlStr:[KWebviewSubscriptionUrl(kBaseUrl,loginSingle.userID, webviewInfoModel.secondType, webviewInfoModel.classString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil completionHandr:^(id responseObject) {
                NSString * subscriResultstr= responseObject[@"subscriResult"];
                NSLog(@"[jsondic valueForKey:]:%@",responseObject[@"subscriResult"]);
                if ([subscriResultstr intValue]==1) {
                    NSLog(@"订阅成功");
                    int i;
                    for (i=0; i<4; i++) {
                        NSArray *typeOneArray=[allTypeArray objectAtIndex:i];
                        NSMutableArray *typeOneInterestNo=[interestNoallTypeArray objectAtIndex:i];
                        //NSLog(@"typeOne;%lu",(unsigned long)typeOneInterestNo.count);
                        NSMutableArray *typeOneInterest=[interestallTypeArray objectAtIndex:i];
                        for (int j=0; j<typeOneArray.count; j++) {
                            KBTwoSortModel *find_2=[typeOneArray objectAtIndex:j];
                            
                            KBTwoSortModel *find2Interest=[typeOneInterest objectAtIndex:j];
                            
                            for (int k=0; k<find_2.subArray.count; k++) {
                                KBThreeSortModel *find_3=[find_2.subArray objectAtIndex:k];
                                
                                
                                if ([find_3.name isEqualToString:webviewInfoModel.classString]) {
                                    //                    NSLog(@"1111find_3.isIntrest:%d",find_3.isIntrest);
                                    find_3.isIntrest=YES;
                                    isSubscription=YES;
                                    [typeOneInterestNo addObject:find_3];
                                    [find2Interest.subArray addObject:find_3];                                        [viewUnderWeb.referenceView.subscriptionButton setTitle:@"已订阅" forState:UIControlStateNormal];
                                    [viewUnderWeb.referenceView.subscriptionButton removeTarget:self action:@selector(addInterest) forControlEvents:UIControlEventTouchDown];
                                    {
                                        
                                        intesterItemNumber=i;
                                    }
                                    
                                    break;
                                    
                                }
                            }
                            if (isSubscription) {
                                
                                break;
                            }
                            
                        }
                        if (isSubscription) {
                            
                            break;
                        }
                    }
                    
                }
                else
                {
                    NSLog(@"订阅失败");
                    isSubscription=NO;
                }
                
                
            }
              error:^(NSError *error)
            {
                [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
            }];
        }
        else
        {
            int i;
            for (i=0; i<4; i++) {
                NSArray *typeOneArray=[allTypeArray objectAtIndex:i];
                NSMutableArray *typeOneInterestNo=[interestNoallTypeArray objectAtIndex:i];
                //NSLog(@"typeOne;%lu",(unsigned long)typeOneInterestNo.count);
                NSMutableArray *typeOneInterest=[interestallTypeArray objectAtIndex:i];
                for (int j=0; j<typeOneArray.count; j++) {
                    KBTwoSortModel *find_2=[typeOneArray objectAtIndex:j];
                    
                    KBTwoSortModel *find2Interest=[typeOneInterest objectAtIndex:j];
                    
                    for (int k=0; k<find_2.subArray.count; k++) {
                        KBThreeSortModel *find_3=[find_2.subArray objectAtIndex:k];
                        if ([find_3.name isEqualToString:webviewInfoModel.classString]) {
                            //                    NSLog(@"1111find_3.isIntrest:%d",find_3.isIntrest);
                            //                            NSLog(@"find3.name;%@",find_3.name);
                            //                            NSLog(@"self;%@",self.thirdTypeName);
                            find_3.isIntrest=YES;
                            isSubscription=YES;
                            [typeOneInterestNo addObject:find_3];
                            [find2Interest.subArray addObject:find_3];
                            [viewUnderWeb.referenceView.subscriptionButton setTitle:@"已订阅" forState:UIControlStateNormal];
                            [viewUnderWeb.referenceView.subscriptionButton removeTarget:self action:@selector(addInterest) forControlEvents:UIControlEventTouchDown];
                            {
                                intesterItemNumber=i;
                            }
                            
                            break;
                            
                        }
                    }
                    if (isSubscription) {
                        
                        break;
                    }
                }
                
                if (isSubscription) {
                    
                    break;
                }
                
            }

        }
        
        
        
        
    }
    
    
}
#pragma mark - 点击推荐的文章的方法
 -(void)pushPage:(UIButton *)Button
 {
     webviewInfoModel.readWebViewInfoCount++;
     KBHomeArticleModel * articleModel=recomArray[Button.tag];
     [webviewInfoModel setWebviewInfoArticleModel:articleModel];
     KBInfoWebViewController *titleVC=[[KBInfoWebViewController alloc]init];
     titleVC.navdelegate=self.parentDelegate;
     [(UINavigationController *)self.parentDelegate pushViewController:titleVC animated:YES];
 }

#pragma mark - QQ空间分享
-(void)qqZoneShare{
    [self navigationBarHidden];
    if( [QQApiInterface isQQInstalled])
    {
        //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
        [UMSocialQQHandler setQQWithAppId:KYouMengQQCounter appKey:KYouMengQQSecretCounter url:[KBWebviewInfoModel newinstance].shareURL];
        
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQzone]];
        [UMSocialConfig setTheme:UMSocialThemeBlack];
        [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionBottom];
        [UMSocialConfig setShareGridViewTheme:^(CGContextRef ref, UIImageView *backgroundView,UILabel *label){
            //改变背景颜色
            backgroundView.backgroundColor = [UIColor whiteColor];
            //改变文字标题的文字颜色
            label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            
        }];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            [KBWebviewInfoModel newinstance].imagestr];
        
        [UMSocialData defaultData].extConfig.qzoneData.url =[KBWebviewInfoModel newinstance].shareURL;
        [UMSocialData defaultData].extConfig.qzoneData.title = [KBWebviewInfoModel newinstance].textString;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"新鲜·新潮·心意—跬步为你每日精选"  image:[KBWebviewInfoModel newinstance].imageData location:nil urlResource:urlResource  presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [KBProgressHUD setHud:self.view withText:@"分享成功" AndWith:0.375];
            }
        }];
        
        [MobClick event:@"Qzone"];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您未安装QZone客户端" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    }
}
#pragma mark - 微信朋友圈分享
-(void)WechatTimelineShare{
    
    [self navigationBarHidden];
    [UMSocialWechatHandler setWXAppId:KYouMengWXCounter appSecret:KYouMengWXSecretCounter url:[KBWebviewInfoModel newinstance].shareURL];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatTimeline]];
    [UMSocialConfig setTheme:UMSocialThemeBlack];
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionBottom];
    [UMSocialConfig setShareGridViewTheme:^(CGContextRef ref, UIImageView *backgroundView,UILabel *label){
        //改变背景颜色
        backgroundView.backgroundColor = [UIColor whiteColor];
        //改变文字标题的文字颜色
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        
    }];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        [KBWebviewInfoModel newinstance].imagestr];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [KBWebviewInfoModel newinstance].shareURL;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [KBWebviewInfoModel newinstance].textString;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"" image:[KBWebviewInfoModel newinstance].imageData location:nil urlResource:urlResource  presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
             [KBProgressHUD setHud:self.view withText:@"分享成功" AndWith:0.375];
            
            //[UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionTop];
        }
    }];
    [MobClick event:@"weixin"];
}
#pragma mark - 新浪微博的分享
-(void)sinaShare{
    
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    super.navigationController.navigationBarHidden=YES;
    [UMSocialConfig setTheme:UMSocialThemeBlack];
    [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"[%@]详情请见:%@",[KBWebviewInfoModel newinstance].textString,[KBWebviewInfoModel newinstance].shareURL] shareImage:[KBWebviewInfoModel newinstance].imageData socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
   
    [MobClick event:@"weibo"];
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"12312312"}];
    
}
#pragma mark - 分享的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shareClose" object:nil];
    //[self navigationBarHeidden];
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {

        //得到分享到的微博平台名
        [KBHTTPTool getRequestWithUrlStr:KWebviewShareSuccessUrl(kBaseUrl, [KBWebviewInfoModel newinstance].pageId) parameters:nil completionHandr:^(id responseObject)
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
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView1{
    
    if (_textView.text.length==0) {
        if ([publishBtn.titleLabel.text isEqualToString:@"评论"]) {
            _placeHolderLable.text=@"说点什么吧...";
        }
        else
            _placeHolderLable.text=@"输入回复内容...";
    }
    else
    {
        _placeHolderLable.text=@"";
        CGRect frame = _textView.frame;
        
        frame.size.height = _textView.contentSize.height;
        if (frame.size.height>_textView.frame.size.height&&frame.size.height<60) {
            CGRect oldFrame=_textView.frame;
            [_textView setFrame:CGRectMake(_textView.frame.origin.x
                                          ,_textView.frame.origin.y, _textView.frame.size.width, frame.size.height)];
            [_toolBar setFrame:CGRectMake(_toolBar.frame.origin.x, _toolBar.frame.origin.y-frame.size.height+oldFrame.size.height, _toolBar.frame.size.width, _toolBar.frame.size.height+frame.size.height-oldFrame.size.height)];
            [publishBtn setFrame:CGRectMake(publishBtn.frame.origin.x, _toolBar.frame.size.height-42, publishBtn.frame.size.width, publishBtn.frame.size.height)];
            
        }
        else if(frame.size.height<_textView.frame.size.height)
        {
            CGRect oldFrame=_textView.frame;
            [_textView setFrame:CGRectMake(_textView.frame.origin.x
                                          ,_textView.frame.origin.y, _textView.frame.size.width, frame.size.height)];
            [_toolBar setFrame:CGRectMake(_toolBar.frame.origin.x, _toolBar.frame.origin.y-frame.size.height+oldFrame.size.height, _toolBar.frame.size.width, _toolBar.frame.size.height+frame.size.height-oldFrame.size.height)];
            [publishBtn setFrame:CGRectMake(publishBtn.frame.origin.x, _toolBar.frame.size.height-42, publishBtn.frame.size.width, publishBtn.frame.size.height)];
        }
        toolBarRect=_toolBar.frame;
    }
    
}
#pragma mark - notification
-(void)keyUp:(NSNotification *)notification{
    if ([_textView isFirstResponder]) {
        
        NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect;
        [keyboardObject getValue:&keyboardRect];
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [UIView setAnimationDelegate:self];
        if ([_textView.text isEqualToString:@""]) {
            {
                if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
                {
                    [_toolBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -keyboardRect.size.height-70, self.view.frame.size.width , 50)];
                }
                else
                {
                    [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height -keyboardRect.size.height-50, self.view.frame.size.width , 50)];
                }
                
            }
            
        }
        else
        {
            [_toolBar setFrame:toolBarRect];
            
        }
        
        
        [UIView commitAnimations];
        isTextViewShow=YES;
        
    }
    if ([viewUnderWeb.feedBackView.textField isFirstResponder]||[viewUnderWeb.feedBackView.textField1 isFirstResponder])
    {
        [self.commentTableView setContentOffset:CGPointMake(0, self.webview.frame.size.height) animated:YES];
    }
    
}
-(void)keyDown:(NSNotification *)notification{
    
    if ([_textView isFirstResponder]||isTextViewShow)
    {
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [UIView setAnimationDelegate:self];
        
        if ([_textView.text isEqualToString:@""]) {
            [_textView setFrame:textViewOriginRect];
            {
                if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
                {
                    // NSLog(@"440404040");
                    [_toolBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, self.view.frame.size.width , 50)];
                }
                else
                {
                    //  NSLog(@"22222202020202020");
                    [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, self.view.frame.size.width , 50)];
                }
                
            }
            
        }
        else{
            [_toolBar setFrame:CGRectMake(0,  self.view.frame.size.height-toolBarRect.size.height, toolBarRect.size.width, toolBarRect.size.height)];
        }
        isTextViewShow=NO;
        [UIView commitAnimations];
    }
}
#pragma mark -promote
-(void)promote
{
    loadMoreText.text=@"请检查网络设置";
    [tableFooterActivityIndicator stopAnimating];
}
#pragma mark - 置顶方法
- (void)toTopWeb:(BOOL)animated {
    [self.webview.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}
-(void)toTopHot:(BOOL)animated
{
    [self.commentTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - 判断置顶button是否已经加入
-(void)AddToTopButton
{
    isAddToTopButton=NO;
    for(id tmpView in self.view.subviews)
    {
        //找到要删除的子视图的对象
        if([tmpView isKindOfClass:[UIButton class]])
        {
            UIButton * promptbutton = (UIButton *)tmpView;
            if(promptbutton.tag == 1)   //判断是否满足自己要删除的子视图的条件
            {
                NSLog(@"判断是否满足自己要删除的子视图的条件");
                isAddToTopButton=YES;
                //删除子视图
                
                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
            }
        }
    }
    
}
#pragma mark - 导航栏隐藏
-(void)navigationBarHidden
{
    self.navigationController.navigationBarHidden=YES;
}
#pragma mark - 状态栏高度的改变
-(void)DidChangeStatusBarFrame
{
    if (commonSingleValueModel.isFinishLaunching) {
        
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            [self.commentTableView setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height-30)];
            commonSingleValueModel.isFinishLaunching=NO;
            [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-70, [UIScreen mainScreen].bounds.size.width, 50 )];
        }
        else
        {
            
            [self.commentTableView setFrame:CGRectMake(0, -20,self.view.frame.size.width, self.view.frame.size.height-30)];
            [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50 )];
            
            commonSingleValueModel.isFinishLaunching=NO;
         
            
        }
    }
    else if(!commonSingleValueModel.isFinishLaunching)
    {
        if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
        {
            //NSLog(@"440404040");
            [self.commentTableView setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height-30)];
            [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-70, [UIScreen mainScreen].bounds.size.width, 50 )];
        }
        else
        {
            //NSLog(@"22222202020202020");
            [self.commentTableView setFrame:CGRectMake(0, -20,self.view.frame.size.width, self.view.frame.size.height-30)];
            [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50 )];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidChangeStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
}

#pragma mark - 回复 (外面点击回复废弃了)
-(void)reply:(KBThumpButton *)Button
{
    if (loginSingle.isLogined) {
        KBInfoWebViewController  *webviewInfoVC=(KBInfoWebViewController  *)self.parentViewController;
        webviewInfoVC.toolBar.hidden=YES;
        _textView.text=@"";
        _placeHolderStr=@"输入回复内容...";
        _placeHolderLable.text=_placeHolderStr;
        NSMutableDictionary *dis=[_commentArray objectAtIndex:Button.indexPath.row-2];
        _commentId=[[dis objectForKey:@"commentId"]intValue];
        
        [publishBtn setTitle:@"回复" forState:UIControlStateNormal];
    }
    else
    {
        [KBProgressHUD setHud:self.view withText:@"请先登录再回复" AndWith:0.375];
    }
}
#pragma marl - 点赞评论
-(void)thumUpDiscuss:(KBThumpButton *)btn{
    if ([KBWhetherLoginModel userWhetherLogin]) {
        KBCommentModel * commentModel=_commentArray[btn.indexPath.row-2];
        //还没点赞
        if (![commentModel.hasPraised intValue]) {
            NSDate* datestr = [NSDate date];
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"hh:mm  MM-dd"];
           
            NSString * replyDate=[formatter stringFromDate:datestr];
            //post参数
           NSDictionary *  commentString = [KBPostParametersModel setThumbUpCommentParameters:1 withCommentId:[commentModel.commentId integerValue] withSendId:loginSingle.userID withReceiverId: [commentModel.receiverId integerValue] withDate:replyDate];
            //请求
            [KBHTTPTool postRequestWithUrlStr:KWebviewThumbUpUrl(kBaseUrl) parameters:commentString completionHandr:^(id responseObject) {
                NSLog(@"responseObject:%@",responseObject);
                NSString* commentOK=responseObject[@"commentOK"];
                int intcommentOK = [commentOK intValue];
                //NSLog(@"intcommentOK:%d",intcommentOK);
                if (intcommentOK==1) {
                    [KBProgressHUD setHud:self.view withText:@"点赞成功" AndWith:0.375];
                    NSIndexPath * indexpath=[NSIndexPath indexPathForItem:btn.indexPath.row inSection:0];
                    NSArray *indexArray=[NSArray arrayWithObject:indexpath];
                    KBWebViewCommentCell * cell=(KBWebViewCommentCell *)[self.commentTableView cellForRowAtIndexPath:(indexpath)];
                    cell.thumbUp.count=cell.thumbUp.count+1;
                    commentModel.praiseNum =[NSString stringWithFormat:@"%d",cell.thumbUp.count];
                    commentModel.hasPraised=[NSString stringWithFormat:@"%d",1];
                    
                    [self.commentTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                }

            } error:^(NSError *error) {
                KBLog(@"error:%@",error);
                [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
            }];
            
        }
        //取消点赞
        else
        {
            
            NSDate* datestr = [NSDate date];
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"hh:mm  MM-dd"];
            
            NSString * replyDate=[formatter stringFromDate:datestr];
            //post参数
            NSDictionary *  commentString = [KBPostParametersModel setThumbUpCommentParameters:1 withCommentId:[commentModel.commentId integerValue] withSendId:loginSingle.userID withReceiverId: [commentModel.receiverId integerValue] withDate:replyDate];
            //请求
            [KBHTTPTool postRequestWithUrlStr:KWebviewThumbUpUrl(kBaseUrl) parameters:commentString completionHandr:^(id responseObject) {
                NSLog(@"responseObject:%@",responseObject);
                NSString* commentOK=responseObject[@"commentOK"];
                int intcommentOK = [commentOK intValue];
                //NSLog(@"intcommentOK:%d",intcommentOK);
                if (intcommentOK==1) {
                    [KBProgressHUD setHud:self.view withText:@"取消成功" AndWith:0.375];
                    NSIndexPath * indexpath=[NSIndexPath indexPathForItem:btn.indexPath.row inSection:0];
                    NSArray *indexArray=[NSArray arrayWithObject:indexpath];
                    KBWebViewCommentCell * cell=(KBWebViewCommentCell *)[self.commentTableView cellForRowAtIndexPath:(indexpath)];
                    cell.thumbUp.count=cell.thumbUp.count-1;
                    commentModel.praiseNum =[NSString stringWithFormat:@"%d",cell.thumbUp.count];
                    commentModel.hasPraised=[NSString stringWithFormat:@"%d",0];
                    
                    [self.commentTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                }
                
            } error:^(NSError *error) {
                KBLog(@"error:%@",error);
                [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
            }];
        }
    }
    else
    {
         [KBProgressHUD setHud:self.view withText:@"请先登录再点赞" AndWith:0.375];
    }
    
}
#pragma mark -发表评论前进行的判断
-(void)publishComment
{
    if ([publishBtn.titleLabel.text isEqualToString:@"评论"]) {
        if (_textView.text.length!=0)
        {
            if([KBWhetherLoginModel userWhetherLogin]){
                
                [self commentRequest];
                
            }
        }
        else
        {
            
            [KBProgressHUD setHud:self.view withText:@"评论不能为空" AndWith:0.375];
        }
    }
    else
    {
        if (_textView.text.length!=0)
        {
            if([KBWhetherLoginModel userWhetherLogin]){
                
                //[self replyRequest];
                
            }
        }
        else
        {
            
            [KBProgressHUD setHud:self.view withText:@"回复不能为空" AndWith:0.375];
        }
    }
}
#pragma mark - 评论请求
-(void)commentRequest
{
    NSString * publish=[NSString stringWithFormat:@"%@", _textView.text];
    publish=[publish stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"publish:%@",publish);
    //    NSData *nsdata = [publish
    //                      dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    // Get NSString from NSData object in Base64
    //    publish = [nsdata base64EncodedStringWithOptions:0];
    NSDate* datestr = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm  MM-dd"];
    NSString * commentDate=[formatter stringFromDate:datestr];
    
    if(publish != nil && publish.length > 0)
    {
       
        NSDictionary *  commentString=[KBPostParametersModel setCommentParameters:webviewInfoModel.pageId  withSendId:loginSingle.userID withdate:commentDate withComment:publish];
        [KBHTTPTool postRequestWithUrlStr:KWebviewCommentUrl(kBaseUrl) parameters:commentString completionHandr:^(id responseObject) {
            NSLog(@"responseObject:%@",responseObject);
            NSString* commentOK=responseObject[@"commentOK"];
            int intcommentOK = [commentOK intValue];
            if (intcommentOK==1) {
                {
                    _placeHolderStr=@"说点什么吧...";
                    _placeHolderLable.text=_placeHolderStr;
                    _textView.text=@"";
                    [_textView resignFirstResponder];
                    NSMutableDictionary *commendDic=[[NSMutableDictionary alloc]init];
                    [commendDic setObject:loginSingle.userPhoto forKey:@"userPhoto"];
                    [commendDic setObject:[NSNumber numberWithInteger: loginSingle.userID] forKey:@"commentId"];
                    [commendDic setObject:loginSingle.userName forKey:@"userName"];
                    [commendDic setObject:publish forKey:@"comContent"];
                    [commendDic setObject:@"0" forKey:@"praiseNum"];
                    [commendDic setObject:@"0" forKey:@"replyNum"];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"hh:mm  MM-dd"];
                    [commendDic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"date"];
                    discussNum=discussNum+1;
                    viewUnderWeb.referenceView.commentCountLabel.text=[NSString stringWithFormat:@"评论(%d)",discussNum];
                    [KBCommentModel commentModelWithDictionary:commendDic];
                     KBCommentModel * commentModel=[[KBCommentModel alloc]init];
                    [_commentArray insertObject:commentModel atIndex:0];
                    //   NSLog(@"%d",discussArray.count);
                    
                    [self.commentTableView reloadData];
                    
                    [KBProgressHUD setHud:self.view withText:@"评论成功" AndWith:0.375];
                }
            }

        } error:^(NSError *error) {
            KBLog(@"error:%@",error);
            [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
        }];
                // 获取服务器响应失败时激发的代码块
    }
}
/*
-(void)replyRequest
{
    NSString * publish=[NSString stringWithFormat:@"%@", textView.text];
    
    //    NSData* data = [publish dataUsingEncoding: NSUTF8StringEncoding];
    //
    //    publish=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    publish=[publish stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDate* datestr = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm  MM-dd"];
    NSString * replyDate=[formatter stringFromDate:datestr];
    //NSLog (@"commentid:%ld",(long)commentId);
    if(publish != nil && publish.length > 0)
    {
        NSString * commentString1 = [NSString stringWithFormat:@"{\"pageId\":\"%ld\",\"senderId\":\"%ld\",\"toComId\":\"%ld\",\"date\":\"%@\",\"comment\":\"%@\"}",(long)transport.mainpageid,(long)loginsingle.userID,(long)commentId,replyDate,publish];
        // 使用NSDictionary封装请求参数
        
        NSDictionary *  commentString = @{@"commentString":commentString1};
        NSString *replyUrl = [NSString stringWithFormat:@"%@/kuibuversion1/page/addComment",transport.ip121];
        
        // 使用AFHTTPRequestOperationManager发送POST请求
        [appDelegate.manager
         POST:replyUrl
         parameters:commentString // 指定请求参数
         // 获取服务器响应成功时激发的代码块
         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             // 当使用HTTP响应解析器时，服务器响应数据被封装在NSData中
             // 此处将NSData转换成NSString、并使用UIAlertView显示登录结果
             NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             // NSLog(@"json;%@",json);
             NSString* commentOK=[json objectForKey:@"commentOK"];
             
             int intcommentOK = [commentOK intValue];
             if (intcommentOK==1) {
                 //NSLog(@"回复成功");
                 placeHolderStr=@"输入回复内容...";
                 placeHolderLable.text=placeHolderStr;
                 textView.text=@"";
                 [textView resignFirstResponder];
                 hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.labelText=@"回复成功";
                 hud.removeFromSuperViewOnHide=YES;
                 hud.minSize=CGSizeMake(120.0f, 20.0f);
                 hud.margin=10.f;
                 
                 hud.yOffset=0.375*DEVICE_HEIGHT;
                 
                 hud.mode=MBProgressHUDModeText;
                 [hud hide:YES afterDelay:1];
                 
                 
                 
                 
             }
             
         }
         // 获取服务器响应失败时激发的代码块
         failure:^(AFHTTPRequestOperation *operation,  NSError *error)
         {
             hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.labelText=@"请检查网络设置";
             hud.removeFromSuperViewOnHide=YES;
             hud.minSize=CGSizeMake(120.0f, 20.0f);
             hud.margin=10.f;
             
             hud.yOffset=0.375*DEVICE_HEIGHT;
             
             hud.mode=MBProgressHUDModeText;
             [hud hide:YES afterDelay:1];
             
         }];
    }
    
}
-(void)loadDataing
{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/kuibuversion1/page/getCommentList/%ld/%ld/%ld",transport.ip121,(long)loginsingle.userID,(long)transport.mainpageid,(long)pageNumber];
    //NSLog(@"strurl;%@",strUrl);
    [appDelegate.manager
     GET:strUrl
     parameters:nil // 指定无需请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSString *jsonString=[[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSError *er;
         NSMutableDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&er];
         
         NSArray *arr= [jsondic objectForKey:@"commentList"];
         for (int index=0; index<arr.count; index++) {
             NSMutableDictionary *muDic=[NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:index]];
             [discussArray addObject:muDic];
         }
         
         // NSLog(@"DIscussjsonString-%@",arr);
         if([arr count]==0)
         {
             islast=YES;
             
             loadMoreText.text=@"没有更多评论了";
             [tableFooterActivityIndicator stopAnimating];
         }
         else {
             // [discussArray addObjectsFromArray:arr];
             [hotTableView reloadData];
             pageNumber++;
         }
         
     }
     
     // 获取服务器响应失败时激发的代码块
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         // NSLog(@"获取服务器响应出错！");
     }];
}*/
@end
