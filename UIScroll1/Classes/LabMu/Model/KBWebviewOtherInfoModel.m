//
//  KBWebviewOtherInfoModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/16.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBWebviewOtherInfoModel.h"
#import "KBCommentModel.h"
#import "KBHomeArticleModel.h"
@implementation KBWebviewOtherInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static KBWebviewOtherInfoModel *webviewOtherInfoModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webviewOtherInfoModel = [[KBWebviewOtherInfoModel alloc] init];
    });
    return webviewOtherInfoModel;
}


- (void)setDataWithDictionary:(NSDictionary *)dict
{
    self.praNum=dict[@"praNum"]?dict[@"praNum"]:@"";
    self.criNum=dict[@"criNum"]?dict[@"criNum"]:@"";
    self.userChoice=dict[@"userChoice"]?dict[@"userChoice"]:@"";
    self.adLink=dict[@"adLink"]?dict[@"adLink"]:@"";
    self.adPicurl=dict[@"adPicUrl"]?dict[@"adPicUrl"]:@"";
    self.isSubscri=dict[@"isSubscri"]?dict[@"isSubscri"]:@"";
    self.recomArray=[self getModelArrWithRecomArray:dict[@"recomArtc"]];
    self.comNum=dict[@"comNum"]?dict[@"comNum"]:@"";
    self.commentArray=[self getModelArrWithCommentArray:dict[@"comFirPage"]];
}
//评论
-(NSMutableArray*)getModelArrWithCommentArray:(NSArray * )array
{
    //分解数据
    NSMutableArray * commentArray=[[NSMutableArray alloc]init];
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [commentArray addObject:[KBCommentModel commentModelWithDictionary:obj]];
    }];
    return commentArray;
}
//相关推荐的文章
-(NSMutableArray *)getModelArrWithRecomArray:(NSArray *)array
{
    NSMutableArray * recomArray=[[NSMutableArray alloc]init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [recomArray addObject:[KBHomeArticleModel arcticleModelWithDictionary:obj]];
    }];
    return recomArray;
}
@end
