//
//  rootViewController.m
//  UIScroll1
//
//  Created by eddie on 15-3-20.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "rootViewController.h"
#import "Reachability.h"
#import "KBMainViewController.h"
#import "KBCommonSingleValueModel.h"
#import "KBMyVIewController.h"
@interface rootViewController ()
{
    UIImageView *shadowImageView;
    BOOL isExistShadow;
    KBMyVIewController *menuController;
    KBCommonSingleValueModel  *transport;
}
@end

@implementation rootViewController
@synthesize scView=_scView;
@synthesize nav;
float DEVICE_WIDTH,DEVICE_HEIGHT;

struct PPoint{
    float x,y;
};
struct PPoint touch_Begin;
struct PPoint touch_Current;
struct PPoint touch_End;
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    NSLog(@"error%@",error);
//}
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    NSError *err;
//    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
//    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@--------",json);
//
//}
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    NSLog(@"response------%@",response);
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    DEVICE_WIDTH-=[UIScreen mainScreen].bounds.size.width;
    DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
    
    transport=[KBCommonSingleValueModel newinstance];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enable) name:@"SCROLL_ENABLE" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(disable) name:@"SCROLL_DISABLE" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollToMenuNoAnimate) name:@"SCROLL_TO_MENU_NOANIMATE" object:nil];
    
    menuController=[[KBMyVIewController alloc]init];
    
    if(DEVICE_WIDTH==414)
    {
        [menuController.view setFrame:CGRectMake(0, 0, 0.75*DEVICE_WIDTH-0.1, DEVICE_HEIGHT)];
    }
    else
        [menuController.view setFrame:CGRectMake(0, 0, 0.75*DEVICE_WIDTH, DEVICE_HEIGHT)];
    
    menuController.rootDelegate=self;
    
    [self addChildViewController:menuController];
    
    
    KBMainViewController *main=[[KBMainViewController alloc]init];
    
    nav=[[KBBaseNavigationController alloc]initWithRootViewController:main];
    main.navdelegate=nav;
    nav.delegateroot=self;
    
    view2=[[UIView alloc]initWithFrame:CGRectMake(0.75*DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [view2 addSubview: nav.view];
    
    view3 =[[UIView alloc]initWithFrame:CGRectMake(0.75*DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    //[view3 setBackgroundColor:[UIColor blackColor]];
    [view3 setAlpha:0];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollToMenu)];
    
    // [view1 setBackgroundColor:[UIColor redColor]];
    
    
    self.scView=[[MainScroll alloc]initWithFrame:CGRectMake(-0.1, 0, DEVICE_WIDTH,DEVICE_HEIGHT)];
    
    if(DEVICE_WIDTH==414)
    {
        self.scView=[[MainScroll alloc]initWithFrame:CGRectMake(-0.5, 0, DEVICE_WIDTH+1,DEVICE_HEIGHT)];
    }
    else
        self.scView=[[MainScroll alloc]initWithFrame:CGRectMake(-0.1, 0, DEVICE_WIDTH,DEVICE_HEIGHT)];
    
    self.scView.scrollsToTop=NO;
    self.scView.pagingEnabled=YES;
    self.scView.isMainState=true;
    if (DEVICE_WIDTH==375) {
        self.scView.contentSize=CGSizeMake((DEVICE_WIDTH)*1.75-0.5  , DEVICE_HEIGHT);
    }
    
    else if(DEVICE_WIDTH==414)
    {
        self.scView.contentSize=CGSizeMake((DEVICE_WIDTH)*1.75+0.5  , DEVICE_HEIGHT);
        
    }
    
    
    else{
        self.scView.contentSize=CGSizeMake(DEVICE_WIDTH*1.75  , DEVICE_HEIGHT);
    }
    
    [self.scView setScrollEnabled:NO];
    
    [self.view addSubview:self.scView];
    
    [self.scView addSubview:menuController.view];
    [self.scView addSubview:view2];
    
    
    self.scView.bounces=NO;
    self.scView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    self.scView.showsVerticalScrollIndicator=NO;
    self.scView.showsHorizontalScrollIndicator=NO;
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnMain)];
    
    
    self.scView.scrollEnabled=YES;
    
    
    
    self.scView.delegate=self;
    
    self.scView.pagingEnabled=YES;
    [self.scView addSubview:view3];
    [[view3 superview]bringSubviewToFront:view3];
    view3.userInteractionEnabled=YES;
    
    if(DEVICE_WIDTH==414)
    {
        [self.scView setContentOffset:CGPointMake(0.75*DEVICE_WIDTH-0.5, 0)];
        
    }
    else
        [self.scView setContentOffset:CGPointMake(0.75*DEVICE_WIDTH, 0)];
    
    
    isExistShadow=NO;
    
    //
    //    //让Reachability对象开启被监听状态
    //
    //    [reach startNotifier];
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    //NSLog(@"deviceWidth:%f DeviceHeghy:%f",DEVICE_WIDTH,DEVICE_HEIGHT);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.view setFrame:CGRectMake(0, 0, DEVICE_WIDTH-0.5, DEVICE_HEIGHT)];
    
    
}

-(void)enable{
    self.scView.scrollEnabled=YES;
    
}

-(void)disable{
    self.scView.scrollEnabled=NO;
}
-(void)returnMain{
    if(DEVICE_WIDTH==414)
    {
        [self.scView  setContentOffset:CGPointMake(0.75*DEVICE_WIDTH-0.5, 0) animated:YES] ;
    }
    else if(DEVICE_WIDTH==375)
        [self.scView  setContentOffset:CGPointMake(0.75*DEVICE_WIDTH-0.1, 0) animated:YES] ;

    else
        
        [self.scView  setContentOffset:CGPointMake(0.75*DEVICE_WIDTH, 0) animated:YES] ;
    
    self.scView.isMainState=true;
    
    
    KBMainViewController *main=nav.delegatemain;
    main.view.userInteractionEnabled=YES;
    [view3 removeGestureRecognizer:tap];
}
-(void) scrollToMenu{
    
    // NSLog(@"scrollToMenu");
    if(DEVICE_WIDTH==414)
    {
        [self.scView  setContentOffset:CGPointMake(-0.1, 0) animated:YES] ;
    }
    else
        [self.scView  setContentOffset:CGPointMake(0, 0) animated:YES] ;
    self.scView.isMainState=false;
    KBMainViewController *main=nav.delegatemain;
    main.view.userInteractionEnabled=NO;
    [view3 addGestureRecognizer:tap];
    
    
    
}
-(void)scrollToMenuNoAnimate{
    
    if(DEVICE_WIDTH==414)
    {
        [self.scView  setContentOffset:CGPointMake(-0.1, 0) animated:YES] ;
    }
    else
        [self.scView  setContentOffset:CGPointMake(0, 0) animated:YES] ;
    
    
    self.scView.isMainState=false;
    KBMainViewController *main=nav.delegatemain;
    
    main.view.userInteractionEnabled=NO;
    [view3 addGestureRecognizer:tap];
    
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if(scrollView.contentOffset.x<0.5*DEVICE_WIDTH)
//    {
//        [self scrollToMenu];
//    }
//
//    else
//    {
//        [self returnMain];
//    }
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isExistShadow&&scrollView.contentOffset.x!=DEVICE_WIDTH*0.75)
    {
        shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"阴影右"]];
        shadowImageView.frame = CGRectMake(0, 0, 10, self.view.frame.size.height);
        
        // NSLog(@"scarrarrroorlllllllllll");
        [view2 addSubview:shadowImageView];
        isExistShadow=YES;
        
    }
    if (scrollView.contentOffset.x>(DEVICE_WIDTH*0.75-5)&&isExistShadow) {
        [shadowImageView removeFromSuperview];
        isExistShadow=NO;
    }
    float alpha=1.0-scrollView.contentOffset.x/(0.75*DEVICE_WIDTH);
    if(alpha<0.5)
        [view3 setAlpha:alpha];
    else [view3 setAlpha:0.5];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
