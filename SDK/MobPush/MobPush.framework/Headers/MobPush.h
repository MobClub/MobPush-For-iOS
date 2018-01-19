//
//  MobPush.h
//  MobPush
//
//  Created by 刘靖煌 on 2017/9/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPushNotificationConfiguration.h"
#import "MPushMessage.h"

/**
 收到消息通知（数据是MPushMessage对象，可能是推送数据，也可能是自定义消息数据，非APNs通道数据）
 */
extern NSString *const MobPushDidReceiveMessageNotification;

/**
 推送SDK的核心类
 */
@interface MobPush : NSObject

#pragma mark APNs（苹果公司提供的推送系统）

/**
 设置推送配置

 @param configuration 配置信息
 */
+ (void)setupNotification:(MPushNotificationConfiguration *)configuration;

#pragma mark 本地推送

/**
 添加本地推送通知

 @param message 消息数据
 */
+ (void)addLocalNotification:(MPushMessage *)message;

#pragma mark 推送设置

/**
 获取所有标签

 @param handler 结果
 */
+ (void)getTagsWithResult:(void (^) (NSArray *tags, NSError *error))handler;

/**
 添加标签

 @param tags 标签组
 @param handler 结果
 */
+ (void)addTags:(NSArray<NSString *> *)tags result:(void (^) (NSError *error))handler;

/**
 删除标签

 @param tags 需要删除的标签
 @param handler 结果
 */
+ (void)deleteTags:(NSArray<NSString *> *)tags result:(void (^) (NSError *error))handler;

/**
 清空所有标签

 @param handler 结果
 */
+ (void)cleanAllTags:(void (^) (NSError *error))handler;

/**
 获取别名

 @param handler 结果
 */
+ (void)getAliasWithResult:(void (^) (NSString *alias, NSError *error))handler;

/**
 设置别名

 @param alias 别名
 @param handler 结果
 */
+ (void)setAlias:(NSString *)alias result:(void (^) (NSError *error))handler;

/**
 删除别名

 @param handler 结果
 */
+ (void)deleteAlias:(void (^) (NSError *error))handler;

#pragma mark - other

/**
 获取注册id（可与用户id绑定，实现向指定用户推送消息）

 @param handler 结果
 */
+ (void)getRegistrationID:(void(^)(NSString *registrationID, NSError *error))handler;

@end
