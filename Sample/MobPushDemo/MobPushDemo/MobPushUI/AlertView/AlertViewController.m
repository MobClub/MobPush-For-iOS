//
//  AlertViewController.m
//  MobPushDemo
//
//  Created by LeeJay on 2017/11/7.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "AlertViewController.h"
#import <MOBFoundation/MOBFoundation.h>

@interface AlertViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) NSString *theTitle;
@property (nonatomic, copy) NSString *content;

@end

@implementation AlertViewController

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content
{
    if (self = [super init])
    {
        self.theTitle = title;
        self.content = content;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [MOBFColor colorWithARGB:0x4c000000];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height/2 - 125, [UIScreen mainScreen].bounds.size.width - 60, 250)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.masksToBounds = YES;
    [self.view addSubview:self.containerView];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame =CGRectMake(0, 20, self.containerView.frame.size.width, 20);
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.theTitle;
    [self.containerView addSubview:title];
    
    UILabel *content = [[UILabel alloc] init];
    content.frame =CGRectMake(0, CGRectGetMaxY(title.frame) + 10, self.containerView.frame.size.width, 70);
    content.font = [UIFont systemFontOfSize:14];
    content.textAlignment = NSTextAlignmentCenter;
    content.numberOfLines = 0;
    content.text = self.content;
    [self.containerView addSubview:content];
    
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(content.frame) + 20, self.containerView.frame.size.width - 40, 40)];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btnOK setTitle:@"我知道了" forState:UIControlStateNormal];
    btnOK.backgroundColor = [MOBFColor colorWithRGB:0x7B91FF];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(pickerViewBtnOk:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btnOK];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.frame =CGRectMake(0,CGRectGetMaxY(btnOK.frame) + 20, self.containerView.frame.size.width, 20);
    tip.font = [UIFont systemFontOfSize:12];
    tip.textColor = [UIColor grayColor];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.numberOfLines = 0;
    tip.text = @"此推送服务由MobPush提供";
    [self.containerView addSubview:tip];
}

- (void)pickerViewBtnOk:(UIButton *)btn
{
    if ([self.delegate conformsToProtocol:@protocol(IAlertViewControllerDelegate)] &&
        [self.delegate respondsToSelector:@selector(selectOKWithData:)])
    {
        [self.delegate selectOKWithData:nil];
    }
}


@end
