//
//  AlertViewController.h
//  MobPushDemo
//
//  Created by LeeJay on 2017/11/7.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IAlertViewControllerDelegate <NSObject>

- (void)selectOKWithData:(id)data;

@end

@interface AlertViewController : UIViewController

@property (nonatomic, weak) id<IAlertViewControllerDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@end
