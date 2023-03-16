//
//  MPushNotificationTrigger.h
//  MobPush
//
//  Created by wkx on 2020/5/21.
//  Copyright © 2020 com.mob. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRegion;

/*
 * 本地推送触发方式
 * iOS10以上请使用region、dateComponents、timeInterval选择其中一种方式，如果同时多个赋值根据优先级(I：高、II：中、III：低)高的为主，如果全为空，为即时消息。
 * iOS10以下定时推送使用fireDate
 */
@interface MPushNotificationTrigger : NSObject

// 设置是否重复，默认为NO
@property (nonatomic, assign) BOOL repeat;

// 用来设置触发推送的时间，iOS10以上无效
@property (nonatomic, copy) NSDate *fireDate NS_DEPRECATED_IOS(2_0, 10_0);

// 用来设置触发推送的位置，应用需要允许使用定位的授权，iOS8以上有效，iOS10以上优先级为I
@property (nonatomic, copy) CLRegion *region NS_AVAILABLE_IOS(8_0);

// 用来设置触发推送的日期时间，iOS10以上有效，优先级为II
@property (nonatomic, copy) NSDateComponents *dateComponents NS_AVAILABLE_IOS(10_0);

// 用来设置触发推送的时间，iOS10以上有效，优先级为III
@property (nonatomic, assign) NSTimeInterval timeInterval NS_AVAILABLE_IOS(10_0);

@end

