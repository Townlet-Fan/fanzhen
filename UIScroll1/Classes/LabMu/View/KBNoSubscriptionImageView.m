//
//  KBNoSubscriptionImageView.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/13.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBNoSubscriptionImageView.h"

@interface KBNoSubscriptionImageView()
//无订阅的ImageView
@property (nonatomic,strong)UIImageView * noSubscriptionImageView;

@end
@implementation KBNoSubscriptionImageView

-(instancetype)initWithFrame:(CGRect)frame withItemNumber:(NSInteger)itemNumber
{
    self=[super initWithFrame:frame];
    if (self) {
        self.noSubscriptionImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.noSubscriptionImageView.contentMode=UIViewContentModeScaleAspectFill;
        switch (itemNumber) {
            case 2:
                self.noSubscriptionImageView.image=[UIImage imageNamed:@"学科"];
                break;
                
            case 3:
            {
                self.noSubscriptionImageView.image=[UIImage imageNamed:@"能力"];
            }
                break;
            case 4:
            {
                self.noSubscriptionImageView.image=[UIImage imageNamed:@"规划"];
            }
                break;
            case 5:
                self.noSubscriptionImageView.image=[UIImage imageNamed:@"兴趣"];
                break;
                
            default:
                break;
        }
        [self addSubview:self.noSubscriptionImageView];

    }
    return self;
}
@end
