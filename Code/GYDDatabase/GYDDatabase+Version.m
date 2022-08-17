//
//  GYDDatabase+Version.m
//  FMDB
//
//  Created by 宫亚东 on 2018/11/9.
//

#import "GYDDatabase+Version.h"
#import "GYDDatabasePrivateHeader.h"
#import "GYDDatabase+SQL.h"

static NSString *const TableNameOfVersion = @"gyd_version";
static NSString *const ColumnNameOfKey = @"name";
static NSString *const ColumnNameOfVersion = @"version";
static NSString *const IndexNameOfVersion = @"gyd_index_version";

@implementation GYDDatabase (Version)

- (BOOL)updateVersion:(long long)version forKey:(nonnull NSString *)key actionBlock:(BOOL (NS_NOESCAPE ^ _Nonnull)(FMDatabase * _Nonnull db, long long lastVersion))block {
    if (!_isVersionTableCreate) {
        BOOL r = [self inTransaction:^BOOL(FMDatabase * _Nonnull db) {
            if (![self createTableIfNotExists:TableNameOfVersion checkColumns:NO columnArray:@[ColumnNameOfKey, ColumnNameOfVersion]]) {
                return NO;
            }
            if (![self createIndexIfNotExists:IndexNameOfVersion unique:YES onTable:TableNameOfVersion columnArray:@[ColumnNameOfKey]]) {
                return NO;
            }
            return YES;
        }];
        
        if (!r) {
            return NO;
        }
        _isVersionTableCreate = YES;
    }
    NSNumber *number = [self selectFirstColumn:ColumnNameOfVersion fromTable:TableNameOfVersion whereEqualDic:@{ColumnNameOfKey : key}];
    long long lastVersion = [number longLongValue];
    
    BOOL r = [self inTransaction:^BOOL(FMDatabase * _Nonnull db) {
        if (!block(db, lastVersion)) {
            return NO;
        }
        if (![self insertOrUpdateTable:TableNameOfVersion setDic:@{ColumnNameOfVersion : @(version)} whereDic:@{ColumnNameOfKey : key}]) {
            return NO;
        }
        return YES;
    }];
    
    return r;
}


@end
