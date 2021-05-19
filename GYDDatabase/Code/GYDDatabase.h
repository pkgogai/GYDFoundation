//
//  GYDDatabase.h
//  GYDDatabase
//
//  Created by 宫亚东 on 2018/10/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDatabase.h>

@interface GYDDatabase : NSObject

// 已删除全局默认的数据库，如有需要，可以自己补充类别
//+ (nullable instancetype)defaultDatabase;

#pragma mark - 创建。

/** 创建并打开数据库，失败的情况都是path有问题，或文件无法创建，可以忽略 */
- (nullable instancetype)initWithPath:(nonnull NSString *)path;

#pragma mark - 使用。与FMDatabaseQueue不同的是 inDatabase: inTransaction: inGroup: 都可以随意嵌套

/** 对db进行操作，多层调用效果等同一层 */
- (void)inDatabase:(void (^ _Nonnull)(FMDatabase * _Nonnull db))block;

/** 在事务中执行，可以多层事务嵌套使用，且每层都可以正常回滚。block返回YES提交，返回NO回滚 */
- (BOOL)inTransaction:(BOOL (^ _Nonnull)(FMDatabase * _Nonnull db))block;

/** 有连续多次写入操作的话，放到一个组里会快一些。与inTransaction:相比，嵌套使用时效率更高。 */
- (void)inGroup:(void (^ _Nonnull)(FMDatabase * _Nonnull db))block;


#pragma mark - 弃用

- (nullable instancetype)init NS_DEPRECATED_IOS(1_0, 1_0, "用 initWithPath:初始化 ");

/*
 事务的block从(void (^ _Nonnull)(FMDatabase * _Nonnull db, BOOL * _Nonnull shouldRollback))改为(BOOL (^ _Nonnull)(FMDatabase * _Nonnull db))，使用方便
 */
//又一次决定还是删除了干净，代码里也不用记录这些状态，也可以强制别人不要使用，当然如果非要用的话，inDatabase:里获取了FMDB后还可以自己写，只是这样就完全和inTransaction:等不兼容。两者的事务不能同时存在。
///*
// 这三个方法加了又删，删了又加，最终决定，为了更好的融入其它人的项目，还是提供一下事务单独处理的方法。
// 但是要注意，本文的事务是可以嵌套调用的，所以每1个 beginTransaction 都一定要有1个 commit 或者1个 rollback 与之对应，不能多也不能少。
// */
//- (void)beginTransaction NS_DEPRECATED_IOS(1_0, 1_0, "事务用 inTransaction: ，仅仅是为了批量提交则用 inGroup: ");
//- (void)commit NS_DEPRECATED_IOS(1_0, 1_0, "事务用 inTransaction: ，仅仅是为了批量提交则用 inGroup: ");
//- (void)rollback NS_DEPRECATED_IOS(1_0, 1_0, "事务用 inTransaction: ，仅仅是为了批量提交则用 inGroup: ");

@end



