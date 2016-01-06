//
//  KBPersonInfoSetView.m
//  UIScroll1
//
//  Created by kuibu on 15/12/19.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBPersonInfoSetView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "KBLogoAndBackView.h"
#import "KBCustomTextField.h"
#import "KBCustomButton.h"
#import "KBLoginSingle.h"
#import "KBCommonSingleValueModel.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "KB_RegisterAndLoginViewController.h"
#import "KBColor.h"
#import "KBCommonSingleValueModel.h"
#define logoSize 100
@interface KBPersonInfoSetView ()<UITextFieldDelegate,KBLogoAndBackViewDelegte>
{
    //昵称
    KBCustomTextField* nickName;
    
    //学校
    KBCustomTextField* schoolName;
    
    //设置完进入按钮
    KBCustomButton* registerButton;
    
    NSString * userSex;//用户选择性别
}
@end

@implementation KBPersonInfoSetView

- (instancetype)initWithFrame:(CGRect)frame andViewController:(KB_RegisterAndLoginViewController*)registerAndLoginVC
{
    self = [super initWithFrame:frame];
    if (self) {
        //返回按钮
        KBLogoAndBackView *logoAndBackView = [[KBLogoAndBackView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 0.2*kWindowSize.height + 100)];
        [logoAndBackView setBackButtonTag:0 andLogoImage:nil];
        logoAndBackView.delegate = registerAndLoginVC;
        [self addSubview:logoAndBackView];
        
        self.logoImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.logoImageButton.frame = CGRectMake(0.5*kWindowSize.width-0.5*logoSize, 0.2*kWindowSize.height, logoSize, logoSize);
        [self.logoImageButton setBackgroundImage:[UIImage imageNamed:@"默认头像-大有阴影"] forState:UIControlStateNormal];
        [self.logoImageButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
        self.logoImageButton.layer.cornerRadius = 50;
        self.logoImageButton.clipsToBounds = YES;
        [self addSubview:self.logoImageButton];
        
        //昵称
        nickName = [[KBCustomTextField alloc] initWithFrame:CGRectMake(0.16*kWindowSize.width, logoAndBackView.bottom + 0.1*kWindowSize.height, 0.68*kWindowSize.width, 45) drawingLeftViewString:@"昵称" andIsImage:NO];
        [nickName setTextFieldWithTag:1 andPlaceHolder:nil andSecureTextEntry:NO andKeyBoardType:UIKeyboardTypeDefault andTextAlignment:NSTextAlignmentLeft];
        nickName.delegate = self;
        [self addSubview:nickName];
        
        //学校
        schoolName = [[KBCustomTextField alloc] initWithFrame:CGRectMake(nickName.frame.origin.x, nickName.frame.origin.y + nickName.frame.size.height + 20, nickName.frame.size.width, nickName.frame.size.height) drawingLeftViewString:@"学校" andIsImage:NO];
        [schoolName setTextFieldWithTag:2 andPlaceHolder:nil andSecureTextEntry:NO andKeyBoardType:UIKeyboardTypeDefault andTextAlignment:NSTextAlignmentLeft];
        schoolName.delegate = self;
        [self addSubview:schoolName];
        
        //性别男
        KBCustomButton* maleButton = [[KBCustomButton alloc]initWithFrame:CGRectMake(schoolName.left, schoolName.bottom + 20, 0.5*schoolName.width-10, schoolName.height)];
        [maleButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"男" andBorderWidth:1 andBorderColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:20] andImageString:@"gender male"];
        maleButton.tag = 11;
        [maleButton addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maleButton];
        
        //性别女
        KBCustomButton* femaleButton = [[KBCustomButton alloc] initWithFrame:CGRectMake(maleButton.right +10, maleButton.top, 0.5*schoolName.width -10, maleButton.height)];
        [femaleButton setButtonWithBackgroundColor:[UIColor clearColor] andTitle:@"女" andBorderWidth:1 andBorderColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:20] andImageString:@"gender female"];
        femaleButton.tag = 12;
        [femaleButton addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:femaleButton];
        
        //信息设置完，进入主界面按钮
        registerButton = [[KBCustomButton alloc]initWithFrame:CGRectMake(maleButton.left, maleButton.bottom + 20, schoolName.width, schoolName.height)];
        [registerButton setButtonWithBackgroundColor:KColor_19_127_238 andTitle:@"登   录" andBorderWidth:0 andBorderColor:nil andFont:nil andImageString:nil];
        [registerButton addTarget:self action:@selector(pushMainView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerButton];
    }
    return self;
}
#pragma mark - 个人信息界面选择头像
- (void)choosePhoto
{
    if ([_delegate respondsToSelector:@selector(choosePhoto)]) {
        [_delegate choosePhoto];
    }
}
#pragma mark - 选择性别
-(void)chooseSex:(UIButton *)button{
    [nickName resignFirstResponder];
    [schoolName resignFirstResponder];
    if (button.tag==11) {
        [button setBackgroundColor:[UIColor greenColor]];
        button.layer.borderWidth=0;
        userSex=@"男";
        UIButton *btn = (UIButton *)[self viewWithTag:12];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.layer.borderWidth=1;
    } else {
        [button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:123/255.0 blue:88/255.0 alpha:1.0]];
        button.layer.borderWidth=0;
        userSex=@"女";
        UIButton *btn = (UIButton *)[self viewWithTag:11];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.layer.borderWidth=1;
    }
}

#pragma mark - UIResponder点击屏幕其他地方隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nickName resignFirstResponder];
    [schoolName resignFirstResponder];
}

#pragma mark - UITextFieldDelagate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(startEdit:)]) {
        [self.delegate startEdit:registerButton.bottom];
    }
}
#pragma mark - 完成编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(endEdit)]) {
        [self.delegate endEdit];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    return YES;
}
#pragma mark - 完成信息输入 进入主界面
-(void)pushMainView
{
    if ([_delegate respondsToSelector:@selector(pushMainView:withUserSchool:withUserSex:)]) {
        [_delegate pushMainView:nickName.text withUserSchool:schoolName.text withUserSex:userSex];
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
