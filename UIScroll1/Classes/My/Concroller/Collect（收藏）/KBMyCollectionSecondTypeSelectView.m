//
//  KBMyCollectionSecondTypeSelectView.m
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/23.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMyCollectionSecondTypeSelectView.h"
#import "KBConstant.h"
#import "KBColor.h"
@implementation KBMyCollectionSecondTypeSelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        if (kWindowSize.width==320)
        {
            self.allBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20,kWindowSize.width/3.0-kWindowSize.width*0.05 , 20)];
            self.btnLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWindowSize.width/3.0-kWindowSize.width*0.08, 20)];
        }
        else{
            self.allBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 20,kWindowSize.width/3.0-kWindowSize.width*0.08 , 20)];
            self.btnLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWindowSize.width/3.0-kWindowSize.width*0.05, 20)];
        }
        //btnLabel
        self.btnLabel.textColor=KColor_102;
        self.btnLabel.textAlignment=NSTextAlignmentLeft;
        self.btnLabel.text=[NSString stringWithFormat:@"全 部  %d",0];
        //allbtn
        [self.allBtn addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
        self.allBtn.layer.borderColor=KColor_102.CGColor;
        self.allBtn.layer.cornerRadius=5;
        self.allBtn.layer.borderWidth=1;
        [self.allBtn addSubview:self.btnLabel];
        [self addSubview:self.allBtn];
    }
    return self;
}
-(void)showAll
{
    if ([_delegate respondsToSelector:@selector(showAll)]) {
        [_delegate showAll];
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
