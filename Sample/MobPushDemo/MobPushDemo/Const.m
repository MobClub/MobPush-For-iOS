//
//  Const.m
//  MobPushDemo
//
//  Created by wkx on 2020/7/29.
//  Copyright © 2020 com.mob. All rights reserved.
//

#import "Const.h"

@implementation Const

+ (instancetype)shared
{
    static Const *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Const alloc] init];
        instance.DemoAttachmentURL = @"http://download.sdk.mob.com/2021/05/11/18/16207285804677.20.png";
    });
    return instance;
}

@end
