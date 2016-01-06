//
//  RCDSearchResultTableViewCell.m
//  RCloudMessage
//
//  Created by Liv on 15/4/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDSearchResultTableViewCell.h"

@implementation RCDSearchResultTableViewCell
@synthesize FriendImgeView;
@synthesize FriendLabel;
@synthesize AddFriendButton;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        FriendImgeView=[[UIImageView alloc]init];
        FriendImgeView.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:FriendImgeView];
        
        FriendLabel=[[UILabel alloc]init];
        FriendLabel.textColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
        FriendLabel.font=[UIFont systemFontOfSize:20.0];
        [self.contentView addSubview:FriendLabel];
        
        AddFriendButton=[[KBThumpButton alloc]init];
       
        [self.contentView addSubview:AddFriendButton];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
