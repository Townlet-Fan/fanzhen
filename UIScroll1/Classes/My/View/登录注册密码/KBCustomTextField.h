//
//  RegisterTextField.h
//  UIScroll1
//
//  Created by kuibu on 15/12/7.
//  Copyright © 2015年 Test. All rights reserved.
//

//自定义TextField，使输入框左边view有一定间距
#import <UIKit/UIKit.h>

@interface KBCustomTextField : UITextField

-(id)initWithFrame:(CGRect)frame drawingLeftViewString:(NSString*)string andIsImage:(BOOL)isImage;

//对TextField设置属性
- (void)setTextFieldWithTag:(NSInteger)tag andPlaceHolder:(NSString*)string andSecureTextEntry:(BOOL)isSecure andKeyBoardType:(UIKeyboardType)keyBoardType andTextAlignment:(NSTextAlignment)textAlignment;

@end
