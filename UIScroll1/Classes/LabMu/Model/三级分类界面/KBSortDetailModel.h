//
//  KBSortDetailModel.h
//  UIScroll1
//
//  Created by 邓存彬 on 15/12/26.
//  Copyright © 2015年 Test. All rights reserved.
//

//三级分类的关注
#import <Foundation/Foundation.h>

@interface KBSortDetailModel : NSObject
//判断三级分类是否关注
+(BOOL)whetherThreeTypeSubscription:(NSString * )threeTypeName;

//三级分类订阅成功
+(int)threeTypeSubcription:(NSString * )threeTypeName;

//三级分类取消订阅成功
+(int)threeTypeCancelSubcription:(NSString * )threeTypeName;
@end
