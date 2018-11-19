//
//  MPushCustomMessage.h
//  MobPush
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自定义消息类型
 */
@interface MPushCustomMessage : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 自定义消息类型，如 text 文本
 */
@property (nonatomic, copy) NSString *type;

/**
 *  字典转模型
 */
+ (instancetype)customMessageWithDict:(NSDictionary *)dict;

@end
