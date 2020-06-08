//
//  MPushCustomMessage.h
//  MobPush
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自定义消息类型
 */
DEPRECATED_MSG_ATTRIBUTE("MobPush 3.0.1 版本此类已弃用 信息可在MPushMessage对象下notification.userInfo key为'mobpushCustomTitle'、'mobpushCustomType' 获取")
@interface MPushCustomMessage : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 自定义消息类型，如 text 文本
 */
@property (nonatomic, copy) NSString *type;

/**
 *  字典转模型
 */
+ (instancetype)customMessageWithDict:(NSDictionary *)dict;

@end
