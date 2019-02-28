//
//  PushViewController.h
//  MobPushDemo
//
//  Created by LeeJay on 2017/9/14.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobPush/MobPush+Test.h>
#import <MobPush/MobPush.h>


@interface PushViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
         buttonBackgroudColor:(UIColor *)color
                  messageType:(MSendMessageType)type
                  isTimedPush:(BOOL)isTimedPush;

- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
         buttonBackgroudColor:(UIColor *)color
                  messageType:(MSendMessageType)type
                  isTimedPush:(BOOL)isTimedPush
                          tag:(NSInteger)tag;

@end
