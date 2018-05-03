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

 - MPushMessageTypeNotification: UDP 通知
 - MPushMessageTypeCustom: UDP 自定义消息
 - MPushMessageTypeAPNs: APNs
 - MPushMessageTypeLocal: 本地通知
 */
typedef NS_ENUM(NSUInteger, MPushMessageType)
{
    MPushMessageTypeNotification = 1,
    MPushMessageTypeCustom = 2,
    MPushMessageTypeAPNs = 3,
    MPushMessageTypeLocal = 4,
};

/**
 消息
 */
@interface MPushMessage : NSObject

/**
 消息任务ID
 */
@property (nonatomic, copy) NSString *messageID;

/**
 消息类型
 */
@property (nonatomic, assign) MPushMessageType messageType;

/**
 消息内容
 */
@property (nonatomic, copy) NSString *content;

/**
 是否为及时消息，如果是定时消息，taskDate属性会有时间数据。
 */
@property (nonatomic, assign) BOOL isInstantMessage;

/**
 定时消息的发送时间
 */
@property (nonatomic, assign) NSTimeInterval taskDate;

/**
 额外的数据
 */
@property (nonatomic, strong) NSDictionary *extraInfomation;

/**
 当前服务器时间戳
 */
@property (nonatomic, assign) NSTimeInterval currentServerTimestamp;

/**
 通知类型，当 MPushMessageType 为 MPushMessageTypeNotification 或者 MPushMessageTypeLocal，这个字段才会有数据。
 */
@property (nonatomic, strong) MPushNotification *notification;

/**
 自定义消息类型，当 MPushMessageType 为 MPushMessageTypeCustom时，这个字段才会有数据。
 */
@property (nonatomic, strong) MPushCustomMessage *customMessage;

/**
 APNs 类型，当 MPushMessageType 为 MPushMessageTypeAPNs 时，这个字段才会有数据。
 */
@property (nonatomic, copy) NSDictionary *apnsDict;

/**
 *  字典转模型
 */
+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
