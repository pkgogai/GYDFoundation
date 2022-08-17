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

- (void)testMatch {
    NSString *str = @"12345";
    NSArray *matchingArray = @[
        //符合条件
        @"12345", @"*", @"*5", @"1*5", @"1*", @"*12345", @"12*345", @"12345*", @"1*3*", @"1**5", @"*12*5", @"?2345", @"1??45", @"123??", @"1*4?", @"1?*345", @"1?*5", @"?2345",
        //不符合条件
        @"1234", @"2345", @"1245", @"1*4", @"1?2345", @"1?45", @""
    ];
    for (NSString *s in matchingArray) {
        BOOL r = [str gyd_matchingWildcardString:s];
        BOOL realR = [[NSPredicate predicateWithFormat:@"SELF LIKE %@", s] evaluateWithObject:str];
        if (r != realR) {
            NSLog(@"");
        }
        XCTAssert(r == realR);
    }
    
    NSString *oStr = @"12345123451234512345123451234512345123451234512345123451234512345123451234512345123451234512345123645123451234512345123451278345123451234512345123451234512345123451234512345123451234512345123451234512345";
    NSString *matchStr = @"1*6*7*8*5";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF LIKE %@", matchStr];
    NSTimeInterval t1 = [NSDate timeIntervalSinceReferenceDate];
    for (NSInteger i = 0; i < 100000; i++) {
        [oStr gyd_matchingWildcardString:matchStr];
    }
    NSTimeInterval t2 = [NSDate timeIntervalSinceReferenceDate];
    for (NSInteger i = 0; i < 100000; i++) {
        [pre evaluateWithObject:oStr];
    }
    NSTimeInterval t3 = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"%lf, %lf", t2 - t1, t3 - t2);
    //iMac (Retina 5K, 27-inch, 2020)3.8 GHz 八核Intel Core i7
    //0.093964, 0.473417
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
