//
//  GYDStringSearchTests.m
//  GYDFoundationTests
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GYDStringSearch.h"

@interface GYDStringSearchTests : XCTestCase

@end

@implementation GYDStringSearchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - 长度和下标测试
- (void)testIndexProperty {
    //先用长度为0的字符串测试
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:@""];
    XCTAssert(search.stringLength == 0, @"长度错误");
    
    XCTAssert(search.index == 0, @"初始值错误");
    search.index = 1;
    XCTAssert(search.index == 0, @"index上限错误");
    search.index = -1;
    XCTAssert(search.index == 0, @"index上限错误");
    
    //换长度为3的字符串测试
    search = [[GYDStringSearch alloc] initWithString:@"123"];
    XCTAssert(search.stringLength == 3, @"长度错误");
    XCTAssert(search.index == 0, @"初始值错误");
    search.index = 1;
    XCTAssert(search.index == 1, @"index上限错误");
    search.index = 2;
    XCTAssert(search.index == 2, @"index上限错误");
    search.index = 3;
    XCTAssert(search.index == 3, @"index上限错误");
    search.index = 4;
    XCTAssert(search.index == 3, @"index上限错误");
    search.index = -1;
    XCTAssert(search.index == 3, @"index上限错误");
    
}

#pragma mark - 当前内容测试
- (void)testCurrentContent {
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:@""];
    XCTAssert([search currentCharacter] == '\0', @"结尾\\0错误");
    XCTAssert([search hasCurrentCharacter:'\0'], @"结尾\\0错误");
    XCTAssert([search hasCurrentString:@""], @"应该永远为真");
    
    XCTAssert(![search hasCurrentCharacter:'1'], @"结尾\\0错误");
    XCTAssert(![search hasCurrentString:@"1"], @"应该永远为真");
    
    search = [[GYDStringSearch alloc] initWithString:@"123"];
    search.index = 1;
    XCTAssert([search currentCharacter] == '2', @"取值错误");
    XCTAssert([search hasCurrentCharacter:'2'], @"取值错误");
    XCTAssert([search hasCurrentString:@"2"], @"取值错误");
    XCTAssert([search hasCurrentString:@"23"], @"取值错误");
    
    XCTAssert(![search hasCurrentString:@"123"], @"取值错误");
    XCTAssert(![search hasCurrentString:@"234"], @"取值错误");
    
}

#pragma mark - 跳过字符测试
- (void)testSkipCharacter {
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:@"  1 1 \t\n3  "];
    [search skipWhitespaceCharacters];
    XCTAssert(search.index == 2, @"跳过开头空格错误");
    search.index = 3;
    [search skipWhitespaceCharacters];
    XCTAssert(search.index == 4, @"跳过中间空格错误");
    search.index = 5;
    [search skipWhitespaceCharacters];
    XCTAssert(search.index == 8, @"跳过制表符换行符错误");
    search.index = 9;
    [search skipWhitespaceCharacters];
    XCTAssert(search.index == 11, @"跳过结尾空格错误");
    
    
    search = [[GYDStringSearch alloc] initWithString:@" 1 \t12 2 "];
    int count = [search skipCharacter:'1' ignoreWhitespaceCharacters:NO];
    XCTAssert(count == 0, @"计数错误");
    XCTAssert(search.index == 0, @"不应跳过空格");
    
    count = [search skipCharacter:'1' ignoreWhitespaceCharacters:YES];
    XCTAssert(count == 2, @"计数错误");
    XCTAssert(search.index == 5, @"定位错误");
    
    count = [search skipCharacter:'2' ignoreWhitespaceCharacters:YES];
    XCTAssert(count == 2, @"计数错误");
    XCTAssert(search.index == 9, @"定位错误");
    
    //skipCharacterInString 使用了 skipCharacterInCharacterSet，所以只测外层的即可
    search = [[GYDStringSearch alloc] initWithString:@" 1 \t12 2 3 4"];
    count = [search skipCharacterInString:@"23" ignoreWhitespaceCharacters:NO];
    XCTAssert(count == 0, @"计数错误");
    XCTAssert(search.index == 0, @"不应跳过空格");
    
    count = [search skipCharacterInString:@"12" ignoreWhitespaceCharacters:YES];
    XCTAssert(count == 4, @"计数错误");
    XCTAssert(search.index == 9, @"定位错误");
    
    count = [search skipCharacterInString:@"3" ignoreWhitespaceCharacters:YES];
    XCTAssert(count == 1, @"计数错误");
    XCTAssert(search.index == 11, @"定位错误");
    
    search = [[GYDStringSearch alloc] initWithString:@" 12 \t1212 1 2 3 4"];
    count = [search skipCharacterInString:@"12" ignoreWhitespaceCharacters:NO];
    XCTAssert(count == 0, @"计数错误");
    XCTAssert(search.index == 0, @"不应跳过空格");
    
    count = [search skipString:@"12" ignoreWhitespaceCharacters:YES];
    XCTAssert(count == 3, @"计数错误");
    XCTAssert(search.index == 10, @"定位错误");
    
}

#pragma mark - 截取内容测试
- (void)testSubString {
    XCTAssert('\0' == 0, @"知识错误");
    
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:@"123"];
    XCTAssert([search subCharacter] == '1', @"截取出错");
    XCTAssert([search subCharacter] == '2', @"截取出错");
    XCTAssert([search subCharacter] == '3', @"截取出错");
    XCTAssert([search subCharacter] == '\0', @"截取出错");
    XCTAssert([search subCharacter] == '\0', @"截取出错");
    
    search.index = 0;
    unichar c = 0;
    BOOL r = [search getSubCharacter:&c];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert(c == '1', @"截取出错");
    
    r = [search getSubCharacter:&c];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert(c == '2', @"截取出错");
    
    r = [search getSubCharacter:&c];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert(c == '3', @"截取出错");
    
    r = [search getSubCharacter:&c];
    XCTAssert(r == NO, @"截取出错");
    
    search = [GYDStringSearch searchWithString:@"12345678"];
    NSString *tmp = [search subStringToString:@"12"];
    XCTAssert([tmp isEqualToString:@""], @"截取出错");
    XCTAssert(search.index == 2, @"截取后下标出错");
    
    tmp = [search subStringToString:@"12"];
    XCTAssert(!tmp, @"截取出错");
    XCTAssert(search.index == 2, @"截取不到下标不应改变");
    
    tmp = [search subStringToString:@"4"];
    XCTAssert(tmp && [tmp isEqualToString:@"3"], @"截取出错");
    XCTAssert(search.index == 4, @"截取后下标出错");
    
    tmp = [search subStringToString:@""];
    XCTAssert(!tmp, @"截取出错");
    XCTAssert(search.index == 4, @"截取后下标出错");
    
    tmp = [search subStringToString:@"78"];
    XCTAssert(tmp && [tmp isEqualToString:@"56"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    
    search.index = 0;
    tmp = [search subStringWithLength:-1];
    XCTAssert([tmp isEqualToString:@""], @"截取出错");
    XCTAssert(search.index == 0, @"截取不到下标不应改变");
    
    tmp = [search subStringWithLength:1];
    XCTAssert([tmp isEqualToString:@"1"], @"截取出错");
    XCTAssert(search.index == 1, @"截取后下标出错");
    
    tmp = [search subStringWithLength:2];
    XCTAssert([tmp isEqualToString:@"23"], @"截取出错");
    XCTAssert(search.index == 3, @"截取后下标出错");
    
    tmp = [search subStringWithLength:5];
    XCTAssert([tmp isEqualToString:@"45678"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    tmp = [search subStringWithLength:-1];
    XCTAssert([tmp isEqualToString:@"8"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    tmp = [search subStringWithLength:-2];
    XCTAssert([tmp isEqualToString:@"78"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    tmp = [search subStringWithLength:-8];
    XCTAssert([tmp isEqualToString:@"12345678"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    tmp = [search subStringWithLength:-9];
    XCTAssert([tmp isEqualToString:@"12345678"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    
    search.index = 6;
    tmp = [search subStringWithLength:3];
    XCTAssert([tmp isEqualToString:@"78"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    search.index = 6;
    tmp = [search subStringWithLength:0];
    XCTAssert([tmp isEqualToString:@"78"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    search.index = 0;
    tmp = [search subStringInCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"234"]];
    XCTAssert(!tmp, @"截取出错");
    XCTAssert(search.index == 0, @"截取不到下标不应改变");
    
    tmp = [search subStringInCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"43012"]];
    XCTAssert([tmp isEqualToString:@"1234"], @"截取出错");
    XCTAssert(search.index == 4, @"截取后下标出错");
    
    tmp = [search subStringInCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"56789"]];
    XCTAssert([tmp isEqualToString:@"5678"], @"截取出错");
    XCTAssert(search.index == 8, @"截取后下标出错");
    
    search = [GYDStringSearch searchWithString:@"12345678"];
    tmp = [search subStringToCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@""] indexMoveToRight:NO];
    XCTAssert(!tmp, @"截取出错");
    XCTAssert(search.index == 0, @"下标出错");
    
    tmp = [search subStringToCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"31"] indexMoveToRight:NO];
    XCTAssert([tmp isEqualToString:@""], @"截取出错");
    XCTAssert(search.index == 0, @"下标出错");
    
    tmp = [search subStringToCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"31"] indexMoveToRight:YES];
    XCTAssert([tmp isEqualToString:@""], @"截取出错");
    XCTAssert(search.index == 1, @"下标出错");
    
    tmp = [search subStringToCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"876"] indexMoveToRight:NO];
    XCTAssert([tmp isEqualToString:@"2345"], @"截取出错");
    XCTAssert(search.index == 5, @"下标出错");
    
    search.index = 1;
    tmp = [search subStringToCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"876"] indexMoveToRight:YES];
    XCTAssert([tmp isEqualToString:@"2345"], @"截取出错");
    XCTAssert(search.index == 6, @"下标出错");
    
    //简单测试一下get
    search = [GYDStringSearch searchWithString:@"12345678"];
    r = [search getSubString:&tmp toString:@"34"];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert([tmp isEqualToString:@"12"], @"截取出错");
    XCTAssert(search.index == 4, @"下标出错");
    
    r = [search getSubString:&tmp toString:@"34"];
    XCTAssert(r == NO, @"截取出错");
    XCTAssert(search.index == 4, @"下标出错");
    
    
    r = [search getSubString:&tmp withLength:2];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert([tmp isEqualToString:@"56"], @"截取出错");
    XCTAssert(search.index == 6, @"下标出错");
    
    
    search.index = 0;
    r = [search getSubString:&tmp inCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"3421"]];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert([tmp isEqualToString:@"1234"], @"截取出错");
    XCTAssert(search.index == 4, @"下标出错");
    
    
    r = [search getSubString:&tmp inCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"78"]];
    XCTAssert(r == NO, @"截取出错");
    XCTAssert(search.index == 4, @"下标出错");
    
    
    r = [search getSubString:&tmp toCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"78"] indexMoveToRight:NO];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert([tmp isEqualToString:@"56"], @"截取出错");
    XCTAssert(search.index == 6, @"下标出错");
    
    search.index = 4;
    r = [search getSubString:&tmp toCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"78"] indexMoveToRight:YES];
    XCTAssert(r == YES, @"截取出错");
    XCTAssert([tmp isEqualToString:@"56"], @"截取出错");
    XCTAssert(search.index == 7, @"下标出错");
    
    r = [search getSubString:&tmp toCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"67"] indexMoveToRight:YES];
    XCTAssert(r == NO, @"截取出错");
    XCTAssert(search.index == 7, @"下标出错");
    
    
}

#pragma mark - 截取特殊字符串
- (void)testSubOther {
    GYDStringSearch *search = [GYDStringSearch searchWithString:@"\\\\ \\tabc\\x5F\\77 \\a \\b \\f \\n\\r \\t \\v \"76"];
    NSString *tmp = [search subEscapeStringToCharacter:'\"'];
    XCTAssert([tmp isEqualToString:@"\\ \tabc\x5F\77 \a \b \f \n\r \t \v "], @"提取错误");
    
    search = [GYDStringSearch searchWithString:@"/*igigig\nign*/hk\nh"];
    tmp = [search subDescString];
    XCTAssert([tmp isEqualToString:@"igigig\nign"], @"提取错误");
    XCTAssert([search currentCharacter] == 'h', @"位置错误");
    
    search = [GYDStringSearch searchWithString:@"//igigig\nign*/hk\nh"];
    tmp = [search subDescString];
    XCTAssert([tmp isEqualToString:@"igigig"], @"提取错误");
    XCTAssert([search currentCharacter] == 'i', @"位置错误");
    
    search = [GYDStringSearch searchWithString:@"//igigigign*/hkh"];
    tmp = [search subDescString];
    XCTAssert([tmp isEqualToString:@"igigigign*/hkh"], @"提取错误");
    XCTAssert([search currentCharacter] == '\0', @"位置错误");
    
    
}

#pragma mark - 截取数字和时间测试
- (void)testSubNumber {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
