//
//  MPushNotificationRequest.h
//  MobPush
//
//  Created by wkx on 2020/5/21.
//  Copyright © 2020 com.mob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPushNotificationTrigger.h"
#import "MPushNotification.h"

/**
 * 本地消息推送请求体
 * [MobPush addLocalNotification:result:]
 */
@interface MPushNotificationRequest : NSObject

// 推送消息唯一标识,iOS10以上 相同标识的消息将会被替换，如果为nil将随机生成
@property(nonatomic, copy) NSString *requestIdentifier;

// 推送消息具体内容
@property(nonatomic, strong) MPushNotification *content;

// 推送消息触发方式,nil时为即时消息，立即推送
@property(nonatomic, strong) MPushNotificationTrigger *trigger;

@end

