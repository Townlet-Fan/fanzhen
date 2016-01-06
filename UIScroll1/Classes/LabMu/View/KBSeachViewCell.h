//
//  KBSeachViewCell.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//

//搜索得到文章的cell
#import <UIKit/UIKit.h>

@class KBHomeArticleModel;

@interface KBSeachViewCell : UITableViewCell

//设置cell的数据
-(void)setSearchCellWithModel:(KBHomeArticleModel *)model;
@end
