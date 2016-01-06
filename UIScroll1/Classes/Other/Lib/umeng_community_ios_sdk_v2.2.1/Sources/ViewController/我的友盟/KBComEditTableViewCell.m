//
//  KBComEditTableViewCell.m
//  UIScroll1
//
//  Created by 樊振 on 15/12/27.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBComEditTableViewCell.h"
#import "UMComImageView.h"
#import "KBConstant.h"
#import "UIView+ITTAdditions.h"
#import "UMComUser.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComButton.h"
#import "KBComEditTableViewController.h"
#import "KBLoginSingle.h"
@interface KBComEditTableViewCell()
{
    UIView *view;//背景
}
@end

@implementation KBComEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //feed背景
        view = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kWindowSize.width -10, 500)];
        view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.8];
        [self.contentView addSubview:view];
        
        //用户头像
        _icon = [[UMComImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        _icon.layer.cornerRadius = _icon.width*0.5;
        [view addSubview:_icon];
        
        //用户名
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right+10, _icon.top, 100, 20)];
        [view addSubview:_name];
        //输入的评论
        _comment = [[UITextView alloc] initWithFrame:CGRectMake(_name.left, _name.bottom +10, kWindowSize.width - _name.left - 20, 150)];
        _comment.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        _comment.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
        _comment.delegate = self;//设置它的委托方法
        _comment.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        _comment.returnKeyType = UIReturnKeyDefault;//返回键的类型
        _comment.keyboardType = UIKeyboardTypeDefault;//键盘类型
        _comment.scrollEnabled = YES;//是否可以拖动
        _comment.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        _comment.layer.borderWidth = 1;
        _comment.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.9].CGColor;
        [view addSubview:_comment];

        _showImagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_comment.left, _comment.bottom + 5, _comment.width, _comment.height)];
        _showImagesScrollView.showsVerticalScrollIndicator = YES;
        _showImagesScrollView.showsHorizontalScrollIndicator = YES;
        _showImagesScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        _showImagesScrollView.contentSize = CGSizeMake(_showImagesScrollView.width, _showImagesScrollView.height*1.5);
        [view addSubview:_showImagesScrollView];
        
        _pickerPhotos = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.5*_showImagesScrollView.height, 0.5*_showImagesScrollView.height)];
        [_pickerPhotos addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        [_pickerPhotos setBackgroundImage:[UIImage imageNamed:@"图片"] forState:UIControlStateNormal];
        [_showImagesScrollView addSubview:_pickerPhotos];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto)];
        [_icon addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark - 选择照片
- (void)selectPhoto
{
    if ([self.delegate respondsToSelector:@selector(showImagePicker)]) {
        [self.delegate showImagePicker];
    }
    
}
#pragma mark - 设置数据
- (void)setEditViewCellWith:(UMComUser*)user
{
    if (user) {
        NSString *iconString = [user iconUrlStrWithType:UMComIconSmallType];
        UIImage *placeHolderImage = [UMComImageView placeHolderImageGender:[user.gender integerValue]];
        [self.icon setImageURL:iconString placeHolderImage:placeHolderImage];
        self.icon.clipsToBounds = YES;
        self.icon.layer.cornerRadius = self.icon.frame.size.width/2;
        
        _name.text = user.name;
    }
}
#pragma mark - 设置图片
- (void)setCellImagesWith:(NSMutableArray*)images
{
    for (id view1 in _showImagesScrollView.subviews) {
        if (![view1 isKindOfClass:[UIButton class]]) {
            [view1 removeFromSuperview];
        }
    }
    NSInteger level = 0;//一层4张图
    for (NSInteger idx = 0; idx<images.count; idx++) {
        
        if ((idx+1)%4 == 0&&idx!=0) {
            level++;
        }

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((idx+1-level*4)*(_pickerPhotos.width+5), (_pickerPhotos.height+5)*level, _pickerPhotos.width, _pickerPhotos.height)];
        imageView.image = [images objectAtIndex:idx];
        [_showImagesScrollView addSubview:imageView];
    }
}
#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_comment resignFirstResponder];
}
#pragma mark - textViewDelegate
//这样无论你是使用电脑键盘上的回车键还是使用弹出键盘里的return键都可以达到退出键盘的效果。(text是新输入的内容)
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_comment becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [_comment.text sizeWithAttributes:@{NSFontAttributeName:_comment.font}];//输入换行符，会将font高变大，导致colomNumber变小？？？？待解决
    int colomNumber = _comment.contentSize.height/size.height;
    if (colomNumber>6) {//限制字符个数用length
        if ([self.delegate respondsToSelector:@selector(showTipMessage)]) {
            [self.delegate showTipMessage];
        }
        textView.text = [textView.text substringToIndex:[textView.text length]-1];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
