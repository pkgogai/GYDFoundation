//
//  GYDViewTests.m
//  GYDFoundationTests
//
//  Created by 宫亚东 on 2018/10/26.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIView+GYDSafeArea.h"

@interface GYDViewTests : XCTestCase

@end

@implementation GYDViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    if (@available(iOS 11.0, *)) {
        return;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    UIScrollView *view2 = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 40, 135, 145)];
    
    //没设置过safeArea，没有父视图，safeArea全0
    UIEdgeInsets safeArea = view2.gyd_safeAreaInsets;
    XCTAssert(safeArea.top == 0, @"初始化错误");
    XCTAssert(safeArea.left == 0, @"初始化错误");
    XCTAssert(safeArea.bottom == 0, @"初始化错误");
    XCTAssert(safeArea.right == 0, @"初始化错误");
    
    //没设置过safeArea，父视图也没设置过，safeArea全0
    [view addSubview:view2];
    safeArea = view2.gyd_safeAreaInsets;
    XCTAssert(safeArea.top == 0, @"初始化错误");
    XCTAssert(safeArea.left == 0, @"初始化错误");
    XCTAssert(safeArea.bottom == 0, @"初始化错误");
    XCTAssert(safeArea.right == 0, @"初始化错误");
    
    //父视图设置了，要根据父视图计算
    [view gyd_setSafeAreaInsets:UIEdgeInsetsMake(100, 100, 100, 100)];
    safeArea = view2.gyd_safeAreaInsetsAllowNegative;
    XCTAssert(safeArea.top == 60, @"top2 错误");
    XCTAssert(safeArea.left == 70, @"left2 错误");
    XCTAssert(safeArea.bottom == 85, @"bottom2 错误");
    XCTAssert(safeArea.right == 65, @"right2 错误");
    
    //UIScrollView中的视图，要考虑contentSize和contentInset
    view2.contentSize = CGSizeMake(200, 200);
    view2.contentInset = UIEdgeInsetsMake(10, 20, 20, 20);
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(3, 4, 221, 221)];
    [view2 addSubview:view3];
    safeArea = view3.gyd_safeAreaInsetsAllowNegative;
    XCTAssert(safeArea.top == 46, @"top3 错误");
    XCTAssert(safeArea.left == 47, @"left3 错误");
    XCTAssert(safeArea.bottom == 90, @"bottom3 错误");
    XCTAssert(safeArea.right == 69, @"right3 错误");
    
    
    view2.contentSize = CGSizeMake(80, 80);
    safeArea = view3.gyd_safeAreaInsetsAllowNegative;
    XCTAssert(safeArea.top == 46, @"top4 错误");
    XCTAssert(safeArea.left == 47, @"left4 错误");
    XCTAssert(safeArea.bottom == 10 + 4 + 221 - 145 + 85, @"bottom4 错误");
    XCTAssert(safeArea.right == 20 + 3 + 221 - 135 + 65, @"right4 错误");
    

    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
