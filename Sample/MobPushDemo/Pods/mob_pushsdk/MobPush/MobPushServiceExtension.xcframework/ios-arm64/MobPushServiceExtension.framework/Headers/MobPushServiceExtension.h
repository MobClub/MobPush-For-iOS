//
//  MobPushServiceExtension.h
//  MobPushServiceExtension
//
//  Created by Brilance on 2018/8/22.
//  Copyright © 2018年 Brilancecom.mob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface MobPushServiceExtension : NSObject

/**
 * APNs消息回执
 */
+ (void)deliverNotificationRequest:(UNNotificationRequest *)request
                      MobAppSecret:(NSString *)mobAppSecret
                              with:(void(^)(void))completion;

/**
 *  多媒体推送支持
 */
+ (void)handelNotificationServiceRequestUrl:(NSString *)requestUrl withAttachmentsComplete:(void (^)(NSArray *attachments, NSError *error))completeBlock;

@end
