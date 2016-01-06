//
//  MessageTableVC.m
//  UIScroll1
//
//  Created by eddie on 15-4-25.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMyMessageReplyViewController.h"
#import "KBCommonSingleValueModel.h"
#import "KBLoginSingle.h"
#import "KBMyMessageReplyViewCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "KBWhetherReachableModel.h"
#import "KBMessageViewController.h"
#import "KBInfoWebViewController.h"
#import "KBCommonSingleValueModel.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "KBHTTPTool.h"
#import "KBMyMessageReplyAllData.h"
#import "KBMyMessagReplyModel.h"
#import "KBPostParametersModel.h"
#import "MJRefresh.h"
//距离上边的距离
#define MARGIN_HEIGHT 20
//距离左边的距离
#define MARGIN_WIDTH 15
//头像的高度
#define HEADVIEW_WIDTH 50
//原来自己回复内容View的高度
#define HEIGHT_ORIGN_RESPOND_VIEW 40

@interface KBMyMessageReplyViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UITextField *textField;//输入textField
    
    UIView *toolBar;//下方输入框
    
    UITableViewCell *selectedCell;//选中的cell
    
    UITapGestureRecognizer *tapKeydown;//手势使得键盘取消第一响应
    
    NSMutableArray * replyArray;//回复的数组
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    KBLoginSingle * loginSingle;//用户的单例
    
    NSInteger commentId;//评论Id
    
    NSInteger pageNumber;//分页数
    
    KBMyMessageReplyAllData * myMessageReplyAllData; //我的消息回复的所有数据
    
    MBProgressHUD * hud;//提示
    
    MJRefreshAutoNormalFooter *footer;//自动加载更多
}
@end

@implementation KBMyMessageReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    replyArray=[[NSMutableArray alloc]init];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    loginSingle=[KBLoginSingle newinstance];
    myMessageReplyAllData=[[KBMyMessageReplyAllData alloc]init];
    
    //tableview
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.scrollsToTop=NO;
    self.tableView.bounces=YES;
   
    //手势使得键盘取消第一响应
    tapKeydown=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapKeyDown)];
    //下方输入框
    [self addToolBar];
    
    //加入下拉刷新
    [self addMjRefreshInTableHeadView];
    //加入上拉加载更多
    [self addMjRefreshInTableFooterView];

    //加载数据
    [self performSelector:@selector(myMessageReplyInit) withObject:nil afterDelay:0.5];
}
#pragma mark - 下方的输入框
-(void)addToolBar
{
    //下方输入框
    toolBar=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.height-50,self.view.frame.size.width,50) ];
    toolBar.backgroundColor=KColor_223_224_226;
    toolBar.layer.borderColor=KColor_230.CGColor;
    toolBar.layer.borderWidth=1;
    
    textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.view.width*0.8-10, 30)];
    textField.placeholder=@"回复这条评论";
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.textAlignment=NSTextAlignmentLeft;
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.layer.cornerRadius=5;
    textField.layer.borderWidth=1;
    textField.delegate=self;
    textField.layer.borderColor=KColor_235.CGColor;
    textField.font=[UIFont systemFontOfSize:15];
    //回复的button
    UIButton *publishBtn=[[UIButton alloc] initWithFrame:CGRectMake(0.8*self.view.width+10, 10, 0.2*self.view.width-20, 30)];
    [publishBtn setBackgroundColor:KColor_15_86_192];
    [publishBtn setTitle:@"回复" forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishReply) forControlEvents:UIControlEventTouchDown];
    [toolBar addSubview:publishBtn];
    [toolBar addSubview:textField];
}
#pragma mark - 加入下拉刷新
- (void)addMjRefreshInTableHeadView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(myMessageReplyInit)];
    self.tableView.header = header;
}
#pragma mark - 加入上拉加载更多
-(void)addMjRefreshInTableFooterView
{
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 获取回复列表的数据
-(void)myMessageReplyInit
{
    pageNumber=1;
    if(replyArray.count!=0)
       [replyArray removeAllObjects];
    [KBHTTPTool getRequestWithUrlStr:KUserMessageReplyUrl(kBaseUrl,loginSingle.userID, pageNumber) parameters:nil completionHandr:^(id responseObject) {
        NSString * isLastStr = responseObject[@"isLast"];
        if ([isLastStr intValue]) {
            [self.tableView.header endRefreshing];
        }
        else
        {
            [myMessageReplyAllData setDataWithDictionary:responseObject];
            replyArray=[NSMutableArray arrayWithArray:myMessageReplyAllData.myMessageReplyAllDataArray];
            self.tableView.footer=footer;
            if (commonSingleValueModel.hasRely) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_MESSAGE" object:nil];
            }
            commonSingleValueModel.hasRely=NO;
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            pageNumber++;

            
        }
    } error:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return replyArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBMyMessageReplyViewCell *myMessageReplyViewcell;
    static NSString *cellIdentifier=@"messageCellIdentifier";
    myMessageReplyViewcell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(myMessageReplyViewcell==nil)
    {
        myMessageReplyViewcell=[[KBMyMessageReplyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    KBMyMessagReplyModel * myMessageReplyModel = replyArray[indexPath.section];
    //加载cell的数据
    [myMessageReplyViewcell setMessageReplyCellWithModel:myMessageReplyModel];
    return myMessageReplyViewcell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KBMyMessagReplyModel * myMessageReplyModel = replyArray[indexPath.section];
  CGRect rect = [myMessageReplyModel.replyerContent boundingRectWithSize:CGSizeMake(kWindowSize.width-2*MARGIN_WIDTH-HEADVIEW_WIDTH-45,500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5]} context:nil];
    return MARGIN_HEIGHT+20+10+rect.size.height+20+40+10+20+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 27;
    else
        return 0.000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedCell= [self.tableView cellForRowAtIndexPath:indexPath];
    [self.parentViewController.view addSubview:toolBar];
    [textField becomeFirstResponder];

}
#pragma mark -  加载更多数据
-(void)loadMoreData
{
    [KBHTTPTool getRequestWithUrlStr:KUserMessageReplyUrl(kBaseUrl,loginSingle.userID, pageNumber) parameters:nil completionHandr:^(id responseObject) {
        NSString * isLastStr = responseObject[@"isLast"];
        if ([isLastStr intValue]) {
            [self.tableView.footer endRefreshing];
        }
        else
        {
            [myMessageReplyAllData setDataWithDictionary:responseObject];
            [replyArray addObjectsFromArray:myMessageReplyAllData.myMessageReplyAllDataArray];
            [self.tableView reloadData];
            pageNumber++;
            [self.tableView.footer endRefreshing];

        }
    } error:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}
#pragma mark - 回复
-(void)reply
{
    [self.parentViewController.view addSubview:toolBar];
    [textField becomeFirstResponder];
    
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyDown:) name:UIKeyboardWillHideNotification object:nil];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
}
#pragma mark - 键盘监听
-(void)keyUp:(NSNotification *)notification{
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MESSAGE_NO_ENABLE" object:nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    [toolBar setFrame:CGRectMake(0, self.parentViewController.view.height -keyboardRect.size.height-50, self.view.width , 50)];
    [UIView commitAnimations];
    [self.tableView setContentOffset:CGPointMake(0, selectedCell.top-40) animated:YES];
    [self.tableView addGestureRecognizer:tapKeydown];
    
}
-(void)keyDown:(NSNotification *)notification{
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [self.parentViewController.view bringSubviewToFront:toolBar];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    [toolBar setFrame:CGRectMake(0, self.parentViewController.view.height -50, self.view.width , 50)];
    [UIView commitAnimations];
    [self.tableView removeGestureRecognizer:tapKeydown];
    [toolBar removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MESSAGE_ENABLE" object:nil];
}
#pragma mark - 开始拖拽视图
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([textField isFirstResponder])
    {
        [textField resignFirstResponder];
        textField.text=@"";
        textField.placeholder=@"回复这条评论";
    }
}
#pragma mark - 手势点击取消键盘的第一响应
-(void)tapKeyDown{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
        textField.text=@"";
        textField.placeholder=@"回复这条评论";
    }
}
#pragma mark -  回复提交服务器
-(void)publishReply
{
    NSIndexPath *indexpath=[self.tableView indexPathForCell:selectedCell];
    KBMyMessagReplyModel * myMessageReplyModel =  replyArray [indexpath.section];
    NSString * commentID=myMessageReplyModel.commentId;
    commentId=[commentID intValue];
    NSString *nu=@"";
    NSString * replyContent=textField.text;
    replyContent=[replyContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(replyContent.length > 0)
    {
        NSDictionary * commentDic=[KBPostParametersModel setUserReplyToOthersParameters:[myMessageReplyModel.pageId integerValue] withUserId:loginSingle.userID withCommentId:commentId withReplyContent:replyContent];
        [KBHTTPTool postRequestWithUrlStr:KUserReplyToOthersUrl(kBaseUrl) parameters:commentDic completionHandr:^(id responseObject) {
            NSString* commentOK=[responseObject objectForKey:@"commentOK"];
            int intcommentOK = [commentOK intValue];
            if (intcommentOK==1) {
                NSLog(@"commentok:%@",commentOK);
                textField.text=@"";
                [textField resignFirstResponder];
                hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText=@"回复成功";
                hud.removeFromSuperViewOnHide=YES;
                hud.minSize=CGSizeMake(120.0f, 20.0f);
                hud.margin=10.f;
                hud.yOffset=selectedCell.frame.origin.y-115;
                hud.mode=MBProgressHUDModeText;
                [hud hide:YES afterDelay:1];
            }

        } error:^(NSError *error) {
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"请检查网络设置";
            hud.removeFromSuperViewOnHide=YES;
            hud.minSize=CGSizeMake(120.0f, 20.0f);
            hud.margin=10.f;
            hud.yOffset=selectedCell.frame.origin.y-115;
            hud.mode=MBProgressHUDModeText;
            [hud hide:YES afterDelay:1];
        }];
    }
    else
        if ([replyContent isEqualToString:nu])
        {
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"回复不能为空";
            hud.removeFromSuperViewOnHide=YES;
            hud.minSize=CGSizeMake(120.0f, 20.0f);
            hud.margin=10.f;
            hud.yOffset=selectedCell.frame.origin.y-115;
            hud.mode=MBProgressHUDModeText;
            [hud hide:YES afterDelay:1];
        }
}
@end
