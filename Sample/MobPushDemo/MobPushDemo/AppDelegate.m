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
// bugly
#import <Bugly/Bugly.h>
#import <MOBFoundation/MobSDK.h>
#import <MOBFoundation/MobSDK+Privacy.h>
// bugly app id
#define BUGLY_APP_ID @"5abda4b390"

@interface AppDelegate () <UIAlertViewDelegate, IAlertViewControllerDelegate, BuglyDelegate>

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
    // Demo集成bugly,便于定位崩溃,与MobPushSDK集成无关
    [self setupBugly];
    [MobPush setAPNsForProduction:YES];
#endif
    
    //外部demo
    [MobSDK registerAppKey:@"moba6b6c6d6" appSecret:@"b89d2427a3bc7ad1aea1e1e8c1d36bf3"];
    //内部调试
//    [MobSDK registerAppKey:@"2dbe655e88c80" appSecret:@"a7b9f1918c596eacbff8a172ba8ed158"];
    
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
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
        NSLog(@"-------------->上传结果：%d",success);
    }];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //程序进入前台时,清除角标，但不清空通知栏消息(开发者根据业务需求，自行调用)
    //注意：不建议在进入后台通知(applicationDidEnterBackground:)中调用此方法，原因进入后台将角标清空结果无法通过网络同步到服务器
    [MobPush clearBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
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
            NSLog(@"收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge:%ld,\nsound:%@,\n}",body, title, subtitle, (long)badge, sound);
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




// Bugly
- (void)setupBugly
{
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#ifdef DEBUG
    config.debugMode = YES;
#else
    config.debugMode = NO;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    return @"This is an attachment";
}

@end
