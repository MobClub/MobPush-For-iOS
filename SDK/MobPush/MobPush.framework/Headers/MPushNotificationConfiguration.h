//
//  MPushNotificationConfiguration.h
//  MobPush
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 通知权限
 */
typedef NS_OPTIONS(NSUInteger, MPushAuthorizationOptions)
{
    MPushAuthorizationOptionsNone = 0,               //不提醒
    MPushAuthorizationOptionsBadge = (1 << 0),       //角标提醒
    MPushAuthorizationOptionsSound = (1 << 1),       //声音提醒
    MPushAuthorizationOptionsAlert = (1 << 2),       //弹框提醒
};

/**
 通知配置
 */
@interface MPushNotificationConfiguration : NSObject

/**
 权限选项
 */
@property (nonatomic, assign) MPushAuthorizationOptions types;

/**
 注入的类别，iOS10以及以上使用UNNotificationCategory，iOS10以下使用UIUserNotificationCategory。
 */
@property (nonatomic, strong) NSSet *categories;

@end
