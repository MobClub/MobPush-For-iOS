//
//  AppDelegate.m
//  MobPushDemo
//
//  Created by 刘靖煌 on 2017/9/27.
//  Copyright © 2017年 com.mob. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import <MobPush/MobPush.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //MobPush推送设置
    MPushNotificationConfiguration *configuration = [[MPushNotificationConfiguration alloc] init];
    configuration.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsAlert;
    [MobPush setupNotification:configuration];
    
    //UI相关
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    ViewController *viewC = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewC];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //清掉角标和列表
    [application setApplicationIconBadgeNumber:0];
}

@end
