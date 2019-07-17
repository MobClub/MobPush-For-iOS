//
//  MobPushDemoTests.m
//  MobPushDemoTests
//
//  Created by LeeJay on 2018/5/31.
//  Copyright © 2018年 com.mob. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MobPush/MobPush.h>

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
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
       
        [MobPush getTagsWithResult:^(NSArray *tags, NSError *error){
            
            XCTAssertNil(error, @"Fail to get tags.");
            
            terminate();
        }];
    }];
}

- (void)testGetTagsWithResult100Times
{
    [self _wait:20 testOperation:^(void (^terminate)(void)) {
       
        [MobPush getTagsWithResult:^(NSArray *tags, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get tags.");
            
            terminate();
        }];
    }];
}


- (void)testAddTags
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        [MobPush addTags:@[@"tag666"] result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to add tags.");
            
            terminate();
            
        }];
    }];
}

- (void)testAddTags100Times
{
    [self _wait:100 testOperation:^(void (^terminate)(void)) {
        
       __block int tmp = 0;
        for (int i = 0; i < 100; i++)
        {
            [MobPush addTags:@[@"tag666"] result:^(NSError *error) {
                
                XCTAssertNil(error, @"Fail to add tags.");
                if (++tmp == 100) {
                    terminate();
                }
            }];
        }
    }];
}

- (void)testAddTagsWithNil
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
       
        [MobPush addTags:nil result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to add tags.");
            
            terminate();
        }];
    }];
}

- (void)testAddTagsWithWrongParameter
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        [MobPush addTags:@(212) result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to add tags.");
            
            terminate();
        }];
    }];
}


- (void)testDeleteTags
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        
        [MobPush deleteTags:@[@"tag666"] result:^(NSError *error) {
            
            terminate();
        }];
    }];
}

- (void)testDeleteTags100Times
{
    [self _wait:100 testOperation:^(void (^terminate)(void)) {
        
        __block int tmp = 0;
        for (int i = 0; i < 100; i++)
        {
            [MobPush deleteTags:@[@"tag666"] result:^(NSError *error) {
                
                XCTAssertNil(error, @"Fail to delete tags.");
                
                if (++tmp == 100)
                {
                    terminate();
                }
            }];
        }
    }];
}

- (void)testDeleteTagsWithNil
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        [MobPush deleteTags:nil result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to delete tags.");
            
            terminate();
        }];
    }];
}

- (void)testDeleteTagsWithWrongParameter
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        
        [MobPush deleteTags:@(666) result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to delete tags.");
            
            terminate();
            
        }];
    }];
}


- (void)testCleanAllTagsWithResult
{
    [self _wait:20 testOperation:^(void (^terminate)(void)) {
       
        [MobPush addTags:@[@"AddTag"] result:^(NSError *error) {
            
             XCTAssertNil(error, @"Fail to clean tags.");
            if (!error) {
                [MobPush cleanAllTags:^(NSError *error) {
                    
                    XCTAssertNil(error, @"Fail to clean tags.");
                    
                    terminate();
                }];
            }
        }];
    }];
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
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get alias.");
            
            terminate();
        }];
    }];
}

- (void)testGetAliasWithResult100Times
{
    [self _wait:100 testOperation:^(void (^terminate)(void)) {
        
        __block int tmp = 0;
        for (int i = 0; i < 100; i++)
        {
            [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
                
                XCTAssertNil(error, @"Fail to get alias.");
                
                if (++tmp == 100) {
                    terminate();
                }
            }];
        }
    }];
}


- (void)testSetAlias
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        
        [MobPush setAlias:@"6666" result:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to set alias.");
            
            terminate();
        }];
    }];
}

- (void)testSetAlias100Times
{
    [self _wait:50 testOperation:^(void (^terminate)(void)) {
       
        __block int tmp = 0;
        for (int i = 0; i < 100; i++)
        {
            [MobPush setAlias:@"6666" result:^(NSError *error) {
                
                XCTAssertNil(error, @"Fail to set alias.");
                
                if (++tmp == 100) {
                    terminate();
                }
                
            }];
        }
    }];
}

- (void)testSetAliasWithNil
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        
        [MobPush setAlias:nil result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to set alias.");
            
            terminate();
            
        }];
    }];
}

- (void)testSetAliasWithWrongParameter
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
       
        [MobPush setAlias:@(666) result:^(NSError *error) {
            
            XCTAssertNotNil(error, @"It should Fail to set alias.");
            
            terminate();
        }];
    }];
}



- (void)testDeleteAlias
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
       
        [MobPush deleteAlias:^(NSError *error) {
            
            XCTAssertNil(error, @"Fail to delete alias.");
            
            terminate();
        }];
    }];
}

- (void)testDeleteAlias100Times
{
    [self _wait:100 testOperation:^(void (^terminate)(void)) {
       
        __block int tmp = 0;
        for (int i = 0; i < 100; i++)
        {
            [MobPush deleteAlias:^(NSError *error) {
                
                XCTAssertNil(error, @"Fail to delete alias.");
                
                if (++tmp == 100)
                {
                    terminate();
                }
            }];
        }
    }];
}


- (void)testGetRegistrationID
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
        
        [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
            
            XCTAssertNil(error, @"Fail to get registrationID.");
            
            terminate();
        }];
    }];
}

- (void)testGetRegistrationID100Times
{
    [self _wait:10 testOperation:^(void (^terminate)(void)) {
       
        __block int tmp = 0;
        for (int i = 0; i < 100; i++)
        {
            [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
                
                XCTAssertNil(error, @"Fail to get alias.");
                
                if (++tmp == 100) {
                    terminate();
                }
            }];
        }
    }];
}


- (void)testSetBadge
{
    [MobPush setBadge:0];
}

#pragma mark - Privite

- (void)_wait:(NSTimeInterval)delay testOperation:(void(^)(void(^terminate)(void)))operation
{
    XCTestExpectation *expectation = [self expectationWithDescription:self.name];
    
    operation(^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [expectation fulfill];
//        });
    });
    
    [self waitForExpectations:@[expectation] timeout:delay];
}


@end

