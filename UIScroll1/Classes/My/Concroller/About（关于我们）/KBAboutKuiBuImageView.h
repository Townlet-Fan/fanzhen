//
//  KBAboutKuiBuImageView.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

//关于的Image
#import <UIKit/UIKit.h>

@protocol KBAboutKuiBuDelegate <NSObject>

-(void)backToMenu;

@end

@interface KBAboutKuiBuImageView : UIImageView

/**
 *  返回按钮
 */
@property (nonatomic,strong) UIButton * backButton;

/**
 *  返回的Image
 */
@property (nonatomic,strong) UIImageView * backImage;


-(instancetype)initWithFrame:(CGRect)frame withImage:(NSString * )imageName;

/**
 *  代理
 */
@property (nonatomic,weak) id<KBAboutKuiBuDelegate>delegate;
@end
