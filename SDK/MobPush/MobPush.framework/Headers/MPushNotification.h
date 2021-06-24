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
 弹框的按钮显示的内容，IOS 8默认为"打开",iOS10以下有效
 */
@property (nonatomic, copy) NSString *action;

/**
 消息附加信息
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 多媒体附件，需要传入UNNotificationAttachment对象数组类型。iOS10及以上有效
 */
@property (nonatomic, copy) NSArray *attachments;

/**
 可用来对推送消息进行分组。iOS10及以上有效
 */
@property (nonatomic, copy) NSString *threadIdentifier;

/**
 启动图片名，从推送启动时将会用到。iOS10及以上有效
 */
@property (nonatomic, copy) NSString *launchImageName;

/**
 插入到通知摘要中的部分参数。iOS12及以上有效
 */
@property (nonatomic, copy) NSString *summaryArgument;

/**
 插入到通知摘要中的项目数。iOS12及以上有效
 */
@property (nonatomic, assign) NSUInteger summaryArgumentCount;

/**
 通知内容的标识符,点击通知栏消息，用于系统激活自定义的Scene。iOS13及以上有效
 */
@property (nonatomic, copy) NSString *targetContentIdentifier;

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


- (NSDictionary *)convertDictionary;

@end
