//
//  GYDDatabaseTests.m
//  GYDFoundationDevelopmentTests
//
//  Created by 宫亚东 on 2018/11/9.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GYDDatabase+SQL.h"
#import "GYDDatabase+Version.h"
#import "GYDFile.h"
#import "NSString+GYDString.h"

@interface GYDDatabaseTests : XCTestCase

@end

@implementation GYDDatabaseTests
{
    GYDDatabase *_database;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *path = NSTemporaryDirectory();
    path = [path stringByAppendingPathComponent:@"testDatabase/database.db"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    NSLog(@"%@", path);
    _database = [[GYDDatabase alloc] initWithPath:path];
    BOOL r = [_database createTableIfNotExists:@"t`e\'s\"t_table" checkColumns:YES columnArray:@[@"c'o\'l\"1", @"col2"]];
    XCTAssert(r, @"%s", __func__);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
- (void)testGroup {
    [self updateCol2WithValue:@"a`a\'a\"a"];
    [self compareCol2WithValue:@"a`a\'a\"a"];
    BOOL r = [_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
        [self->_database inGroup:^(FMDatabase * _Nonnull db) {
            [self updateCol2WithValue:@"bbb"];
            [self compareCol2WithValue:@"bbb"];
        }];
        return YES;
    }];
    XCTAssert(r, @"%s", __func__);
    [self compareCol2WithValue:@"bbb"];
    
    [self updateCol2WithValue:@"a`a\'a\"a"];
    [self compareCol2WithValue:@"a`a\'a\"a"];
    r = [_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
        [self->_database inGroup:^(FMDatabase * _Nonnull db) {
            [self updateCol2WithValue:@"bbb"];
            [self compareCol2WithValue:@"bbb"];
        }];
        return NO;
    }];
    XCTAssert(!r, @"%s", __func__);
    [self compareCol2WithValue:@"a`a\'a\"a"];
    
    [self->_database inGroup:^(FMDatabase * _Nonnull db) {
        BOOL r = [self->_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
            [self->_database inGroup:^(FMDatabase * _Nonnull db) {
                [self updateCol2WithValue:@"bbb"];
                [self compareCol2WithValue:@"bbb"];
            }];
            return YES;
        }];
        XCTAssert(r, @"%s", __func__);
        [self compareCol2WithValue:@"bbb"];
    }];
    
    [self->_database inGroup:^(FMDatabase * _Nonnull db) {
        BOOL r = [self->_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
            [self->_database inGroup:^(FMDatabase * _Nonnull db) {
                [self updateCol2WithValue:@"ccc"];
                [self compareCol2WithValue:@"ccc"];
            }];
            return NO;
        }];
        XCTAssert(!r, @"%s", __func__);
        [self compareCol2WithValue:@"bbb"];
    }];
}
- (void)testTransaction {
    BOOL r = [_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
        [self updateCol2WithValue:@"a`a\'a\"a"];
        [self compareCol2WithValue:@"a`a\'a\"a"];
        BOOL r = [self->_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
            [self updateCol2WithValue:@"bbb"];
            [self compareCol2WithValue:@"bbb"];
            
            BOOL r = [self->_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
                [self updateCol2WithValue:@"ccc"];
                [self compareCol2WithValue:@"ccc"];
                return YES;
            }];
            [self compareCol2WithValue:@"ccc"];
            XCTAssert(r, @"%s", __func__);
            return NO;
        }];
        [self compareCol2WithValue:@"a`a\'a\"a"];
        XCTAssert(!r, @"%s", __func__);
        
        r = [self->_database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
            [self updateCol2WithValue:@"ddd"];
            [self compareCol2WithValue:@"ddd"];
            return NO;
        }];
        [self compareCol2WithValue:@"a`a\'a\"a"];
        XCTAssert(!r, @"%s", __func__);
        return YES;
    }];
    [self compareCol2WithValue:@"a`a\'a\"a"];
    XCTAssert(r, @"%s", __func__);
}
- (void)updateCol2WithValue:(NSString *)value {
    BOOL r = [_database insertOrUpdateTable:@"t`e\'s\"t_table" setDic:@{@"col2":value} whereDic:@{@"c'o\'l\"1":@"key1"}];
    XCTAssert(r, @"%s", __func__);
}
- (void)compareCol2WithValue:(NSString *)value {
    NSString *col2Value = [_database selectFirstColumn:@"col2" fromTable:@"t`e\'s\"t_table" whereEqualDic:@{@"c'o\'l\"1":@"key1"}];
    XCTAssert([NSString gyd_isString:value equalToString:col2Value], @"%s", __func__);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self->_database inGroup:^(FMDatabase * _Nonnull db) {
            for (NSInteger i = 0; i < 100; i ++) {
                [self updateCol2WithValue:[NSString stringWithFormat:@"%d", (int)i]];
            }
        }];
        [self compareCol2WithValue:@"99"];
    }];
}

@end
