//
//  SchoolChoose.m
//  UIScroll1
//
//  Created by kuibu technology on 15/7/24.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBSchoolChooseViewController.h"
#import "KBLoginSingle.h"
#import "NSDictionary-DeepMutableCopy.h"
#import "KBPersonalDataViewController.h"
#import "KBBaseNavigationController.h"
#import "KBCommonSingleValueModel.h"
#import "UIView+ITTAdditions.h"

//cell的高度
#define USUAL_ROW_HEIGHT 45

@interface KBSchoolChooseViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView * SchoolChooseTableview;//tableView
    
    KBLoginSingle *loginSingle;//用户的单例
    
    UISearchBar *search;//搜素栏
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
}
@end
@implementation KBSchoolChooseViewController

@synthesize search;
@synthesize schoolsArray;
@synthesize schoolsdic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.view.backgroundColor=[UIColor whiteColor];
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
   
    //导航栏的title
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"学校列表";
    titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
    self.navigationItem.titleView=titleLable;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //导航栏的左侧返回按钮
    UIButton *leftBarBtn=[[UIButton alloc]init];
    leftBarBtn.contentMode=UIViewContentModeScaleAspectFit;
    [leftBarBtn setImage:[UIImage imageNamed: @"返回.png"] forState:UIControlStateNormal];
    [leftBarBtn setFrame:CGRectMake(14, 0, 11,19)];
    [leftBarBtn addTarget:self action:@selector(popPersonal) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    //读取学校的plist文件
    NSBundle *bundle=[NSBundle mainBundle];
    NSURL * plistURL=[bundle URLForResource:@"school" withExtension:@"plist"];
    NSDictionary *dictionary=[NSDictionary dictionaryWithContentsOfURL:plistURL];
    self.schoolsdic=dictionary;
    [self resetSearch]; //加载并填充words可变字典和keys数组
    
    //tabelview
    SchoolChooseTableview =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    SchoolChooseTableview.scrollsToTop=NO;
    SchoolChooseTableview.dataSource=self;
    SchoolChooseTableview.delegate=self;
    [self.view addSubview:SchoolChooseTableview];
    SchoolChooseTableview.sectionIndexBackgroundColor=[UIColor clearColor];
    
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    
    //搜索栏
    search=[[UISearchBar alloc] init];
    search.frame=CGRectMake(0, 44+statusBarHeight, self.view.width, 44);
    search.placeholder=@"搜索学校名称";
    search .showsCancelButton=YES;
    search.backgroundColor=[UIColor whiteColor];
    search.delegate=self;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
    search.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
    [self.view addSubview:search];
    SchoolChooseTableview.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.width,search.height+20 )];
    // Do any additional setup after loading the view.
}
#pragma mark -  取消搜索或者改变搜索条件
- (void)resetSearch
{
    self.allSchools = [self.schoolsdic mutableDeepCopy]; //得到所有字典的副本 得到一个字典
    
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];//创建一个可变数组
    [keyArray addObjectsFromArray:[[self.schoolsdic allKeys]sortedArrayUsingSelector:@selector(compare:)]]; //用指定的selector对array的元素进行排序
    self.schoolsArray= keyArray; //将所有key 存到一个数组里面
}
#pragma mark - 实现搜索方法
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsRemove = [[NSMutableArray alloc]init]; //创建一个数组存放我们所找到的空分区
    [self resetSearch];
    for(NSString *key in self.schoolsArray)//遍历所有的key
    {
        NSMutableArray *array = [self.allSchools valueForKey:key] ;     //得到当前键key的名称 数组
        NSMutableArray *toRemove = [[NSMutableArray alloc]init];//需要从words中删除的值 数组
        for(NSString *word in array) //实现搜索
        {
            if([word rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)//搜索时忽略大小写 把没有搜到的值 放到要删除的对象数组中去
                [toRemove addObject:word]; //把没有搜到的内容放到 toRemove中去
        }
        
        if([array count] == [toRemove count])//校对要删除的名称数组长度和名称数组长度是否相等
            [sectionsRemove addObject:key]; //相等 则整个分区组为空
        [array removeObjectsInArray:toRemove]; //否则 删除数组中所有与数组toRemove包含相同的元素
    }
    [self.schoolsArray removeObjectsInArray:sectionsRemove];// 删除整个key 也就是删除空分区，释放用来存储分区的数组，并重新加载table 这样就实现了搜索
    [SchoolChooseTableview reloadData];
}
#pragma mark - tableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSString * key=[schoolsArray objectAtIndex:section];
    NSArray * schools=[self.allSchools objectForKey:key];
    static NSString * GroupedTableViewIdentifier=@"NoteSectionIdentifier";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:GroupedTableViewIdentifier];
    if(cell==nil)
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupedTableViewIdentifier];
    cell.textLabel.text=[schools objectAtIndex:row];
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSString * key=[schoolsArray objectAtIndex:section];
    NSArray * schools=[self.allSchools objectForKey:key];
    loginSingle.userSchool=[schools objectAtIndex:row];
    commonSingleValueModel.schoolchangeBool=YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([schoolsArray count] == 0)
        return @" ";
    NSString *key = [schoolsArray objectAtIndex:section];
    return key;
}
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return schoolsArray;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder]; //点击任意 cell都会取消键盘
    return indexPath;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([schoolsArray count] == 0)
    {
        return 0;
    }
    NSString *key = [schoolsArray objectAtIndex:section]; //得到第几组的key
    NSArray *wordSection = [self.allSchools objectForKey:key]; //得到这个key里面所有的元素
    return [wordSection count]; //返回元素的个数
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return USUAL_ROW_HEIGHT;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ([schoolsArray count] >0)?[schoolsArray count]:1; //搜索时可能会删除所有分区 则要保证要有一个分区
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 搜索button点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm]; //搜索内容 删除words里面的空分区和不匹配内容
}
#pragma mark - 搜索内容随着输入及时地显示出来
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        [self resetSearch];
        [SchoolChooseTableview reloadData];
        return;
    }
    else
        [self handleSearchForTerm:searchText];
}
#pragma mark - 点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    search.text = @"";  //标题 为空
    [self resetSearch]; //重新 加载分类数据
    [SchoolChooseTableview reloadData];
    [searchBar resignFirstResponder]; //退出键盘
    
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
#pragma mark - 视图已经出现
-(void)viewDidAppear:(BOOL)animated
{
    KBBaseNavigationController *navVC  =(KBBaseNavigationController *)self.navigationController;
    navVC.canDragBack=YES;
}
#pragma mark - 返回Personal
-(void)popPersonal
{
    [self.navigationController popViewControllerAnimated:YES];
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
