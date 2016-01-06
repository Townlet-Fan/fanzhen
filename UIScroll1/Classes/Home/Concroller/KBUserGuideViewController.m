//
//  UserGuideViewController.m
//  UIScroll1
//
//  Created by kuibu technology on 15/10/7.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBUserGuideViewController.h"
#import "rootViewController.h"
#import "KBMainViewController.h"
#import "UMessage.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface KBUserGuideViewController ()

{
    UIScrollView *scrollView;
    UIPageControl * pagecontrol;
   
}
@end

@implementation KBUserGuideViewController
@synthesize NavigationController;
@synthesize locationManager;
float DEVICE_WIDTH,DEVICE_HEIGHT;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGuide];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (![defaults objectForKey:@"intro_screen_viewed"]) {
//        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
//        self.introView.delegate = self;
//        self.introView.backgroundColor = [UIColor greenColor];
//        [self.view addSubview:self.introView];
//    }

    // Do any additional setup after loading the view.
}
-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     
        rootViewController * rootviewController=[[rootViewController alloc]init];
        [self presentViewController:rootviewController animated:NO completion:^{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                //register remoteNotification types （iOS 8.0及其以上版本）
                UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
                action1.identifier = @"action1_identifier";
                action1.title=@"Accept";
                action1.activationMode =UIUserNotificationActivationModeForeground;//当点击的时候启动程序
                
                UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
                action2.identifier = @"action2_identifier";
                action2.title=@"Reject";
                action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
                action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
                action2.destructive = YES;
                
                UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
                categorys.identifier = @"category1";//这组动作的唯一标示
                [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
                
                UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                             categories:[NSSet setWithObject:categorys]];
                [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
                
            } else{
                //register remoteNotification types (iOS 8.0以下)
                //        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
                //         |UIRemoteNotificationTypeSound
                //         |UIRemoteNotificationTypeAlert];
            }
#else
            
            //register remoteNotification types (iOS 8.0以下)
            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
             |UIRemoteNotificationTypeSound
             |UIRemoteNotificationTypeAlert];
            
#endif
            
            //for log
            [UMessage setLogEnabled:YES];
            
            
        }];
    } completion:^(BOOL finished) {
        [self.inputView removeFromSuperview];
    }];
}


- (void)initGuide
 {
     DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
     DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
     scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
     scrollView.tag=101;
     scrollView.scrollsToTop=NO;
     scrollView.delegate=self;
     scrollView.showsHorizontalScrollIndicator=NO;
     [scrollView setContentSize:CGSizeMake(DEVICE_WIDTH*4, 0)];
     [scrollView setPagingEnabled:YES];  //视图整页显示
     [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
     [self push];
     [self permissionToplace];
//     pagecontrol=[[UIPageControl alloc]init];
//     [pagecontrol sizeToFit];
//     pagecontrol.currentPage=0;
//     pagecontrol.tag=111;
//     [pagecontrol setCenter:CGPointMake(DEVICE_WIDTH*0.5, 0.8*DEVICE_HEIGHT)];
//     [pagecontrol addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
//     pagecontrol.numberOfPages=4;
     
     UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
     [imageview setImage:[UIImage imageNamed:@"引导1.jpg"]];
     [scrollView addSubview:imageview];
     
   
     UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
     [imageview1 setImage:[UIImage imageNamed:@"引导2.jpg"]];
     [scrollView addSubview:imageview1];
     
    
     UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*2, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
     [imageview2 setImage:[UIImage imageNamed:@"引导3.jpg"]];
     [scrollView addSubview:imageview2];
     
     UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*3, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
     [imageview3 setImage:[UIImage imageNamed:@"引导4.jpg"]];
     imageview3.userInteractionEnabled = YES;    //打开imageview3的用户交互;否则下面的button无法响应
     [scrollView addSubview:imageview3];
     
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
     [button setTitle:@"进入" forState:UIControlStateNormal];
     button.titleLabel.font= [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
     [button setFrame:CGRectMake(DEVICE_WIDTH-100 , DEVICE_HEIGHT-60, 100, 40)];
     [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
     [imageview3 addSubview:button];
     
     
     [self.view addSubview:scrollView];
    // [self.view addSubview:pagecontrol];
}
-(void)push{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                //register remoteNotification types （iOS 8.0及其以上版本）
                UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
                action1.identifier = @"action1_identifier";
                action1.title=@"Accept";
                action1.activationMode =UIUserNotificationActivationModeForeground;//当点击的时候启动程序
                
                UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
                action2.identifier = @"action2_identifier";
                action2.title=@"Reject";
                action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
                action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
                action2.destructive = YES;
                
                UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
                categorys.identifier = @"category1";//这组动作的唯一标示
                [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
                
                UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                             categories:[NSSet setWithObject:categorys]];
                [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
                
            } else{
                //register remoteNotification types (iOS 8.0以下)
                //        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
                //         |UIRemoteNotificationTypeSound
                //         |UIRemoteNotificationTypeAlert];
            }
#else
            
            //register remoteNotification types (iOS 8.0以下)
            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
             |UIRemoteNotificationTypeSound
             |UIRemoteNotificationTypeAlert];
            
#endif
            
            //for log
            [UMessage setLogEnabled:YES];
            
            
    
    
}

-(void)permissionToplace
{
    locationManager=[[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = 10;
    //[locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

- (void)firstpressed
 {
     [self presentViewController:[[rootViewController alloc] init] animated:NO completion:^{
         
        // [self permissionToplace];
     }];
     //[self.navigationController pushViewController:[[rootViewController alloc] init] animated:YES];
     
 }
//- (void)pageTurn:(UIPageControl*)sender
//{
//    //令UIScrollView做出相应的滑动显示
//    CGSize viewSize =scrollView .frame.size;
//    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
//    [scrollView scrollRectToVisible:rect animated:YES];
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView1
//{
//    if(pagecontrol.tag==111){
//        CGPoint curretPoint = scrollView1.contentOffset;
//        int pageCount = curretPoint.x/DEVICE_WIDTH;
//        
//        pagecontrol.currentPage=pageCount;
//    }
//}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView1

{
    int currentNum=scrollView1.contentOffset.x/DEVICE_WIDTH;
    if(currentNum==4)
    {
        [self destroyScrollView];
    }
}
-(void)destroyScrollView
{
    UIScrollView * scrollview=(UIScrollView *)[self.view viewWithTag:101];
    UIPageControl * Pagecontrol=(UIPageControl *)[self.view viewWithTag:111];
    [UIView animateWithDuration:1.5f animations:^{
        scrollview.center=CGPointMake(-DEVICE_WIDTH/2.0, DEVICE_HEIGHT/2.0) ;
        
    } completion:^(BOOL finished) {
        [scrollview removeFromSuperview];
        [Pagecontrol removeFromSuperview];
        
    }];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
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
