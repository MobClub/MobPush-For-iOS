//
//  RestoreViewController.m
//  MobPushDemo
//
//  Created by Brilance on 2018/7/2.
//  Copyright © 2018年 com.mob. All rights reserved.
//

#import "RestoreViewController.h"
#import "UITextView+MPushPlaceholder.h"
#import "MBProgressHUD+Extension.h"
#import <MOBFoundation/MOBFoundation.h>
#import <MobPush/MobPush+Test.h>

@interface RestoreViewController () <UITextViewDelegate>
{
    __weak IBOutlet UITextView *_textView;
    IBOutletCollection(UILabel) NSArray *_arrayTitleLabel;
    IBOutletCollection(UIImageView) NSArray *_arraySelectImg;
    __weak IBOutlet UIButton *_btnTest;
}

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation RestoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _textView.placeholder = @"填写推送内容（不超过35个字）";
    _textView.placeholderColor = [MOBFColor colorWithRGB:0xb8bcc9];
    _textView.layer.cornerRadius = 2;
    _textView.layer.borderColor = [MOBFColor colorWithRGB:0xE6E6EC].CGColor;
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.cornerRadius = 2;
    _btnTest.layer.cornerRadius = 5;
    [self setUpForDismissKeyboard];
    
    _path = @"/path/ViewController";
    _params = @{};
}

#pragma mark - 任何空白区域键盘事件
- (void)setUpForDismissKeyboard
{
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    [self.view addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

//界面还原选择
- (IBAction)onSelectLinkVC:(UIButton *)sender
{
    [self.view endEditing:YES];
    for (UILabel *lbTitle in _arrayTitleLabel)
    {
        if (lbTitle.tag == sender.tag)
        {
            lbTitle.textColor = [MOBFColor colorWithRGB:0x00d098];
        }
        else
        {
            lbTitle.textColor = [MOBFColor colorWithRGB:0x272831];
        }
    }
    
    for (UIImageView *selectImg in _arraySelectImg)
    {
        selectImg.hidden = selectImg.tag != sender.tag;
    }
    
    switch (sender.tag)
    {
        case 0://首页
        {
            _path = @"/path/ViewController";
            _params = @{};
        }
            break;
        case 1://App内推送测试页面
        {
            _path = @"/path/PushViewController";
            _params = @{@"title" : @"App内推送测试" , @"desc" : @"点击测试按钮后，你将立即收到一条app内推送",@"color" : @(0x7B91FF) ,@"msgType" : @2 , @"isTimedPush" : @0 , @"tag" : @1};
        }
            break;
        case 2://通知测试页面
        {
            _path = @"/path/PushViewController";
            _params = @{@"title" : @"通知测试" , @"desc" : @"点击测试按钮后，5s左右将收到一条测试通知",@"color" : @(0xFF7D00) ,@"msgType" : @1 , @"isTimedPush" : @0 , @"tag" : @0};
        }
            
            break;
        case 3://定时通知测试页面
        {
            _path = @"/path/PushViewController";
            _params = @{@"title" : @"定时通知测试" , @"desc" : @"设置时间后点击测试按钮，在到设置时间时将收到一条测试通知",@"color" : @(0x29C18B) ,@"msgType" : @3 , @"isTimedPush" : @1 , @"tag" : @0};
        }
            
            break;
        default:
            break;
    }
    
}

//点击测试
- (IBAction)onSendApnsMsg:(id)sender
{
    if (_textView.text.length < 1 || _textView.text.length > 35)
    {
        [MBProgressHUD showTitle:@"内容不能为空或超过35个字符"];
        return;
    }
    
    BOOL isProductionEnvironment;
#ifdef DEBUG
    isProductionEnvironment = NO;
#else
    isProductionEnvironment = YES;
#endif
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [MobPush sendMessageWithMessageType:MSendMessageTypeAPNs
                                content:_textView.text
                                  space:0
                isProductionEnvironment:isProductionEnvironment
                                 extras:nil
                             linkScheme:_path
                               linkData:[MOBFJson jsonStringFromObject:_params]
                                 result:^(NSError *error) {
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
                                         if (error)
                                         {
                                             [MBProgressHUD showTitle:@"发送失败"];
                                         }
                                         else
                                         {
                                             [MBProgressHUD showTitle:@"发送成功"];
                                         }
                                     });
                                     
                                 }];
}



@end
