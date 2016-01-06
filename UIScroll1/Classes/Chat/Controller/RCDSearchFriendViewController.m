//
//  RCDSearchFriendTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/12.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDSearchFriendViewController.h"
#import "MBProgressHUD.h"
#import "RCDHttpTool.h"
#import "UIImageView+WebCache.h"
#import "RCDUserInfo.h"
#import "RCDSearchResultTableViewCell.h"
#import "RCDAddFriendViewController.h"
#import "AppDelegate.h"
#import "KBCommonSingleValueModel.h"
#import "RCDChatViewController.h"
#import "KBConstant.h"
@interface RCDSearchFriendViewController ()

{
    NSMutableArray *searchArray;//搜索数组
    
     UISearchBar *search;
    UITableView * FriendSearchTableView;
    AppDelegate * appdelegate;
    KBCommonSingleValueModel *transport;
}
@end

@implementation RCDSearchFriendViewController
@synthesize AllUserInfoArray;
@synthesize AllUserInfo_Name;
float DEVICE_WIDTH,DEVICE_HEIGHT;
- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate=[UIApplication sharedApplication].delegate;
    transport=[KBCommonSingleValueModel newinstance];
    //设备宽度和高度
    DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
    DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
    //导航栏标题
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"查找好友";
    titleLable.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    self.navigationItem.titleView = titleLable;
    //导航栏左侧按钮返回
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(backToChat) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    //搜索框
    search=[[UISearchBar alloc] init];
    search.frame=CGRectMake(0, 64, self.view.frame.size.width, 40);
    search.placeholder=@"搜索好友";
    search .showsCancelButton=YES;
    search.backgroundColor=[UIColor whiteColor];
    search.delegate=self;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
    search.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
    [self.view addSubview:search];
    //tableview
    FriendSearchTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, search.frame.origin.y+search.frame.size.height,DEVICE_WIDTH,DEVICE_HEIGHT-(search.frame.origin.y+search.frame.size.height)) style:UITableViewStyleGrouped];
    FriendSearchTableView.delegate=self;
    FriendSearchTableView.dataSource=self;
    FriendSearchTableView.scrollsToTop=NO;
    FriendSearchTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
//     FriendSearchTableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,search.frame.size.height )];
    [self.view addSubview:FriendSearchTableView];
    //手势用于取消搜索的第一响应
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    //initial data
    RCUserInfo * user1 = [[RCUserInfo alloc]initWithUserId:@"26" name:@"跬步" portrait:@""];
     RCUserInfo * user2 = [[RCUserInfo alloc]initWithUserId:@"84" name:@"德勋" portrait:@""];
    AllUserInfoArray=[[NSMutableArray alloc]initWithObjects:user1,user2, nil];
    searchArray=[NSMutableArray arrayWithArray:AllUserInfoArray];//拷贝个人信息的数组
    AllUserInfo_Name=[[NSMutableArray alloc]initWithObjects:user1.name,user2.name,nil];
    NSLog(@"alluserinfoname;:%@",AllUserInfo_Name);
    



}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [FriendSearchTableView reloadData];
//}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
        [self backToChat];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [search resignFirstResponder];
}
#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length==0) {
        AllUserInfoArray=[NSMutableArray arrayWithArray:searchArray];
        [FriendSearchTableView reloadData];
    }
    else{
        [AllUserInfoArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"self contains [c] %@", searchBar.text];
        
        NSArray *searchUserNameArray=  [AllUserInfo_Name filteredArrayUsingPredicate:predicate];
        
       for(int i=0;i<searchUserNameArray.count;i++) {
                NSString *adaptString=[searchUserNameArray objectAtIndex:i];
          
                NSInteger adaptIndex=[AllUserInfo_Name indexOfObject:adaptString];
        
                RCDUserInfo * adaptUserInfo=[searchArray objectAtIndex:adaptIndex];
         
                if ([searchArray indexOfObject:adaptUserInfo]!=NSNotFound) {
                      [AllUserInfoArray addObject:adaptUserInfo];
            }
        }
        [FriendSearchTableView reloadData];
    }
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

//返回我的会话
-(void)backToChat
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - searchResultDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return AllUserInfoArray.count;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *reusableCellWithIdentifier = @"RCDSearchResultTableViewCell";
    RCDSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    cell = [[RCDSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
    RCDUserInfo *user =AllUserInfoArray[indexPath.row];
    if(user){
        [cell.FriendImgeView setFrame:CGRectMake(20, 10, 50, 50)];
        cell.FriendImgeView.layer.cornerRadius=15.f;
        [cell.FriendImgeView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"未登录"]];
        
        [cell.FriendLabel setFrame:CGRectMake(cell.FriendImgeView.frame.origin.x+cell.FriendImgeView.frame.size.width+20, 25, DEVICE_WIDTH-(cell.FriendImgeView.frame.origin.x+cell.FriendImgeView.frame.size.width+150), 20)];
        cell.FriendLabel.text = user.name;
        
        
        [cell.AddFriendButton setFrame:CGRectMake(cell.FriendLabel.frame.origin.x+cell.FriendLabel.frame.size.width+50, 20,50, 30)];
        cell.AddFriendButton.indexPath=indexPath;
        cell.AddFriendButton.layer.cornerRadius=2;
        cell.AddFriendButton.layer.borderWidth=1.0f;
        cell.AddFriendButton.layer.borderColor=[UIColor colorWithRed:192/255.0 green:191/255.0 blue:191/255.0 alpha:1.0].CGColor;
        cell.AddFriendButton.contentHorizontalAlignment=  UIControlContentHorizontalAlignmentCenter;
        cell.AddFriendButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
        [cell.AddFriendButton setTitle:@"添加" forState:UIControlStateNormal];
        [cell.AddFriendButton setTitleColor:[UIColor colorWithRed:15/255.0 green:86/255.0 blue:208/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cell.AddFriendButton addTarget:self action:@selector(AddFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        
   }
    


    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
//

#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDSearchResultTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    RCDUserInfo *user = AllUserInfoArray[indexPath.row];
    RCUserInfo *userInfo = [RCUserInfo new];
    userInfo.userId = user.userId;
    userInfo.name = user.name;
    userInfo.portraitUri = user.portraitUri;
    RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = user.userId; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId
    conversationVC.userName = user.name;
    conversationVC.title = user.name;
    [self.navigationController pushViewController:conversationVC animated:YES];

//    if(user && tableView == self.searchDisplayController.searchResultsTableView){
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        RCDAddFriendViewController *addViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDAddFriendViewController"];
//        addViewController.targetUserInfo = userInfo;
//        [self.navigationController pushViewController:addViewController animated:YES];
//    }

}
-(void)AddFriendRequest:(KBThumpButton * )indexpath;
{
    NSString * addFriendsStr1 = [NSString stringWithFormat:@"{\"fromUserId\":\"%d\",\"toUserId\":\"%d\",\"content\":\"%@\"}",26,261,@"hello"];
    
    NSDictionary * addFriendsStr = @{@"addFriendsStr":addFriendsStr1};
    NSString *FriendRequestUrl = KRongYunAddFriendsUrl(kBaseUrl);
    // 使用AFHTTPRequestOperationManager发送POST请求
    [appdelegate.manager
     POST:FriendRequestUrl
     parameters:addFriendsStr  // 指定请求参数
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         // 当使用HTTP响应解析器时，服务器响应数据被封装在NSData中
         // 此处将NSData转换成NSString、并使用UIAlertView显示登录结果
         NSError * er;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&er];
         NSString * addFriendResult=[json objectForKey:@"addFriendsResult"];
         if([addFriendResult intValue])
         {
             NSLog(@"添加成功");
         }
         else
             NSLog(@"添加失败");
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"errorrrrr:%@",error);
     }];

}








@end
