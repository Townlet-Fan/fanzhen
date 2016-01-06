//
//  UMComFeedsTableViewCell.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComFeedStyle,UMComFeed,UMComMutiStyleTextView, UMComImageView,UMComGridView;

@protocol UMComClickActionDelegate;

@interface UMComFeedsTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (weak, nonatomic) IBOutlet UIImageView *publicImage;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong)  UMComImageView *portrait;

@property (nonatomic, weak) IBOutlet UMComMutiStyleTextView *feedStyleView;

@property (nonatomic, weak) IBOutlet UIImageView *originFeedBackgroundView;

@property (nonatomic, weak) IBOutlet UMComMutiStyleTextView *originFeedStyleView;

@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

@property (nonatomic, weak) IBOutlet UIView *locationBgView;

@property (nonatomic, weak) IBOutlet UILabel *locationDistance;

@property (weak, nonatomic) IBOutlet UMComGridView *imageGridView;


@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//包含likeView和label
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
//点赞计数
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
//评论计数
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
//转发计数
@property (weak, nonatomic) IBOutlet UILabel *forwardCountLabel;
//包含下三个
@property (weak, nonatomic) IBOutlet UIView *bottomMenuBgView;

//点赞按钮
@property (weak, nonatomic) IBOutlet UIView *likeBgView;
//转发按钮
@property (weak, nonatomic) IBOutlet UIView *forwardBgView;
//评论按钮
@property (weak, nonatomic) IBOutlet UIView *commentBgView;

@property (nonatomic, weak) id<UMComClickActionDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)reloadFeedWithfeedStyle:(UMComFeedStyle *)feedStyle tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;



- (IBAction)onClickOnShareButton:(UIButton *)sender;

- (IBAction)onClickOnAddCollection:(id)sender;

@end
