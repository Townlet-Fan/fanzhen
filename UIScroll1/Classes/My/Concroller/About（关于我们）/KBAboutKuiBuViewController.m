//
//  AboutKuiBuViewController.m
//  UIScroll1
//
//  Created by kuibu technology on 15/11/17.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBAboutKuiBuViewController.h"
#import "KBBaseNavigationController.h"
#import "rootViewController.h"
#import "KBCommonSingleValueModel.h"
#import "KBColor.h"
#import "KBConstant.h"
#import "KBAboutKuiBuImageView.h"
@interface KBAboutKuiBuViewController ()<UIScrollViewDelegate,KBAboutKuiBuDelegate>
{
    UIScrollView *scrollView;//scrollview
    
    KBCommonSingleValueModel *commonSingleValueModel;//传值的单例
}
@end

@implementation KBAboutKuiBuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化单例
    commonSingleValueModel=[KBCommonSingleValueModel newinstance];
    self.navigationController.navigationBarHidden=YES;
    //初始化scrollview
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20,kWindowSize.width, kWindowSize.height+20)];
    scrollView.tag=101;
    scrollView.scrollsToTop=NO;
    scrollView.delegate=self;
    scrollView.showsHorizontalScrollIndicator=NO;
    [scrollView setContentSize:CGSizeMake(kWindowSize.width*4, 0)];
    [scrollView setPagingEnabled:YES];  //视图整页显示
    [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
    
    //scrollview的第一个Image
    KBAboutKuiBuImageView *imageView = [[KBAboutKuiBuImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width,kWindowSize.height) withImage:@"引导1.jpg"];
    imageView.delegate=self;
    [scrollView addSubview:imageView];
    
    //scrollview的第二个Image
    KBAboutKuiBuImageView *imageView1 = [[KBAboutKuiBuImageView alloc] initWithFrame:CGRectMake(kWindowSize.width, 0, kWindowSize.width, kWindowSize.height) withImage:@"引导2.jpg"];
    imageView1.delegate=self;
    [scrollView addSubview:imageView1];
    
    //scrollview的第三个Image
    KBAboutKuiBuImageView *imageView2 = [[KBAboutKuiBuImageView alloc] initWithFrame:CGRectMake(kWindowSize.width*2, 0, kWindowSize.width, kWindowSize.height) withImage:@"引导3.jpg"];
    imageView2.delegate=self;
    [scrollView addSubview:imageView2];
    
    //scrollview的第四个Image
    KBAboutKuiBuImageView *imageView3 = [[KBAboutKuiBuImageView alloc] initWithFrame:CGRectMake(kWindowSize.width*3, 0,kWindowSize.width, kWindowSize.height) withImage:@"引导4.jpg"];
    imageView3.delegate=self;
    [scrollView addSubview:imageView3];
    
    [self.view addSubview:scrollView];

    // Do any additional setup after loading the view.
}
#pragma mark - 返回到Menu
-(void)backToMenu
{
    rootViewController *root=self.rootDelegate;
    [root scrollToMenu];
    [commonSingleValueModel.navcontrolDelegate popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}
#pragma mark  - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCROLL_ENABLE" object:nil];
     self.navigationController.navigationBarHidden=NO;
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
