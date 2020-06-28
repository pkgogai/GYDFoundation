//
//  GYDDatabase+SQL.h
//  FMDB
//
//  Created by 宫亚东 on 2018/11/1.
//

#import <Foundation/Foundation.h>
#import "GYDDatabase.h"

#pragma mark - 简单的SQL语句处理，不处理转义符号，只有MFDB自己对参数的处理

@interface GYDDatabase (SQL)

/** 整理数据库 */
+ (BOOL)cleanDatabase:(nonnull FMDatabase *)db;
- (BOOL)cleanDatabase;


#pragma mark - 表和索引

/** 表不存在则创建，checkColumns表示当表已经存在时是否检查并补充缺失的列 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db createTableIfNotExists:(nonnull NSString *)table checkColumns:(BOOL)checkColumns columnArray:(nonnull NSArray *)colArray;
- (BOOL)createTableIfNotExists:(nonnull NSString *)table checkColumns:(BOOL)checkColumns columnArray:(nonnull NSArray *)colArray;

/** 删除表 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteTableIfExists:(nonnull NSString *)table;
- (BOOL)deleteTableIfExists:(nonnull NSString *)table;

/** 创建索引（多个列则是联合索引），unique:索引值是否唯一（索引列插入相同的值会失败） */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db createIndexIfNotExists:(nonnull NSString *)indexName unique:(BOOL)unique onTable:(nonnull NSString*)table columnArray:(nonnull NSArray *)colArray;
- (BOOL)createIndexIfNotExists:(nonnull NSString *)indexName unique:(BOOL)unique onTable:(nonnull NSString*)table columnArray:(nonnull NSArray *)colArray;

/** 删除索引 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteIndexIfExists:(nonnull NSString *)indexName;
- (BOOL)deleteIndexIfExists:(nonnull NSString *)indexName;

/** 列不存在则创建 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db createColumnIfNotExits:(nonnull NSString *)columnName forTable:(nonnull NSString *)table;
- (BOOL)createColumnIfNotExits:(nonnull NSString *)columnName forTable:(nonnull NSString *)table;

#pragma mark - 增

/** 插入数据{@"列1":@"值1", @"列2":@"值2", ……} */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db insertIntoTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dic;
- (BOOL)insertIntoTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dic;


#pragma mark - 删

/** 删除完全符合条件的数据 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteFromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;
- (BOOL)deleteFromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;

/** 删除数据，appendSQL 用问号作为占位符，argumentArray是其中的值，例如：@"WHERE key=?", @[@"value"] */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db deleteFromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray;
- (BOOL)deleteFromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray;


#pragma mark - 查

/** 查找符合条件的第一条数据的指定列的内容 */
+ (nullable id)inDatabase:(nonnull FMDatabase *)db selectFirstColumn:(nonnull NSString *)columnName fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;
- (nullable id)selectFirstColumn:(nonnull NSString *)columnName fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;

/** 查找符合条件的第一条数据,返回值是数组，@[@"第1条数据第1列",@"第1条数据第2列",……] */
+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectFirstRowWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;
- (nullable NSMutableArray *)selectFirstRowWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;

/** 查找数据，返回值是双重数组，@[@[@"第1条数据第1列",@"第1条数据第2列"],@[@"第2条数据第1列",@"第2条数据第2列"]] */
+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;
- (nullable NSMutableArray *)selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;

/** 查找数据，可在where的等式后面继续附加语句，返回值是双重数组，@[@[@"第1条数据第1列",@"第1条数据第1列"],@[@"第2条数据第1列",@"第2条数据第2列"]] */
+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray;
- (nullable NSMutableArray *)selectRowsWithColumns:(nullable NSArray *)colArr fromTable:(nonnull NSString *)table appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argumentArray;


#pragma mark - 改

/** 更新数据 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nullable NSDictionary *)whereDic;
- (BOOL)updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nullable NSDictionary *)whereDic;

/** 更新数据 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argument;
- (BOOL)updateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic appendSQL:(nullable NSString *)appendSQL arguments:(nullable NSArray *)argument;


#pragma mark - 插或改

/** 有则修改dataDic，无则插入whereDic和dataDic的合集 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db insertOrUpdateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nonnull NSDictionary *)whereDic;
- (BOOL)insertOrUpdateTable:(nonnull NSString *)table setDic:(nonnull NSDictionary *)dataDic whereDic:(nonnull NSDictionary *)whereDic;

/** 有则修改updateDic，无则插入whereDic和insertDic的合集 */
+ (BOOL)inDatabase:(nonnull FMDatabase *)db insertOrUpdateTable:(nonnull NSString *)table insertDic:(nonnull NSDictionary *)insertDic updateDic:(nonnull NSDictionary *)updateDic whereDic:(nonnull NSDictionary *)whereDic;
- (BOOL)insertOrUpdateTable:(nonnull NSString *)table insertDic:(nonnull NSDictionary *)insertDic updateDic:(nonnull NSDictionary *)updateDic whereDic:(nonnull NSDictionary *)whereDic;

#pragma mark - 执行SQL语句

+ (BOOL)inDatabase:(nonnull FMDatabase *)db executeSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments;
- (BOOL)executeSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments;

+ (nullable NSMutableArray *)inDatabase:(nonnull FMDatabase *)db selectFirstRowWithSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments;
- (nullable NSMutableArray *)selectFirstRowWithSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments;

+ (nullable NSMutableArray<NSMutableArray *> *)inDatabase:(nonnull FMDatabase *)db selectRowsWithSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments;
- (nullable NSMutableArray<NSMutableArray *> *)selectRowsWithSQL:(nonnull NSString *)SQL arguments:(nullable NSArray *)arguments;

#pragma mark - 其它

+ (BOOL)inDatabase:(nonnull FMDatabase *)db hasRowfromTable:(nonnull NSString *)table whereEqualDic:(nullable NSDictionary *)dic;

/** 不包括where字样，例如separator是and，处理结果 `col1`=? and `col2`=? */
+ (nullable NSString *)SQLStringWithKeysOfDic:(nullable NSDictionary *)dic joinedByString:(nullable NSString *)separator argumentToArray:(nonnull NSMutableArray *)arr;

@end

