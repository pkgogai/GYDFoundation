//
//  GYDDatabase+SQL.m
//  FMDB
//
//  Created by 宫亚东 on 2018/11/1.
//

#import "GYDDatabase+SQL.h"
#import "GYDFoundationPrivateHeader.h"
#import <fmdb/FMDB.h>

@implementation GYDDatabase (SQL)

#ifndef GYD_DATABASE_NEED_ESCAPE
#   define GYD_DATABASE_NEED_ESCAPE 1
#endif

#if GYD_DATABASE_NEED_ESCAPE == 0
#   define appendEscapeColumn(col) appendString:(col)
#   define columnEscapeWithQuote(col) (col)
#else
#   define appendEscapeColumn(col) appendFormat:@"`%@`", [(col) stringByReplacingOccurrencesOfString:@"`" withString:@"``"]
//SQL语句组装，方法改成宏定义速度提高约1%
#   define columnEscapeWithQuote(col) [NSString stringWithFormat:@"`%@`", [col stringByReplacingOccurrencesOfString:@"`" withString:@"``"]]
#   define columnEscape(col) [col stringByReplacingOccurrencesOfString:@"`" withString:@"``"];
//static NSString * _Nonnull columnEscapeWithQuote(NSString * _Nonnull column) {
//    return [NSString stringWithFormat:@"`%@`", [column stringByReplacingOccurrencesOfString:@"`" withString:@"``"]];
//}
//static NSString * _Nonnull columnEscape(NSString * _Nonnull column) {
//    return [column stringByReplacingOccurrencesOfString:@"`" withString:@"``"];
//}
#endif

#define GYDDatabaseLogSQL(sql) NSLog(@"%@", sql)




/** 整理数据库 */
+ (BOOL)cleanDatabase:(FMDatabase *)db {
    NSString *sql = @"VACUUM";
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)cleanDatabase {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase * _Nonnull db) {
        r = [GYDDatabase cleanDatabase:db];
    }];
    return r;
}

#pragma mark - 表和索引
/** 表不存在则创建（存在时不检查列是否相同） */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db createTableIfNotExists:(nonnull NSString *)table checkColumns:(BOOL)checkColumns columnArray:(nonnull NSArray *)colArray {
    table = columnEscapeWithQuote(table);
    NSMutableString *columnStr = [NSMutableString string];
    BOOL first = YES;
    for (NSString *col in colArray) {
        if (first) {
            first = NO;
        } else {
            [columnStr appendString:@","];
        }
        [columnStr appendEscapeColumn(col)];
    }
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)", table, columnStr];
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    if (checkColumns) {
        NSMutableDictionary *createColumnDic = [NSMutableDictionary dictionary];
        for (NSString *col in colArray) {
            createColumnDic[[col lowercaseString]] = col;
        }
//        NSMutableArray *deleteColumns = nil;
        
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat: @"pragma table_info(%@)", table]];
        if (!rs) {
            GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
        }
        while ([rs next]) {
            NSString *col = [[rs stringForColumn:@"name"] lowercaseString];
            if (createColumnDic[col]) {
                [createColumnDic removeObjectForKey:col];
//            } else {
//                if (!deleteColumns) {
//                    deleteColumns = [NSMutableArray arrayWithCapacity:0];
//                }
//                [deleteColumns addObject:col];
            }
        }
        [rs close];
        
        for (NSString *key in createColumnDic) {
            NSString *col = createColumnDic[key];
            col = columnEscapeWithQuote(col);
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@",table, col];
            GYDDatabaseLogSQL(sql);
            BOOL r = [db executeUpdate:sql];
            if (!r) {
                GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
            }
        }
        //不支持删除列，为此复制一个新表又不值得。
//        for (NSString *tmpCol in deleteColumns) {
//            NSString *col = columnEscapeWithQuote(tmpCol);
//            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ DROP COLUMN %@",table, col];
//            GYDDatabaseLogSQL(sql);
//            BOOL r = [db executeUpdate:sql];
//            if (!r) {
//                GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
//            }
//        }
        
    }
    return r;
}

- (BOOL)createTableIfNotExists:(nonnull NSString *)table checkColumns:(BOOL)checkColumns columnArray:(nonnull NSArray *)colArray {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db createTableIfNotExists:table checkColumns:checkColumns columnArray:colArray];
    }];
    return r;
}

/** 删除表 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteTableIfExists:(nonnull NSString *)table {
    table = columnEscapeWithQuote(table);
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", table];
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)deleteTableIfExists:(nonnull NSString *)table {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db deleteTableIfExists:table];
    }];
    return r;
}

/** 创建索引（多个列则是联合索引），unique:索引值是否唯一（索引列插入相同的值会失败） */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db createIndexIfNotExists:(nonnull NSString *)indexName unique:(BOOL)unique onTable:(nonnull NSString*)table columnArray:(nonnull NSArray *)colArray {
    indexName = columnEscapeWithQuote(indexName);
    table = columnEscapeWithQuote(table);
    NSMutableString *columnStr = [NSMutableString string];
    BOOL first = YES;
    for (NSString *col in colArray) {
        if (first) {
            first = NO;
        } else {
            [columnStr appendString:@","];
        }
        [columnStr appendEscapeColumn(col)];
    }
    NSString *sql = [NSString stringWithFormat:@"create %@ index if not exists %@ on %@(%@)", (unique?@"unique":@""), indexName, table, columnStr];
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)createIndexIfNotExists:(nonnull NSString *)indexName unique:(BOOL)unique onTable:(nonnull NSString*)table columnArray:(nonnull NSArray *)colArray {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db createIndexIfNotExists:indexName unique:unique onTable:table columnArray:colArray];
    }];
    return r;
}

/** 删除索引 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteIndexIfExists:(nonnull NSString *)indexName {
    indexName = columnEscapeWithQuote(indexName);
    NSString *sql = [NSString stringWithFormat:@"DROP INDEX IF EXISTS %@", indexName];
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)deleteIndexIfExists:(nonnull NSString *)indexName {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db deleteIndexIfExists:indexName];
    }];
    return r;
}

/** 列不存在则创建 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db createColumnIfNotExits:(nonnull NSString *)columnName forTable:(nonnull NSString *)table {
    if (!columnName) {
        return NO;
    }
    NSString *lowercaseColumn = [columnName lowercaseString];
    columnName = columnEscapeWithQuote(columnName);
    table = columnEscapeWithQuote(table);
    
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat: @"pragma table_info(%@)", table]];
    while ([rs next]) {
        if ([[[rs stringForColumn:@"name"] lowercaseString] isEqualToString:lowercaseColumn]) {
            [rs close];
            return YES;
        }
    }
    [rs close];
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@",table,columnName];
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)createColumnIfNotExits:(nonnull NSString *)columnName forTable:(nonnull NSString *)table {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db createColumnIfNotExits:columnName forTable:table];
    }];
    return r;
}

#pragma mark - 增
/** 插入数据{@"列1":@"值1", @"列2":@"值2", ……} */
+ (int64_t)inDatabase:(nonnull FMDatabase *)db insertIntoTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dic {
    table = columnEscapeWithQuote(table);
    NSMutableString *keyStr = [NSMutableString string];
    NSMutableString *valueStr = [NSMutableString string];
    NSMutableArray *argumentArray = [NSMutableArray array];
    
    BOOL first = YES;
    for (NSString *key in dic) {
        if (first) {
            first = NO;
        } else {
            [keyStr appendString:@","];
            [valueStr appendString:@","];
        }
        [keyStr appendEscapeColumn(key)];
        [valueStr appendString:@"?"];
        [argumentArray addObject:dic[key]];
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@)VALUES(%@)", table, keyStr, valueStr];
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql withArgumentsInArray:argumentArray];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
        return 0;
    }
    return [db lastInsertRowId];
}
- (int64_t)insertIntoTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dic {
    __block int64_t r = 0;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db insertIntoTable:table setDic:dic];
    }];
    return r;
}

#pragma mark - 删
/** 删除完全符合条件的数据 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteFromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    table = columnEscapeWithQuote(table);
    
    NSMutableArray *argumentArray = [NSMutableArray array];
    NSString *sql = [self SQLStringWithKeysOfDic:dic joinedByString:@"AND" argumentToArray:argumentArray];
    if (sql) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", table, sql];
    } else {
        sql = [NSString stringWithFormat:@"DELETE FROM %@", table];
    }
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql withArgumentsInArray:argumentArray];;
    
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)deleteFromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db deleteFromTable:table whereEqualDic:dic];
    }];
    return r;
}

/** 删除数据，appendSQL 用问号作为占位符，argumentArray是其中的值，例如：@"WHERE key=?", @[@"value"] */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteFromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray {
    table = columnEscapeWithQuote(table);
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@", table, appendSQL ?: @""];
    GYDDatabaseLogSQL(sql);
    
    BOOL r = [db executeUpdate:sql withArgumentsInArray:argumentArray];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)deleteFromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db deleteFromTable:table appendSQL:appendSQL arguments:argumentArray];
    }];
    return r;
}

#pragma mark - 查
/** 查找符合条件的第一条数据的指定列的内容 */
+ (nullable id)inDatabase:(nonnull FMDatabase *)db selectFirstColumn:(nonnull NSString *)columnName fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    
    table = columnEscapeWithQuote(table);
    columnName = columnEscapeWithQuote(columnName);
    
    NSMutableArray *argumentArray = [NSMutableArray array];
    NSString *sql = [self SQLStringWithKeysOfDic:dic joinedByString:@"AND" argumentToArray:argumentArray];
    if (sql) {
        sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ LIMIT 1", columnName, table, sql];
    } else {
        sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ LIMIT 1", columnName, table];
    }
    GYDDatabaseLogSQL(sql);
    
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:argumentArray];
    if (!result) {
        GYDFoundationError(@"db select fail:[errCode:]%d [Msg:]%@", [db lastErrorCode], [db lastErrorMessage]);
        return nil;
    }
    
    id data = nil;
    if ([result next]) {
        data = [result objectForColumnIndex:0];
        if ([data isKindOfClass:[NSNull class]]) {
            data = nil;
        }
    }
    [result close];
    return data;
}
- (nullable id)selectFirstColumn:(nonnull NSString *)columnName fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    __block id r = nil;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db selectFirstColumn:columnName fromTable:table whereEqualDic:dic];
    }];
    return r;
}

/** 查找符合条件的第一条数据,返回值是数组，@[@"第1条数据第1列",@"第1条数据第2列",……] */
+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectFirstRowWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    
    table = columnEscapeWithQuote(table);
    
    NSMutableString * colStr = [NSMutableString string];
    
    for (int i=0; i<colArr.count; i++) {
        if (i != 0) {
            [colStr appendString:@","];
        }
        [colStr appendEscapeColumn([colArr objectAtIndex:i])];
    }
    
    NSMutableArray *argumentArray = [NSMutableArray array];
    NSString *sql = [self SQLStringWithKeysOfDic:dic joinedByString:@"AND" argumentToArray:argumentArray];
    if (sql) {
        sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ LIMIT 1", colStr ?: @"", table, sql];
    } else {
        sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ LIMIT 1", colStr ?: @"", table];
    }
    GYDDatabaseLogSQL(sql);
    
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:argumentArray];
    if (!result) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
        return nil;
    }
    NSMutableArray *row = nil;
    if ([result next]) {
        row = [NSMutableArray array];
        for (int i=0; i<colArr.count; i++) {
            [row addObject:[result objectForColumnIndex:i]];
        }
    }
    [result close];
    return row;
}
- (nullable NSMutableArray *)selectFirstRowWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    __block NSMutableArray *r = nil;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db selectFirstRowWithColumns:colArr fromTable:table whereEqualDic:dic];
    }];
    return r;
}

/** 查找数据，返回值是双重数组，@[@[@"第1条数据第1列",@"第1条数据第2列"],@[@"第2条数据第1列",@"第2条数据第2列"]] */
+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    
    NSMutableArray *argumentArray = nil;
    NSString *whereSql = nil;
    if (dic.count > 0) {
        argumentArray = [NSMutableArray array];
        whereSql = [self SQLStringWithKeysOfDic:dic joinedByString:@"AND" argumentToArray:argumentArray];
        if (whereSql) {
            whereSql = [NSString stringWithFormat:@" WHERE %@", whereSql];
        }
    }
    return [self inDatabase:db selectRowsWithColumns:colArr fromTable:table appendSQL:whereSql arguments:argumentArray];
}
- (nullable NSMutableArray *)selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    __block NSMutableArray *r = nil;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db selectRowsWithColumns:colArr fromTable:table whereEqualDic:dic];
    }];
    return r;
}

/** 查找数据，可在where的等式后面继续附加语句，返回值是双重数组，@[@[@"第1条数据第1列",@"第1条数据第1列"],@[@"第2条数据第1列",@"第2条数据第2列"]] */
+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray {
    
    table = columnEscapeWithQuote(table);
    
    NSMutableArray *resultData = [NSMutableArray array];
    NSMutableString * colStr = [NSMutableString string];
    
    for (int i=0; i<colArr.count; i++) {
        if (i != 0) {
            [colStr appendString:@","];
        }
        [colStr appendEscapeColumn([colArr objectAtIndex:i])];
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@", colStr, table, appendSQL ?: @""];
    GYDDatabaseLogSQL(sql);
    
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:argumentArray];
    if (!result) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
        return nil;
    }
    while ([result next]) {
        NSMutableArray *row = [NSMutableArray array];
        for (int i=0; i<colArr.count; i++) {
            [row addObject:[result objectForColumnIndex:i]];
        }
        [resultData addObject:row];
    }
    [result close];
    return resultData;
}
- (nullable NSMutableArray *)selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray {
    __block NSMutableArray *r = nil;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db selectRowsWithColumns:colArr fromTable:table appendSQL:appendSQL arguments:argumentArray];
    }];
    return r;
}

#pragma mark - 改
/** 更新数据 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nullable NSDictionary *)whereDic {
    
    table = columnEscapeWithQuote(table);
    
    BOOL r;
    NSMutableArray *argumentArray = [NSMutableArray array];
    
    NSString *setStr = [self SQLStringWithKeysOfDic:dataDic joinedByString:@"," argumentToArray:argumentArray];
    NSString *whereStr = [self SQLStringWithKeysOfDic:whereDic joinedByString:@"AND" argumentToArray:argumentArray];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@", table, setStr ?: @""];
    if (whereStr) {
        sql = [sql stringByAppendingFormat:@" WHERE %@", whereStr];
    }
    GYDDatabaseLogSQL(sql);
    
    r = [db executeUpdate:sql withArgumentsInArray:argumentArray];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    
    return r;
}
- (BOOL)updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nullable NSDictionary *)whereDic {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db updateTable:table setDic:dataDic whereDic:whereDic];
    }];
    return r;
}

/** 更新数据 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argument {
    
    table = columnEscapeWithQuote(table);
    
    NSMutableArray *argumentArray = [NSMutableArray array];
    
    NSString *setStr = [self SQLStringWithKeysOfDic:dataDic joinedByString:@"," argumentToArray:argumentArray];
    if (argument) {
        [argumentArray addObjectsFromArray:argument];
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ %@", table , setStr ?: @"", appendSQL ?: @""];
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql withArgumentsInArray:argumentArray];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    
    return r;
}
- (BOOL)updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argument {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db updateTable:table setDic:dataDic appendSQL:appendSQL arguments:argument];
    }];
    return r;
}

#pragma mark - 插或改
/** 有则修改dataDic，无则插入whereDic和dataDic的合集 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db insertOrUpdateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nonnull NSDictionary *)whereDic {
    BOOL r = NO;
    if ([GYDDatabase inDatabase:db hasRowfromTable:table whereEqualDic:whereDic]) {
        r = [GYDDatabase inDatabase:db updateTable:table setDic:dataDic whereDic:whereDic];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:whereDic];
        [dic addEntriesFromDictionary:dataDic];
        r = [GYDDatabase inDatabase:db insertIntoTable:table setDic:dic] > 0;
    }
    return r;
}
- (BOOL)insertOrUpdateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nonnull NSDictionary *)whereDic {
    __block BOOL r;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db insertOrUpdateTable:table setDic:dataDic whereDic:whereDic];
    }];
    return r;
}

/** 有则修改updateDic，无则插入whereDic和insertDic的合集 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db insertOrUpdateTable:(nonnull NSString *)table insertDic:(nonnull NSDictionary *)insertDic updateDic:(nonnull NSDictionary *)updateDic whereDic:(nonnull NSDictionary *)whereDic {
    BOOL r = NO;
    if ([GYDDatabase inDatabase:db hasRowfromTable:table whereEqualDic:whereDic]) {
        r = [GYDDatabase inDatabase:db updateTable:table setDic:updateDic whereDic:whereDic];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:whereDic];
        [dic addEntriesFromDictionary:insertDic];
        r = [GYDDatabase inDatabase:db insertIntoTable:table setDic:insertDic];
    }
    return r;
}
- (BOOL)insertOrUpdateTable:(nonnull NSString *)table insertDic:(nonnull NSDictionary *)insertDic updateDic:(nonnull NSDictionary *)updateDic whereDic:(nonnull NSDictionary *)whereDic {
    __block BOOL r;
    [self inDatabase:^(FMDatabase *db) {
        r = [GYDDatabase inDatabase:db insertOrUpdateTable:table insertDic:insertDic updateDic:updateDic whereDic:whereDic];
    }];
    return r;
}

#pragma mark - 执行SQL语句

+ (BOOL)inDatabase:(nonnull FMDatabase *)db executeSQL:(nonnull NSString *)sql arguments:(nullable NSArray *)arguments {
    GYDDatabaseLogSQL(sql);
    BOOL r = [db executeUpdate:sql withArgumentsInArray:arguments];
    if (!r) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
    }
    return r;
}
- (BOOL)executeSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments {
    __block BOOL r = NO;
    [self inDatabase:^(FMDatabase * _Nonnull db) {
        r = [GYDDatabase inDatabase:db executeSQL:SQL arguments:arguments];
    }];
    return r;
}

+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectFirstRowWithSQL:(nonnull NSString *)sql arguments:(nullable NSArray *)arguments {
    GYDDatabaseLogSQL(sql);
    
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:arguments];
    if (!result) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
        return nil;
    }
    NSMutableArray *row = nil;
    if ([result next]) {
        row = [NSMutableArray array];
        int colCount = [result columnCount];
        for (int i=0; i<colCount; i++) {
            [row addObject:[result objectForColumnIndex:i]];
        }
    }
    [result close];
    return row;
}
- (nullable NSMutableArray *)selectFirstRowWithSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments {
    __block NSMutableArray *r = nil;
    [self inDatabase:^(FMDatabase * _Nonnull db) {
        r = [GYDDatabase inDatabase:db selectFirstRowWithSQL:SQL arguments:arguments];
    }];
    return r;
}

+ (nullable NSMutableArray<NSMutableArray *> *)inDatabase:(nonnull FMDatabase *)db selectRowsWithSQL:(nonnull NSString *)sql arguments:(nullable NSArray *)arguments {
    GYDDatabaseLogSQL(sql);
    
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:arguments];
    if (!result) {
        GYDFoundationError(@"数据库操作失败:[ErrCode:]%d [Msg:]%@\n[SQL:]%@", [db lastErrorCode], [db lastErrorMessage], sql);
        return nil;
    }
    NSMutableArray *resultData = [NSMutableArray array];
    while ([result next]) {
        NSMutableArray *row = [NSMutableArray array];
        int colCount = [result columnCount];
        for (int i=0; i<colCount; i++) {
            [row addObject:[result objectForColumnIndex:i]];
        }
        [resultData addObject:row];
    }
    [result close];
    return resultData;
    
}
- (nullable NSMutableArray<NSMutableArray *> *)selectRowsWithSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments {
    __block NSMutableArray *r = nil;
    [self inDatabase:^(FMDatabase * _Nonnull db) {
        r = [GYDDatabase inDatabase:db selectRowsWithSQL:SQL arguments:arguments];
    }];
    return r;
}

#pragma mark - 其它
+ (BOOL)inDatabase:(nonnull FMDatabase *)db hasRowfromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic {
    
    table = columnEscapeWithQuote(table);
    NSMutableArray *argumentArray = [NSMutableArray array];
    
    NSString *sql = [self SQLStringWithKeysOfDic:dic joinedByString:@"AND" argumentToArray:argumentArray];
    if (sql) {
        sql = [NSString stringWithFormat:@"SELECT 1 FROM %@ WHERE %@ LIMIT 1", table, sql];
    } else {
        sql = [NSString stringWithFormat:@"SELECT 1 FROM %@ LIMIT 1", table];
    }
    GYDDatabaseLogSQL(sql);
    
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:argumentArray];
    if (!result) {
        GYDFoundationError(@"db select fail:[errCode:]%d [Msg:]%@", [db lastErrorCode], [db lastErrorMessage]);
    }
    BOOL r = [result next];
    [result close];
    return r;
}
/** 不包括where字样，只有 `col1`=? and `col2`=? */
+ (nullable NSString *)SQLStringWithKeysOfDic:(nullable NSDictionary *)dic joinedByString:(nullable NSString *)separator argumentToArray:(nonnull NSMutableArray *)arr {
    if (!separator) {
        separator = @" ";
    }
    NSMutableString *sql = nil;
    
    for (NSString *key in dic) {
        if (sql) {
            [sql appendFormat:@" %@ %@=?", separator, columnEscapeWithQuote(key)];
        } else {
            sql = [NSMutableString stringWithFormat:@"%@=?", columnEscapeWithQuote(key)];
        }
        [arr addObject:dic[key]];
    }
    return sql;
}

@end
