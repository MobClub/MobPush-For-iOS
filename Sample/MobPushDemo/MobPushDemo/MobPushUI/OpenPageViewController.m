//
//  OpenPageViewController.m
//  MobPushDemo
//
//  Created by LeeJay on 2018/3/16.
//  Copyright © 2018年 com.mob. All rights reserved.
//

#import "OpenPageViewController.h"
#import "UITextView+MPushPlaceholder.h"
#import <MOBFoundation/MOBFoundation.h>
#import "MBProgressHUD+Extension.h"
#import <MobPush/MobPush+Test.h>

@interface OpenPageViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;

@end

@implementation OpenPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.textView.placeholder = @"填写推送内容（不超过35个字）";
    self.textView.placeholderColor = [MOBFColor colorWithRGB:0xA6A6B2];
    self.textView.layer.cornerRadius = 2;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [MOBFColor colorWithRGB:0xE6E6EC].CGColor;
    self.textView.layer.borderWidth = 0.5f;
    
    self.textBtn.layer.cornerRadius = 2;
    self.textBtn.layer.masksToBounds = YES;
    
    [self setUpForDismissKeyboard];
}

- (IBAction)onClick:(id)sender
{
    if (self.textView.text.length < 1 || self.textView.text.length > 35)
    {
        [MBProgressHUD showTitle:@"内容不能为空或超过35个字符"];
        return;
    }
    
    NSString *urlStr;
    
    if (self.textField.text.length < 1)
    {
        urlStr = @"http://m.mob.com";
    }
    else
    {
        if ([self.textField.text containsString:@"http"])
        {
            urlStr = self.textField.text;
        }
        else
        {
            urlStr = [NSString stringWithFormat:@"http://%@", self.textField.text];
        }
    }
    
    BOOL isProductionEnvironment;
#ifdef DEBUG
    isProductionEnvironment = NO;
#else
    isProductionEnvironment = YES;
#endif
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [MobPush sendMessageWithMessageType:MSendMessageTypeAPNs
                                content:self.textView.text
                                  space:0
                isProductionEnvironment:isProductionEnvironment
                                 extras:@{@"url" : urlStr}
                             linkScheme:nil
                               linkData:nil
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

#pragma mark - 任何空白区域键盘事件

- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
