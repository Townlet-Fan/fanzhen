//
//  KBRegisterView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBRegisterView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBCustomTextField.h"
#import "KBCustomButton.h"
#import "KBLogoAndBackView.h"
#import "KB_RegisterAndLoginViewController.h"
#import "KBColor.h"
#import "KBCommonSingleValueModel.h"
@interface KBRegisterView ()<UITextFieldDelegate>
{
    //手机
    KBCustomTextField* userName;
    
    //密码
    KBCustomTextField* password;
    
    //验证码
    KBCustomTextField* identifyingCode;
    
    //已有账号登陆标签
    KBCustomButton *havedRegisterButton;
    
    //注册
    KBCustomButton* registerButton;
}
@end

@implementation KBRegisterView

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC
{
    self = [super initWithFrame:frame];
    if (self) {
        //返回键
        KBLogoAndBackView *logoAndBackView = [[KBLogoAndBackView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 0.2*kWindowSize.height + 100)];
        [logoAndBackView setBackButtonTag:1 andLogoImage:@"340logow"];
        logoAndBackView.delegate = registerAndLoginVC;
        [self addSubview:logoAndBackView];
        
        //手机输入框
        userName = [[KBCustomTextField alloc] initWithFrame:CGRectMake(0.16*kWindowSize.width, logoAndBackView.bottom + 0.1*kWindowSize.height, 0.68*kWindowSize.width, 45) drawingLeftViewString:@"phone0" andIsImage:YES];
        [userName setTextFieldWithTag:1 andPlaceHolder:@"手机" andSecureTextEntry:NO andKeyBoardType:UIKeyboardTypeNumberPad andTextAlignment:NSTextAlignmentLeft];
        userName.delegate = self;
        [self addSubview:userName];


        //密码输入框
        password = [[KBCustomTextField alloc] initWithFrame:CGRectMake(userName.left, userName.bottom + 20, userName.width, userName.height) drawingLeftViewString:@"lock0" andIsImage:YES];
        [password setTextFieldWithTag:2 andPlaceHolder:@"密码" andSecureTextEntry:YES andKeyBoardType:UIKeyboardTypeDefault andTextAlignment:NSTextAlignmentLeft];
        password.returnKeyType = UIReturnKeyGo;
        password.delegate = self;
        [self addSubview:password];
        
        //验证码框
        identifyingCode = [[KBCustomTextField alloc] initWithFrame:CGRectMake(password.left, password.bottom + 20, 0.6*password.width, password.height) drawingLeftViewString:@"验证码" andIsImage:YES];
        identifyingCode.leftView=[[UIView alloc]initWithFrame:
        CGRectMake(0, 0, 10, identifyingCode.height)];
        [identifyingCode setTextFieldWithTag:3 andPlaceHolder:@"验证码" andSecureTextEntry:NO andKeyBoardType:UIKeyboardTypeNumberPad andTextAlignment:NSTextAlignmentLeft];
        [identifyingCode setValue:KColor_191 forKeyPath:@"_placeholderLabel.textColor"];
        identifyingCode.delegate = self;
        [self addSubview:identifyingCode];
        
        //获取验证码按钮
        KBCustomButton* getIdentifyingCodeButton = [[KBCustomButton alloc]initWithFrame:CGRectMake(identifyingCode.right +10, identifyingCode.top, 0.4*password.width-10, identifyingCode.height)];
        [getIdentifyingCodeButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"获取验证" andBorderWidth:1 andBorderColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:16] andImageString:nil];
        [getIdentifyingCodeButton addTarget:self action:@selector(getIdentifyCode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:getIdentifyingCodeButton];
        
        //注册按钮
        registerButton = [[KBCustomButton alloc]initWithFrame:CGRectMake(identifyingCode.left, identifyingCode.bottom + 20, password.width, password.height)];
        registerButton.tag=24;
        [registerButton setButtonWithBackgroundColor:KColor_19_127_238 andTitle:@"注   册" andBorderWidth:0 andBorderColor:nil andFont:[UIFont systemFontOfSize:20] andImageString:nil];
        [registerButton addTarget:self action:@selector(registerJudge) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerButton];
        
        //已有账号登录标签
        havedRegisterButton = [[KBCustomButton alloc] initWithFrame:CGRectMake(0, 0, registerButton.width, 20)];
        havedRegisterButton.center = CGPointMake(0.5*kWindowSize.width, registerButton.bottom + 40);
        [havedRegisterButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"已有账号登录>>" andBorderWidth:0 andBorderColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:16] andImageString:nil];
        havedRegisterButton.tag=25;
        [havedRegisterButton addTarget:registerAndLoginVC action:@selector(pushToOtherView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:havedRegisterButton];
    }
    return self;
}

#pragma mark - UITextFieldDelagate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(startEdit:)]) {
        [self.delegate startEdit:registerButton.bottom-registerButton.height];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(endEdit)]) {
        [self.delegate endEdit];
    }
}
#pragma mark - UIResponder点击屏幕其他地方隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [identifyingCode resignFirstResponder];
}
#pragma mark - 获取验证码
-(void)getIdentifyCode
{
    if ([_delegate respondsToSelector:@selector(getIdentifyCode:)]) {
        [userName resignFirstResponder];
        [password resignFirstResponder];
        [KBCommonSingleValueModel newinstance].isForgetPw=NO;
        [_delegate getIdentifyCode:userName.text];
    }
}
#pragma mark - 键盘的go
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag==2) {
        [userName resignFirstResponder];
        [password resignFirstResponder];
        [identifyingCode resignFirstResponder];
        [self registerJudge];
    }
    return YES;
}
#pragma mark - 注册
-(void)registerJudge
{
    if ([_delegate respondsToSelector:@selector(registerJudge:withPassWord:withIdentifyCode:)]) {
        [userName resignFirstResponder];
        [password resignFirstResponder];
        [identifyingCode resignFirstResponder];
        [_delegate registerJudge:userName.text withPassWord:password.text withIdentifyCode:identifyingCode.text];
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
