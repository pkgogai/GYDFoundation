//
//  GYDDatabaseSQLTests.m
//  GYDFoundationDevelopmentTests
//
//  Created by 宫亚东 on 2018/11/9.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GYDDatabase+SQL.h"
#import "GYDDatabase+Version.h"
#import "NSString+GYDString.h"

@interface GYDDatabaseSQLTests : XCTestCase

@end

static NSString *const TableName = @"t`e\'s\"t_table";
static NSString *const IndexName = @"t`e\'s\"t_index";
static NSString *const ColumnName = @"t`e\'s\"t_column";
static NSString *const ColumnName1 = @"t`e\'s\"t_column1";
static NSString *const ColumnName2 = @"t`e\'s\"t_column2";

@implementation GYDDatabaseSQLTests
{
    GYDDatabase *_database;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)updateCol2WithValue:(NSString *)value {
    BOOL r = [_database insertOrUpdateTable:TableName setDic:@{@"col2":value} whereDic:@{ColumnName:@"key1"}];
    XCTAssert(r, @"%s", __func__);
}
- (void)compareCol2WithValue:(NSString *)value {
    NSString *col2Value = [_database selectFirstColumn:@"col2" fromTable:TableName whereEqualDic:@{ColumnName:@"key1"}];
    XCTAssert([NSString gyd_isString:value equalToString:col2Value], @"%s", __func__);
}

- (void)testTable {
    NSString *path = NSTemporaryDirectory();
    path = [path stringByAppendingPathComponent:@"testDatabase/database.db"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    NSLog(@"%@", path);
    _database = [[GYDDatabase alloc] initWithPath:path];
    BOOL r = [_database createTableIfNotExits:TableName columnArray:@[ColumnName]];
    XCTAssert(r, @"%s", __func__);
    r = [_database deleteTableIfExists:TableName];
    
    [_database createTableIfNotExits:TableName columnArray:@[ColumnName, @"col2"]];
    [self updateCol2WithValue:@"a`a\'a\"a"];
    [self compareCol2WithValue:@"a`a\'a\"a"];
    
    r = [_database createColumnIfNotExits:ColumnName1 forTable:TableName];
    XCTAssert(r, @"%s", __func__);
    
    r = [_database insertOrUpdateTable:TableName setDic:@{ColumnName1:ColumnName2} whereDic:@{ColumnName:@"key2"}];
    XCTAssert(r, @"%s", __func__);
    NSString *col2Value = [_database selectFirstColumn:ColumnName1 fromTable:TableName whereEqualDic:@{ColumnName:@"key2"}];
    XCTAssert([NSString gyd_isString:ColumnName2 equalToString:col2Value], @"%s", __func__);
    
    r = [_database createTableIfNotExits:IndexName columnArray:@[ColumnName]];
    XCTAssert(r, @"%s", __func__);
    
    r = [_database createTableIfNotExits:@"other_index" columnArray:@[ColumnName, ColumnName1]];
    XCTAssert(r, @"%s", __func__);
    
}

- (void)testInsert {
    
}

- (void)testDelete {
    
}

- (void)testSelect {
    
}

- (void)testUpdate {
    
}

- (void)testOther {
    
}


- (void)testExample {
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
