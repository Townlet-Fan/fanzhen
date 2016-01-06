




//WebView内容页面视图


#import <UIKit/UIKit.h>

@interface KBInfoWebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
/**
 *  导航控制器协议代理
 */
@property (nonatomic,strong)id navdelegate;

/**
 *  webview
 */
@property (nonatomic,strong) UIWebView * theWebView;
/**
 *  toolbar
 */
@property (nonatomic,strong) UIToolbar *toolBar;
/**
 *  取消收藏的Indexpath
 */
@property  NSIndexPath * cancelCollectIndexPath;
@end