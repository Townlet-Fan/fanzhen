//
//  KBNoLoginParametersModel.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/13.
//  Copyright © 2015年 Test. All rights reserved.
//


//post的请求参数
#import <Foundation/Foundation.h>

@interface KBPostParametersModel : NSObject

#pragma mark - 获取没登陆用户订阅的post参数(ok)
+(NSDictionary *)setNoLoginParameters:(NSArray *)subscriptionStructArray addItemNumber:(NSInteger)itemNumber;
#pragma mark - 获取用户点击收藏的post参数
+(NSDictionary *)setCollectParameters:(NSInteger )pageId withActionType:(int)actionType;
#pragma mark - 获取正文反馈的post参数
+(NSDictionary *)setFeedBackWebParameters:(NSInteger )userId withTextField:(NSString * )textField withTextField1:(NSString *)textField1;
#pragma mark - 获取点赞的post参数
+(NSDictionary *)setThumbUpCommentParameters:(NSInteger)commentType withCommentId:(NSInteger) commentId withSendId:(NSInteger)userId withReceiverId:(NSInteger) receiverId withDate :(NSString *) date;
#pragma mark - 获取评论的post参数
+(NSDictionary *)setCommentParameters:(NSInteger )pageId withSendId:(NSInteger)userId withdate:(NSString * )date withComment:(NSString *)comment;
#pragma mark - 获取登录的post参数
+(NSDictionary *) setLoginParameters:(NSInteger )userId withMail:(NSString *)userMail withTelNumber:(NSString *)userTelNumber withPassWord:(NSString *)passWord;
#pragma mark - 获取Menu反馈的post参数(ok)
+(NSDictionary *)setFeedBackMenuParameters:(NSInteger)userId withFeedBackType:(int)feedBackType withFeedBackContent:(NSString *)feedBackContent withScreenShot:(NSArray *)imageArray withImageCount:(int)imageCount;
#pragma mark - 获取保存用户信息的post参数(ok)
+(NSDictionary *)setSaveUserInfoParameters:(NSInteger)userId withUserName:(NSString *)userName withUserPhoto:(NSString * )userPhoto withUserSex:(NSString * )userSex withUserSchool:(NSString *)userSchool withUserSchoolYear:(NSString * )userSchoolYear;
#pragma mark - 获取保存用户新密码的post参数(修改密码)
+(NSDictionary *)setSaveUserNewPassWordParameters:(NSInteger)userId withOldPassWord:(NSString *)oldPassWord withNewPassWord:(NSString *)newPassWord;
#pragma mark - 获取用户回复他人的post参数(ok)
+(NSDictionary *)setUserReplyToOthersParameters:(NSInteger)pageId withUserId:(NSInteger)userId withCommentId:(NSInteger)commentId  withReplyContent:(NSString *)replyContent;
#pragma mark - 获取用户订阅发生改变的post参数
+(NSDictionary *)setUserSubscriptionChangeParameters:(NSArray * )subscriptionArray  withUserId:(NSInteger) userId;
#pragma mark - 获取置顶的三级分类的post参数
+(NSDictionary *)setThirdTypeToTopParameters:(NSInteger )userId withItemNumber:(NSInteger )itemNumber withThirdType:(NSString *)thirdTypeId;
@end
