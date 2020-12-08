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
        instance.DemoAttachmentURL = @"https://static.mob.com/www_mob_com/.nuxt/dist/client/img/f641a28.png";
    });
    return instance;
}

@end
