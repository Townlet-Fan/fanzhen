//
//  RegisterTextField.m
//  UIScroll1
//
//  Created by kuibu on 15/12/7.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBCustomTextField.h"
#import "UIView+ITTAdditions.h"
#import "KBColor.h"
@implementation KBCustomTextField

-(id)initWithFrame:(CGRect)frame drawingLeftViewString:(NSString*)string andIsImage:(BOOL)isImage{
    
    self = [super initWithFrame:frame];
    if (self) {
        if (isImage) {
            UIImageView *LeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            UIImage *image = [UIImage imageNamed:string];
            LeftImageView.image = image;
            LeftImageView.contentMode=UIViewContentModeScaleAspectFill;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
            [view addSubview:LeftImageView];//用两层view是解决输入起点与图标距离问题，暂时未想到好方法
            
            self.leftView = view;
            self.leftViewMode = UITextFieldViewModeAlways;
        } else {
            UILabel *label = [[UILabel alloc] init];
            if (string)
                label.frame = CGRectMake(0, 0, 50, 30);
            else
                label.frame = CGRectMake(0, 0, 15,30);
            
            label.textColor = KColor_153_Alpha_1;
            label.text = string;
            self.leftView = label;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
        
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15;// 右偏10
    return iconRect;
}

- (void)setTextFieldWithTag:(NSInteger)tag andPlaceHolder:(NSString*)string andSecureTextEntry:(BOOL)isSecure andKeyBoardType:(UIKeyboardType)keyBoardType andTextAlignment:(NSTextAlignment)textAlignment
{
    //原始设置
    self.layer.cornerRadius = self.height*0.2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textColor = [UIColor whiteColor];
//    self.delegate = self;
    //根据值设置
    self.tag = tag;
    self.placeholder = string;
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];//要在placeholder设置之后，否则无效
    self.secureTextEntry = isSecure;
    self.keyboardType = keyBoardType;
    self.textAlignment = textAlignment;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
