//
//  MobPushServiceExtension.h
//  MobPushServiceExtension
//
//  Created by Brilance on 2018/8/22.
//  Copyright © 2018年 Brilancecom.mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobPushServiceExtension : NSObject

/**
 *  多媒体推送支持
 */
+ (void)handelNotificationServiceRequestUrl:(NSString *)requestUrl withAttachmentsComplete:(void (^)(NSArray *attachments, NSError *error))completeBlock;

@end
