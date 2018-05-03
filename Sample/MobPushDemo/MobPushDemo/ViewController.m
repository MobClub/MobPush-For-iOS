//
//  ViewController.m
//  MobPushDemo
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "ViewController.h"
#import "MainItemView.h"
#import "PushViewController.h"
#import <MobPush/MPushMessage.h>
#import <MOBFoundation/MOBFoundation.h>
#import "OpenPageViewController.h"

@interface ViewController () <IMainItemViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *selectedLabel = [[UILabel alloc] init];
    selectedLabel.frame = CGRectMake(self.view.frame.size.width*0.1, 16,self.view.frame.size.width*0.8 , 40);
    selectedLabel.text = @"选择你想测试的推送类型";
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.font = [UIFont systemFontOfSize:20];
    selectedLabel.textColor = [UIColor blackColor];
    [self.view addSubview:selectedLabel];
    
    MainItemView *localPush = [MainItemView viewWithTitle:@"App内推送"
                                                    image:[UIImage imageNamed:@"local"]
                                          backgroundImage:nil
                                          backgroundColor:[MOBFColor colorWithRGB:0xEBF2FF]];
    localPush.delegate = self;
    localPush.tag = 1;
    localPush.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(selectedLabel.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:localPush];
    
    MainItemView *remotePush = [MainItemView viewWithTitle:@"通知"
                                                     image:[UIImage imageNamed:@"remote"]
                                           backgroundImage:nil
                                           backgroundColor:[MOBFColor colorWithRGB:0xFFCFAE]];
    remotePush.delegate = self;
    remotePush.tag = 2;
    remotePush.frame = CGRectMake(self.view.frame.size.width*0.55, CGRectGetMaxY(selectedLabel.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:remotePush];
    
    MainItemView *schedulePush = [MainItemView viewWithTitle:@"定时通知"
                                                       image:[UIImage imageNamed:@"schedule"]
                                             backgroundImage:nil
                                             backgroundColor:[MOBFColor colorWithRGB:0x9AE2D5]];
    schedulePush.delegate = self;
    schedulePush.tag = 3;
    schedulePush.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(remotePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:schedulePush];
    
    MainItemView *localNotication = [MainItemView viewWithTitle:@"本地通知"
                                                          image:[UIImage imageNamed:@"localNotication"]
                                                backgroundImage:nil
                                                backgroundColor:[MOBFColor colorWithRGB:0xFFCFAE]];
    localNotication.delegate = self;
    localNotication.tag = 4;
    localNotication.frame = CGRectMake(self.view.frame.size.width*0.55, CGRectGetMaxY(remotePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:localNotication];
    
    MainItemView *pushVC = [MainItemView viewWithTitle:@"通过推送打开指定页面"
                                                 image:[UIImage imageNamed:@"pushVC"]
                                       backgroundImage:nil
                                       backgroundColor:[MOBFColor colorWithRGB:0xEBF2FF]];
    pushVC.delegate = self;
    pushVC.tag = 5;
    pushVC.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(schedulePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:pushVC];
    
}

- (void)itemClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"App内推送测试"
                                                                      description:@"点击测试按钮后，你将立即收到一条app内推送"
                                                             buttonBackgroudColor:[MOBFColor colorWithRGB:0x7B91FF]
                                                                      messageType:MPushMsgTypeMessage
                                                                      isTimedPush:NO
                                                                              tag:1];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 2:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"通知测试"
                                                                      description:@"点击测试按钮后，5s左右将收到一条测试通知"
                                                             buttonBackgroudColor:[MOBFColor colorWithRGB:0xFF7D00]
                                                                      messageType:MPushMsgTypeNotification
                                                                      isTimedPush:NO];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 3:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"定时通知测试"
                                                                      description:@"设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
                                                             buttonBackgroudColor:[MOBFColor colorWithRGB:0x29C18B]
                                                                      messageType:MPushMsgTypeTimeMessage
                                                                      isTimedPush:YES];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 4:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"本地通知测试"
                                                                      description:@"设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
                                                             buttonBackgroudColor:[MOBFColor colorWithRGB:0xFF7D00]
                                                                      messageType:MPushMsgTypeTimeMessage
                                                                      isTimedPush:YES
                                                                              tag:4];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 5:
        {
            OpenPageViewController *pageVC = [[OpenPageViewController alloc] init];
            pageVC.title = @"通过推送打开指定页面";
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end

