//
//  MobPush+Test.h
//  MobPush
//
//  Created by LeeJay on 2017/11/27.
//  Copyright © 2017年 com.mob. All rights reserved.
//

#import <MobPush/MobPush.h>

typedef NS_ENUM(NSUInteger, MPushMsgType)
{
    MPushMsgTypeNotification = 1,       //通知类型
    MPushMsgTypeMessage = 2,            //内推类型
    MPushMsgTypeTimeMessage = 3,        //定时类型
};

/**
 这个类仅”客户端发起推送接口“使用，不属于MobPush的功能接口，开发者可以忽略。
 */
@interface MobPush (Test)

/**
 客户端发起推送接口
 
 @param msgType 消息类型
 @param content 模拟发送内容
 @param space 定时消息时间（仅对定时消息有效，单位分钟，默认值为1）
 @param isProduction 开否为生产环境（跟证书相关）
 @param extras 额外字段
 @param handler 结果
 */
+ (void)sendMessageWithMessageType:(MPushMsgType)msgType
                           content:(NSString *)content
                             space:(NSNumber *)space
           isProductionEnvironment:(BOOL)isProduction
                            extras:(NSDictionary *)extras
                            result:(void (^)(NSError *error))handler;

@end
