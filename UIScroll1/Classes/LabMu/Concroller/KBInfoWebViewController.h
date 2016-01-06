




//WebView内容页面视图


#import <UIKit/UIKit.h>
//#import "TitleWebView.h"
#import "KBBaseNavigationController.h"
#import "KBMyCollectionDataModel.h"
#import <sqlite3.h>

@class  AppDelegate;
@interface KBInfoWebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    BOOL failed;
    
@private
    AppDelegate *_appDelegate;
}
@property id navdelegate;
@property UIButton *btn;
@property UIWebView * theWebView;
@property NSString *secondType;
@property BOOL isShow;
@property UIToolbar *toolBar1;
@property NSIndexPath * cancelCollectIndexPath;
-(void)like;
@end