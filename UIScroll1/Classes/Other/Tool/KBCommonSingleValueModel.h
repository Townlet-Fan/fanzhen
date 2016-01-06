//
//  tranSport.h
//  UIScroll1
//
//  Created by kuibu technology on 15/5/18.
//  Copyright (c) 2015年 Test. All rights reserved.
//

//单例传值

#import <Foundation/Foundation.h>

@interface KBCommonSingleValueModel : NSObject
/**
 *  是否只在WiFi下加载图片
 */
@property (nonatomic,assign) BOOL isOnlyImageInWiFi;
/**
 *  字体
 */
@property (nonatomic,strong) NSString *fontSizeStr;
/**
 *  机型设备
 */
@property (nonatomic,strong) NSString *DeviceModel;

/**
 *  接收友盟通知 是否在appDelegate里的启动函数进入文章
 */
@property (nonatomic,assign) BOOL TitleIsroot;
/**
 *  用户的昵称是否改变
 */
@property (nonatomic,assign) BOOL namechangeBool;
/**
 *  用户的性别是否改变
 */
@property (nonatomic,assign) BOOL sexchangeBool;
/**
 *  用户的学校是否改变
 */
@property (nonatomic,assign) BOOL schoolchangeBool;
/**
 *  用户的入学年份是否改变
 */
@property (nonatomic,assign) BOOL yearschoolchangeBool;
/**
 *  用户的昵称传值
 */
@property (nonatomic, strong)NSString * userName;
/**
 *  用户的性别传值
 */
@property (nonatomic, strong)NSString  *userSex;
/**
 *  是否有点赞的新消息
 */
@property (nonatomic,assign) BOOL hasPraise;
/**
 *  是否有回复的新消息
 */
@property (nonatomic,assign) BOOL hasRely;
/**
 *  是否有总的新消息（回复或者点赞，在Menu的消息显示红点）
 */
@property (nonatomic,assign)BOOL hasMessage;

/**
 *  是否是第一次使用（引导页）
 */
@property (nonatomic,assign) BOOL isFirstUsing;
/**
 *  是否是第一启动程序 (已经有app了）
 */
@property BOOL isFinishLaunching;
/**
 *  用户注销登录时，保存用户的账号 以便下次登录时不要输入账号
 */
@property (nonatomic, strong) NSString * remainUserName;

/**
 *  导航栏的代理
 */
@property (nonatomic,retain) id navcontrolDelegate;

/**
 *  在文章中点击相关推荐文章的次数
 */
@property (nonatomic,assign) int  navCount;
/**
 *  是否从三级分类界面进入正文
 */
@property (nonatomic,assign) BOOL isThreeEnterTitle;

/**
 *  是否忘记密码
 */
@property BOOL isForgetPw;
/**
 *  是否点击三级分类的关注和取消关注
 */
@property (nonatomic,assign)BOOL istouchDownInterest;
/**
 *  是否是推荐的分类
 */
@property  (nonatomic,assign)BOOL isRecommandTypeClass;
/**
 *  是否订阅改变 用于主界面的访问服务器的变化
 */
@property (nonatomic,assign)BOOL isChangeInterest;
/**
 *  从主界面进入到订阅频道 对应显示一级分类
 */
@property (nonatomic,assign)int FindContentOffSet;
/**
 *  二级分类
 */
@property (nonatomic,strong)NSString *secondType;

//创建单例
+(KBCommonSingleValueModel*)newinstance;
//获取设备的机型
-(NSString *)getCurrentDeviceModel;
@end
