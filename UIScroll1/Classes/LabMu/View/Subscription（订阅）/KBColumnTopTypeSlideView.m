//
//  TypeNavView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/5/30.
//  Copyright (c) 2015年 Test. All rights reserved.
//

#import "KBColumnTopTypeSlideView.h"
#import "KBSubcriptionMainViewController.h"
#import "UIView+ITTAdditions.h"
#define ORIGIN_Y 104
#define HEIGHT 96
#define WIDTH (DEVICE_WIDTH-20)
@implementation KBColumnTopTypeSlideView
@synthesize buttonArray;
@synthesize selectedBtn;
@synthesize findVCDelegate;
float DEVICE_WIDTH,DEVICE_HEIGHT;
- (instancetype)init
{
    DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
    DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
    self = [super init];
    if (self)
    {
        [self setFrame:CGRectMake(0 , ORIGIN_Y, DEVICE_WIDTH, HEIGHT)];
        self.backgroundColor=[UIColor whiteColor];
        buttonArray=[[NSMutableArray alloc]init];
        for (int i=0; i<5;i++)
        {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10+DEVICE_WIDTH/5.0*i, 20, DEVICE_WIDTH/5.0-20, DEVICE_WIDTH/5.0-20)];
            switch (i) {
                case 0:
                {
                    [btn setFrame:CGRectMake(btn.left-5, btn.top-5, btn.width+10, btn.height+10)];
                    [btn setTitle:@"推荐" forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"热点.jpg"] forState:UIControlStateNormal];
                    btn.layer.borderWidth=1;
                    selectedBtn=btn;
                }
                    break;
                case 1:
                    [btn setTitle:@"学科" forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"学科.jpg"] forState:UIControlStateNormal];
                    break;
                    
                case 2:
                    [btn setTitle:@"能力" forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"能力.jpg"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [btn setTitle:@"规划" forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"规划.jpg"] forState:UIControlStateNormal];
                    break;
                case 4:
                    [btn setTitle:@"兴趣" forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"兴趣.jpg"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19];
            btn.backgroundColor=[UIColor clearColor];
            btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            [self addSubview:btn];
            [buttonArray addObject:btn];
            [btn addTarget:self action:@selector(selectedChange:) forControlEvents:UIControlEventTouchDown];
            btn.layer.borderColor=[UIColor whiteColor].CGColor;
        }
    }
    return self;
}
-(void)selectedChange:(UIButton *)selectingButton{
    selectingButton.layer.borderWidth=1;
    KBSubcriptionMainViewController *findVC=self.findVCDelegate;
    [findVC.tableview setContentOffset:CGPointMake(0, findVC.tableview.contentOffset.y-1) animated:YES];
    [findVC.tableview setContentOffset:CGPointMake(0, -64)];
    [UIView animateWithDuration:0.3 animations:^{
        [selectingButton setFrame:CGRectMake(selectingButton.left-5, selectingButton.top-5, selectingButton.width+10, selectingButton.height+10)];
        [selectedBtn setFrame:CGRectMake(selectedBtn.left+5, selectedBtn.top+5, selectedBtn.width-10, selectedBtn.height-10)];
    }];
    selectedBtn.layer.borderWidth=0;
    selectedBtn=selectingButton;
}
@end
