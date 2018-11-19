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


- (void)testAddLocalNotificationWithNil
{
    [MobPush addLocalNotification:nil];
}

- (void)testAddLocalNotificationWithWrongParameter
{
    [MobPush addLocalNotification:@""];
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


- (void)testAddTags
{
    [self expectationForNotification:@"testAddTags"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        
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


- (void)testDeleteTags
{
    [self expectationForNotification:@"testDeleteTags"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        
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


- (void)testCleanAllTagsWithResult
{
    [self expectationForNotification:@"testCleanAllTagsWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{

        [MobPush addTags:@[@"AddTag"] result:^(NSError *error) {
            if (!error) {
                [MobPush cleanAllTags:^(NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to clean tags.");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"testCleanAllTagsWithResult"
                                                                        object:nil
                                                                      userInfo:nil];
                    
                }];
            }
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:20
                                 handler:^(NSError * _Nullable error) {}];
}

//- (void)testCleanAllTagsWithResult100Times
//{
//    [self expectationForNotification:@"testCleanAllTagsWithResult100Times"
//                              object:nil
//                             handler:^BOOL(NSNotification * _Nonnull notification) {
//
//                                 return YES;
//                             }];
//
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue addOperationWithBlock:^{
//
//        for (int i = 0; i < 100; i++)
//        {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//                [MobPush addTags:@[@"AddTag"] result:^(NSError *error) {
//                    if (!error) {
//                        [MobPush cleanAllTags:^(NSError *error) {
//
//                            XCTAssertNil(error, @"Fail to clean tags.");
//
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"testCleanAllTagsWithResult100Times"
//                                                                                object:nil
//                                                                              userInfo:nil];
//
//                        }];
//                    }
//                }];
//
//            });
//        }
//    }];
//
//    [self waitForExpectationsWithTimeout:30
//                                 handler:^(NSError * _Nullable error) {}];
//}


- (void)testGetAliasWithResult
{
    [self expectationForNotification:@"testGetAliasWithResult"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        
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


- (void)testSetAlias
{
    [self expectationForNotification:@"testSetAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        
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



- (void)testDeleteAlias
{
    [self expectationForNotification:@"testDeleteAlias"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        
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


- (void)testGetRegistrationID
{
    [self expectationForNotification:@"testGetRegistrationID"
                              object:nil
                             handler:^BOOL(NSNotification * _Nonnull notification) {
                                 
                                 return YES;
                             }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        
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


- (void)testSetBadge
{
    [MobPush setBadge:0];
}


@end

