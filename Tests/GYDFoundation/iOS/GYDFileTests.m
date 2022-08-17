//
//  GYDFileTests.m
//  GYDFoundationTests
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GYDFile.h"

@interface GYDFileTests : XCTestCase

@end

@implementation GYDFileTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateFile {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path1 = [dirPath stringByAppendingPathComponent:@"path1.txt"];
    NSString *path2 = [path1 stringByAppendingPathComponent:@"path2"];
    NSString *path3 = [path2 stringByAppendingPathComponent:@"path3.txt"];
    
    BOOL r;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        r = [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
        XCTAssert(r, @"准备工作失败");
    }
    //----------------------------------有文件占用了子路径时，文件和目录都应创建失败（如已存在文件@"/aa/bb，注意bb是文件，再创建文件/aa/bb/cc/dd就应该失败"）
    NSString *errMsg = nil;
    r = [GYDFile makeSureFileAtPath:path1 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path1, errMsg);
    
    errMsg = nil;
    r = [GYDFile makeSureFileAtPath:path2 errorMessage:&errMsg];
    XCTAssert( (!r) && errMsg, @"应该创建失败：%@",path2);
    NSLog(@"路径被占用的错误文案：%@", errMsg);
    
    errMsg = nil;
    r = [GYDFile makeSureFileAtPath:path3 errorMessage:&errMsg];
    XCTAssert( (!r) && errMsg, @"应该创建失败：%@",path3);
    NSLog(@"路径被占用的错误文案：%@", errMsg);
    
    errMsg = nil;
    r = [GYDFile makeSureDirectoryAtPath:path2 errorMessage:&errMsg];
    XCTAssert( (!r) && errMsg, @"应该创建失败：%@",path2);
    NSLog(@"路径被占用的错误文案：%@", errMsg);
    
    errMsg = nil;
    r = [GYDFile makeSureDirectoryAtPath:path3 errorMessage:&errMsg];
    XCTAssert( (!r) && errMsg, @"应该创建失败：%@",path3);
    NSLog(@"路径被占用的错误文案：%@", errMsg);
    
    //----------------------------------在本路径已存在文件的情况下创建目录，在已存在目录的情况下创建文件，都应该失败
    errMsg = nil;
    r = [GYDFile makeSureDirectoryAtPath:path1 errorMessage:&errMsg];
    XCTAssert( (!r) && errMsg, @"应该创建失败：%@",path1);
    NSLog(@"路径被文件占用的错误文案：%@", errMsg);
    
    r = [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
    XCTAssert(r, @"准备工作失败");
    
    errMsg = nil;
    r = [GYDFile makeSureDirectoryAtPath:path1 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path1, errMsg);
    
    errMsg = nil;
    r = [GYDFile makeSureFileAtPath:path1 errorMessage:&errMsg];
    XCTAssert( (!r) && errMsg, @"应该创建失败：%@",path1);
    NSLog(@"路径被目录占用的错误文案：%@", errMsg);
    
    //----------------------------------缺目录时创建目录和文件，应该成功
    r = [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
    XCTAssert(r, @"准备工作失败");
    
    errMsg = nil;
    r = [GYDFile makeSureDirectoryAtPath:path3 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path3, errMsg);
    
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path3 isDirectory:&isDir]) {
        XCTAssert(isDir, @"应该创建的是目录");
    } else {
        XCTAssert(0, @"创建文件失败");
    }
    
    r = [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
    XCTAssert(r, @"准备工作失败");
    
    errMsg = nil;
    r = [GYDFile makeSureFileAtPath:path3 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path3, errMsg);
    
    isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path3 isDirectory:&isDir]) {
        XCTAssert(!isDir, @"应该创建的是文件");
    } else {
        XCTAssert(0, @"创建文件失败");
    }
    
    //------------------------------------不缺目录时创建，应该成功。顺便检查本身就已经存在目录或文件，应该成功
    r = [[NSFileManager defaultManager] removeItemAtPath:path3 error:nil];
    XCTAssert(r, @"准备工作失败");
    
    errMsg = nil;
    r = [GYDFile makeSureDirectoryAtPath:path3 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path3, errMsg);
    
    isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path3 isDirectory:&isDir]) {
        XCTAssert(isDir, @"应该创建的是目录");
    } else {
        XCTAssert(0, @"创建文件失败");
    }
    //--已经存在目录，再次创建相同的目录
    errMsg = nil;
    r = [GYDFile makeSureDirectoryAtPath:path3 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path3, errMsg);
    
    isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path3 isDirectory:&isDir]) {
        XCTAssert(isDir, @"应该创建的是目录");
    } else {
        XCTAssert(0, @"创建文件失败");
    }
    //--
    
    r = [[NSFileManager defaultManager] removeItemAtPath:path3 error:nil];
    XCTAssert(r, @"准备工作失败");
    
    errMsg = nil;
    r = [GYDFile makeSureFileAtPath:path3 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path3, errMsg);
    
    isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path3 isDirectory:&isDir]) {
        XCTAssert(!isDir, @"应该创建的是文件");
    } else {
        XCTAssert(0, @"创建文件失败");
    }
    
    //--已经存在文件，再次创建相同的文件
    errMsg = nil;
    r = [GYDFile makeSureFileAtPath:path3 errorMessage:&errMsg];
    XCTAssert(r, @"应该创建成功：%@，%@", path3, errMsg);
    
    isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path3 isDirectory:&isDir]) {
        XCTAssert(!isDir, @"应该创建的是文件");
    } else {
        XCTAssert(0, @"创建文件失败");
    }
    //--
    
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
