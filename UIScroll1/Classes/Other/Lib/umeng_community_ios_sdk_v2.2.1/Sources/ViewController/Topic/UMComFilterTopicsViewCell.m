//
//  KBComFilterTopicsViewCell.m
//  UIScroll1
//
//  Created by 樊振 on 15/12/25.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "UMComFilterTopicsViewCell.h"
#import "UMComTools.h"
#import "UMComTopic.h"
#import "UMComClickActionDelegate.h"
#import "UMComImageView.h"
#import "UIView+ITTAdditions.h"
#import "KBConstant.h"
#import "UMComImageModel.h"
#import "KBLoginSingle.h"
#import "UMComSession.h"
@implementation UMComFilterTopicsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //背景图
        _backgroundImageView = [[UMComImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowSize.width, 220)];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_backgroundImageView];
        
        //话题描述
        _labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(0 , _backgroundImageView.bottom + 10, 0.5*_backgroundImageView.width, 20)];
        _labelDesc.center = CGPointMake(0.5*kWindowSize.width, _labelDesc.centerY);
        _labelDesc.text = @"第2期|2016-01-09";
        _labelDesc.font = UMComFontNotoSansLightWithSafeSize(16);
        _labelDesc.textColor = [UMComTools colorWithHexString:FontColorBlue];
        _labelDesc.textAlignment = NSTextAlignmentCenter;
        [_backgroundImageView addSubview:_labelDesc];
        
        //话题名称
        _labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelDesc.bottom+10, 0.9*_backgroundImageView.width, 60)];
        _labelName.center = CGPointMake(0.5*kWindowSize.width , _labelName.centerY);
        _labelName.numberOfLines = 0;
        _labelName.textColor = [UIColor blackColor];
        _labelName.font = UMComFontNotoSansLightWithSafeSize(20);
        [_backgroundImageView addSubview:_labelName];
        
        self.isRecommendTopic = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickOnTopic)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

//点击cell进入话题界面
- (void)didClickOnTopic
{
    if ([KBLoginSingle newinstance].isLogined&&[UMComSession sharedInstance].uid) {
        if (self.clickOnTopic) {
            self.clickOnTopic(self.topic);
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(showLoginView)]) {
            [self.delegate showLoginView];
        }
    }
    
}

- (void)setWithTopic:(UMComTopic *)topic
{
    if (topic.isFault || topic.isDeleted) {
        return;
    }

    if ([topic isKindOfClass:[UMComTopic class]]) {
        self.topic = topic;
        
        self.labelName.text = [NSString stringWithFormat:@"    %@",self.topic.name];
        CGSize size1 = [self.labelName sizeThatFits:CGSizeMake(self.labelName.width, MAXFLOAT)];
        self.labelName.frame = CGRectMake(self.labelName.left, self.labelName.top, self.labelName.width, size1.height);
        
        self.labelDesc.text = [self.topic.descriptor length] == 0 ? UMComLocalizedString(@"Topic_No_Desc", @"该话题没有描述"): self.topic.descriptor;
        NSString *originUrl=nil;
        for (NSDictionary *imageDict in topic.image_urls)
        {
            originUrl = [imageDict valueForKey:@"origin"];
        }
        [self.backgroundImageView setImageURL:originUrl placeHolderImage:[UIImage imageNamed:@"zhuozi"]];
        CGSize size = [self.backgroundImageView.image size];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height), NO, 0);
        [self.backgroundImageView.image drawAtPoint:CGPointMake(0, 0)];
        //拿到当前视图准备好的画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        //利用path进行绘制三角形
        CGContextBeginPath(context);//标记
        CGContextMoveToPoint(context,0.45*size.width, size.height);//设置起点
        CGContextAddLineToPoint(context,0.5*size.width, size.height-0.1*size.height);
        CGContextAddLineToPoint(context,0.55*size.width, size.height);
        CGContextClosePath(context);//路径结束标志，不写默认封闭
        [[UIColor whiteColor] setFill]; //设置填充色
        [[UIColor whiteColor] setStroke]; //设置边框颜色
        CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
        
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundImageView.image = im;
        
        CGRect frame = self.frame;
        frame.size.height = _labelName.bottom +20;
        self.frame = frame;
        self.contentView.frame = frame;
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
