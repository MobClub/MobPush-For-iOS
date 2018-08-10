//
//  MobPushDemoTests.m
//  MobPushDemoTests
//
//  Created by LeeJay on 2018/5/31.
//  Copyright © 2018年 com.mob. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MobPush/MobPush.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface MobPushDemoTests : XCTestCase

@end

@implementation MobPushDemoTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetupNotification
{
    //MobPush推送设置（获得角标、声音、弹框提醒权限）
    MPushNotificationConfiguration *configuration = [[MPushNotificationConfiguration alloc] init];
    configuration.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsAlert;
    [MobPush setupNotification:configuration];
}

- (void)testSetupNotificationFor100
{
    for(int i = 0 ; i <100 ; i++)
    {
        MPushNotificationConfiguration *configuration = [[MPushNotificationConfiguration alloc] init];
        configuration.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsAlert;
        [MobPush setupNotification:configuration];
    }
}

- (void)testSetupNotificationWithNil
{
    [MobPush setupNotification:nil];
}

- (void)testSetupNotificationWithWrongParameter
{
    [MobPush setupNotification:@""];
}

- (void)testSetupNotificationWithBadNetwork
{
    //MobPush推送设置（获得角标、声音、弹框提醒权限）
    MPushNotificationConfiguration *configuration = [[MPushNotificationConfiguration alloc] init];
    configuration.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsAlert;
    [MobPush setupNotification:configuration];
}

- (void)testAddLocalNotification
{
    MPushMessage *message = [[MPushMessage alloc] init];
    message.messageType = MPushMessageTypeLocal;
    message.content = @"本地推送内容";
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowtime = [currentDate timeIntervalSince1970] *1000;
    
    //设置0.06秒后发起本地推送
    NSTimeInterval taskDate = nowtime + 0.001*60*1000;
    message.taskDate = taskDate;
    [MobPush addLocalNotification:message];
}

- (void)testAddLocalNotificationFor100
{
    for(int i = 0 ; i <100 ;i++)
    {
        MPushMessage *message = [[MPushMessage alloc] init];
        message.messageType = MPushMessageTypeLocal;
        message.content = @"本地推送内容";
        
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval nowtime = [currentDate timeIntervalSince1970] *1000;
        
        //设置0.06秒后发起本地推送
        NSTimeInterval taskDate = nowtime + 0.001*60*1000;
        message.taskDate = taskDate;
        [MobPush addLocalNotification:message];
    }
}

- (void)testAddLocalNotificationWithNil
{
    [MobPush addLocalNotification:nil];
}

- (void)testAddLocalNotificationWithWrongParameter
{
    [MobPush addLocalNotification:@""];
}

- (void)testAddLocalNotificationWithBadNetwork
{
    MPushMessage *message = [[MPushMessage alloc] init];
    message.messageType = MPushMessageTypeLocal;
    message.content = @"本地推送内容";
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowtime = [currentDate timeIntervalSince1970] *1000;
    
    //设置0.06秒后发起本地推送
    NSTimeInterval taskDate = nowtime + 0.001*60*1000;
    message.taskDate = taskDate;
    [MobPush addLocalNotification:message];
}

- (void)testGetTagsWithResult
{
    [self expectationForNotification:@"testGetTagsWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        [MobPush getTagsWithResult:^(NSArray *tags, NSError *error){
            
            XCTAssertNil(error, @"Fail to get tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetTagsWithResult"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {
                                 }];
}

- (void)testGetTagsWithResult100Times
{
    [self expectationForNotification:@"testGetTagsWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush getTagsWithResult:^(NSArray *tags, NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to get tags.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetTagsWithResult"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
            });
        }
    }];
    
    [self waitForExpectationsWithTimeout:20
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testGetTagsWithResultWithBadNetwork
{
    [self expectationForNotification:@"testGetTagsWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush getTagsWithResult:^(NSArray *tags, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetTagsWithResult"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {
                                     
                                 }];
}

- (void)testAddTags
{
    [self expectationForNotification:@"testAddTags"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush addTags:@[@"tag666"] result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to add tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testAddTags"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testAddTags100Times
{
    [self expectationForNotification:@"testAddTags"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush addTags:@[@"tag666"] result:^(NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to add tags.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testAddTags"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
            });
        }
    }];
    
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testAddTagsWithNil
{
    [self expectationForNotification:@"testAddTagsWithNil"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush addTags:nil result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to add tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testAddTagsWithNil"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testAddTagsWithWrongParameter
{
    [self expectationForNotification:@"testAddTagsWithNil"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush addTags:@(212) result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to add tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testAddTagsWithNil"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testAddTagsWithBadNetwork
{
    [self expectationForNotification:@"testAddTagsWithBadNetwork"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush addTags:@[@"tag777"] result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to add tags because of the bad network.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testAddTagsWithBadNetwork"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteTags
{
    [self expectationForNotification:@"testDeleteTags"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush deleteTags:@[@"tag666"] result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to delete tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteTags"
                                                                object:nil
                                                              userInfo:nil];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteTags100Times
{
    [self expectationForNotification:@"testDeleteTags"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush deleteTags:@[@"tag666"] result:^(NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to delete tags.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteTags"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
            });
        }
    }];
    
    [self waitForExpectationsWithTimeout:20
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteTagsWithNil
{
    [self expectationForNotification:@"testDeleteTagsWithNil"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush deleteTags:nil result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to delete tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteTagsWithNil"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteTagsWithWrongParameter
{
    [self expectationForNotification:@"testDeleteTagsWithNil"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush deleteTags:@(666) result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to delete tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteTagsWithNil"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteTagsWithBadNetwork
{
    [self expectationForNotification:@"testDeleteTagsWithBadNetwork"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush deleteTags:@[@"tag666"] result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to delete tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteTagsWithBadNetwork"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testCleanAllTagsWithResult
{
    [self expectationForNotification:@"testCleanAllTagsWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush cleanAllTags:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to clean tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testCleanAllTagsWithResult"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:20
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testCleanAllTagsWithResult100Times
{
    [self expectationForNotification:@"testCleanAllTagsWithResult100Times"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush cleanAllTags:^(NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to clean tags.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testCleanAllTagsWithResult100Times"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
                
            });
        }
    }];
    
    [self waitForExpectationsWithTimeout:30
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testCleanAllTagsWithBadNetwork
{
    [self expectationForNotification:@"testCleanAllTagsWithBadNetwork"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush cleanAllTags:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to clean tags.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testCleanAllTagsWithBadNetwork"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testGetAliasWithResult
{
    [self expectationForNotification:@"testGetAliasWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetAliasWithResult"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testGetAliasWithResult100Times
{
    [self expectationForNotification:@"testGetAliasWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to get alias.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetAliasWithResult"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
                
            });
        }
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testGetAliasWithResultWithBadNetwork
{
    [self expectationForNotification:@"testGetTagsWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetTagsWithResult"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testSetAlias
{
    [self expectationForNotification:@"testSetAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush setAlias:@"6666" result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to set alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testSetAlias"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testSetAlias100Times
{
    [self expectationForNotification:@"testSetAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush setAlias:@"6666" result:^(NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to set alias.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testSetAlias"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
            });
        }
    }];
    
    [self waitForExpectationsWithTimeout:30
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testSetAliasWithNil
{
    [self expectationForNotification:@"testSetAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush setAlias:nil result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to set alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testSetAlias"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testSetAliasWithWrongParameter
{
    [self expectationForNotification:@"testSetAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush setAlias:@(666) result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to set alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testSetAlias"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}


- (void)testSetAliasWithBadNetwork
{
    [self expectationForNotification:@"testSetAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush setAlias:@"alias777" result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to set alias because of the bad network.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testSetAlias"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteAlias
{
    [self expectationForNotification:@"testDeleteAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush deleteAlias:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to delete alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteAlias"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteAlias100Times
{
    [self expectationForNotification:@"testDeleteAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush deleteAlias:^(NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to delete alias.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteAlias"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
            });
        }
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testDeleteAliasWithBadNetwork
{
    [self expectationForNotification:@"testDeleteAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush deleteAlias:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to delete alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testDeleteAlias"
                                                                object:nil
                                                              userInfo:nil];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testGetRegistrationID
{
    [self expectationForNotification:@"testGetRegistrationID"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get registrationID.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetRegistrationID"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testGetRegistrationID100Times
{
    [self expectationForNotification:@"testGetRegistrationID"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        for (int i = 0; i < 100; i++)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to get alias.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetRegistrationID"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
                
            });
        }
    }];
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

- (void)testGetRegistrationIDWithBadNetwork
{
    [self expectationForNotification:@"testGetRegistrationID"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要3秒后才能获取结果，比如一个异步网络请求
        sleep(3);
        
        [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get alias.");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"testGetRegistrationID"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
    }];
    
    
    [self waitForExpectationsWithTimeout:10
                                 handler:^(NSError * _Nullable error) {}];
}

// iOS 10 后台点击通知
- (void)mpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    
}

// iOS 10 前台收到通知
- (void)mpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSUInteger))completionHandler
{
    
}

@end

