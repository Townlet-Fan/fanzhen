//
//  HotTableVC.h
//  UIScroll1
//
//  Created by eddie on 15-4-19.
//  Copyright (c) 2015年 Test. All rights reserved.

//内容界面的主 TableViewController 里面嵌套 WebView

#import <UIKit/UIKit.h>

@class UICopyLable,KBWebViewCommentCell;
@interface KBInfoTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
/**
 *  评论的textView
 */
@property (nonatomic,strong) UITextView *textView;
/**
 *  代理
 */
@property (nonatomic,strong)  id parentDelegate;
/**
 *  评论的数组
 */
@property (nonatomic,strong) NSMutableArray * commentArray;
/**
 *  tabelview
 */
@property (nonatomic,strong) UITableView *commentTableView;
/**
 *  默认输入的字符串
 */
@property (nonatomic,strong)  NSString *placeHolderStr;
/**
 *  默认输入的Label
 */
@property (nonatomic,strong) UILabel *placeHolderLable;
/**
 *  评论的Id
 */
@property (nonatomic,assign) NSInteger commentId;
/**
 *  文章 pageId
 */
@property (nonatomic,assign) NSInteger pageId;
/**
 *  webview
 */
@property (nonatomic,strong) UIWebView *webview;
/**
 *  toolbar
 */
@property (nonatomic,strong) UIView *toolBar;
/**
 *  是否显示反馈View
 */
@property (nonatomic,assign) BOOL isFeedBackShow;

/**
 *  webview下面的view
 */
@property (nonatomic,strong) UIView *subView;
/**
 *  评论回复的刷新
 *
 *  @param replynum 回复数
 */
-(void)refreshReplyCount:(int )replynum;
/**
 *  选中哪个评论
 *
 *  @param selectedIndex 选中评论的标记
 */
-(void )discussSelectedIndex:(NSIndexPath *) selectedIndex;
/**
 *  评论的数组
 *
 *  @param discussArr 评论的数组
 */
-(void )discussArray:(NSMutableArray * )discussArr;

-(void)webviewOtherInfo;
@end
