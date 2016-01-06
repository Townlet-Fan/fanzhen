//
//  replyViewController.m
//  UIScroll1
//
//  Created by kuibu technology on 15/11/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBReplyViewController.h"
#import "KBWebViewRelyCell.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "UIImageView+WebCache.h"
#import "KBProgressHUD.h"
#import "KBBaseNavigationController.h"
#import "KBInfoTableViewController.h"
#import "KBWhetherReachableModel.h"
#import "KBWebviewInfoModel.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
#import "KBPostParametersModel.h"
#import "KBReplyHeadView.h"
#import "KBHTTPTool.h"
#import "KBReplyModel.h"
#import "MJRefresh.h"
//距离上边
#define HEIGHT_MARGIN 20
//距离左边
#define WIDTH_MARGIN 20
//头像的高度
#define HEAD_WIDTH 50

@interface KBReplyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,KBReplyHeadViewDelegate>

{
    UITableView * replyTableView;//回复的tableView
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    KBLoginSingle * loginSingle;//用户的单例
    
    CGRect textViewOriginRect;//textview的原始尺寸
    
    CGRect toolBarRect;//toolbar的原始尺寸
    
    NSInteger pageNumber;//分页数
   
    NSMutableArray * replyArray;//回复的数组
    
    UIButton *publishBtn;//回复的button
    
    int countDrag;//拖拽的滑动的次数
    
    UIWindow * statusWindow;// 新定义的状态的UIWindow
    
    BOOL isAddToTopButton;// 是否加入了置顶的button
    
    UIButton * toTopButton;//置顶的button
    
    int replyCount;//回复数

    KBWebviewInfoModel * webViewInfoModel;//正文的单例
    
    KBReplyHeadView * replyHeadView;//回复的顶部View
    
    KBReplyModel * replyModel; //回复的模型
}
@end

@implementation KBReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.view.backgroundColor=[UIColor clearColor];
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    webViewInfoModel=[KBWebviewInfoModel newinstance];
    replyArray=[[NSMutableArray alloc]init];
    replyCount=0;

    //导航栏设置
    self.navigationController.navigationBarHidden=YES;
    
    //设置回复的顶部View
    [self topView];
    
    //设置tableview
    [self setTableView];
    
    //加入下拉刷新
    [self addMjRefreshInTableHeadView];

    //设置toolBar
    [self setToolBar];
    
    //检测状态的变化
    [self DidChangeStatusBarFrame];
    
    //加载数据
    [self replyData];
    
// Do any additional setup after loading the view.
}
#pragma mark - 回复顶部的View
-(void)topView
{
    replyHeadView = [[KBReplyHeadView alloc]initWithFrame:CGRectMake(0, 0, kWindowSize.width, kWindowSize.width*9/16)];
    replyHeadView.delegate=self;
    [replyHeadView setReplyHeadData:webViewInfoModel.imagestr withComment:self.discussTextL withReplyCount:replyCount];
    [self.view addSubview:replyHeadView];
}

#pragma mark - 设置tableview
-(void)setTableView
{
    replyTableView=[[UITableView alloc]initWithFrame:CGRectMake(replyHeadView.separatorView.left, replyHeadView.separatorView.bottom, kWindowSize.width, kWindowSize.height-(replyHeadView.separatorView.bottom+40)) style:UITableViewStylePlain];
    replyTableView.dataSource=self;
    replyTableView.delegate=self;
    replyTableView.scrollsToTop=NO;
    replyTableView.bounces=YES;
    replyTableView.backgroundColor=[UIColor whiteColor];
    replyTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:replyTableView];

}
#pragma mark - 加入下拉刷新
- (void)addMjRefreshInTableHeadView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(replyData)];
    replyTableView.header = header;
}
#pragma  mark - 初始化toolbar工具栏
-(void)setToolBar
{
    //初始化toolbar
    _toolBar=[[UIView alloc]initWithFrame:CGRectMake(0,kWindowSize.height-50,self.view.width,50) ];
    _toolBar.layer.masksToBounds=YES;    //  toolBar.layer.cornerRadius=6;
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
    _textView.delegate=self;
    
    _placeHolderStr=@"输入回复内容...";
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
    [publishBtn setTitle:@"回复" forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishReply) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:publishBtn];
    [_toolBar addSubview:_textView];
    [self.view addSubview:_toolBar];
}
#pragma mark - 返回
-(void)popToHot
{
    [commonSingleValueModel.navcontrolDelegate popViewControllerAnimated:YES];
}
#pragma mark - tableView 置顶
-(void)toTop:(BOOL)animated
{
    [replyTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark  - 获取回复的数据
-(void)replyData
{
    replyArray=[[NSMutableArray alloc]init];
    replyModel = [[KBReplyModel alloc]init];
    [KBHTTPTool getRequestWithUrlStr:KCommentReplyUrl(kBaseUrl, _commentId) parameters:nil completionHandr:^(id responseObject) {
        [replyModel setDataWithDictionary:responseObject];
        replyArray = replyModel.replyArray;
        replyCount=(int)[replyArray count];
        replyHeadView.refrenceReplyLabel.text=[NSString stringWithFormat:@"    相关回复(%d)",replyCount];
        [replyTableView reloadData];
        
    } error:^(NSError *error) {
        KBLog(@"error:%@",error);
    }];
}
#pragma mark - 回复
-(void)publishReply
{
    if (loginSingle.isLogined) {
        if (_textView.text.length!=0)
            [self reply];
        else
        {
           [KBProgressHUD setHud:self.view withText:@"回复不能为空" AndWith:0.375];
        }
    }
    else
    {
        [KBProgressHUD setHud:self.view withText:@"请先登录再回复" AndWith:0.375];
    }
}
#pragma mark - 请求服务器回复
-(void)reply
{
    NSString * replyContent=[NSString stringWithFormat:@"%@",_textView.text];
    
//    NSData* data = [publish dataUsingEncoding: NSUTF8StringEncoding];
//    
//    publish=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    replyContent=[replyContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(replyContent.length > 0)
    {
        NSDictionary * replyDic=[KBPostParametersModel setUserReplyToOthersParameters:webViewInfoModel.pageId  withUserId:loginSingle.userID withCommentId:_commentId withReplyContent:replyContent];
        [KBHTTPTool postRequestWithUrlStr:KUserReplyToOthersUrl(kBaseUrl) parameters:replyDic completionHandr:^(id responseObject) {
            NSString* commentOK=responseObject[@"commentOK"];
            if ([commentOK intValue]==1) {
                NSLog(@"回复成功");
                _placeHolderStr=@"输入回复内容...";
                _placeHolderLable.text=_placeHolderStr;
                _textView.text=@"";
                [_textView resignFirstResponder];
            
                NSMutableDictionary *replyDic=[[NSMutableDictionary alloc]init];
                
                [replyDic setObject:loginSingle.userPhoto forKey:@"replyerPhoto"];
                
                [replyDic setObject:loginSingle.userName forKey:@"replyerName"];
                [replyDic setObject:replyContent forKey:@"replyContent"];
                NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"hh:mm  MM-dd"];
                [replyDic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"replyDate"];
                [replyArray insertObject:replyDic atIndex:0];
                replyCount=replyCount+1;
                replyHeadView.refrenceReplyLabel.text=[NSString stringWithFormat:@"    相关回复(%d)",replyCount];
                [KBProgressHUD setHud:self.view withText:@"回复成功" AndWith:0.375];
            
                [replyTableView reloadData];
            }
            
        } error:^(NSError *error) {
            [KBProgressHUD setHud:self.view withText:@"请检查网络设置" AndWith:0.375];
        }];
    }
}
#pragma mark — tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return replyArray.count;
        
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBWebViewRelyCell *cell;
    static NSString *hotDiscussCellIdentifier = @"replyCell";
    cell = [tableView dequeueReusableCellWithIdentifier:hotDiscussCellIdentifier];
    
    if (cell==nil)
    {
        cell = [[KBWebViewRelyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotDiscussCellIdentifier];
    }
    [cell setReplyCellWithModel:replyArray [indexPath.row]];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (replyArray.count!=0) {
        CGRect replyRect = [self sizeWithReply:replyModel.replyerContent];
        if(replyRect.size.height>(HEAD_WIDTH))
        {
            return replyRect.size.height+2*HEIGHT_MARGIN+40;
        }
        else{
            return HEAD_WIDTH+2*HEIGHT_MARGIN+40;
        }
    }
    else
        return 0;
    
}
#pragma mark - 计算回复label的尺寸
- (CGRect)sizeWithReply:(NSString *)replyContent
{
    CGRect rect = [replyContent boundingRectWithSize:CGSizeMake(kWindowSize.width-2*WIDTH_MARGIN-HEAD_WIDTH-10,500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=NO;
    self.navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyDown:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 视图已经的出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [statusWindow removeFromSuperview];
    //回复评论的数据和刷新回复数
    KBInfoTableViewController * infoTableVC=[[KBInfoTableViewController alloc]init];
    [infoTableVC discussSelectedIndex:_discussSelectedIndex];
    [infoTableVC discussArray:_discuss_reply_Array];
    [infoTableVC refreshReplyCount:replyCount];
}

#pragma mark - 视图已经消失
-(void)viewdidDisappear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=NO;

    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
}
#pragma mark -将要开始滑图时候，textview回到原来的位置
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
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
            _placeHolderStr=@"输入回复内容...";
            _placeHolderLable.text=_placeHolderStr;
        }
        //当textview的输入长度不为0的时候
        else if(_textView.text.length!=0)
        {
            //拖拽了一次，再次拖拽隐藏
           if (countDrag==1)
            {
                //根据状态栏的高度设置toolbar的frame
                if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
                {
                    [_toolBar setFrame:CGRectMake(0,kWindowSize.height-toolBarRect.size.height-20, self.view.width , toolBarRect.size.height+20)];
                }
                else
                {

                    [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-toolBarRect.size.height, self.view.frame.size.width , toolBarRect.size.height)];
                }

            }
            
            
        }
        
    }
    //当textview不是第一响应的时候
    else if (![_textView isFirstResponder])
    {
        _textView.text=@"";
        _placeHolderStr=@"输入回复内容...";
        _placeHolderLable.text=_placeHolderStr;
        [_textView setFrame:textViewOriginRect];
        [publishBtn setFrame:CGRectMake(0.8*self.view.width+10, 10, 0.2*self.view.width-20, 30)];
        {
            if ([UIApplication sharedApplication].statusBarFrame.size.height==40)
            {
                [_toolBar setFrame:CGRectMake(0, kWindowSize.height-70, self.view.width , 50)];
            }
            else
            {
                [_toolBar setFrame:CGRectMake(0,kWindowSize.height-50, self.view.width , 50)];
            }
            
        }
        
    }
    
}
#pragma mark - notification 键盘
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
                    //NSLog(@"22222202020202020");
                    [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height -keyboardRect.size.height-50, self.view.frame.size.width , 50)];
                }
                
            }
        }
        else
        {
            [_toolBar setFrame:toolBarRect];
            
        }
        [UIView commitAnimations];
        
    }
    
}
-(void)keyDown:(NSNotification *)notification{
    
    if ([_textView isFirstResponder])
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
                    [_toolBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, self.view.frame.size.width , 50)];
                }
                else
                {
                    [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, self.view.frame.size.width , 50)];
                }
                
            }
        }
        else{
            [_toolBar setFrame:CGRectMake(0,  self.view.frame.size.height-toolBarRect.size.height, toolBarRect.size.width, toolBarRect.size.height)];
        }
        [UIView commitAnimations];
    }
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView1{
    
    if (_textView.text.length==0) {
        _placeHolderLable.text=_placeHolderStr;
    }
    else
    {
        _placeHolderLable.text=@"";
        CGRect frame = _textView.frame;
        
        frame.size.height = _textView.contentSize.height;
        if (frame.size.height>_textView.height&&frame.size.height<60) {
            CGRect oldFrame=_textView.frame;
            [_textView setFrame:CGRectMake(_textView.left
                                          ,_textView.top, _textView.width, frame.size.height)];
            [_toolBar setFrame:CGRectMake(_toolBar.left, _toolBar.top-frame.size.height+oldFrame.size.height, _toolBar.width, _toolBar.height+frame.size.height-oldFrame.size.height)];
            [publishBtn setFrame:CGRectMake(publishBtn.left, _toolBar.height-42, publishBtn.width, publishBtn.height)];
            
        }
        else if(frame.size.height<_textView.height)
        {
            CGRect oldFrame=_textView.frame;
            [_textView setFrame:CGRectMake(_textView.left
                                          ,_textView.top, _textView.width, frame.size.height)];
            [_toolBar setFrame:CGRectMake(_toolBar.left, _toolBar.top-frame.size.height+oldFrame.size.height, _toolBar.width, _toolBar.height+frame.size.height-oldFrame.size.height)];
            [publishBtn setFrame:CGRectMake(publishBtn.left, _toolBar.height-42, publishBtn.width, publishBtn.height)];
        }
        toolBarRect=_toolBar.frame;
    }
    
}
#pragma mark - 状态栏高度的改变
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
            [_toolBar setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50 )];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidChangeStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
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
