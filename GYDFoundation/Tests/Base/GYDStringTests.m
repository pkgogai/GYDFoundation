//
//  GYDString.m
//  GYDFoundationTests
//
//  Created by 宫亚东 on 2018/8/22.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+GYDString.h"

@interface GYDStringTests : XCTestCase

@end

@implementation GYDStringTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSubstring {
    NSString *str = @"12345";
    NSString *tmp;
    tmp = [str gyd_substringWithIndex:0 length:0];
    XCTAssert([tmp isEqualToString:@"12345"]);
    
    tmp = [str gyd_substringWithIndex:0 length:1];
    XCTAssert([tmp isEqualToString:@"1"]);
    
    tmp = [str gyd_substringWithIndex:1 length:4];
    XCTAssert([tmp isEqualToString:@"2345"]);
    
    tmp = [str gyd_substringWithIndex:2 length:10];
    XCTAssert([tmp isEqualToString:@"345"]);
    
    tmp = [str gyd_substringWithIndex:-1 length:2];
    XCTAssert([tmp isEqualToString:@"5"]);
    
    tmp = [str gyd_substringWithIndex:-100 length:100-2];
    XCTAssert([tmp isEqualToString:@"123"]);
    
    tmp = [str gyd_substringWithIndex:-100 length:2];
    XCTAssert([tmp isEqualToString:@""]);
    
    
}

- (void)testEqual {
    XCTAssert([NSString gyd_isString:@"" equalToString:@""]);
    XCTAssert([NSString gyd_isString:nil equalToString:nil]);
    XCTAssert([NSString gyd_isString:@"1" equalToString:@"1"]);
    
    XCTAssert(![NSString gyd_isString:nil equalToString:@""]);
    XCTAssert(![NSString gyd_isString:@"" equalToString:nil]);
    XCTAssert(![NSString gyd_isString:@"1" equalToString:@"2"]);
    
    XCTAssert([NSString gyd_isStringValue:@"" equalToStringValue:@""]);
    XCTAssert([NSString gyd_isStringValue:nil equalToStringValue:nil]);
    XCTAssert([NSString gyd_isStringValue:@"" equalToStringValue:nil]);
    XCTAssert([NSString gyd_isStringValue:nil equalToStringValue:@""]);
    XCTAssert([NSString gyd_isStringValue:@"1" equalToStringValue:@"1"]);
    
    XCTAssert(![NSString gyd_isStringValue:@"1" equalToStringValue:@""]);
    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
