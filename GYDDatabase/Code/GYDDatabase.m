//
//  GYDDatabase.m
//  GYDDatabase
//
//  Created by 宫亚东 on 2018/10/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDatabase.h"
#import "GYDDatabasePrivateHeader.h"

#import "GYDFoundationPrivateHeader.h"
#import <fmdb/FMDB.h>
#import "GYDFile.h"

@implementation GYDDatabase
{
    FMDatabase *_db;
    NSRecursiveLock *_lock;
    long long _savePointIndex;
}

static NSString *_DefaultDatabasePath = nil;

#pragma mark - 实际上大部分项目只需要一个数据库，所以记录一个默认的数据库，不想用就自己alloc。

/** 设置全局默认数据库的路径，在调用 defaultDatabase 时会根据此路径创建一个数据库 */
+ (void)setDefaultDatabasePath:(nonnull NSString *)path {
    if (_DefaultDatabasePath) {
        if (![_DefaultDatabasePath isEqualToString:path]) {
            GYDFoundationError(@"已经设置过路径：%@，\n无法修改为：%@", _DefaultDatabasePath, path);
        }
    } else {
        _DefaultDatabasePath = [path copy];
    }
}

/** 全局默认的数据库（需要先设置路径）， */
+ (nullable instancetype)defaultDatabase {
    static GYDDatabase *defaultDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultDatabase = [[self alloc] initWithPath:_DefaultDatabasePath];
        if (!defaultDatabase) {
            if (_DefaultDatabasePath) {
                GYDFoundationError(@"数据库路径使用失败：%@", _DefaultDatabasePath);
            } else {
                GYDFoundationError(@"没有设置数据库路径");
            }
        }
    });
    return defaultDatabase;
}

#pragma mark - 创建。

/** 创建并打开数据库，失败的情况都是path有问题，或文件无法创建，可以忽略 */
- (nullable instancetype)initWithPath:(nonnull NSString *)path {
    self = [super init];
    if (self) {
        [GYDFile makeSureFileAtPath:path errorMessage:nil];
        
        _db = [[FMDatabase alloc] initWithPath:path];
        _lock = [[NSRecursiveLock alloc] init];
        _savePointIndex = 0;
        _isVersionTableCreate = NO;
        
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success = [_db openWithFlags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
#else
        BOOL success = [_db open];
#endif
        if (!success) {
            GYDFoundationError(@"数据库创建失败，路径：%@", path);
            self = nil;
        }
    }
    return self;
}

#pragma mark - 使用。与FMDatabaseQueue不同的是 inDatabase: inTransaction: inGroup: 都可以随意嵌套

/** 对db进行操作，多层调用效果等同一层 */
- (void)inDatabase:(void (^ _Nonnull)(FMDatabase * _Nonnull db))block {
    [_lock lock];
    block(_db);
    [_lock unlock];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/** 在事务中执行，可以多层事务嵌套使用，且每层都可以正常回滚。 */
- (BOOL)inTransaction:(BOOL (^ _Nonnull)(FMDatabase * _Nonnull db))block {
    BOOL result = NO;
    [_lock lock];
    _savePointIndex ++;
    if (_savePointIndex == 1) {
        //最外层一定要有事务，中间可以是savePoint。在savePoint操作到一半时异常中断，外面有层事务才能确保所有操作都被取消
        [_db beginTransaction] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@", [_db lastErrorCode], [_db lastErrorMessage]);
        
        result = block(_db);
        
        if (result) {
            [_db commit] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@", [_db lastErrorCode], [_db lastErrorMessage]);
        } else {
            [_db rollback] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@", [_db lastErrorCode], [_db lastErrorMessage]);
        }
        
    } else {
        NSString *savePointName = [NSString stringWithFormat:@"savePoint_%lld", _savePointIndex];
        NSError *err = nil;
        [_db startSavePointWithName:savePointName error:&err] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@, \nNSError:%@", [_db lastErrorCode], [_db lastErrorMessage],[err localizedDescription]);
        
        result = block(_db);
        
        if (!result) {
            [_db rollbackToSavePointWithName:savePointName error:&err] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@, \nNSError:%@", [_db lastErrorCode], [_db lastErrorMessage],[err localizedDescription]);
        }
        [_db releaseSavePointWithName:savePointName error:&err] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@, \nNSError:%@", [_db lastErrorCode], [_db lastErrorMessage],[err localizedDescription]);
    }
    _savePointIndex --;
    
    [_lock unlock];
    return result;
}

/** 有连续多次写入操作的话，放到一个组里会快一些。与inTransaction:相比，嵌套使用时效率更高。 */
- (void)inGroup:(void (^ _Nonnull)(FMDatabase * _Nonnull db))block {
    [_lock lock];
    if (_savePointIndex == 0) {
        _savePointIndex ++;
        
        [_db beginTransaction] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@", [_db lastErrorCode], [_db lastErrorMessage]);
        
        block(_db);
        
        [_db commit] ?: GYDFoundationError(@"数据库操作失败:[errCode:]%d [Msg:]%@", [_db lastErrorCode], [_db lastErrorMessage]);
        
        _savePointIndex --;
    } else {
        block(_db);
    }
    [_lock unlock];
}

#pragma clang diagnostic pop


#pragma mark - 弃用

- (nullable instancetype)init
{
    self = [super init];
    if (self) {
        GYDFoundationError(@"错误的初始化");
    }
    return self;
}

@end
