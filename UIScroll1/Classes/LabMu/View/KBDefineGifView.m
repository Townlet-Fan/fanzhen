//
//  KBDefineGifView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/14.
//  Copyright © 2015年 Test. All rights reserved.
//


#import "KBDefineGifView.h"
#import "KBConstant.h"
#import "GifView.h"

@interface KBDefineGifView()
{
    GifView * showGifView;
}

@end

@implementation KBDefineGifView

-(instancetype)initWithFrame:(CGRect)frame withStartTop:(float)startTop
{
    self=[super initWithFrame:frame];
    if (self) {
        showGifView =[[GifView alloc] initWithFrame:CGRectMake(0, startTop, kWindowSize.width,kWindowSize.height) ];
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"loading" ofType:@"gif"];
        NSData *data = [[NSData alloc]initWithContentsOfFile:dataPath];
        [showGifView loadData:data];
        showGifView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:showGifView];
    }
    return self;
}
@end
