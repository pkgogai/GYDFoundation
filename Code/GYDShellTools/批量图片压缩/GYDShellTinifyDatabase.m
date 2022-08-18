//
//  GYDShellTinifyDatabase.m
//  GYDFoundation
//
//  Created by gongyadong on 2020/12/17.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellTinifyDatabase.h"
#import "GYDFoundation.h"
#import "GYDDatabasePublishHeader.h"
#import "GYDFoundationPrivateHeader.h"

static NSString * const TableName = @"table_file";
static NSString * const IndexName = @"index_file";
static NSString * const MD5Column = @"md5";
static NSString * const NameColumn = @"name";
static NSString * const StateColumn = @"state";

@implementation GYDShellTinifyDatabase
{
    GYDDatabase *_db;
}
- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _db = [[GYDDatabase alloc] initWithPath:path];
        if (!_db) {
            return nil;
        }
        BOOL r = [_db updateVersion:1 forKey:@"" actionBlock:^BOOL(FMDatabase * _Nonnull db, long long lastVersion) {
            
            BOOL r = [_db createTableIfNotExists:TableName checkColumns:YES columnArray:@[
                MD5Column,
                NameColumn,
                StateColumn
            ]];
            
            if (!r) {
                return NO;
            }
            r = [_db createIndexIfNotExists:IndexName unique:YES onTable:TableName columnArray:@[MD5Column]];
            if (!r) {
                return NO;
            }
            return YES;
        }];
        if (!r) {
            return nil;
        }
    }
    return self;
}

- (NSInteger)state:(NSInteger)state forFileMd5:(NSString *)md5 {
    NSNumber *r = [_db selectFirstColumn:StateColumn fromTable:TableName whereEqualDic:@{
        MD5Column : md5
    }];
    return [r integerValue];
}

- (BOOL)setName:(NSString *)name state:(NSInteger)state forFileMd5:(NSString *)md5 {
    if (!md5) {
        GYDFoundationWarning(@"md5 为空");
        return NO;
    }
    BOOL r = [_db insertOrUpdateTable:TableName setDic:@{
        NameColumn : name ?: @"",
        StateColumn : @(state)
    } whereDic:@{
        MD5Column : md5
    }];
    if (!r) {
        return NO;
    }
    return YES;
}

@end
