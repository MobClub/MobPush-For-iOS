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
#import "MPushNotificationRequest.h"
#import "MPushNotificationTrigger.h"
#import "MPushNotification.h"

/**
 收到消息通知（数据是MPushMessage对象，可能是推送数据、自定义消息数据，APNs、本地通知等的回调）
 */
extern NSString *const MobPushDidReceiveMessageNotification;    // 接收通知消息

extern NSString *const MobPushNetworkDidRegisterNotification;          // 注册通知成功
extern NSString *const MobPushNetworkFailedRegisterNotification;       // 注册通知失败
extern NSString *const MobPushNetworkConnectingNotification;           // 正在连接中
extern NSString *const MobPushNetworkConnectedNotification;            // 连接成功
extern NSString *const MobPushNetworkDidLoginNotification;             // 登录成功
extern NSString *const MobPushNetworkDidCloseNotification;             // 关闭连接

/**
 系统通知授权状态
 */
typedef NS_ENUM(NSInteger, MPushAuthorizationStatus) {
    // The user has not yet made a choice regarding whether the application may post user notifications.
    MPushAuthorizationStatusNotDetermined   = 0,
    
    // The application is not authorized to post user notifications.
    MPushAuthorizationStatusDenied,
    
    // The application is authorized to post user notifications.
    MPushAuthorizationStatusAuthorized,
    
    // The application is authorized to post non-interruptive user notifications.
    MPushAuthorizationStatusProvisional NS_AVAILABLE_IOS(12.0),
};

/**
 提交到系统的推送请求状态，目前用于删除推送通知使用
*/
typedef NS_ENUM(NSInteger, MPushNotificationRequestStatus) {
    MPushNotificationRequestStatusAll           = 0,    //包括下列所有情况
    MPushNotificationRequestStatusPending       = -1,   //待发送(如：定时推送未发送)
    MPushNotificationRequestStatusDelivered     = 1,    //在系统通知栏里的推送
};

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

/**
 检测当前应用通知授权状态
 */
+ (void)requestNotificationAuthorizationStatus:(void (^)(MPushAuthorizationStatus status))handler;

/**
 打开系统设置页面，iOS8及以上有效
 */
+ (void)openSettingsForNotification:(void (^)(BOOL success))handler;

#pragma mark 本地推送

/**
 添加本地推送通知

 @param message 消息数据
 */
+ (void)addLocalNotification:(MPushMessage *)message  __attribute__((deprecated("MobPush 3.0.1 版本已弃用 use 'addLocalNotification:result:' instead")));

/**
 添加本地推送通知

 @param request 消息请求(消息标识、消息具体信息、触发方式)
 @param handler 结果，iOS10以上成功result为UNNotificationRequest对象、iOS10以下成功result为UILocalNotification对象，失败result为nil
*/
+ (void)addLocalNotification:(MPushNotificationRequest *)request result:(void (^) (id result, NSError *error))handler;

/**
 删除指定的推送通知（可以删除未发送或者已经发送的本地通知）

 @param identifiers 推送请求标识数组，为nil，删除所有通知
 */
+ (void)removeNotificationWithIdentifiers:(NSArray <NSString *> *)identifiers;

/**
 删除指定的推送通知
 @param identifiers 推送请求标识数组，为nil，删除该类型所有通知
 @param requestStatus 三种类型MPushNotificationRequestStatusPending:未发送，MPushNotificationRequestStatusAll：未发送和已发送(通知栏)，MPushNotificationRequestStatusDelivered：已发送(通知栏)
*/
+ (void)removeNotificationWithIdentifiers:(NSArray<NSString *> *)identifiers requestStatus:(MPushNotificationRequestStatus)requestStatus;

/**
 查找通知

 @param identifiers 推送请求标识数组，为nil或空数组时则返回相应标志下所有在通知中心显示推送或待推送请求
 @param delivered  在通知中心显示的或待推送的标志，默认为NO，YES表示在通知中心显示的，NO表示待推送的，在通知中心查询iOS10及以上
 @param handler 查找结果， result值:
    iOS10以下返回UILocalNotification对象数组
    iOS10及以上：
        delivered传入YES，则返回UNNotification对象数组，否则返回UNNotificationRequest对象数组
*/
+ (void)findNotificationWithIdentifiers:(NSArray <NSString *> *)identifiers
                              delivered:(BOOL)delivered
                                handler:(void (^) (NSArray *result, NSError *error))handler;

#pragma mark 推送设置 标签、别名

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
 替换标签

 @param tags 需要删除的标签
 @param handler 结果
*/
+ (void)replaceTags:(NSArray *)tags result:(void (^)(NSError *error))handler;

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
 获取服务器上的角标
 @param handler 回调
*/
+ (void)getBadgeWithhandler:(void (^)(NSInteger badge,NSError *error))handler;

/**
 清除角标，但不清空通知栏消息
 */
+ (void)clearBadge;

/**
 绑定手机号,传字符串空为解除绑定

 @param phoneNum 手机号
 @param handler 回调
 */
+ (void)bindPhoneNum:(NSString *)phoneNum result:(void (^) (NSError *error))handler;

/**
 获取绑定过的手机号码
 
 @param handler 回调
 */
+ (void)getPhoneNumWithResult:(void(^) (NSString *phoneNum, NSError *error))handler;

/**  下面的 API，方便开发者在 APP 内添加 "关闭推送" 的按钮 **/

/**
 当前远程推送是否关闭
 
 @return YES：推送关闭状态，NO：推送打开状态
 */
+ (BOOL)isPushStopped;

/**
 关闭远程推送（应用内推送和本地通知不受影响，只关闭远程推送）
 */
+ (void)stopPush;

/**
 打开远程推送
 */
+ (void)restartPush;

/**
 SDK版本
 */
+ (NSString *)sdkVersion;

/// 设置区域id
/// @param regionId 默认0（国内），1:海外
+ (void)setRegionID:(int)regionId;

@end
