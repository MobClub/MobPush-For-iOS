//
//  MPushMessage.h
//  MobPush
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPushNotification.h"
#import "MPushCustomMessage.h"

/**
 消息类型
 */
typedef NS_ENUM(NSUInteger, MPushMessageType)
{
    MPushMessageTypeUDPNotify = 1, //UDP通知
    MPushMessageTypeTCPNotify = MPushMessageTypeUDPNotify, //TCP通知
    MPushMessageTypeCustom = 2, //自定义消息
    MPushMessageTypeAPNs = 3, //APNs推送
    MPushMessageTypeLocal = 4, //本地推送
    MPushMessageTypeClicked = 5,//点击通知
};

/**
 消息对象
 */
@interface MPushMessage : NSObject

/**
 消息任务ID
 */
@property (nonatomic, copy, readonly) NSString *messageID;

/**
 消息类型
 */
@property (nonatomic, assign) MPushMessageType messageType;

/**
 推送的唯一标识(两条推送该属性不能一样，否则通知栏显示，新的推送会覆盖旧推送，删除推送功能可以设置该属性，默认值是当前时间戳)
 */
@property (nonatomic, copy) NSString *identifier;

/**
 通知消息体
 */
@property (nonatomic, strong) MPushNotification *notification;


- (NSDictionary *)convertDictionary;

#pragma mark - API 已弃用

/**
 消息内容
 */
@property (nonatomic, copy) NSString *content __attribute__((deprecated("MobPush 3.0.1 版本已弃用 use 'notification.body' instead")));

/**
 是否为及时消息，如果是定时消息，taskDate属性会有时间数据。
 */
@property (nonatomic, assign) BOOL isInstantMessage __attribute__((deprecated("MobPush 3.0.1 版本已弃用 发送本地通知请使用 'MPushNotificationRequest、MPushNotificationTrigger'相关类")));

/**
 定时消息的发送时间
 */
@property (nonatomic, assign) NSTimeInterval taskDate  __attribute__((deprecated("MobPush 3.0.1 版本已弃用 ,发送本地通知请使用 'MPushNotificationRequest、MPushNotificationTrigger'相关类")));

/**
 额外的数据
 */
@property (nonatomic, strong) NSDictionary *extraInfomation __attribute__((deprecated("MobPush 3.0.1 版本已弃用 use 'notification.userInfo' instead")));

/**
当 MPushMessageType为MPushMessageTypeCustom时 这个字段才会有数据。
 */
@property (nonatomic, strong) MPushCustomMessage *customMessage __attribute__((deprecated("MobPush 3.0.1 版本已弃用 use 'notification.userInfo 'mobpushCustomTitle'、'mobpushCustomType' key get value' instead")));

/**
 当 MPushMessageType为MPushMessageTypeAPNs时，返回apns消息数据以及场景还原数据。
 当 MPushMessageType为MPushMessageTypeLocal时，返回场景还原数据。
 "mobpush_link_k" :点击Apns消息场景还原的控制器路径。
 "mobpush_link_v" :点击Apns消息场景还原的参数。
 */
@property (nonatomic, strong) NSDictionary *msgInfo __attribute__((deprecated("MobPush 3.0.1 版本已弃用 use 'notification.userInfo' instead")));

/**
当 MPushMessageType为MPushMessageTypeAPNs时，这个字段才会有数据。
 */
@property (nonatomic, strong) NSDictionary *apnsDict __attribute__((deprecated("MobPush 1.4.0 版本已弃用")));

@end
