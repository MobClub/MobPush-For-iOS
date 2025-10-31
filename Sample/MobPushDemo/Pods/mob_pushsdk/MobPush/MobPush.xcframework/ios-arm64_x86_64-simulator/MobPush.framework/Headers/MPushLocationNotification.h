//
//  MPushLocationNotification.h
//  MobPush
//
//  Created by MobTech-iOS on 2024/10/9.
//  Copyright © 2024 com.mob. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPushLocationNotification : NSObject

@property(nonatomic, copy) NSString *geofenceID;
@property(nonatomic, strong) NSNumber *expireTime;

@end

NS_ASSUME_NONNULL_END
