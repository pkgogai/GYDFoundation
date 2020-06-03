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
    //假设我要创建一个表。
    
    //假设有这么一个数据库，可以是整个app公用的，也可以每个业务创建自己的
    GYDDatabase * database = [[GYDDatabase alloc] initWithPath:@"filepath"];
    
    //假设当前业务是第一次使用数据库，版本号就用1吧
    long long GYDVersion = 1;
    
    //假设当前业务需要创建一个表，有2列
    NSString *tableName = @"table1";
    NSString *columnName1 = @"col1";
    NSString *columnName2 = @"col2";
    
    //执行SQL创建数据表，既然本业务只有一个表，key就用表名吧
    [database updateVersion:GYDVersion forKey:tableName actionBlock:^BOOL(FMDatabase * _Nonnull db, long long lastVersion) {
        BOOL r = [GYDDatabase inDatabase:db createTableIfNotExists:tableName columnArray:@[columnName1, columnName2]];
        if (!r) {
            return NO;
        }
        return YES;
    }];
    
}
- (void)testUpdate2 {
    //假设下一版要对这个表做处理，增加一列col3
    
    //假设有这么一个数据库，可以是整个app公用的，也可以每个业务创建自己的
    GYDDatabase * database = [[GYDDatabase alloc] initWithPath:@"filepath"];
    
    //如今要对数据库进行升级处理，版本号就加为2吧
    long long GYDVersion = 2;
    
    //假设当前业务需要创建一个表，有2列
    NSString *tableName = @"table1";
    NSString *columnName1 = @"col1";
    NSString *columnName2 = @"col2";
    NSString *columnName3 = @"col3";
    
    //执行SQL创建数据表，既然是第一次处理，版本号就用1吧，本业务只有一个表，key就用表名吧
    [database updateVersion:1 forKey:tableName actionBlock:^BOOL(FMDatabase * _Nonnull db, long long lastVersion) {
        /*
         当前版本是2，根据之前的版本，升级处理应该是
         0->2：从无到有直接按最终版创建表即可
         1->2：版本1时已经创建过表了，只需再增加一列即可。
         2->2：本来就是版本2，无需任何操作。
         所以代码可以是：
        */
        if (lastVersion == 0) {
            BOOL r = [GYDDatabase inDatabase:db createTableIfNotExists:tableName columnArray:@[columnName1, columnName2, columnName3]];
            if (!r) {
                return NO;
            }
        } else if (lastVersion == 1) {
            BOOL r = [GYDDatabase inDatabase:db createColumnIfNotExits:columnName3 forTable:tableName];
            if (!r) {
                return NO;
            }
        }
        return YES;
    }];
    //但版本多了看着乱，而过于精细的处理也容易产生错误，例如有人把这个表删了却留下版本号，那就不会再走创建表的语句了。所以我通常只会区分2种情况：需要升级和不需要升级。
    [database updateVersion:1 forKey:tableName actionBlock:^BOOL(FMDatabase * _Nonnull db, long long lastVersion) {
        //完整的创建：即使表存在，多调用一次创建表的语句也没关系
        BOOL r = [GYDDatabase inDatabase:db createTableIfNotExists:tableName columnArray:@[columnName1, columnName2, columnName3]];
        if (!r) {
            return NO;
        }
        //需要升级
        if (lastVersion > 0 && lastVersion < GYDVersion) {
            //低版本中有缺少col3这列的情况，那不管从哪个版本的数据库升级上来我都尝试创建一下确保这列的存在。
            r = [GYDDatabase inDatabase:db createColumnIfNotExits:columnName3 forTable:tableName];
            if (!r) {
                return NO;
            }
        }
        return YES;
     }];
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
