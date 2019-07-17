//
//  SettingViewController.m
//  MobPushDemo
//
//  Created by LeeJay on 2019/1/18.
//  Copyright © 2019 com.mob. All rights reserved.
//

#import "SettingViewController.h"
#import <MobPush/MobPush.h>
#import "MBProgressHUD+Extension.h"
#import "TagsAndAliasViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UITextField *addIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *deleteIdTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn1;
@property (weak, nonatomic) IBOutlet UITextField *badgeTF;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设置";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.switchBtn.on = ![MobPush isPushStopped];
    [self.switchBtn addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bindBtn addTarget:self action:@selector(onBind) forControlEvents:UIControlEventTouchUpInside];
    
    self.switchBtn1.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"NotAPNsShowForeground"];
}

- (void)onSwitch:(UISwitch *)sender
{
    if ([MobPush isPushStopped])
    { // 当前推送关闭状态
        // 将其打开
        [MobPush restartPush];
    }
    else
    { // 当前推送打开状态
        // 将其关闭
        [MobPush stopPush];
    }
}

- (void)onBind
{
    if ([self.textField.text isEqualToString:@""] || !self.textField.text)
    {
        [MBProgressHUD showTitle:@"请填写手机号"];
        return;
    }
    
    [MobPush bindPhoneNum:self.textField.text result:^(NSError *error) {
        if (!error)
        {
            [MBProgressHUD showTitle:@"绑定成功"];
        }
        else
        {
            [MBProgressHUD showTitle:@"绑定失败"];
        }
    }];
}

- (IBAction)onCacel:(id)sender
{
    if ([self.deleteIdTextField.text isEqualToString:@""] || !self.deleteIdTextField.text)
    {
        [MobPush removeNotificationWithIdentifiers:nil];
    }
    else
    {
        [MobPush removeNotificationWithIdentifiers:@[self.deleteIdTextField.text]];
    }
}

- (IBAction)onAdd:(id)sender
{
    MPushMessage *message = [[MPushMessage alloc] init];
    message.messageType = MPushMessageTypeLocal;
    MPushNotification *noti = [[MPushNotification alloc] init];
    noti.body = self.addIdTextField.text;
    noti.title = @"标题";
    noti.subTitle = @"子标题";
    noti.badge = ([UIApplication sharedApplication].applicationIconBadgeNumber < 0 ? 0 : [UIApplication sharedApplication].applicationIconBadgeNumber) + 1;
    message.notification = noti;
    
    // 立即触发
    message.isInstantMessage = YES;
    
    //设置几分钟后发起本地推送
//    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval nowtime = [currentDate timeIntervalSince1970] * 1000;
//    NSTimeInterval taskDate = nowtime + 5*60*1000;
//    message.taskDate = taskDate;
    
    // 创建通知标示，两条通知不能唯一，否则会覆盖旧推送
    message.identifier = self.addIdTextField.text;// 这边以输入的文字为ID，ID一样，新的消息会覆盖旧的
    [MobPush addLocalNotification:message];
}

- (IBAction)onSwitch1:(UISwitch *)sender
{
    if (sender.isOn)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NotAPNsShowForeground"];
        [MobPush setAPNsShowForegroundType:MPushAuthorizationOptionsAlert | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsBadge];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NotAPNsShowForeground"];
        [MobPush setAPNsShowForegroundType:MPushAuthorizationOptionsNone];
    }
}

- (IBAction)clearBadge:(id)sender
{
    [MobPush clearBadge];
    [MBProgressHUD showTitle:@"清除成功"];
}

- (IBAction)setBadge:(id)sender
{
    if ([self.badgeTF.text isEqualToString:@""] || !self.badgeTF.text)
    {
        [MBProgressHUD showTitle:@"请填写角标"];
        return;
    }
    // 本地先调用setApplicationIconBadgeNumber函数来显示角标，
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.badgeTF.text integerValue];
    // 再将该角标值同步到Mob服务器
    [MobPush setBadge:[self.badgeTF.text integerValue]];
}

- (IBAction)setAliasOrTags:(id)sender {
    TagsAndAliasViewController *vc = [TagsAndAliasViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
