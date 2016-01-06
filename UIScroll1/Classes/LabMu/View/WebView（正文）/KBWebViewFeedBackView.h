//
//  SubView.h
//  SubView
//
//  Created by 樊振 on 15/9/17.
//  Copyright (c) 2015年 樊振. All rights reserved.
//

//WebView下的反馈视图

#import <UIKit/UIKit.h>

@interface KBWebViewFeedBackView : UIView
/**
 *  反馈最上的label
 */
@property (nonatomic,strong) UILabel *feedBackLabel;
/**
 *  反馈的第一个输入框
 */
@property (nonatomic,strong) UITextField *textField;
/**
 *  反馈的第二个输入框
 */
@property (nonatomic,strong) UITextField *textField1;
/**
 *  提交反馈的button
 */
@property (nonatomic,strong) UIButton *feedBackButton;

@end
