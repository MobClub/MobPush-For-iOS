//
//  UIViewController+MobPush.h
//  MobPush
//
//  Created by Brilance on 2018/6/11.
//  Copyright © 2018年 com.mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MobPush)

/**
 设置控制器路径

 @return 控制器路径
 */
+ (NSString *)MobPushPath;

/**
 初始化场景参数

 @param params 场景参数
 @return 控制器对象
 */
- (instancetype)initWithMobPushScene:(NSDictionary*)params;

@end
