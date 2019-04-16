//
//  MobPush.h
//  MobPush
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPushNotificationConfiguration.h"
#import "MPushMessage.h"

/**
 收到消息通知（数据是MPushMessage对象，可能是推送数据、自定义消息数据，APNs、本地通知等的回调）
 */
extern NSString *const MobPushDidReceiveMessageNotification;

/**
 推送SDK的核心类
 */
@interface MobPush : NSObject

#pragma mark APNs（苹果公司提供的推送系统）

/**
 设置推送环境

 @param isProduction 是否生产环境。 如果为开发状态，设置为 NO； 如果为生产状态，应改为 YES。 Default 为 YES 生产状态
 */
+ (void)setAPNsForProduction:(BOOL)isProduction;

/**
 设置推送配置

 @param configuration 配置信息
 */
+ (void)setupNotification:(MPushNotificationConfiguration *)configuration;

/**
 设置应用在前台有 Badge、Sound、Alert 三种类型，默认3个选项都有，iOS 10 以后设置有效。
 如果不想前台有 Badge、Sound、Alert，设置 MPushAuthorizationOptionsNone

 @param type 类型
 */
+ (void)setAPNsShowForegroundType:(MPushAuthorizationOptions)type;

#pragma mark 本地推送

/**
 添加本地推送通知

 @param message 消息数据
 */
+ (void)addLocalNotification:(MPushMessage *)message;

/**
 删除指定的本地通知（可以删除未发送或者已经发送的本地通知）

 @param identifiers 推送请求标识数组，为nil，删除所有通知
 */
+ (void)removeNotificationWithIdentifiers:(NSArray <NSString *> *)identifiers;

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

/**
 设置角标值到Mob服务器
 本地先调用setApplicationIconBadgeNumber函数来显示角标，再将该角标值同步到Mob服务器，
 @param badge 新的角标值（会覆盖服务器上保存的值）
 */
+ (void)setBadge:(NSInteger)badge;

/**
 清除角标，但不清空通知栏消息
 */
+ (void)clearBadge;

/**
 绑定手机号

 @param phoneNum 手机号
 @param handler 回调
 */
+ (void)bindPhoneNum:(NSString *)phoneNum result:(void (^) (NSError *error))handler;

/**  下面的 API，方便开发者在 APP 内添加 "关闭推送" 的按钮 **/

/**
 当前远程推送是否关闭
 
 @return YES：推送关闭状态，NO：推送打开状态
 */
+ (BOOL)isPushStopped;

/**
 关闭远程推送（应用内推送和本地通知不送影响，只关闭远程推送）
 */
+ (void)stopPush;

/**
 打开远程推送
 */
+ (void)restartPush;

@end
