//
//  GYDDatabaseDemo.m
//  FMDB
//
//  Created by 宫亚东 on 2020/5/20.
//

#import "GYDDatabaseDemo.h"
#import "GYDDatabase+SQL.h"
#import "GYDDatabase+Version.h"

#if TARGET_OS_IPHONE
#import "GYDDemoMenu.h"
#endif

@implementation GYDDatabaseDemo

#if TARGET_OS_IPHONE
+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"GYDDatabase" desc:@"使用FMDB，简单的SQL语句处理，事务嵌套使用" order:75 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
    
    //更多例子见 GYDDatabaseSQLTests
}
#endif

- (void)fun3 {
    GYDDatabase *database = [[GYDDatabase alloc] initWithPath:@"一个文件路径"];
    //对于不需要回滚的sql语句
    [database inGroup:^(FMDatabase * _Nonnull db) {
        //一些SQL语句
        [database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
            //一些SQL语句
            [database inGroup:^(FMDatabase * _Nonnull db) {
                //一些SQL语句，
            }];
            [database inTransaction:^BOOL(FMDatabase * _Nonnull db) {
                //一些SQL语句，
                return NO;//这部分我要回滚
            }];
            return YES;//这里我要提交
        }];
    }];
}


@end
