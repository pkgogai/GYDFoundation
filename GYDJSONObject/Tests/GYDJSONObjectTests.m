//
//  GYDJSONObjectTests.m
//  GYDFoundationTests
//
//  Created by 宫亚东 on 2018/9/4.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+GYDJSONObject.h"
#import "GYDJSONSerialization.h"

@interface GYDTestJsonObject1 : NSObject

GYDJSONProperty(int, a);
GYDJSONProperty(NSString *, b);
GYDJSONPropertyNamed(NSNumber *, c, d);

GYDJSONPropertyArray(NSString, *, eee);
GYDJSONProperty(NSArray *, f);

@end

@implementation GYDTestJsonObject1

@end

@interface GYDTestJsonObject2 : GYDTestJsonObject1

GYDJSONProperty(int, f);
GYDJSONProperty(NSString *, g);
GYDJSONPropertyNamed(NSNumber *, h, i);

GYDJSONPropertyArray(NSString, *, j);

@end

@implementation GYDTestJsonObject2

@end


@interface GYDJSONObjectTests : XCTestCase

@end



//只是临时做个试验，还没写正式的测试用例

@implementation GYDJSONObjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testPropertyInfo {
//    NSArray<GYDJSONPropertyInfo *> *infoArray = [GYDTestJsonObject1 gyd_propertyInfoArray];
//    NSArray<GYDJSONPropertyInfo *> *infoArray2 = [GYDTestJsonObject2 gyd_propertyInfoArray];
//
//    NSLog(@"%@", infoArray);
//    NSLog(@"%@", infoArray2);
    
}
- (void)testExample {
    
    GYDTestJsonObject1 *obj1 = [[GYDTestJsonObject1 alloc] init];
    obj1.a = 1;
    obj1.b = @"b\nbb";
//    obj1.c = @"ccc";
    obj1.f = @[@"eee", @"eee"];
    NSDictionary *dic = [obj1 gyd_JSONDictionary];
    
    NSLog(@"%@", [obj1 gyd_JSONString]);
    obj1 = [GYDTestJsonObject1 gyd_modelWithJSONDictionary:dic];
    
    
    BOOL r = [GYDJSONSerialization isValidJSONObject:@(1)];
    r = [GYDJSONSerialization isValidJSONObject:@"1"];
    
    r = [GYDJSONSerialization isValidJSONObject:[NSNull null]];

    r = [GYDJSONSerialization isValidJSONObject:@[@"a", @"b"] ];
    r = [GYDJSONSerialization isValidJSONObject:@{
                                                  @"12" : [@[@"a", @"b"] mutableCopy],
                                                  }];
//    NSString *json3 = [GYDJSONSerialization stringWithJSONObject:@(1)];
    NSDictionary *a = @{
                        @(12) : [@[@"a", @"b"] mutableCopy],
                        };
    NSString *json = [GYDJSONSerialization stringWithJSONObject:a];
    a = [a mutableCopy];
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    

    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
