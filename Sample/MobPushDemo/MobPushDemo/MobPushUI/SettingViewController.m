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
#import "Const.h"

@interface SettingViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sdkVerLable;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UITextField *addIdTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn1;
@property (weak, nonatomic) IBOutlet UITextField *badgeTF;
@property (weak, nonatomic) IBOutlet UISwitch *switchDelivered;

@property (weak, nonatomic) IBOutlet UILabel *tipLable;

@property (weak, nonatomic) IBOutlet UITextField *attachmentField;

@property (nonatomic, strong) NSMutableDictionary *configParams;
@property (nonatomic, strong) dispatch_semaphore_t wrLock;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设置";
    
    self.sdkVerLable.text = [NSString stringWithFormat:@"MobPushSDK:v%@",[MobPush sdkVersion]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.switchBtn.on = ![MobPush isPushStopped];
    [self.switchBtn addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bindBtn addTarget:self action:@selector(onBind) forControlEvents:UIControlEventTouchUpInside];
    
    self.switchBtn1.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"NotAPNsShowForeground"];
    
    self.attachmentField.text = Const.shared.DemoAttachmentURL;
    
    self.configParams = [[NSMutableDictionary alloc] init];
    self.wrLock = dispatch_semaphore_create(1);
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
//    if ([self.textField.text isEqualToString:@""] || !self.textField.text)
//    {
//        [MBProgressHUD showTitle:@"请填写手机号"];
//        return;
//    }
    
    NSString *phoneNum = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [MobPush bindPhoneNum:phoneNum result:^(NSError *error) {
        if (!error)
        {
            [MBProgressHUD showTitle:@"绑定成功"];
            self.tipLable.text = @"手机绑定成功！";
        }
        else
        {
            [MBProgressHUD showTitle:@"绑定失败"];
            self.tipLable.text = @"手机绑定失败！";
        }
    }];
}

- (IBAction)getPhone
{
    [MobPush getPhoneNumWithResult:^(NSString *phoneNum, NSError *error) {
        if (!error)
        {
            if (phoneNum.length > 0)
            {
                self.tipLable.text = [NSString stringWithFormat:@"线上手机号为：%@", phoneNum];
            }
            else
            {
                self.tipLable.text = @"线上未绑定过手机号";
            }
        }
        else
        {
            self.tipLable.text = @"手机获取失败！Api返回错误";
        }
    }];
}

- (IBAction)openSystemSettings:(id)sender
{
    [MobPush openSettingsForNotification:^(BOOL success) {
        [MBProgressHUD showTitle:@"打开成功"];
    }];
}

- (IBAction)onDeleteNotification:(id)sender
{
    if ([self.addIdTextField.text isEqualToString:@""] || !self.addIdTextField.text)
    {
        [MobPush removeNotificationWithIdentifiers:nil];
    }
    else
    {
        [MobPush removeNotificationWithIdentifiers:@[self.addIdTextField.text]];
    }
}

- (IBAction)onSelectNotification:(id)sender
{
    if ([self.addIdTextField.text isEqualToString:@""] || !self.addIdTextField.text)
    {
        [MBProgressHUD showTitle:@"通知唯一标识identity"];
        return;
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [MobPush findNotificationWithIdentifiers:@[self.addIdTextField.text] delivered:self.switchDelivered.on handler:^(NSArray *result, NSError *error) {
            if (error == nil)
            {
                NSString *title = [NSString stringWithFormat:@"查找所有通知 %ld 条",result.count];
                NSString *message = [NSString stringWithFormat:@"%@",result];
                [weakSelf showAlertControllerWithTitle:title message:message];
            }
        }];
    }
}

- (IBAction)onAddNotification:(id)sender
{
//  本地通知添加方式 此方式v3.0.1开始弃用
    {
//    MPushMessage *message = [[MPushMessage alloc] init];
//    message.messageType = MPushMessageTypeLocal;
//    MPushNotification *noti = [[MPushNotification alloc] init];
//    noti.body = self.addIdTextField.text;
//    noti.title = @"标题";
//    noti.subTitle = @"子标题";
//    noti.badge = ([UIApplication sharedApplication].applicationIconBadgeNumber < 0 ? 0 : [UIApplication sharedApplication].applicationIconBadgeNumber) + 1;
//    message.notification = noti;
//
//    // 立即触发
//    message.isInstantMessage = YES;
//
//    //设置几分钟后发起本地推送
////    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
////    NSTimeInterval nowtime = [currentDate timeIntervalSince1970] * 1000;
////    NSTimeInterval taskDate = nowtime + 5*60*1000;
////    message.taskDate = taskDate;
//
//    // 创建通知标示，两条通知不能唯一，否则会覆盖旧推送
//    message.identifier = self.addIdTextField.text;// 这边以输入的文字为ID，ID一样，新的消息会覆盖旧的
//    [MobPush addLocalNotification:message];
    
    }
    
//  v3.0.1及以上建议使用方式
    
    MPushNotificationRequest *request = [MPushNotificationRequest new];
    // 推送通知唯一标识
    request.requestIdentifier = self.addIdTextField.text;//”推送通知“标识，相同值的“推送通知”将覆盖旧“推送通知”(iOS10及以上)
    
    MPushNotification *content = [MPushNotification new];
    content.title = @"标题";
    content.subTitle = @"子标题";
    content.badge = ([UIApplication sharedApplication].applicationIconBadgeNumber < 0 ? 0 : [UIApplication sharedApplication].applicationIconBadgeNumber) + 1;
    content.body = @"消息body";
    content.action = @"action";// iOS10以下使用
    if (self.attachmentField.text.length > 0 && [NSURL URLWithString:self.attachmentField.text])
    {
        content.userInfo = @{@"attachment":self.attachmentField.text, @"key01":@"value01"};//扩展信息(attachment为多媒体信息，亦可通过content.attachments添加UNNotificationAttachment对象)
    }
    else
    {
        content.userInfo = @{@"key01":@"value01"};
    }
    content.sound = @"warn.caf"; //本地资源警告音
    //category、threadIdentifier、targetContentIdentifier、...
    
    // 推送通知内容
    request.content = content;
    
    // 推送通知触发条件
    MPushNotificationTrigger *trigger = [MPushNotificationTrigger new];
    // 根据需求设置条件 trigger.fireDate(iOS10以下)、trigger.dateComponents、trigger.timeInterval、trigger.region
    request.trigger = trigger;//不设置条件或者传nil 认为即时推送
    
    // 添加本地推送
    [MobPush addLocalNotification:request result:^(id result, NSError *error) {
        if (!error)
        {
            //iOS10以上result为UNNotificationRequest对象、iOS10以下成功result为UILocalNotification对象
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showTitle:@"发送成功"];
                    NSLog(@"本地通知添加成功：%@", result);
                });
            }
        }
    }];
    
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (IBAction)endediting:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (IBAction)setupCustomParams:(UIButton *)sender {
    [self showInputCustomParamsAlert];
}

- (IBAction)updateCustomParamsDefines:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    dispatch_semaphore_wait(self.wrLock, DISPATCH_TIME_FOREVER);
    NSDictionary *dict = [[self configParams] copy];
    [MobPush addCustomParamsWith:dict handler:^(NSArray *successKeys, NSArray *failedKeys, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *successKeyStr = @"";
        NSString *failedKeyStr = @"";
        NSString *desc = error ? error.localizedDescription : @"";
        if ([successKeys count]) {
            successKeyStr = [successKeys componentsJoinedByString:@","];
        }
        if ([failedKeys count]) {
            failedKeyStr = [failedKeys componentsJoinedByString:@","];
        }
        
        [strongSelf.configParams removeAllObjects];
        dispatch_semaphore_signal(strongSelf.wrLock);
        
        NSString *msg = [NSString stringWithFormat:@"Success: %@, Failed: %@, Error: %@", successKeyStr, failedKeyStr, desc];
        [strongSelf showAlertControllerWithTitle:@"添加或更新参数定义" message:msg];
    }];
}

- (IBAction)deleteCustomParamsDefines:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    dispatch_semaphore_wait(self.wrLock, DISPATCH_TIME_FOREVER);
    
    NSDictionary *dict = [[self configParams] copy];
    [MobPush deleteCustomParamsWith:dict handler:^(NSArray *successKeys, NSArray *failedKeys, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *successKeyStr = @"";
        NSString *failedKeyStr = @"";
        NSString *desc = error ? error.localizedDescription : @"";
        if ([successKeys count]) {
            successKeyStr = [successKeys componentsJoinedByString:@","];
        }
        if ([failedKeys count]) {
            failedKeyStr = [failedKeys componentsJoinedByString:@","];
        }
        NSString *msg = [NSString stringWithFormat:@"Success: %@, Failed: %@, Error: %@", successKeyStr, failedKeyStr, desc];
        
        [strongSelf.configParams removeAllObjects];
        dispatch_semaphore_signal(strongSelf.wrLock);
        
        [strongSelf showAlertControllerWithTitle:@"删除参数定义" message:msg];
    }];
}

- (IBAction)deleteAllCustomParamsDefines:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    dispatch_semaphore_wait(self.wrLock, DISPATCH_TIME_FOREVER);
    [MobPush deleteAllCustomParamsWith:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *msg = error ? error.localizedDescription : @"success";
        
        [strongSelf.configParams removeAllObjects];
        dispatch_semaphore_signal(strongSelf.wrLock);
        
        [strongSelf showAlertControllerWithTitle:@"删除全部参数定义" message:msg];
    }];
}

- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
      [alert addAction: closeAction];
      [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
      UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle:title
                                 message:message
                                delegate:self
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil, nil];
      [alert show];
    }
  });
}

- (void)showInputCustomParamsAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"参数含义" message:@"配置参数含义" preferredStyle:UIAlertControllerStyleAlert];
    
    static UITextField *nameField = nil;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"参数名";
        nameField = textField;
    }];
    static UITextField *valueField = nil;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"含义";
        valueField = textField;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        /// 取消操作不更新自定义参数配置
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *name = nameField.text ? :@"";
        NSString *value = valueField.text ? :@"";
        if (name && [name isKindOfClass:[NSString class]] && [name length] && value && [value isKindOfClass:[NSString class]]) {
            dispatch_semaphore_wait(strongSelf.wrLock, DISPATCH_TIME_FOREVER);
            [strongSelf.configParams setObject:value forKey:name];
            dispatch_semaphore_signal(strongSelf.wrLock);
        }
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)onEditAttachmentURL:(id)sender
{
    Const.shared.DemoAttachmentURL = self.attachmentField.text;
}
@end
