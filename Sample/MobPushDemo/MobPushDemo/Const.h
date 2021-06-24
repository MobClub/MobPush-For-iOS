//
//  Const.h
//  MobPushDemo
//
//  Created by wkx on 2020/7/29.
//  Copyright © 2020 com.mob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Const : NSObject

@property(nonatomic, strong)NSString *DemoAttachmentURL;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
