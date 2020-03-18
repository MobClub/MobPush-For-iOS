//
//  MPushHookService.h
//  MobPush
//
//  Created by Max on 2019/11/5.
//  Copyright © 2019 com.mob. All rights reserved.
//

#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPushHookProtocol
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)applicationWillTerminateNotification;
- (void)applicationDidFinishLaunching;
@end

@interface MPushHookService : NSObject

+ (instancetype)shareService;
@property (nonatomic, weak) id appDelegate;
@property (nonatomic, weak) id unDelegate;
@property (nonatomic, strong) NSMutableArray *observers;
@end

NS_ASSUME_NONNULL_END
