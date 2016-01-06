//
//  MenuTableViewCell.m
//  UIScroll1
//
//  Created by kuibu technology on 15/11/20.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBMyTableViewCell.h"
#import "KBColor.h"
@implementation KBMyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftIconImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 15, 30, 30)];
        self.leftIconImage.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.leftIconImage];
        
        self.leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 15, 50, 30)];
        self.leftLabel.textAlignment=NSTextAlignmentLeft;
        self.leftLabel.textColor=KColor_51;
        self.leftLabel.font=[UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:self.leftLabel];
    }
    return self;
}

@end
