//
//  MOBNavigationViewController.m
//  MobPushDemo
//
//  Created by LeeJay on 2018/3/16.
//  Copyright © 2018年 com.mob. All rights reserved.
//

#import "MOBNavigationViewController.h"

@interface MOBNavigationViewController () <UIGestureRecognizerDelegate>

@end

@implementation MOBNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _enablePopGesture = YES;
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self configureNavBarTheme];
}

- (void)configureNavBarTheme
{
    self.navigationBar.tintColor = [UIColor blackColor];
    
    // 设置导航栏的标题颜色，字体
    NSDictionary *textAttrs = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:16.0]};
    [self.navigationBar setTitleTextAttributes:textAttrs];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1)
    {
        return NO;
    }
    return self.enablePopGesture;
}

#pragma mark - override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(navGoBack)];
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - action

- (void)navGoBack
{
    [self popViewControllerAnimated:YES];
}

@end
