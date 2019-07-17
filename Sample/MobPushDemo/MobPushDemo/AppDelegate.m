 //
//  AppDelegate.m
//  MobPushDemo
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MOBNavigationViewController.h"
#import <MobPush/MobPush.h>
#import "AlertViewController.h"
#import "MBProgressHUD+Extension.h"
#import "WebViewController.h"

@interface AppDelegate () <UIAlertViewDelegate, IAlertViewControllerDelegate>

@property (nonatomic, strong) MPushMessage *message;
@property (nonatomic, strong) AlertViewController *alertVC;
@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 设置推送环境
#ifdef DEBUG
    [MobPush setAPNsForProduction:NO];
#else
    [MobPush setAPNsForProduction:YES];
#endif
    
    //MobPush推送设置（获得角标、声音、弹框提醒权限）
    MPushNotificationConfiguration *configuration = [[MPushNotificationConfiguration alloc] init];
    configuration.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsAlert;
    [MobPush setupNotification:configuration];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NotAPNsShowForeground"])
    {
        // 设置后，应用在前台时不展示通知横幅、角标、声音。（iOS 10 以后有效，iOS 10 以前本来就不展示）
        [MobPush setAPNsShowForegroundType:MPushAuthorizationOptionsNone];
    }
    
    [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
        NSLog(@"registrationID = %@--error = %@", registrationID, error);
    }];
        
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    ViewController *viewC = [[ViewController alloc] init];
    MOBNavigationViewController *nav = [[MOBNavigationViewController alloc] initWithRootViewController:viewC];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:MobPushDidReceiveMessageNotification object:nil];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{   //程序进入后台时,清除角标，但不清空通知栏消息(开发者根据业务需求，自行调用)
//    [MobPush clearBadge];
}

// 收到通知回调
- (void)didReceiveMessage:(NSNotification *)notification
{
    MPushMessage *message = notification.object;
        
    switch (message.messageType)
    {
        case MPushMessageTypeCustom:
        {// 自定义消息回调
            self.alertVC = [[AlertViewController alloc] initWithTitle:@"收到推送" content:message.content];
            self.alertVC.delegate = self;
            
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
            _alertWindow.userInteractionEnabled = YES;
            _alertWindow.rootViewController = self.alertVC;
            [_alertWindow makeKeyAndVisible];
        }
            break;
        case MPushMessageTypeAPNs:
        {// APNs回调
            NSLog(@"msgInfo---%@--%@", message.msgInfo, message.extraInfomation);
            [[[UIAlertView alloc] initWithTitle:message.msgInfo.description message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
            break;
        case MPushMessageTypeLocal:
        {// 本地通知回调
            NSString *body = message.notification.body;
            NSString *title = message.notification.title;
            NSString *subtitle = message.notification.subTitle;
            NSInteger badge = message.notification.badge;
            NSString *sound = message.notification.sound;
            NSLog(@"收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%ld，\nsound：%@，\n}",body, title, subtitle, (long)badge, sound);
        }
            break;
        case MPushMessageTypeClicked:
        {// 点击通知回调
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
            { // 前台
                [self showAlertWithMessage:message];
            }
            else
            { // 后台
                [self pushVCWithMessage:message];
            }
        }
        default:
            break;
    }
}

- (void)selectOKWithData:(id)data
{
    if (_alertWindow)
    {
        [_alertWindow resignKeyWindow];
        _alertWindow.hidden = YES;
        _alertWindow = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self pushVCWithMessage:_message];
    }
}

- (void)showAlertWithMessage:(MPushMessage *)message
{
    NSString *url = message.msgInfo[@"url"];
    
    if (url)
    {
        _message = message;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收到推送"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"查看", nil];
        [alertView show];
    }
}

- (void)pushVCWithMessage:(MPushMessage *)message
{
    NSString *url = message.msgInfo[@"url"];
    
    if (url)
    {
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.url = url;
        [nav pushViewController:webVC animated:YES];
    }
}

@end
