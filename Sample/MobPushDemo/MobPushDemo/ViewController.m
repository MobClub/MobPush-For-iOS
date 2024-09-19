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
#import "RestoreViewController.h"
#import <MobPush/UIViewController+MobPush.h>
#import "SettingViewController.h"
#import <MOBFoundation/MobSDK+Privacy.h>

@interface ViewController () <IMainItemViewDelegate>

@property (nonatomic, weak) UILabel *statusLable;
@property (nonatomic, weak) UILabel *registLable;

@end

@implementation ViewController

#pragma mark ---场景还原---

//点击推送场景还原路径
+ (NSString *)MobPushPath
{
    return @"/path/ViewController";
}

//点击推送场景还原页面参数
- (instancetype)initWithMobPushScene:(NSDictionary *)params
{
    if (self = [super init])
    {
        //self.params = params;
    }
    return self;
}

- (void)onTap:(UIButton *)sender
{
    SettingViewController *setVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSNumber *res = [userDefault objectForKey:@"mob_privicy"];
//
//    if (!res)
//    {
//        [self testPrivicy];
//    }else{
//        [MobSDK uploadPrivacyPermissionStatus:res.boolValue onResult:^(BOOL success) {
//            NSLog(@"-------------->上传结果：%d",success);
//        }];
//    }
}

- (void)testPrivicy
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户协议" message:@"用户协议内容" preferredStyle:UIAlertControllerStyleAlert];
    
          UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
              [userDefault setObject:@0 forKey:@"mob_privicy"];
              [userDefault synchronize];
              [MobSDK uploadPrivacyPermissionStatus:NO onResult:^(BOOL success) {
                  NSLog(@"-------------->上传结果：%d",success);
              }];
          }];
     
          UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [userDefault setObject:@1 forKey:@"mob_privicy"];
              [userDefault synchronize];
              [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
                  NSLog(@"-------------->上传结果：%d",success);
              }];
          }];
    
         [alert addAction:action1];
         [alert addAction:action2];
         [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//#ifdef DEBUG
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setTitle:@"设置" forState:UIControlStateNormal];
//#endif

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *statusLable = [[UILabel alloc] init];
    statusLable.frame = CGRectMake(8, 8, self.view.frame.size.width - 8 * 2, 26);
    statusLable.text = @"未连接";
    statusLable.textAlignment = NSTextAlignmentLeft;
    statusLable.font = [UIFont systemFontOfSize:13];
    statusLable.textColor = [UIColor redColor];
    [self.view addSubview:statusLable];
    self.statusLable = statusLable;
    
    UILabel *registLable = [[UILabel alloc] init];
    registLable.frame = CGRectMake(80, 8, self.view.frame.size.width - 80 , 26);
    registLable.text = @"RegistrationID:";
    registLable.textAlignment = NSTextAlignmentLeft;
    registLable.font = [UIFont systemFontOfSize:13];
    registLable.textColor = [UIColor blueColor];
    [self.view addSubview:registLable];
    self.registLable = registLable;
    
    
    UILabel *selectedLabel = [[UILabel alloc] init];
    selectedLabel.frame = CGRectMake(self.view.frame.size.width*0.1, 30, self.view.frame.size.width*0.8, 36);
    selectedLabel.text = @"选择你想测试的推送类型:";
    selectedLabel.textAlignment = NSTextAlignmentCenter;
    selectedLabel.font = [UIFont systemFontOfSize:20];
    selectedLabel.textColor = [UIColor blackColor];
    [self.view addSubview:selectedLabel];
    
    MainItemView *localPush = [MainItemView viewWithTitle:@"App内推送"
                                                    image:[UIImage imageNamed:@"local"]
                                          backgroundImage:nil
                                          backgroundColor:[MOBFColor colorWithRGB:0xf2f3f7]];
    localPush.delegate = self;
    localPush.tag = 1;
    localPush.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(selectedLabel.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:localPush];
    
    MainItemView *remotePush = [MainItemView viewWithTitle:@"通知"
                                                     image:[UIImage imageNamed:@"remote"]
                                           backgroundImage:nil
                                           backgroundColor:[MOBFColor colorWithRGB:0xf2f3f7]];
    remotePush.delegate = self;
    remotePush.tag = 2;
    remotePush.frame = CGRectMake(self.view.frame.size.width*0.55, CGRectGetMaxY(selectedLabel.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:remotePush];
    
    MainItemView *schedulePush = [MainItemView viewWithTitle:@"定时通知"
                                                       image:[UIImage imageNamed:@"schedule"]
                                             backgroundImage:nil
                                             backgroundColor:[MOBFColor colorWithRGB:0xf2f3f7]];
    schedulePush.delegate = self;
    schedulePush.tag = 3;
    schedulePush.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(remotePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:schedulePush];
    
    MainItemView *localNotication = [MainItemView viewWithTitle:@"本地通知"
                                                          image:[UIImage imageNamed:@"localNotication"]
                                                backgroundImage:nil
                                                backgroundColor:[MOBFColor colorWithRGB:0xf2f3f7]];
    localNotication.delegate = self;
    localNotication.tag = 4;
    localNotication.frame = CGRectMake(self.view.frame.size.width*0.55, CGRectGetMaxY(remotePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:localNotication];
    
    MainItemView *pushVC = [MainItemView viewWithTitle:@"推送打开指定链接页面"
                                                 image:[UIImage imageNamed:@"pushVC"]
                                       backgroundImage:nil
                                       backgroundColor:[MOBFColor colorWithRGB:0xf2f3f7]];
    pushVC.delegate = self;
    pushVC.tag = 5;
    pushVC.frame = CGRectMake(self.view.frame.size.width*0.1, CGRectGetMaxY(schedulePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:pushVC];
    
    MainItemView *linkItemView = [MainItemView viewWithTitle:@"推送打开应用内指定页面"
                                                       image:[UIImage imageNamed:@"linkitem"]
                                             backgroundImage:nil
                                             backgroundColor:[MOBFColor colorWithRGB:0xf2f3f7]];
    linkItemView.delegate = self;
    linkItemView.tag = 6;
    linkItemView.frame = CGRectMake(self.view.frame.size.width*0.55, CGRectGetMaxY(schedulePush.frame) + 20, self.view.frame.size.width*0.35, self.view.frame.size.width*0.4);
    [self.view addSubview:linkItemView];
    
    
    [self addAllObserverAboutNetworkNotifications];
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
                                                                      messageType:MSendMessageTypeCustom
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
                                                                      messageType:MSendMessageTypeAPNs
                                                                      isTimedPush:NO];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 3:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"定时通知测试"
                                                                      description:@"设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
                                                             buttonBackgroudColor:[MOBFColor colorWithRGB:0x29C18B]
                                                                      messageType:MSendMessageTypeTimed
                                                                      isTimedPush:YES];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 4:
        {
            PushViewController *pushV = [[PushViewController alloc] initWithTitle:@"本地通知测试"
                                                                      description:@"设置时间后点击测试按钮，在到设置时间时将收到一条测试通知"
                                                             buttonBackgroudColor:[MOBFColor colorWithRGB:0xFF7D00]
                                                                      messageType:MSendMessageTypeTimed
                                                                      isTimedPush:YES
                                                                              tag:4];
            [self.navigationController pushViewController:pushV animated:YES];
        }
            break;
        case 5:
        {
            OpenPageViewController *pageVC = [[OpenPageViewController alloc] init];
            pageVC.title = @"推送打开指定链接页面";
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case 6:
        {
            RestoreViewController *restoreVC = [[RestoreViewController alloc] init];
            restoreVC.title = @"推送打开应用内指定页面";
            [self.navigationController pushViewController:restoreVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)addAllObserverAboutNetworkNotifications
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:MobPushNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkFailedRegister:) name:MobPushNetworkFailedRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkConnecting:) name:MobPushNetworkConnectingNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkConnected:) name:MobPushNetworkConnectedNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:MobPushNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:MobPushNetworkDidCloseNotification object:nil];
    
}

- (void)removeAllObserverAboutNetworkNotifications
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:MobPushNetworkDidRegisterNotification object:nil];
    [defaultCenter removeObserver:self name:MobPushNetworkFailedRegisterNotification object:nil];
    [defaultCenter removeObserver:self name:MobPushNetworkConnectingNotification object:nil];
    [defaultCenter removeObserver:self name:MobPushNetworkConnectedNotification object:nil];
    [defaultCenter removeObserver:self name:MobPushNetworkDidLoginNotification object:nil];
    [defaultCenter removeObserver:self name:MobPushNetworkDidCloseNotification object:nil];
}

- (void)dealloc
{
    [self removeAllObserverAboutNetworkNotifications];
}

// 注册成功
- (void)networkDidRegister:(NSNotification *)notification
{
    NSString *regId = [[notification userInfo] valueForKey:@"RegistrationID"]?:@"";
    self.registLable.text = [NSString stringWithFormat:@"RegistrationID:%@",regId];
        
    self.statusLable.text = @"已注册";
    self.statusLable.textColor = [UIColor blueColor];
    
    NSLog(@"networkStatus:已注册");
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.Mob.HeartNote.group"];
    [defaults setObject:regId forKey:@"c_regId"];
    [defaults synchronize];
}

// 注册失败
- (void)networkFailedRegister:(NSNotification *)notification
{
    self.registLable.text = @"RegistrationID:";
    
    self.statusLable.text = @"注册失败";
    self.statusLable.textColor = [UIColor redColor];

    NSError *error = notification.object;
    if (error && [error isKindOfClass:NSError.class])
    {
        NSLog(@"error:%@",error.description);
    }
    
    NSLog(@"networkStatus:注册失败");
}

// 正在连接中
- (void)networkConnecting:(NSNotification *)notification
{
    self.statusLable.text = @"正在连接中...";
    self.statusLable.textColor = [UIColor blueColor];

    NSLog(@"networkStatus:正在连接中...");
}

// 连接成功
- (void)networkConnected:(NSNotification *)notification
{
    self.statusLable.text = @"连接成功";
    self.statusLable.textColor = [UIColor blueColor];

    NSLog(@"networkStatus:连接成功");
}

// 登录成功
- (void)networkDidLogin:(NSNotification *)notification
{
    
    self.statusLable.text = @"登录成功";
    self.statusLable.textColor = [UIColor blueColor];
    
    __weak typeof(self) weakSelf = self;
    [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
        if (!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *regId = registrationID?:@"";
                weakSelf.registLable.text = [NSString stringWithFormat:@"RegistrationID:%@",regId];
            });
        }
    }];
    
    NSLog(@"networkStatus:登录成功");
}

// 连接关闭
- (void)networkDidClose:(NSNotification *)notification
{
    self.statusLable.text = @"未连接";
    self.statusLable.textColor = [UIColor redColor];
    
    NSLog(@"networkStatus:未连接");
}

@end
