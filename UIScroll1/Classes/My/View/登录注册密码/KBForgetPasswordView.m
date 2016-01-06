//
//  KBForgetPasswordView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBForgetPasswordView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBLogoAndBackView.h"
#import "KBCustomTextField.h"
#import "KBCustomButton.h"
#import "KB_RegisterAndLoginViewController.h"
#import "KBColor.h"
#import "KBCommonSingleValueModel.h"
@interface KBForgetPasswordView ()<UITextFieldDelegate>
{
    KBCustomTextField* userName;//手机号
}
@end

@implementation KBForgetPasswordView

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC
{
    self = [super initWithFrame:frame];
    if (self) {
        //返回键
        KBLogoAndBackView *logoAndBackView = [[KBLogoAndBackView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 0.2*kWindowSize.height + 100)];
        [logoAndBackView setBackButtonTag:4 andLogoImage:nil];
        logoAndBackView.delegate = registerAndLoginVC;
        [self addSubview:logoAndBackView];
        
        //手机输入框
        userName = [[KBCustomTextField alloc] initWithFrame:CGRectMake(0.16*kWindowSize.width, 0.3*kWindowSize.height, 0.68*kWindowSize.width, 45) drawingLeftViewString:@"phone0" andIsImage:YES];
        [userName setTextFieldWithTag:1 andPlaceHolder:@"手机" andSecureTextEntry:NO andKeyBoardType:UIKeyboardTypeNumberPad andTextAlignment:NSTextAlignmentLeft];
        userName.delegate = self;
        [self addSubview:userName];
        
        //验证码
        self.identifyingCode = [[KBCustomTextField alloc] initWithFrame:CGRectMake(userName.left, userName.bottom + 20, 0.6*userName.width, userName.height) drawingLeftViewString:@"验证码" andIsImage:YES];
        self.identifyingCode.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.identifyingCode.height)];
        [self.identifyingCode setTextFieldWithTag:3 andPlaceHolder:@"验证码" andSecureTextEntry:NO andKeyBoardType:UIKeyboardTypeNumberPad andTextAlignment:NSTextAlignmentLeft];
        [self.identifyingCode setValue:KColor_191 forKeyPath:@"_placeholderLabel.textColor"];
        self.identifyingCode.delegate = self;
        [self addSubview:self.identifyingCode];
        
        //获取验证码按钮
        KBCustomButton* getIdentifyingCodeButton = [[KBCustomButton alloc]initWithFrame:CGRectMake(self.identifyingCode.right +10, self.identifyingCode.top, 0.4*userName.width -10, self.identifyingCode.height)];
        [getIdentifyingCodeButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"获取验证" andBorderWidth:1 andBorderColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:16] andImageString:nil];
        [getIdentifyingCodeButton addTarget:self action:@selector(getIdentifyCode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:getIdentifyingCodeButton];
        
        KBCustomButton* modifyPassword = [[KBCustomButton alloc] initWithFrame:CGRectMake(self.identifyingCode.left, self.identifyingCode.bottom + 20, userName.width, userName.height)];
        modifyPassword.tag=28;
        [modifyPassword setButtonWithBackgroundColor:KColor_19_127_238 andTitle:@"下 一 步" andBorderWidth:0 andBorderColor:nil andFont:nil andImageString:nil];
        [modifyPassword addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:modifyPassword];
    }
    return self;
}

#pragma mark - UIResponder点击屏幕其他地方隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userName resignFirstResponder];
    [self.identifyingCode resignFirstResponder];
}
#pragma mark - 完成编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(endEdit)]) {
        [self.delegate endEdit];
    }
}
#pragma  mark - 获取验证码
-(void)getIdentifyCode
{
    if ([_delegate respondsToSelector:@selector(getIdentifyCode:)]) {
        [KBCommonSingleValueModel newinstance].isForgetPw=YES;
        [_delegate getIdentifyCode:userName.text];
    }
}
#pragma mark - 下一步
-(void)nextStep
{
    if ([_delegate respondsToSelector:@selector(nextStep:withIdentifyCode:)]) {
        [self.identifyingCode resignFirstResponder];
        [_delegate nextStep:userName.text withIdentifyCode:self.identifyingCode.text];
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
