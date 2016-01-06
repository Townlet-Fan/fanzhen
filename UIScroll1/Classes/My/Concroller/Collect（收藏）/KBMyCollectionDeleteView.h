//
//  KBMyCollectionDeleteView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

//收藏的底部的删除View
#import <UIKit/UIKit.h>

@protocol KBMyCollectionDeleteViewDelegate <NSObject>

-(void)allDelelte;//全选的方法
-(void)deleteCollect;//删除收藏

@end
@interface KBMyCollectionDeleteView : UIView

/**
 *  全选删除的button
 */
@property (nonatomic,strong) UIButton * allDeteleButton;
/**
 *  删除的button
 */
@property (nonatomic,strong) UIButton * deleteButton;
/**
 *  删除的View
 */
@property (nonatomic,strong) UIView * deleteView;

@property (nonatomic,weak) id<KBMyCollectionDeleteViewDelegate>delegate;

@end
