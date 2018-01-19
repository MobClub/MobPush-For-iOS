//
//  ViewController.m
//  MobPushDemo
//
//  Created by 刘靖煌 on 2017/9/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "ViewController.h"
#import "MainItemView.h"
#import "PushViewController.h"
#import "AlertViewController.h"
#import <MobPush/MPushMessage.h>

@interface ViewController () <IMainItemViewDelegate, IAlertViewControllerDelegate>

@property (nonatomic, strong) AlertViewController *alertView;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *selectedLabel = [[UILabel alloc] init];
    selectedLabel.frame = CGRectMake(self.view.frame.size.width*0.1, 80,self.view.frame.size.width*0.8 , 40);
    selectedLabel.text = @"选择你想测试的推送类型";
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.font = [UIFont systemFontOfSize:20];
    selectedLabel.textColor = [UIColor blackColor];
    [self.view addSubview:selectedLabel];
    
    MainItemView *localPush = [MainItemView viewWithTitle:@"App内推送测试"
                                                    image:[UIImage imageNamed:@"local"]
                                          backgroundImage:nil
                                          backgroundColor:[UIColor colorWithRed:140/255.0 green:230/255.0 blue:255/255.0 alpha:1.0]];
    localPush.delegate = self;
    localPush.tag = 1;
    localPush.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(selectedLabel.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:localPush];
    
    MainItemView *remotePush = [MainItemView viewWithTitle:@"通知测试"
                                                     image:[UIImage imageNamed:@"remote"]
                                           backgroundImage:nil
                                           backgroundColor:[UIColor colorWithRed:254/255.0 green:205/255.0 blue:94/255.0 alpha:1.0]];
    remotePush.delegate = self;
    remotePush.tag = 2;
    remotePush.frame = CGRectMake(self.view.frame.size.width*0.55, CGRectGetMaxY(selectedLabel.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:remotePush];
    
    MainItemView *schedulePush = [MainItemView viewWithTitle:@"定时通知测试"
                                                       image:[UIImage imageNamed:@"schedule"]
                                             backgroundImage:nil
                                             backgroundColor:[UIColor colorWithRed:84/255.0 green:242/255.0 blue:119/255.0 alpha:1.0]];
    schedulePush.delegate = self;
    schedulePush.tag = 3;
    schedulePush.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(remotePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:schedulePush];
    
    MainItemView *localNotication = [MainItemView viewWithTitle:@"本地通知测试"
                                                          image:[UIImage imageNamed:@"LocalNotication"]
                                                backgroundImage:nil
                                                backgroundColor:[UIColor colorWithRed:250/255.0 green:125/255.0 blue:108/255.0 alpha:1.0]];
    localNotication.delegate = self;
    localNotication.tag = 4;
    localNotication.frame = CGRectMake(self.view.frame.size.width*0.55, CGRectGetMaxY(remotePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:localNotication];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:MobPushDidReceiveMessageNotification object:nil];
}

- (void)didReceiveMessage:(NSNotification* )notification
{
    MPushMessage *message = notification.object;
    
    switch (message.messageType)
    {
        case MPushMessageTypeNotification:
        {
            [MobPush addLocalNotification:message];
        }
            break;
        case MPushMessageTypeCustom:
        {
            self.alertView = [[AlertViewController alloc] initWithTitle:@"收到推送" content:message.content];
            self.alertView.delegate = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
                _window.userInteractionEnabled = YES;
                _window.rootViewController = self.alertView;
                [_window makeKeyAndVisible];
                
            });
        }
            break;
        default:
            break;
    }
}

- (void)selectOKWithData:(id)data
{
    if (_window)
    {
        [_window resignKeyWindow];
        _window.hidden = YES;
        _window = nil;
    }
}

- (void)itemClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"自定义消息测试"
                                                                      description:@"点击测试按钮后，你将立即收到一条app内推送"
                                                             buttonBackgroudColor:[UIColor colorWithRed:24/255.0 green:170/255.0 blue:255/255.0 alpha:1.0]
                                                                      messageType:MPushMsgTypeMessage
                                                                      isTimedPush:NO];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 2:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"通知测试"
                                                                      description:@"点击测试按钮后，5s左右将收到一条测试通知"
                                                             buttonBackgroudColor:[UIColor colorWithRed:253/255.0 green:153/255.0 blue:9/255.0 alpha:1.0]
                                                                      messageType:MPushMsgTypeNotification
                                                                      isTimedPush:NO];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 3:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"定时通知测试"
                                                                      description:@"设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
                                                             buttonBackgroudColor:[UIColor colorWithRed:28/255.0 green:212/255.0 blue:49/255.0 alpha:1.0]
                                                                      messageType:MPushMsgTypeTimeMessage
                                                                      isTimedPush:YES];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 4:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"本地通知测试"
                                                                      description:@"设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
                                                             buttonBackgroudColor:[UIColor colorWithRed:250/255.0 green:125/255.0 blue:108/255.0 alpha:1.0]
                                                                      messageType:MPushMsgTypeTimeMessage
                                                                      isTimedPush:YES
                                                                              tag:4];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
