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

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设置";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.switchBtn.on = [MobPush isPushStopped];
    [self.switchBtn addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bindBtn addTarget:self action:@selector(onBind) forControlEvents:UIControlEventTouchUpInside];
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

@end
