//
//  NewSchoolChoose.m
//  UIScroll1
//
//  Created by kuibu technology on 15/11/21.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSchoolLocationViewController.h"
#import "KBLoginSingle.h"
#import "NSDictionary-DeepMutableCopy.h"
#import "KBPersonalDataViewController.h"
#import "KBBaseNavigationController.h"
#import "KBCommonSingleValueModel.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "KBColor.h"
#import "KBAboutKuiBuImageView.h"
#import "KBSchoolLocationRefreshView.h"
//cell的高度
#define USUAL_ROW_HEIGHT 60

@interface KBSchoolLocationViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,KBAboutKuiBuDelegate,KBAboutKuiBuDelegate,KBSchoolLocationRefreshViewDelegate>

{
    UITableView * newSchoolChooseTableview;//tableView
    
    KBLoginSingle *loginSingle;//用户的单例
    
    KBPersonalDataViewController * schoolChoose;//
    
    KBCommonSingleValueModel * commonSingleValueModel;//传值的单例
    
    KBSchoolLocationRefreshView * refreshView;//显示定位结果的view
    
    NSMutableArray * schoolArray;//学校的数组
    
    UILabel * schoolLabel;
    
    MBProgressHUD * hud;
    
    UILabel * imageLabel;//图片上的Label
    
    
}
@end

@implementation KBSchoolLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //刷新学校开始定位
    [self refreshSchool];
    //导航栏隐藏
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    //初始化
    schoolArray=[[NSMutableArray alloc]init];
    loginSingle=[KBLoginSingle newinstance];
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
     schoolLabel=[[UILabel alloc]init];
    
    //上方的imageView
    KBAboutKuiBuImageView *imageview = [[KBAboutKuiBuImageView alloc] initWithFrame:CGRectMake(0, 0,kWindowSize.width, 300) withImage:@"zhuozi"];
    imageview.delegate=self;
    //图片中的Label
    imageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,kWindowSize.width/2.0,50)];
    imageLabel.textColor=[UIColor whiteColor];
    imageLabel.center=imageview.center;
    imageLabel.textAlignment=NSTextAlignmentCenter;
    imageLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:25];
    
    [imageview addSubview:imageLabel];
    [self.view addSubview:imageview];
    
    //显示定位结果的view
    refreshView=[[KBSchoolLocationRefreshView alloc]initWithFrame:CGRectMake(imageview.left, imageview.bottom, kWindowSize.width, 40)];
    [self.view addSubview:refreshView];
    
    //分割view
    UIView * grayView=[[UIView alloc]initWithFrame:CGRectMake(refreshView.frame.origin.x, refreshView.frame.origin.y+refreshView.frame.size.height, kWindowSize.width, 2)];
    grayView.backgroundColor=KColor_235;
    [self.view addSubview:grayView];
    
    //tableView
    newSchoolChooseTableview =[[UITableView alloc]initWithFrame:CGRectMake(grayView.left, grayView.bottom, kWindowSize.width, kWindowSize.height) style:UITableViewStylePlain];
    newSchoolChooseTableview.bounces=NO;
    newSchoolChooseTableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    newSchoolChooseTableview.scrollsToTop=NO;
    newSchoolChooseTableview.dataSource=self;
    newSchoolChooseTableview.delegate=self;
    [self.view addSubview: newSchoolChooseTableview];
    // Do any additional setup after loading the view.
}
#pragma mark - 返回Menu
-(void)backToMenu
{
    [commonSingleValueModel.navcontrolDelegate popViewControllerAnimated:YES];
}
#pragma mark - 定位
-(void)refreshSchool
{
    refreshView.refreshLabel.text=@"正在定位中...";
    [self startLocation];
}
#pragma mark - 开始定位
-(void)startLocation
{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            self.locationManager=[[CLLocationManager alloc]init];
            self.locationManager.delegate=self;
            self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
            
            self.locationManager.distanceFilter=10.0f;
            [self.locationManager startUpdatingLocation];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.distanceFilter=10.0f;
        [self.locationManager startUpdatingLocation];
       
    }
}
#pragma mark - 定位的结果
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"locations is %@",locations);
    CLLocation *location = [locations lastObject];
    CLGeocoder * myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(error == nil && [placemarks count]>0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             if ([placemark.name rangeOfString:@"大学"].location!=NSNotFound) {
                 NSArray * schoolarray=[placemark.name componentsSeparatedByString:@"大学"];
                 schoolArray=[[NSMutableArray alloc]initWithArray:schoolarray];
                 schoolLabel.text=[NSString stringWithFormat:@"%@",[schoolArray objectAtIndex:0]];
                 schoolLabel.text=[schoolLabel.text stringByAppendingString:@"大学"];
                 imageLabel.text=schoolLabel.text;
                 refreshView.refreshLabel.text=[NSString stringWithFormat:@"共1项结果"];

             }
             else if ([placemark.name rangeOfString:@"学院"].location!=NSNotFound)
             {
                 NSArray * schoolarray=[placemark.name componentsSeparatedByString:@"学院"];
                 schoolArray=[[NSMutableArray alloc]initWithArray:schoolarray];
                 schoolLabel.text=[NSString stringWithFormat:@"%@",[schoolArray objectAtIndex:0]];
                 schoolLabel.text=[schoolLabel.text stringByAppendingString:@"学院"];
                  imageLabel.text=schoolLabel.text;
                 refreshView.refreshLabel.text=[NSString stringWithFormat:@"共1项结果"];

             }
             else if ([placemark.name rangeOfString:@"学校"].location!=NSNotFound)
             {
                 NSArray * schoolarray=[placemark.name componentsSeparatedByString:@"学校"];
                 schoolArray=[[NSMutableArray alloc]initWithArray:schoolarray];
                 schoolLabel.text=[NSString stringWithFormat:@"%@",[schoolArray objectAtIndex:0]];
                 schoolLabel.text=[schoolLabel.text stringByAppendingString:@"学校"];
                  imageLabel.text=schoolLabel.text;
                 refreshView.refreshLabel.text=[NSString stringWithFormat:@"共1项结果"];

             }
             else
             {
                refreshView.refreshLabel.text=[NSString stringWithFormat:@"共0项结果"];
             }
             NSLog(@"name = %@ school.text:%@",placemark.name,schoolLabel.text);
             [newSchoolChooseTableview reloadData];
         }
         else if(error==nil && [placemarks count]==0){
             refreshView.refreshLabel.text=[NSString stringWithFormat:@"共0项结果"];
              [newSchoolChooseTableview reloadData];

         }
         else if(error != nil) {
             refreshView.refreshLabel.text=[NSString stringWithFormat:@"共0项结果"];
             [newSchoolChooseTableview reloadData];
             //NSLog(@"An error occurred = %@", error);
         }
     }];
    [self.locationManager stopUpdatingLocation];
}
#pragma mark - tableView dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  USUAL_ROW_HEIGHT;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return schoolArray.count/2.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    loginSingle.userSchool=cell.textLabel.text;
    commonSingleValueModel.schoolchangeBool=YES;
    [commonSingleValueModel.navcontrolDelegate popViewControllerAnimated:YES];
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *FindAllIdentifier=@"school";
    cell=[tableView dequeueReusableCellWithIdentifier:FindAllIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FindAllIdentifier];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=schoolLabel.text;
    [cell.textLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
    cell.textLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.font=[UIFont systemFontOfSize:18];
    return  cell;
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [self refreshSchool];
    self.navigationController.navigationBarHidden=YES;
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
