//
//  MOBFDataService_Private.h
//  MOBFoundation
//
//  Created by 冯鸿杰 on 16/12/26.
//  Copyright © 2016年 MOB. All rights reserved.
//

#import <MOBFoundation/MOBFoundation.h>

@interface MOBFDataService ()

/**
 *  临时缓存数据集合
 */
@property (nonatomic, strong) NSMutableDictionary *cacheDataDomains;

/**
 *  缓存数据集合引用次数
 */
@property (nonatomic, strong) NSMutableDictionary *cacheDataRetainCounts;

/**
 *  安全数据集合
 */
@property (nonatomic, strong) NSMutableDictionary *secureDataCollection;

/**
 *  共享数据集合
 */
@property (nonatomic, strong) NSMutableDictionary *sharedDataCollection;

/**
 获取整个缓存数据，优先取事务中的数据，如果没有则取本地文件数据

 @param domain 域名
 @return 缓存数据
 */
- (id)cacheDataByTraceDomain:(NSString *)domain;

/**
 *  开始缓存数据事务(公库内部使用)
 */
- (void)_beginCacheDataTrans;

/**
 *  结束缓存数据事务(公库内部使用)
 */
- (void)_endCacheDataTrans;

/**
 *  设置缓存数据(公库内部使用)
 *
 *  @param data     数据
 *  @param key      标识
 */
- (void)_setCacheData:(id)data forKey:(NSString *)key;

/**
 *  获取缓存数据(公库内部使用)
 *
 *  @param key 标识
 *
 *  @return 数据
 */
- (id)_cacheDataForKey:(NSString *)key;

/**
 清除缓存

 @param domain 域名
 */
- (void)_clearCacheData:(NSString *)domain;

@end
