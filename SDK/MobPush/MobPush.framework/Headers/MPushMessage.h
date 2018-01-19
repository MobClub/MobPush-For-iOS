//
//  MPushMessage.h
//  MobPush
//
//  Created by 刘靖煌 on 2017/9/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPushNotification.h"
#import "MPushCustomMessage.h"

/**
 消息类型

 - MPushMessageTypeNotification: 通知
 - MPushMessageTypeCustom: 自定义消息
 */
typedef NS_ENUM(NSUInteger, MPushMessageType)
{
    MPushMessageTypeNotification = 1,
    MPushMessageTypeCustom = 2,
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
 通知类型，当 MPushMessageType 为 MPushMessageTypeNotification，这个字段才会有数据。
 */
@property (nonatomic, strong) MPushNotification *notification;

/**
 自定义消息类型，当 MPushMessageType 为 MPushMessageTypeCustom时，这个字段才会有数据。
 */
@property (nonatomic, strong) MPushCustomMessage *customMessage;

/**
 *  字典转模型
 */
+ (instancetype)messageWithDict:(NSDictionary *)dict;

/**
 *  字典转模型
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
