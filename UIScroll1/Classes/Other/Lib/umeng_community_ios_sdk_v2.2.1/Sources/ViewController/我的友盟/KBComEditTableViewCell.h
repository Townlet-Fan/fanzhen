//
//  KBComEditTableViewCell.h
//  UIScroll1
//
//  Created by 樊振 on 15/12/27.
//  Copyright © 2015年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UMComImageView,UMComUser,UMComButton,KBComEditTableViewController;

@protocol KBComEditTableViewCellDelegate <NSObject>
//弹出警告信息
- (void)showTipMessage;
//选择图片
- (void)showImagePicker;

@end
@interface KBComEditTableViewCell : UITableViewCell<UITextViewDelegate>
/**
 *  用户头像
 */
@property (nonatomic,strong) UMComImageView *icon;
/**
 *  用户名字
 */
@property (nonatomic,strong) UILabel *name;
/**
 *  评论内容
 */
@property (nonatomic,strong) UITextView *comment;

/**
 *  展示图片的框
 */
@property (nonatomic,strong) UIScrollView *showImagesScrollView;
/**
 *  选择照片按钮
 */
@property (nonatomic,strong) UIButton *pickerPhotos;

@property (nonatomic,weak) id delegate;

//根据UMComUser设置cell数据
- (void)setEditViewCellWith:(UMComUser*)user;

//选完图片后设置cell
- (void)setCellImagesWith:(NSMutableArray*)images;

@end






