//
//  KBWebviewFootAndCollectModel.h
//  UIScroll1
//
//  Created by kuibu technology on 15/12/17.
//  Copyright © 2015年 Test. All rights reserved.
//

//webview足迹和收藏的数据处理
#import <Foundation/Foundation.h>

@interface KBWebviewFootAndCollectModel : NSObject
/**
 *  足迹插入数据库
 */
+(void)insertFootMaskSQL;
/**
 *  先从数据库里删除对应pageId的文章，在插入数据库
 */
+(void)deleteFooter;

/**
 *  未登录用户 先删除收藏 为后面加入收藏 避免收藏多次
 */
+(void)deleteHavecollect;
/**
 *  加入未登录用户本地收藏
 *
 *  @return Yes or No
 */
+(BOOL )insertCollect;
/**
 *  取消未登录用户本地收藏
 *
 *  @return Yes or No
 */
+(BOOL)deleteCollect;
@end
