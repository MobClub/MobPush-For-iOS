//
//  MobPush+Test.h
//  MobPush
//
//  Created by LeeJay on 2017/11/27.
//  Copyright © 2017年 com.mob. All rights reserved.
//

#import <MobPush/MobPush.h>

typedef NS_ENUM(NSInteger, MSendMessageType)
{
    MSendMessageTypeAPNs = 1,         //推送类型
    MSendMessageTypeCustom = 2,       //自定义消息类型
    MSendMessageTypeTimed = 3,        //定时通知类型
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
 @param linkScheme 界面还原路径
 @param linkData 界面还原参数
 @param handler 结果
 */
+ (void)sendMessageWithMessageType:(MSendMessageType)msgType
                           content:(NSString *)content
                             space:(NSNumber *)space
           isProductionEnvironment:(BOOL)isProduction
                            extras:(NSDictionary *)extras
                        linkScheme:(NSString *)linkScheme
                          linkData:(NSString *)linkData
                            result:(void (^)(NSError *error))handler __deprecated_msg("Method discard from v2.3.0.");

/**
客户端发起推送接口

@param msgType 消息类型
@param content 模拟发送内容
@param space 定时消息时间（仅对定时消息有效，单位分钟，默认值为1）
@param sound mainBundle里面的铃声文件名称
@param isProduction 开否为生产环境（跟证书相关）
@param extras 额外字段
@param linkScheme 界面还原路径
@param linkData 界面还原参数
@param coverId  需要覆盖消息的workid
@param handler 结果
*/
+ (void)sendMessageWithMessageType:(MSendMessageType)msgType
                           content:(NSString *)content
                             space:(NSNumber *)space
                             sound:(NSString *)sound
           isProductionEnvironment:(BOOL)isProduction
                            extras:(NSDictionary *)extras
                        linkScheme:(NSString *)linkScheme
                          linkData:(NSString *)linkData
                           coverId:(NSString *)coverId
                            result:(void (^)(NSString *workId, NSError *error))handler;


/// 消息撤回
/// @param workId 需要撤回的消息id
+ (void)recallMessageWithWorkId:(NSString *)workId
        isProductionEnvironment:(BOOL)isProduction
                         result:(void (^)(NSError *error))handler;
@end
