//
//  NotificationService.m
//  MobPushServiceExtension
//
//  Created by Brilance on 2018/8/22.
//  Copyright © 2018年 com.mob. All rights reserved.
//

#import "NotificationService.h"
#import <MobPushServiceExtension/MobPushServiceExtension.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

//重写你的通知内容，也可以在这里下载附件内容
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler
{
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
//    //重写推送内容
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//    self.bestAttemptContent.title = @"我是修改后的标题";
//    self.bestAttemptContent.subtitle = @"我是修改后的子标题";
//    self.bestAttemptContent.body = @"来自MobPush";
    
#pragma mark ----将APNs信息交由MobPush处理----
    //获取富媒体附件下载地址
    NSString *attachUrl = request.content.userInfo[@"attachment"];
    
    [MobPushServiceExtension handelNotificationServiceRequestUrl:attachUrl withAttachmentsComplete:^(NSArray *attachments, NSError *error) {
        if (attachments.count > 0)
        {
            self.bestAttemptContent.attachments = attachments; //设置通知中的多媒体附件
            self.contentHandler(self.bestAttemptContent);
        }
        else
        {
            self.contentHandler(self.bestAttemptContent);
        }
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
