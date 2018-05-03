//
//  MPushNotification.h
//  MobPush
//
//  Created by LeeJay on 2017/9/8.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 推送通知
 */
@interface MPushNotification : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 副标题
 */
@property (nonatomic, copy) NSString *subTitle;

/**
 推送消息体
 */
@property (nonatomic, copy) NSString *body;

/**
 指定声音的文件名(默认值为"default")
 */
@property (nonatomic, copy) NSString *sound;

/**
 应用图标右上角显示未读数的角标
 */
@property (nonatomic, assign) NSInteger badge;

/**
 处理通知action事件所需的标识
 */
@property (nonatomic, copy) NSString *category;

/**
 是否为静默推送
 */
@property (nonatomic, assign) BOOL silentPush;

/**
 静默推送相关的一个参数，当值为1时为静默推送(有新内容要更新了)
 */
@property (nonatomic, assign) BOOL contentAvailable;

/**
 推送插件相关(可以修改推送内容)
 */
@property (nonatomic, assign) BOOL mutableContent;

/**
 *  字典转模型
 */
+ (instancetype)notificationWithDict:(NSDictionary *)dict;

@end
