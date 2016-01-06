  //
//  MyFooterTVC.m
//  UIScroll1
//
//  Created by eddie on 15-5-3.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBMyFooterViewController.h"
#import "KBCommonSingleValueModel.h"
#import "KBLoginSingle.h"
#import "rootViewController.h"
#import "KBMyFooterViewCell.h"
#import "UIImageView+WebCache.h"
#import "KBBaseNavigationController.h"
#import "KBMyCollectionDataModel.h"
#import <sqlite3.h>
#import "KBConstant.h"
#import "KBColor.h"
#import "UIView+ITTAdditions.h"
#import "KBMyCollectionDeleteView.h"
#import "KBInfoWebViewController.h"
#import "KBWebviewInfoModel.h"
#import "YYWebImage.h"
#import "KBMyCollectionAllDataModel.h"
#import "KBTwoSortModel.h"
//cell的高度
#define ROW_HEIGHT 85

@interface KBMyFooterViewController ()<UITableViewDelegate,UITableViewDataSource,KBMyCollectionDeleteViewDelegate>

{
    UIBarButtonItem *rightEditItem;//右侧的编辑
    
    UIBarButtonItem  *leftBackItem;//左侧的返回
    
    NSMutableArray *dataSourceArray;// 总的数据源的数组
    
    NSMutableArray *selectedIndexpathArray;//选中的Indexpath的数组
    
    NSMutableIndexSet *selectedRowIndexes;//选中的行数
    
    NSMutableArray *deleteArray;//删除的数组
    
    NSMutableArray *deleteIDArray;//删除Id（文章的Id）的数组
    
    NSString * deletedstr;//删除的字符串
    
    KBCommonSingleValueModel * commomSingleValueModel;//传值的单例
    
    KBLoginSingle *loginSingle;//用户的单例
    
    sqlite3 *db;//数据库

    BOOL isDelete;//是否选中
    
    UILabel * loadMoreText;//加载更多的提示文字
    
    KBMyCollectionDeleteView * deleteView;//底部删除view
    
    KBWebviewInfoModel * webviewInfoModel;//正文数据的Model
    
    KBMyCollectionAllDataModel * allDataModel;//所有数据的Model
}
@end

@implementation KBMyFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    isDelete=YES;
    commomSingleValueModel=[KBCommonSingleValueModel newinstance];
    deleteArray=[[NSMutableArray alloc]init];
    deleteIDArray=[[NSMutableArray alloc]init];
    deletedstr=[[NSString alloc]init];
    loginSingle=[KBLoginSingle newinstance];
    selectedRowIndexes =[[NSMutableIndexSet alloc]init];
    selectedIndexpathArray=[[NSMutableArray alloc]init];
    allDataModel = [[KBMyCollectionAllDataModel alloc]init];
    webviewInfoModel= [KBWebviewInfoModel newinstance];
    
    //tableview
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,kWindowSize.width, kWindowSize.height) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.bounces=NO;
    self.tableView.scrollsToTop=NO;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.rowHeight=ROW_HEIGHT;
    [self.view addSubview:self.tableView];
    

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        self.tableView.allowsMultipleSelectionDuringEditing=YES;
    
    //导航栏的标题
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"足迹";
    titleLable.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    
    //导航栏的左侧返回按钮
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:KBackImage forState:UIControlStateNormal];
     [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];;
    [leftBarBtn addTarget:self action:@selector(popMyFooter) forControlEvents:UIControlEventTouchUpInside];
    leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,25,25)];
    [rightBtn addTarget:self action:@selector(beginEDit) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * rightImageView=[[UIImageView alloc]initWithFrame:rightBtn.frame];
    rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    rightImageView.image=[UIImage imageNamed:@"删除"];
    [rightBtn addSubview:rightImageView];
    rightEditItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightEditItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
     //底部出现删除view
    [self addBottomDeleteView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
    loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    loadMoreText.textAlignment=NSTextAlignmentCenter;
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"正在加载..."];
    [tableFooterView addSubview:loadMoreText];
    self.tableView.tableFooterView=tableFooterView;
    
    [self performSelector:@selector(footerInit) withObject:nil afterDelay:0.3f];
    
}
#pragma mark - 底部出现删除view
-(void)addBottomDeleteView
{
    deleteView=[[KBMyCollectionDeleteView alloc]initWithFrame:CGRectMake(0,kWindowSize.height, kWindowSize.width, 64)];
    deleteView.delegate=self;
    deleteView.backgroundColor=KColor_240;
    [self.view addSubview:deleteView];
}
#pragma mark - 加载足迹数据
-(void)footerInit
{
//    NSMutableArray * myCollectionArray = [[NSMutableArray alloc]init];
    dataSourceArray=[[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlQuery = @"SELECT * FROM Footer order by ID DESC";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            KBMyCollectionDataModel *myData=[[KBMyCollectionDataModel alloc]init];
            int pageID = sqlite3_column_int(statement, 1);
            char *title = (char*)sqlite3_column_text(statement, 2);
            char *type=(char *)sqlite3_column_text(statement, 3);
            char *time=(char *)sqlite3_column_text(statement, 4);
            char *imagestr=(char *)sqlite3_column_text(statement, 5);
            Byte *imagedata=(Byte *)sqlite3_column_blob(statement, 6);
            int length=sqlite3_column_bytes(statement, 6);//(statement, 6);
            char *secondType=(char *)sqlite3_column_text(statement, 7);
            if(type!=NULL)
            {
//                //模型初始化
//                allDataModel = [[KBMyCollectionAllDataModel alloc]init];
//                //封装成字典
//                NSDictionary * myCollectionDic=[allDataModel setDictionaryWithData:[[NSString alloc]initWithUTF8String:title] withDate:[[NSString alloc]initWithUTF8String:time] withTypeName:[[NSString alloc]initWithUTF8String:type] withSecondType:[[NSString alloc]initWithUTF8String:secondType] withPageId:[NSNumber numberWithInt:pageID] withImageStr:[[NSString alloc]initWithUTF8String:imagestr] withImageData:[UIImage imageWithData:[NSData dataWithBytes: imagedata   length:length]]];
//                [myCollectionArray addObject:myCollectionDic];

                myData.TypeName=[[NSString alloc]initWithUTF8String:type];
                myData.pageID=[NSNumber numberWithInt:pageID];
                myData.time=[[NSString alloc]initWithUTF8String:time];
                myData.articleTitle=[[NSString alloc]initWithUTF8String:title];
                myData.imagestr=[[NSString alloc]initWithUTF8String:imagestr];
                NSData *data = [NSData dataWithBytes: imagedata   length:length];
                myData.imageData=[UIImage imageWithData:data];
                @try {
                    myData.secondType=[[NSString alloc]initWithUTF8String:secondType];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception:%@",exception);
                }
                @finally {
                    
                }
                [dataSourceArray addObject:myData];
            }
//            NSMutableDictionary * responseObject = [[NSMutableDictionary alloc]init];
//            [responseObject setObject:myCollectionArray forKey:@"collectList"];
//            [allDataModel setDataWithDictionary:responseObject];
//            dataSourceArray =[NSMutableArray arrayWithArray:allDataModel.collectArray];
        }
        
        
    }
    sqlite3_close(db);
    [loadMoreText setText:@"全部加载完毕"];
    [self.tableView reloadData];
    
    
}
#pragma mark - 底部删除view出现和消失
-(void)beginEDit{
    if (isDelete) {
        [UIView animateWithDuration:0.3 animations:^{
            [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
            [deleteView setFrame:CGRectMake(0,kWindowSize.height-64,kWindowSize.width,64)];
            isDelete=NO;
            [self.tableView setEditing:YES animated:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [deleteView setFrame:CGRectMake(0,kWindowSize.height,kWindowSize.width,64)];
            [self.tableView setEditing:NO animated:YES];
            isDelete=YES;
            [selectedIndexpathArray removeAllObjects];
            [selectedRowIndexes removeAllIndexes];
            
        }];
        
    }
}
#pragma mark - 全选
-(void)allDelelte
{
    if ([deleteView.allDeteleButton.titleLabel.text isEqualToString:@"全选"]) {
        //遍历所有的数据
        for (int i=0; i<dataSourceArray.count;i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            //加入到选中的数组
            [selectedIndexpathArray addObject:indexPath];
            //选中的行数
            [selectedRowIndexes addIndex:indexPath.row ];
            //选中
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }
        //全部选中的行数不等于全部的数据的个数
        if (selectedIndexpathArray.count!=0) {
            [deleteView.allDeteleButton setTitle:@"取消全选" forState:UIControlStateNormal];
            
        }
    }
    else
    {
        //取消某行的选中的状态 就取消全选
        for (int i=0; i<dataSourceArray.count;i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [selectedIndexpathArray removeObject:indexPath];
            [selectedRowIndexes removeIndex:indexPath.row];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            //[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
    }
}
#pragma mark - 删除
-(void)deleteCollect{
    //本地删除 加入到删除的数组中
    [deleteArray addObjectsFromArray:[dataSourceArray objectsAtIndexes:selectedRowIndexes]];
    [deleteIDArray addObjectsFromArray:deleteArray];
    [dataSourceArray removeObjectsAtIndexes:selectedRowIndexes];
    //从tableview中删除
    [self.tableView deleteRowsAtIndexPaths:selectedIndexpathArray withRowAnimation:UITableViewRowAnimationFade];
    //清空数组
    [selectedIndexpathArray removeAllObjects];
    [selectedRowIndexes removeAllIndexes];
    [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_DISABLE" object:nil];
    self.tableView.scrollsToTop=YES;
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=KColor_15_86_192;
}
#pragma mark - 视图已经消失
-(void)viewDidDisappear:(BOOL)animated
{
    self.tableView.scrollsToTop=NO;
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, kWindowSize.width+0.5, 44)];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_LIKE" object:deletedstr];
    
    //删除数据库里的内容
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"Footer.sqlite"];
    
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    else{
        NSString * sql=@"DELETE FROM Footer WHERE pageid =?";
        sqlite3_stmt *stmp;
        //根据PageID删除
        for (int i=0; i<deleteIDArray.count; i++){
            //int success = sqlite3_prepare_v2(db, sql, -1, &stmp, NULL);)
            int result= sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmp, nil);
            if(result!=SQLITE_OK){
                NSLog(@"Error: failed to delete:testTable");
                sqlite3_close(db);
            }
            else{
                KBMyCollectionDataModel *data=[deleteIDArray objectAtIndex:i];
                sqlite3_bind_int(stmp, 1, [data.pageID intValue]);
//                NSLog(@"----------%d-----------------------------------------------",ID);
                int r = sqlite3_step(stmp);
                if (r==SQLITE_DONE) {
                    NSLog(@"done!!!!");
                }
                else{
                    NSLog(@"删除SQL语句有问题");
                }
            }
        }
        sqlite3_close(db);
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        [selectedIndexpathArray removeObject:indexPath];
        [selectedRowIndexes removeIndex:indexPath.row];
        if (selectedIndexpathArray.count!=dataSourceArray.count) {
            [deleteView.allDeteleButton setTitle:@"全选" forState:UIControlStateNormal];
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableview在编辑的状态
    if (self.tableView.editing) {
        [selectedIndexpathArray addObject:indexPath];
        [selectedRowIndexes addIndex:indexPath.row ];
        if (selectedIndexpathArray.count==dataSourceArray.count) {
            [deleteView.allDeteleButton setTitle:@"取消全选" forState:UIControlStateNormal];
        }
    }
    else{
        KBMyCollectionDataModel *myCollectionDataModel=[dataSourceArray objectAtIndex:indexPath.row];
        [webviewInfoModel setWebviewInfoMyCollectionDataModel:myCollectionDataModel];
        for (NSMutableArray *typeOne in loginSingle.userAllTypeArray) {
            for (KBTwoSortModel *typeTwo in typeOne) {
                
                if (typeTwo.TypeTowID==[myCollectionDataModel.secondType intValue]) {
                    if ([loginSingle.userAllTypeArray indexOfObject:typeOne]==4) {
                        commomSingleValueModel.isRecommandTypeClass = true;
                        
                    } else {
                        commomSingleValueModel.isRecommandTypeClass = false;
                    }
                    break;
                }
            }
        }

        KBInfoWebViewController *infoWebViewController=[[KBInfoWebViewController alloc]init];
        [self.navigationController pushViewController:infoWebViewController animated:YES];
        [self.tableView reloadData];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    loadMoreText.text=@"全部加载完毕";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KBMyFooterViewCell *cell;
    KBMyCollectionDataModel *myCollectionDataModel=[dataSourceArray objectAtIndex:indexPath.row];
    static NSString *UsualIdentifier=@"Cell";
    cell=[self.tableView dequeueReusableCellWithIdentifier:UsualIdentifier];
    if(cell==nil)
    {
        cell=[[KBMyFooterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UsualIdentifier];
        
    }
    [cell setSelected:NO];
    [cell.customImageView yy_setImageWithURL:[NSURL URLWithString:myCollectionDataModel.imagestr] placeholder:[UIImage imageNamed:@"载入中小图"] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];

    //cell.customImageView.image = myCollectionDataModel.imageData;
        
    cell.titleLable.text =myCollectionDataModel.articleTitle ;
    
    [cell.TypeBtn setTitle:myCollectionDataModel.TypeName forState:UIControlStateNormal];
    
    cell.timeLable.text=myCollectionDataModel.time;
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [deleteArray addObject:[dataSourceArray objectAtIndex:indexPath.row]];
        [deleteIDArray addObject:[dataSourceArray objectAtIndex:indexPath.row]];
        [dataSourceArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - 返回Menu
-(void)popMyFooter{
    rootViewController *root=self.rootDelegate;
    [root scrollToMenu];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
