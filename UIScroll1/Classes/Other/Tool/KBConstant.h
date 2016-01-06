//
//  KBConstant.h
//  UIScroll1
//
//  Created by zhuyongqing on 15/12/9.
//  Copyright © 2015年 Test. All rights reserved.
//

#ifndef KBConstant_h
#define KBConstant_h



#endif /* KBConstant_h */

// 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define KBLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define KBLog(...)
#endif
/**
 *  字体 14
 */
#define kFont_14 [UIFont fontWithName:@"TrebuchetMS-Bold" size:14]
/**
 *  字体 16
 */
#define kFont_16 [UIFont fontWithName:@"TrebuchetMS-Bold" size:16]
/**
 *  字体 18
 */
#define kFont_18 [UIFont fontWithName:@"TrebuchetMS-Bold" size:18]
/**
 *  字体 20
 */

#define KFont_20 [UIFont fontWithName:@"TrebuchetMS-Bold" size:20]

/**
 *  屏幕尺寸
 */
#define kWindowSize [UIScreen mainScreen].bounds.size
/**
 *  基本的url
 */
#define kBaseUrl @"http://192.168.1.16:8080/kuibuversion1/version1_3"//@"http://121.40.188.62"
//@"http://192.168.31.95:8080"
//@"http://139.129.18.232:8080"
/**
 *  友盟的Appkey
 */
#define KYouMengCounter @"55be0ff1e0f55ac25500bc10"

/**
 *  友盟测试的Appkey
 */
#define KYouMengCounterTest @"5657d61667e58eacab000e3f"


/**
 *  友盟微信AppKey
 */
#define KYouMengWXCounter @"wxea87cda5461e6902"


/**
 *  友盟微信AppSecret
 */
#define KYouMengWXSecretCounter @"76c0827f75312d410869410e4ebb6792"

/**
 *  友盟QQAppKey
 */
#define KYouMengQQCounter @"1104745162"


/**
 *  友盟QQAppSecret
 */
#define KYouMengQQSecretCounter @"iCw8CuDzeSpk58wB"
/**
 * 短信验证AppKey
 */

#define KMessageVerifyCounter @"7a5e61bc9498"//@"de7f43826c88"


/**
 * 短信验证AppSecret
 */
#define KMessageVerifySecretCounter @"b84f89a2d1b5939ac4aef5f052688555"//@"eb6dc86e8cf283791f9dac8e98731866"


/**
 *  首页推荐的url
 */
#define kHomeTopUrl(baseUrl) [NSString stringWithFormat:@"%@/subscri/getNewSubscriPage",(baseUrl)]

/**
 *  四个分类 登录的url itemNumber分类的的序号 userID用户的Id pageNumber请求的分页数 服务器有缓存
 */
#define KTypeHaveCacheLoginedUrl(baseUrl,itemNumber,userID,pageNumber)  [NSString stringWithFormat:@"%@/page/mainPage/%ld/%ld/%ld/0",(baseUrl),((long)itemNumber),((long)userID),((long)pageNumber)]

/**
 *   四个分类 登录的url itemNumber分类的的序号 userID用户的Id pageNumber请求的分页数 服务器清空缓存
 */
#define KTypeClearCacheLoginedUrl(baseUrl,itemNumber,userID,pageNumber)  [NSString stringWithFormat:@"%@/page/mainPage/%ld/%ld/%ld/1",(baseUrl),((long)itemNumber),((long)userID),((long)pageNumber)]

/**
 *  四个分类 未登录的url pageNumber请求的分页数 服务器有缓存
 */
#define KTypeHaveCacheNoLoginedUrl(baseUrl,itemNumber,pageNumber)  [NSString stringWithFormat:@"%@/page/newMainPageNoLogin/%ld/%ld/0",(baseUrl),((long)itemNumber),((long)pageNumber)]

/**
 *  四个分类 未登录的url pageNumber请求的分页数 服务器清空缓存
 */
#define KTypeClearCacheNoLoginedUrl(baseUrl,itemNumber,pageNumber)  [NSString stringWithFormat:@"%@/page/newMainPageNoLogin/%ld/%ld/1",(baseUrl),((long)itemNumber),((long)pageNumber)]

/**
 *  正文的url
 */
#define KWebviewUrl(baseUrl,pageId) [NSString stringWithFormat:@"%@/page/getPageInfo/%ld",baseUrl,(long)pageId]

/**
 *  正文下面的信息的url userId登录用户的Id 没登录为-1 pageId为文章的pageId
 */
#define KWebviewOtherInfoUrl(baseUrl,userId,pageId)  [NSString stringWithFormat:@"%@/page/getPageOtherInfo/%ld/%ld",baseUrl,(long)userId,(long)pageId]

/**
 *  正文下面的信息点赞的url
 */
#define KWebviewThumbUpUrl(baseUrl) [NSString stringWithFormat:@"%@/page/comPraise",baseUrl]

/**
 *  正文下面的信息评论的url
 */
#define KWebviewCommentUrl(baseUrl) [NSString stringWithFormat:@"%@/page/addComment",baseUrl]
/**
 *  分享成功
 */
#define KWebviewShareSuccessUrl(baseUrl,pageId) [NSString stringWithFormat:@"%@/page/transmit/%ld",baseUrl,(long)pageId]

/**
 *  用户收藏
 */
#define KWebviewCollectUrl(baseUrl) [NSString stringWithFormat:@"%@/user/doCollect",baseUrl]

/**
 *  点击好文
 */
#define KWebviewThumbUpWebUrl(baseUrl,userId,pageId) [NSString stringWithFormat:@"%@/page/pageContentComment/%ld/%ld/1",baseUrl,(long)userId,(long)pageId]

/**
 *  点击水文
 */
#define KWebviewFootDownWebUrl(baseUrl,userId,pageId) [NSString stringWithFormat:@"%@/page/pageContentComment/%ld/%ld/0",baseUrl,(long)userId,(long)pageId]

/**
 *  正文里的反馈
 */
#define KWebviewFeedBackWebUrl(baseUrl) [NSString stringWithFormat:@"%@/page/postComInPage",baseUrl]

/**
 *  正文里的三级分类的订阅
 */
#define KWebviewSubscriptionUrl(baseUrl,userId,secondType,classString) [NSString stringWithFormat:@"%@/subscri/subscriThirdType/%ld/%ld/%@",baseUrl,(long)userId,(long)secondType,classString]
/**
 *  获取某条评论的回复列表
 */
#define KCommentReplyUrl(baseUrl,commentId) [NSString stringWithFormat:@"%@/page/comReply/%ld",baseUrl,(long)commentId]

/**
 *  置顶某个三级分类
 */
#define KThirdTypeToTopUrl(baseUrl) [NSString stringWithFormat:@"%@/user/topThirdType",baseUrl]

//Menu
/**
 *  收藏列表
 */
#define KCollectLoginUrl(baseUrl,userId,pageNumber) [NSString stringWithFormat:@"%@/user/getCollectList/%ld/%ld",baseUrl,(long)userId,(long)pageNumber]
/**
 *  收藏列表的筛选选中的二级分类
 */
#define KCollectLoginSelectSecondTypeUrl(baseUrl,userId,secondType,pageNumber) [NSString stringWithFormat:@"%@/user/getSecondTypeCollectList/%ld/%ld/%ld",baseUrl,(long)userId,(long)secondtype,(long)pageNumber]

/**
 *  Menu的反馈
 */
#define KMenuFeedBackUrl(baseUrl) [NSString stringWithFormat:@"%@/user/feedback",baseUrl]

/**
 *  保存用户更新的信息
 */
#define KSaveUserInfoUrl(baseUrl) [NSString stringWithFormat:@"%@/user/updateInfo",baseUrl]

/**
 *  保存用户新密码
 */
#define KSaveUserNewPassWordUrl(baseUrl) [NSString stringWithFormat:@"%@/user/changePasswd",baseUrl]
/**
 *  用户的消息状态的改变
 */
#define KUserMessageChangeUrl(baseUrl,userId) [NSString stringWithFormat:@"%@/user/message/%ld",baseUrl,(long )userId]

/**
 *  消息回复列表
 */
#define KUserMessageReplyUrl(baseUrl,userId,pageNumber) [NSString stringWithFormat:@"%@/user/message/reply/%ld/%ld",baseUrl,(long)userId,(long)pageNumber]

/**
 *  用户的回复他人
 */
#define KUserReplyToOthersUrl(baseUrl) [NSString stringWithFormat:@"%@/page/addComment",baseUrl]

/**
 *  消息的点赞列表
 */
#define KUserMessagePraiseUrl(baseUrl,userId,pageNumber) [NSString stringWithFormat:@"%@/user/message/praise/%ld/%ld",baseUrl,(long)userId,(long)pageNumber]
//订阅
/**
 *  登录用户订阅发生改变
 */
#define KUserSubscriptionChangeUrl(baseUrl) [NSString stringWithFormat:@"%@/user/updateFocusList",baseUrl]
/**
 *  搜索文章
 */
#define KSearchWebInfoUrl(baseUrl,searchBarText) [[NSString stringWithFormat: @"%@/page/search/%@",baseUrl,searchBarText]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

/**
 *  三级分类详情
 */
#define KTheeTypeDetailUrl(baseUrl,secondType,thirdTypeName,pageNumber)  [[NSString stringWithFormat:@"%@/page/thirdPage/%ld/%@/%ld",baseUrl,(long)secondType,thirdTypeName,(long)pageNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

/**
 *  单独订阅三级分类
 */
#define KThreeTypeSingleSubscriptionUrl(baseUrl,userId,secondType,thirdTypeName)  [[NSString stringWithFormat:@"%@/subscri/subscriThirdType/%ld/%ld/%@",baseUrl,(long)userId,(long)secondType,thirdTypeName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
/**
 *  单独取消三级分类的订阅
 */

#define KThreeTypeSingleCancelSubscriptionUrl(baseUrl,userId,secondType,thirdTypeName)  [[NSString stringWithFormat:@"%@/subscri/removeSubscri/%ld/%ld/%@",baseUrl,(long)userId,(long)secondType,thirdTypeName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//用户

/**
 *  用户登录
 */
#define KUserLoginUrl(baseUrl) [NSString stringWithFormat:@"%@/user/login",baseUrl]

/**
 *  检测用户的账号是否注册过
 */
#define KWhetherUserCounterHasRegisterUrl(baseUrl,phoneNumber) [NSString stringWithFormat:@"%@/user/checkRegister/%@",baseUrl,phoneNumber]

/**
 *  忘记密码
 */
#define KUserForgetPassWordUrl(baseUrl,phoneNumber,newPassWord) [NSString stringWithFormat:@"%@/user/forgetPass/%@/%@",baseUrl,phoneNumber,newPassWord]

/**
 *  用户注册
 */
#define KUserRegisterUrl(baseUrl) [NSString stringWithFormat:@"%@/user/register",baseUrl]

/**
 *  手机号注册
 */
#define KUserPhoneRegisterUrl(baseUrl,phoneNumber,passWord) [NSString stringWithFormat:@"%@/user/register/%@/%@",baseUrl,phoneNumber,passWord]
/**
 *  融云请求获取用户信息
 */
#define KRongYunGetUserInfoUrl(baseUrl,userId) [NSString stringWithFormat:@"%@/thirdPart/user/getUserInfo/%d",baseUrl,[userId intValue]]
/**
 *  融云请求添加好友
 */
#define KRongYunAddFriendsUrl(baseUrl) [NSString stringWithFormat:@"%@/thirdPart/user/addFriends",baseUrl]
