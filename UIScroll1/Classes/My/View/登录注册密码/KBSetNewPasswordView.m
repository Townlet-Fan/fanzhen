//
//  KBSetNewPasswordView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBSetNewPasswordView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBLogoAndBackView.h"
#import "KBCustomTextField.h"
#import "KBCustomButton.h"
#import "KB_RegisterAndLoginViewController.h"
#import "KBColor.h"
@interface KBSetNewPasswordView ()<UITextFieldDelegate>
{
    KBCustomTextField* newPassword;
    
    KBCustomTextField* confirmPassword;
}
@end

@implementation KBSetNewPasswordView

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC
{
    self = [super initWithFrame:frame];
    if (self) {
        //返回键
        KBLogoAndBackView *logoAndBackView = [[KBLogoAndBackView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 0.2*kWindowSize.height + 100)];
        [logoAndBackView setBackButtonTag:5 andLogoImage:nil];
        logoAndBackView.delegate = registerAndLoginVC;
        [self addSubview:logoAndBackView];
        
        //新密码
        UILabel *newPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.16*kWindowSize.width, 0.2*kWindowSize.height, 0.68*kWindowSize.width, 20)];
        newPasswordLabel.text = @"新密码";
        newPasswordLabel.textColor = [UIColor whiteColor];
        [self addSubview:newPasswordLabel];
        
        newPassword = [[KBCustomTextField alloc] initWithFrame:CGRectMake(newPasswordLabel.left, newPasswordLabel.bottom+10, newPasswordLabel.width, 45) drawingLeftViewString:nil andIsImage:YES];
        newPassword.leftView=[[UIView alloc]initWithFrame:
                                  CGRectMake(0, 0, 10, newPassword.height)];
        [newPassword setTextFieldWithTag:1 andPlaceHolder:nil andSecureTextEntry:YES andKeyBoardType:UIKeyboardTypeDefault andTextAlignment:NSTextAlignmentLeft];
        newPassword.delegate = self;
        [self addSubview:newPassword];
        
        //确认密码
        UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(newPassword.left, newPassword.bottom+10, newPassword.width, newPasswordLabel.height)];
        confirmPasswordLabel.text = @"确认密码";
        confirmPasswordLabel.textColor = [UIColor whiteColor];
        [self addSubview:confirmPasswordLabel];
        
        confirmPassword = [[KBCustomTextField alloc] initWithFrame:CGRectMake(confirmPasswordLabel.left, confirmPasswordLabel.bottom + 10, confirmPasswordLabel.width, newPassword.height) drawingLeftViewString:nil andIsImage:YES];
        confirmPassword.leftView=[[UIView alloc]initWithFrame:
                                  CGRectMake(0, 0, 10, confirmPassword.height)];
        [confirmPassword setTextFieldWithTag:3 andPlaceHolder:nil andSecureTextEntry:YES andKeyBoardType:UIKeyboardTypeDefault andTextAlignment:NSTextAlignmentLeft];
        confirmPassword.delegate = self;
        [self addSubview:confirmPassword];
        
        KBCustomButton* setPasswordSuccess = [[KBCustomButton alloc]initWithFrame:CGRectMake(confirmPassword.left, confirmPassword.bottom + 20, newPassword.width, newPassword.height)];
        [setPasswordSuccess setButtonWithBackgroundColor:KColor_19_127_238 andTitle:@"确   认" andBorderWidth:0 andBorderColor:nil andFont:[UIFont systemFontOfSize:20] andImageString:nil];
        [setPasswordSuccess addTarget:self action:@selector(setPasswordSuccess) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:setPasswordSuccess];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [newPassword resignFirstResponder];
    [confirmPassword resignFirstResponder];
}
#pragma mark - 完成编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(endEdit)]) {
        [self.delegate endEdit];
    }
}
#pragma mark - 确认密码修改
-(void)setPasswordSuccess
{
    if ([_delegate respondsToSelector:@selector(setPasswordSuccess:withConfirmPassWord:)]) {
        [newPassword resignFirstResponder];
        [confirmPassword resignFirstResponder];
        [_delegate setPasswordSuccess:newPassword.text withConfirmPassWord:confirmPassword.text];
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
