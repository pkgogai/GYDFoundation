//
//  GYDLogTests.m
//  GYDFoundationTests
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GYDLog.h"
#import "GYDLogItemModel.h"

@interface GYDLogTests : XCTestCase<GYDLogCacheArrayChangedDelegate>
{
    BOOL _logCacheArrayDidChanged;
}

@end

@implementation GYDLogTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogSetting {
    [GYDLog setLvCount:0];
    GYDLogSetting setting1 = ({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = NO;
        setting.cachedUbound = 30;
        setting.prefix = "error";
        setting;
    });
    
    GYDLogSetting setting2 = ({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = YES;
        setting.cachedUbound = 600;
        setting.prefix = "warning";
        setting;
    });
    
    GYDLogSetting setting3 = ({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = YES;
        setting.cachedUbound = 400;
        setting.prefix = "info";
        setting;
    });
    [GYDLog setLogSetting:setting1 forLv:0];
    
    //判断设置是否生效
    GYDLog.lvCount = 3;
    [GYDLog setLogSetting:setting1 forLv:0];
    [GYDLog setLogSetting:setting2 forLv:1];
    [GYDLog setLogSetting:setting3 forLv:2];
    
    XCTAssert([self isSetting:[GYDLog logSettingForLv:0] equalToSetting:setting1], @"设置修改和读取值不同");
    XCTAssert([self isSetting:[GYDLog logSettingForLv:1] equalToSetting:setting2], @"设置修改和读取值不同");
    XCTAssert([self isSetting:[GYDLog logSettingForLv:2] equalToSetting:setting3], @"设置修改和读取值不同");
    
    //修改log级别是否对旧设置产生影响
    GYDLog.lvCount = 10;
    XCTAssert([self isSetting:[GYDLog logSettingForLv:0] equalToSetting:setting1], @"设置修改和读取值不同");
    XCTAssert([self isSetting:[GYDLog logSettingForLv:1] equalToSetting:setting2], @"设置修改和读取值不同");
    XCTAssert([self isSetting:[GYDLog logSettingForLv:2] equalToSetting:setting3], @"设置修改和读取值不同");
    
    GYDLog.lvCount = 2;
    XCTAssert([self isSetting:[GYDLog logSettingForLv:0] equalToSetting:setting1], @"设置修改和读取值不同");
    XCTAssert([self isSetting:[GYDLog logSettingForLv:1] equalToSetting:setting2], @"设置修改和读取值不同");
    
}

- (BOOL)isSetting:(GYDLogSetting)setting1 equalToSetting:(GYDLogSetting)setting2 {
    if (setting1.print != setting2.print) {
        return NO;
    }
    if (setting1.save != setting2.save) {
        return NO;
    }
    if (setting1.cachedUbound != setting2.cachedUbound) {
        return NO;
    }
    if (strcmp(setting1.prefix, setting2.prefix) != 0) {
        return NO;
    }
    
    return YES;
}

- (void)testLogType {
    
    [GYDLog setLogType:@"abc" on:YES];
    [GYDLog setLogType:@"def" on:NO];
    
    //测试开关状态读取
    XCTAssert([GYDLog isLogTypeOn:@"abc"], @"设置失败");
    XCTAssert(![GYDLog isLogTypeOn:@"def"], @"设置失败");
    XCTAssert([GYDLog isLogTypeOn:@"xxx"], @"默认值错误");
    
    //测试开关是否生效
    GYDLog.lvCount = 1;
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = YES;
        setting.cachedUbound = 400;
        setting.prefix = "info";
        setting;
    }) forLv:0];
    
    NSMutableArray *logArray = [GYDLog logCacheArray];
    [logArray removeAllObjects];
    
    [GYDLog logType:@"abc" lv:0 fun:__func__ msg:@"a"];
    XCTAssert(logArray.count == 1, @"log记录错误");
    
    [GYDLog logType:@"abc" lv:1 fun:__func__ msg:@"a"];
    XCTAssert(logArray.count == 1, @"log记录错误");
    
    [GYDLog logType:@"def" lv:0 fun:__func__ msg:@"a"];
    XCTAssert(logArray.count == 1, @"log记录错误");
    
    [GYDLog logType:@"eee" lv:0 fun:__func__ msg:@"a"];
    XCTAssert(logArray.count == 2, @"log记录错误");
    
    //测试 setCheckLogType 是否有效
    [GYDLog setCheckLogType:NO];
    [GYDLog logType:@"def" lv:0 fun:__func__ msg:@"a"];
    XCTAssert(logArray.count == 3, @"log记录错误");
    
    [GYDLog setCheckLogType:YES];
    [GYDLog logType:@"def" lv:0 fun:__func__ msg:@"a"];
    XCTAssert(logArray.count == 3, @"log记录错误");
    
    //测试使用过的type是否记录，（通过isLogTypeOn: 检查的type不记录）
    NSArray *typeArray = [GYDLog allTypesThatHaveBeenUsed];
    
    XCTAssert([typeArray containsObject:@"abc"], @"log开关统计错误");
    XCTAssert([typeArray containsObject:@"def"], @"log开关统计错误");
    XCTAssert([typeArray containsObject:@"eee"], @"log开关统计错误");
    
}


- (void)testCacheArray {
    GYDLog.logCacheArrayChangedDelegate = self;
    
    GYDLog.lvCount = 3;
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 100;
        setting.prefix = "e";
        setting;
    }) forLv:0];
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 50;
        setting.prefix = "w";
        setting;
    }) forLv:1];
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 30;
        setting.prefix = "i";
        setting;
    }) forLv:2];
    
    NSMutableArray *logArray = [GYDLog logCacheArray];
    [logArray removeAllObjects];
    
    [self makeLogsForLvCount:3 baseLv:0 minCount:100];
    XCTAssert(logArray.count == 100, @"缓存数量不对");
    [self checkCacheUbound];
    
    
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 110;
        setting.prefix = "e";
        setting;
    }) forLv:0];
    
    XCTAssert(logArray.count == 100, @"缓存数量不对");
    [self checkCacheUbound];
    
    [self makeLogsForLvCount:3 baseLv:0 minCount:10];
    
    XCTAssert(logArray.count == 110, @"缓存数量不对");
    [self checkCacheUbound];
    
    
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 90;
        setting.prefix = "e";
        setting;
    }) forLv:0];
    
    XCTAssert(logArray.count == 90, @"缓存数量不对");
    [self checkCacheUbound];
    
    [self makeLogsForLvCount:3 baseLv:0 minCount:10];
    
    XCTAssert(logArray.count == 90, @"缓存数量不对");
    [self checkCacheUbound];
}

/** 造消息，lvCount是lv的范围，其中lv最少要有count个 */
- (void)makeLogsForLvCount:(NSUInteger)lvCount baseLv:(NSUInteger)baseLv minCount:(NSUInteger)count {
    XCTAssert(baseLv < lvCount, @"用例错误");
    NSUInteger n = 0;
    for (int i = 0; i < 1000 || n < count; i ++) {
        int lv = rand() % lvCount;
        _logCacheArrayDidChanged = NO;
        [GYDLog logType:nil lv:lv fun:__func__ msg:[NSString stringWithFormat:@"级别:%d,index:%d", lv, i]];
        XCTAssert(_logCacheArrayDidChanged, @"缓存后没通知delegate");
        if (lv == baseLv) {
            n ++;
        }
    }
}
- (void)checkCacheUbound {
    NSMutableArray *logArray = [GYDLog logCacheArray];
    for (int i = 0; i < logArray.count; i ++) {
        GYDLogItemModel *item = logArray[i];
        GYDLogSetting setting = [GYDLog logSettingForLv:item.lv];
        XCTAssert(i <= setting.cachedUbound, @"%d 位置超过了 %d", i, (int)setting.cachedUbound);
    }
    
}

#pragma mark - GYDLogCacheArrayChangedDelegate
- (void)logCacheArrayDidChangedWithNewLog:(GYDLogItemModel *)log {
    _logCacheArrayDidChanged = YES;
}


- (void)testLogFile {
    [GYDLog closeFile];
    
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [dirPath stringByAppendingPathComponent:@"test.txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    
    //设置文件位置
    NSString *errMessage = nil;
    if ([GYDLog setLogFilePath:path errorMessage:&errMessage]) {
        NSLog(@"设置路径成功：%@", path);
    } else {
        NSLog(@"设置路径失败：%@", errMessage);
        XCTAssert(0, @"设置路径失败：%@", errMessage);
    }
    
    //2个级别的log，一个保存一个不保存，最后检查保存的数量与文件行数是否对应。
    GYDLog.lvCount = 2;
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = YES;
        setting.cachedUbound = 100;
        setting.prefix = "e";
        setting;
    }) forLv:0];
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 50;
        setting.prefix = "w";
        setting;
    }) forLv:1];
    
    NSUInteger n[2] = {};
    
    for (int i = 0; i < 100; i ++) {
        int lv = rand() % 2;
        [GYDLog logType:nil lv:lv fun:__func__ msg:[NSString stringWithFormat:@"级别:%d,index:%d", lv, i]];
        n[lv] ++;
    }
    
    [GYDLog closeFile];
    
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *stringArray = [string componentsSeparatedByString:@"\n"];
    XCTAssert(stringArray.count == n[0] + 1, @"数量对应不上");    //最后还有个空行
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
