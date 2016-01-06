//
//  RecommendViewCell.m
//  UIScroll1
//
//  Created by 樊振 on 15/10/30.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBHomeTableViewCell.h"
#import "LikeButton.h"
#import "UIImageView+WebCache.h"
#import "KBCommonSingleValueModel.h"
#define MARGIN_WIDTH 0//14
#define MARGIN_HEIGHT 0//10
#define USUAL_CELL_HEIGHT 95
#define SECTION_VIEW_HEIGHT 50
#define BTN_WIDTH 80
#define BTN_HEIGHT 15

@implementation KBHomeTableViewCell
@synthesize customImageView;
@synthesize titleLable;
@synthesize TypeBtn;
@synthesize likeBtn;
@synthesize likeImageBtn;
float DEVICE_WIDTH,DEVICE_HEIGHT;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        DEVICE_WIDTH=[UIScreen mainScreen].bounds.size.width;
        DEVICE_HEIGHT=[UIScreen mainScreen].bounds.size.height;
        
        [self setFrame:CGRectMake(0, 0, DEVICE_WIDTH, USUAL_CELL_HEIGHT)];
        [self.contentView setFrame:self.frame];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-5)];
        colorView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:colorView];
        
        customImageView=[[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_WIDTH,MARGIN_HEIGHT,(colorView.frame.size.height)*1.5 , colorView.frame.size.height)];   [colorView addSubview:customImageView];
        
        titleLable  =[[UITopLable alloc]initWithFrame:CGRectMake(customImageView.frame.origin.x+customImageView.frame.size.width+7, customImageView.frame.origin.y+15   , colorView.frame.size.width-MARGIN_WIDTH*2-customImageView.frame.size.width-17, 82)];
        [titleLable setVerticalAlignment:VerticalAlignmentTop];
        titleLable.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        [titleLable setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        titleLable.numberOfLines=2;
        [colorView addSubview:titleLable];
        
        TypeBtn  =[[UIButtonWithIndexPath alloc]initWithFrame:CGRectMake(titleLable.frame.origin.x, customImageView.frame.size.height+MARGIN_HEIGHT-BTN_HEIGHT-10, 50, BTN_HEIGHT)];
        [TypeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [TypeBtn setTitle:@"类别" forState:UIControlStateNormal];
        TypeBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        TypeBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        TypeBtn.layer.borderColor=[UIColor grayColor].CGColor;
        TypeBtn.layer.borderWidth=1;
        TypeBtn.layer.cornerRadius=3;
        if ([[KBCommonSingleValueModel newinstance].DeviceModel rangeOfString:@"iPhone 4"].location != NSNotFound) {
            TypeBtn.titleEdgeInsets=UIEdgeInsetsMake(2, 0, 0, 0) ;
        }
        [colorView addSubview:TypeBtn];
        
        likeImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(titleLable.frame.origin.x+63, TypeBtn.frame.origin.y+3, 20, 10)];
        [colorView addSubview:likeImageBtn];
        
        likeBtn =[[LikeButton alloc]initWithFrame:CGRectMake(titleLable.frame.origin.x+86, TypeBtn.frame.origin.y+2, 100, 13)];
        [likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        likeBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //[likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
        [colorView addSubview:likeBtn];
        
    }
    return self;
}
@end
