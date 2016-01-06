//
//  KBLoginView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBLoginView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBLogoAndBackView.h"
#import "KBCustomTextField.h"
#import "KBCustomButton.h"
#import "KB_RegisterAndLoginViewController.h"
#import "KBColor.h"
@interface KBLoginView ()<UITextFieldDelegate>
{
    //忘记密码按钮
    KBCustomButton* forgetPasswordButton;
}
@end

@implementation KBLoginView
- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC
{
    self = [super initWithFrame:frame];
    if (self) {
        KBLogoAndBackView *logoAndBackView = [[KBLogoAndBackView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 0.2*kWindowSize.height + 100)];
        [logoAndBackView setBackButtonTag:1 andLogoImage:@"340logow"];
        logoAndBackView.delegate = registerAndLoginVC;
        [self addSubview:logoAndBackView];
        
        //手机输入框
        self.userName = [[KBCustomTextField alloc] initWithFrame:CGRectMake(0.16*kWindowSize.width, logoAndBackView.bottom + 0.1*kWindowSize.height, 0.68*kWindowSize.width, 45) drawingLeftViewString:@"phone0" andIsImage:YES];
        [self.userName setTextFieldWithTag:1 andPlaceHolder:@"手机" andSecureTextEntry:NO andKeyBoardType:UIKeyboardTypeNumberPad andTextAlignment:NSTextAlignmentLeft];
        self.userName.delegate = self;
        [self addSubview:self.userName];
        
        //密码输入框
        self.password = [[KBCustomTextField alloc] initWithFrame:CGRectMake(self.userName.left, self.userName.bottom + 20, self.userName.width, self.userName.height) drawingLeftViewString:@"lock0" andIsImage:YES];
        [self.password setTextFieldWithTag:2 andPlaceHolder:@"密码" andSecureTextEntry:YES andKeyBoardType:UIKeyboardTypeDefault andTextAlignment:NSTextAlignmentLeft];
        self.password.returnKeyType=UIReturnKeyGo;
        self.password.delegate = self;
        [self addSubview:self.password];
        
        //登录按钮
        KBCustomButton* loginButton = [[KBCustomButton alloc] initWithFrame:CGRectMake(self.password.left, self.password.bottom + 20, self.password.width, self.password.height)];
        [loginButton setButtonWithBackgroundColor:KColor_19_127_238 andTitle:@"登  录" andBorderWidth:0 andBorderColor:nil andFont:[UIFont systemFontOfSize:20] andImageString:nil];
        [loginButton addTarget:self action:@selector(loginJugde) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        //没有账号？？标签
        KBCustomButton* registerButton = [[KBCustomButton alloc] initWithFrame:CGRectMake(loginButton.left+10, loginButton.bottom +20, 0.5*loginButton.width-10, 30)];
        [registerButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"没有账号？" andBorderWidth:0 andBorderColor:[UIColor whiteColor] andFont:nil andImageString:nil];
        registerButton.tag=26;
       [registerButton addTarget:registerAndLoginVC action:@selector(pushToOtherView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerButton];
        
        //忘记密码按钮
        forgetPasswordButton = [[KBCustomButton alloc] initWithFrame:CGRectMake(registerButton.right+20, registerButton.top, registerButton.width, registerButton.height)];
        forgetPasswordButton.tag=27;
        [forgetPasswordButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"忘记密码" andBorderWidth:0 andBorderColor:[UIColor whiteColor] andFont:nil andImageString:nil];
        [forgetPasswordButton addTarget:registerAndLoginVC action:@selector(pushToOtherView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetPasswordButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

#pragma mark - UITextFieldDelagate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(startEdit:)]) {
        [self.delegate startEdit:forgetPasswordButton.bottom];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(endEdit)]) {
        [self.delegate endEdit];
    }
}
#pragma mark - 键盘的go
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag==2) {
        [self.password resignFirstResponder];
        [self loginJugde];
    }
    return YES;
}

#pragma mark - login
-(void)loginJugde
{
    if ([_delegate respondsToSelector:@selector(loginJugde:withPassWord:)]) {
        [self.userName resignFirstResponder];
        [self.password resignFirstResponder];
        [_delegate loginJugde:self.userName.text withPassWord:self.password.text];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
