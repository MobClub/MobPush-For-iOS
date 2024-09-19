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
#import <MOBFoundation/MobSDK.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import "MobPushDemo-Swift.h"

// bugly
#import <Bugly/Bugly.h>
// bugly app id
#define BUGLY_APP_ID @"5abda4b390"

//#import <UserNotifications/UserNotifications.h>

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
    
    //设置地区：regionId 默认0（国内），1:海外
//    [MobPush setRegionID:1];
    
    //外部demo
//    [MobSDK registerAppKey:@"moba6b6c6d6" appSecret:@"b89d2427a3bc7ad1aea1e1e8c1d36bf3"];
    //内部调试
//    [MobSDK registerAppKey:@"2dbe655e88c80" appSecret:@"a7b9f1918c596eacbff8a172ba8ed158"];
    
//    [MobSDK registerAppKey:@"2ecbc7bc53712" appSecret:@"785544d9f64bf1f51e7aa3b8f21d07e8"];
    
//    [MobSDK registerAppKey:@"2c574691c6986" appSecret:@"4b5cd595eb07b5cf17bb269f7a51391d"];
    
    // 更新证书后: 测试环境
//    [MobSDK registerAppKey:@"m2edc0a7974b00" appSecret:@"6867f7cf3c3a7bb53a438f4ea4cac8cf"];

    // 更新证书后: 生产环境
    [MobSDK registerAppKey:@"3276d3e413040" appSecret:@"4280a3a6df667cfce37528dec03fd9c3"];
    
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
    
    // 监听推送通知 MobPush整合了系统iOS10以上及以下不同方式获取推送统一通过此监听获取，开发者通过原始方式亦不影响。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:MobPushDidReceiveMessageNotification object:nil];
    
    // 注意：上传隐私协议接口，具体查看官方文档(https://policy.zztfly.com/sdk/share/privacy)
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
        NSLog(@"-------------->上传结果：%d",success);
    }];
    
    // 注册实时活动
    if (@available(iOS 16.1, *)) {
#if !TARGET_OS_MACCATALYST
        [LiveActivityUtils startActivityWithPushTokenUpdate:^(BOOL enable, NSData *token) {
            if(enable && token.length) {
                [MobPush registerLiveActivityWithID:@"mpLiveActivity"
                                          pushToken:token
                                         completion:^(NSError *error) {
                    if (error) {
                        NSLog(@"Register LiveActivity Failed: %@", error.localizedDescription);
                    }
                }];
            }
        }];
#endif
    }
    
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

// 收到推送通知回调
- (void)didReceiveMessage:(NSNotification *)notification
{
    MPushMessage *message = notification.object;
    
    NSLog(@"message:%@", message.convertDictionary);
    
    switch (message.messageType)
    {
        case MPushMessageTypeCustom:
        {// 自定义消息回调
            self.alertVC = [[AlertViewController alloc] initWithTitle:@"收到推送" content:message.notification.body];
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
            [[[UIAlertView alloc] initWithTitle:message.notification.userInfo.description message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
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
            [[[UIAlertView alloc] initWithTitle:message.notification.userInfo.description message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
            break;
        case MPushMessageTypeClicked:
        {// 点击通知回调
            
            // 测试
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
    NSString *url = message.notification.userInfo[@"url"];
    
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
    NSString *url = message.notification.userInfo[@"url"];
    
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
