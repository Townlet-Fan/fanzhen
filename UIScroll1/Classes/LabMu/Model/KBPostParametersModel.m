//
//  KBNoLoginParametersModel.m
//  UIScroll1
//
//  Created by kuibu technology on 15/12/13.
//  Copyright © 2015年 Test. All rights reserved.
//

#import "KBPostParametersModel.h"
#import "KBThreeSortModel.h"
#import "KBLoginSingle.h"
@implementation KBPostParametersModel

#pragma mark - 获取没登陆用户订阅的post参数
+(NSDictionary *)setNoLoginParameters:(NSArray *)subscriptionStructArray addItemNumber:(NSInteger)itemNumber
{
    NSMutableArray *mainFocuslistArray=[[NSMutableArray alloc]init];
    for (int i=0; i<subscriptionStructArray.count; i++) {
        KBThreeSortModel *threeSortModel=[subscriptionStructArray objectAtIndex:i];
//        NSMutableDictionary *threeSortDic=[[NSMutableDictionary alloc]init];
//        [threeSortDic setObject:[NSNumber numberWithInteger:threeSortModel.TypeTowID] forKey:@"secondType"];
//        [threeSortDic setObject:threeSortModel.name forKey:@"thirdName"];
        NSLog(@"threeSortModel:%ld",(long)threeSortModel.TypeThreeID);
        [mainFocuslistArray addObject:[NSNumber numberWithInteger:threeSortModel.TypeThreeID]];
       
//        [mainFocuslistArray addObject:threeSortDic];
        
    }
    NSMutableDictionary *dicToSend=[[NSMutableDictionary alloc]init];
    [dicToSend setObject:mainFocuslistArray forKey:@"focusStr"];
    
//    [dicToSend setObject:[NSNumber numberWithInteger:itemNumber] forKey:@"itemNumber"];
//    [dicToSend setObject:mainFocuslistArray forKey:@"mainFocusList"];
//    NSDictionary *mainFocusList=@{@"mainFocusList":dicToSend};
    
    return dicToSend;
}
#pragma mark - 获取用户点击收藏的post参数
+(NSDictionary *)setCollectParameters:(NSInteger )pageId withActionType:(int)actionType
{
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:[KBLoginSingle newinstance].userID] forKey:@"userId"];
    [dicSend setObject:[NSNumber numberWithInteger:pageId] forKey:@"pageId"];
    [dicSend setObject:[NSNumber numberWithInt:actionType] forKey:@"actionType"];
//    NSString *collectString1=[NSString stringWithFormat:@"{\"userId\":\"%ld\",\"pageId\":\"%ld\",\"actionType\":\"%d\"}",(long)[KBLoginSingle newinstance].userID,(long)pageId,actionType];
    NSDictionary *collectDict=@{@"collectString":dicSend};
    
    return collectDict;
}
#pragma mark - 获取正文反馈的post参数
+(NSDictionary *)setFeedBackWebParameters:(NSInteger )userId withTextField:(NSString * )textField withTextField1:(NSString *)textField1
{
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [dicSend setObject:textField forKey:@"wantedInfo"];
    [dicSend setObject:textField1 forKey:@"infoSource"];
//    NSString * pageFeedStr = [NSString stringWithFormat:@"{\"userId\":\"%ld\",\"wantedInfo\":\"%@\",\"infoSource\":\"%@\"}",(long)userId,textField,textField1];
    NSDictionary *pageFeedDic=@{@"comInPageStr":dicSend};
    return pageFeedDic;
}
#pragma mark - 获取点赞的post参数
+(NSDictionary *)setThumbUpCommentParameters:(NSInteger)commentType withCommentId:(NSInteger) commentId withSendId:(NSInteger)userId withReceiverId:(NSInteger) receiverId withDate :(NSString *) date
{
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:commentType] forKey:@"commentType"];
    [dicSend setObject:[NSNumber numberWithInteger:commentId] forKey:@"commentId"];
    [dicSend setObject:[NSNumber numberWithInteger:userId] forKey:@"senderId"];
    [dicSend setObject:[NSNumber numberWithInteger:receiverId] forKey:@"receiverId"];
    [dicSend setObject:date forKey:@"date"];
//    NSString *  commentString1 = [NSString stringWithFormat:@"{\"commentType\":\"%ld\",\"commentId\":\"%ld\",\"senderId\":\"%ld\",\"receiverId\":\"%ld\",\"date\":\"%@\"}",(long)commentType,(long)commentId,(long)userId,(long)receiverId,date];
    NSDictionary *  commentString = @{@"commentString":dicSend};
    return commentString;
}
#pragma mark - 获取评论的post参数
+(NSDictionary *)setCommentParameters:(NSInteger )pageId withSendId:(NSInteger)userId withdate:(NSString * )date withComment:(NSString *)comment
{
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:pageId] forKey:@"pageId"];
    [dicSend setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [dicSend setObject:[NSNumber numberWithInt:-1] forKey:@"toComId"];
    [dicSend setObject:date forKey:@"date"];
    [dicSend setObject:comment forKey:@"comment"];
    
//    NSString * commentString1= [NSString stringWithFormat:@"{\"pageId\":\"%ld\",\"senderId\":\"%ld\",\"toComId\":\"%d\",\"date\":\"%@\",\"comment\":\"%@\"}",(long)pageId,(long)userId,-1,date,comment];
     NSDictionary *  commentString = @{@"commentString":dicSend};
    return commentString;
}
#pragma mark - 获取登录的post参数
+(NSDictionary *) setLoginParameters:(NSInteger )userId withMail:(NSString *)userMail withTelNumber:(NSString *)userTelNumber withPassWord:(NSString *)passWord
{
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [dicSend setObject:userMail forKey:@"mail"];
    [dicSend setObject:userTelNumber forKey:@"telnumber"];
    [dicSend setObject:passWord forKey:@"password"];
    //NSDictionary * loginString = @{@"loginString":dicSend};
    NSLog(@"dicSend:%@",dicSend);
    return dicSend;
}
#pragma mark - 获取Menu反馈的post参数
+(NSDictionary *)setFeedBackMenuParameters:(NSInteger)userId withFeedBackType:(int)feedBackType withFeedBackContent:(NSString *)feedBackContent withScreenShot:(NSArray *)imageArray withImageCount:(int)imageCount
{
    NSInteger i;
    //反馈post参数
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[NSNumber numberWithInteger: [KBLoginSingle newinstance].userID ] forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInt:feedBackType] forKey:@"feedbackType"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm  MM-dd"];
    [dic setObject:  [formatter stringFromDate:[NSDate date]]forKey:@"feedbackDate"];
    
    [dic setObject:feedBackContent forKey:@"feedbackContent"];
    for (i=0; i<imageCount; i++)
    {
        UIImage * sumbitimage=[imageArray objectAtIndex:i];
        NSData *data = UIImageJPEGRepresentation(sumbitimage,1.0f);
        NSString * photo=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        photo=[photo stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        photo = [photo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        photo=  [photo stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        photo = [photo stringByReplacingOccurrencesOfString:@"\v" withString:@""];
        photo = [photo stringByReplacingOccurrencesOfString:@"\f" withString:@""];
        photo = [photo stringByReplacingOccurrencesOfString:@"\b" withString:@""];
        photo = [photo stringByReplacingOccurrencesOfString:@"\a" withString:@""];
        photo = [photo stringByReplacingOccurrencesOfString:@"\e" withString:@""];
        
        [dic setObject:photo forKey:[NSString stringWithFormat:@"screenShot%ld",(long)(i+1)]];
        
    }
    for (i=0; i<4-imageCount; i++){
        [dic setObject:@"" forKey:[NSString stringWithFormat:@"screenShot%ld",imageCount+i+1]];
    }
//    NSString *dicToSendStr;
//    
//    if ([NSJSONSerialization isValidJSONObject:dic]) {
//        NSError *error;
//        NSData *data=    [NSJSONSerialization dataWithJSONObject:dic options: NSJSONWritingPrettyPrinted error:&error];
//        dicToSendStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        
//    }
    NSDictionary * sendDic= @{@"feedbackString":dic};
    return sendDic;
}
#pragma mark - 获取保存用户信息的post参数
+(NSDictionary *)setSaveUserInfoParameters:(NSInteger)userId withUserName:(NSString *)userName withUserPhoto:(NSString * )userPhoto withUserSex:(NSString * )userSex withUserSchool:(NSString *)userSchool withUserSchoolYear:(NSString * )userSchoolYear
{
    NSString* photo=[userPhoto stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    photo = [photo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    photo=  [photo stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    photo = [photo stringByReplacingOccurrencesOfString:@"\v" withString:@""];
    photo = [photo stringByReplacingOccurrencesOfString:@"\f" withString:@""];
    photo = [photo stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    photo = [photo stringByReplacingOccurrencesOfString:@"\a" withString:@""];
    photo = [photo stringByReplacingOccurrencesOfString:@"\e" withString:@""];
    // 使用NSDictionary封装请求参数
    
    NSMutableDictionary *dicToSend=[[NSMutableDictionary alloc]init];
    [dicToSend setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [dicToSend setObject:userName forKey:@"userName"];
    [dicToSend setObject:photo forKey:@"userPhoto"];
    [dicToSend setObject:userSex forKey:@"userSex"];
    [dicToSend setObject:userSchool forKey:@"school"];
    [dicToSend setObject:userSchoolYear forKey:@"schoolYear"];
    NSDictionary * updateInfoString = @{@"updateInfoString":dicToSend};
    return updateInfoString;
}
#pragma mark - 获取保存用户新密码的post参数（修改密码）
+(NSDictionary *)setSaveUserNewPassWordParameters:(NSInteger)userId withOldPassWord:(NSString *)oldPassWord withNewPassWord:(NSString *)newPassWord
{
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [dicSend setObject:oldPassWord forKey:@"oldPasswd"];
    [dicSend setObject:newPassWord forKey:@"newPasswd"];
//    NSString * updatePasswdString1 = [NSString stringWithFormat:@"{\"userId\":\"%ld\",\"oldPasswd\":\"%@\",\"newPasswd\":\"%@\"}",(long)userId,oldPassWord,newPassWord];
    NSDictionary * updatePasswdString = @{@"updatePasswdString":dicSend};
    return updatePasswdString;
}
#pragma mark  - 获取用户回复他人的post参数
+(NSDictionary *)setUserReplyToOthersParameters:(NSInteger)pageId withUserId:(NSInteger)userId withCommentId:(NSInteger)commentId  withReplyContent:(NSString *)replyContent
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm MM-dd"];
    NSString * replyDate=[formatter stringFromDate:date];
    
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:pageId] forKey:@"pageId"];
    [dicSend setObject:[NSNumber numberWithInteger:userId] forKey:@"senderId"];
    [dicSend setObject:[NSNumber numberWithInteger:commentId] forKey:@"toComId"];
    [dicSend setObject:replyDate forKey:@"date"];
    [dicSend setObject:replyContent forKey:@"date"];
//    NSString * commentString1 = [NSString stringWithFormat:@"{\"pageId\":\"%ld\",\"senderId\":\"%ld\",\"toComId\":\"%ld\",\"date\":\"%@\",\"comment\":\"%@\"}",(long)pageId,(long)userId,(long)commentId,replyDate,replyContent];
    NSDictionary *  commentString = @{@"commentString":dicSend};
    return  commentString;
}
#pragma mark - 获取用户订阅发生改变的post参数
+(NSDictionary *)setUserSubscriptionChangeParameters:(NSArray * )subscriptionArray  withUserId:(NSInteger)userId
{
    NSMutableArray *updateArray=[[NSMutableArray alloc]init];
    for (int i=0; i<subscriptionArray.count; i++)
    {
        NSMutableDictionary *updateDic=[[NSMutableDictionary alloc]init];
        NSArray *interestOneArrayToSend=[subscriptionArray objectAtIndex:i];
        NSMutableArray *TwoID_ThirdNameArray=[[NSMutableArray alloc]init];
        for (int j=0; j<interestOneArrayToSend.count; j++)
        {
            KBThreeSortModel *find3InterestToSend=[interestOneArrayToSend objectAtIndex:j];
            NSMutableDictionary *TwoID_ThirdNameDic=[[NSMutableDictionary alloc]init];
            [TwoID_ThirdNameDic setObject:[NSNumber numberWithInteger: find3InterestToSend.TypeTowID] forKey:@"secondType"];
            [TwoID_ThirdNameDic setObject:find3InterestToSend.name forKey:@"thirdName"];
            [TwoID_ThirdNameArray addObject:TwoID_ThirdNameDic];
        }
        [updateDic setObject:TwoID_ThirdNameArray forKey:@"focus"];
        [updateDic setObject:[NSNumber numberWithInt:i+2] forKey:@"itemNumber"];
        [updateArray addObject:updateDic];
    }
    
    NSMutableDictionary *updateAlldic=[[NSMutableDictionary alloc]init];
    [updateAlldic setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [updateAlldic setObject:updateArray forKey:@"updateFocusList"];

    NSDictionary * willSendDic=@{@"updateListString":updateAlldic};
    return willSendDic;
}
+(NSDictionary *)setThirdTypeToTopParameters:(NSInteger )userId withItemNumber:(NSInteger )itemNumber withThirdType:(NSString *)thirdTypeStrId
{
    NSMutableDictionary * dicSend = [[NSMutableDictionary alloc]init];
    [dicSend setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    [dicSend setObject:[NSNumber numberWithInteger:itemNumber] forKey:@"firstType"];
    [dicSend setObject:thirdTypeStrId forKey:@"thirdType"];
    return  dicSend;
}
@end
