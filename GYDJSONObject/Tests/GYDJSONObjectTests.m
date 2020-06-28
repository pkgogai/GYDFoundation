//
//  GYDJSONObjectTests.m
//  GYDFoundationTests
//
//  Created by 宫亚东 on 2018/9/4.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+GYDJSONObject.h"
#import "GYDJSONSerialization.h"
#import "GYDDictionary.h"

#pragma mark - 说明书截图

//@interface GYDModel : NSObject
//
//@property (nonatomic)   int i;
//@property (nonatomic)   NSString *str;
//@property (nonatomic)   NSNumber *num;
//@property (nonatomic)   GYDModel *model;
//
//@end

//GYDJSONProperty(<#type#>, <#name#>)
//GYDJSONPropertyNamed(<#type#>, <#name#>, <#JSONName#>)
//GYDJSONPropertyArray(<#type#>, <#star#>, <#name#>)
//GYDJSONPropertyArrayNamed(<#type#>, <#star#>, <#name#>, <#JSONName#>)

@interface GYDModel : NSObject

GYDJSONProperty(int, i);
GYDJSONPropertyNamed(NSMutableString *, str, name);
GYDJSONProperty(NSNumber *, num);
GYDJSONProperty(GYDModel *, model);
GYDJSONPropertyArray(NSString, *, stringArray);
GYDJSONPropertyArrayNamed(GYDModel, *, modelArray, list);

@property (nonatomic) int k;

@end

@implementation GYDModel

@end

@interface GYDTestModel : NSObject

//定义与json无关的属性，直接使用@property定义，例如
@property (nonatomic, assign) int k;

//定义与json互相转换的普通属性，使用宏定义：GYDJSONProperty(<#type#>, <#name#>)，例如
GYDJSONProperty(int, i);
GYDJSONProperty(NSMutableString *, name);
GYDJSONProperty(NSNumber *, count);
GYDJSONProperty(GYDModel *, model);

//转换时属性名与json字段名不同，使用宏定义：
//GYDJSONPropertyNamed(<#type#>, <#name#>, <#JSONName#>)
//例如
GYDJSONPropertyNamed(NSString *, name, person);

//定义数组属性以及其内部元素类型，使用宏定义：
//GYDJSONPropertyArray(<#type#>, <#star#>, <#name#>)
//注意 星号占用单独的位置，例如
GYDJSONPropertyArray(NSString, *, nameArray);

//数组的属性名与json字段名不同，使用宏定义：
//GYDJSONPropertyArrayNamed(<#type#>, <#star#>, <#name#>, <#JSONName#>)
//注意 星号占用单独的位置，例如
GYDJSONPropertyArrayNamed(NSString, *, nameArray, persionList);


GYDJSONProperty(int, a);
GYDJSONProperty(NSString *, b);
GYDJSONPropertyNamed(NSNumber *, c, d);

GYDJSONPropertyArray(NSString, *, eee);
GYDJSONProperty(NSArray *, f);

//用于与json互转，可隐藏在.m文件的匿名类别中
GYDJSONProperty(NSString *, status);
//用于app内访问，对外开放
@property (nonatomic, weak) BOOL isOpen;

@end

@implementation GYDTestModel
- (void)demo {
    @{
        @"i" : @(5),
        @"name" : @"gongyadong",
        @"num"  : @(6),
        @"model" : @{/*略*/},
        @"stringArray": @[@"str1", @"str2"],
        @"list" : @[/*略*/]
    };
    
    //所有属性都以点方法使用
    GYDModel *model = [[GYDModel alloc] init];
    model.i = 5;
    model.str = @"gyd";
    model.num = @(6);
    model.model = [[GYDModel alloc] init];
    model.stringArray = @[@"str1", @"str2"];
    model.modelArray = @[/*略*/];
    
    //model转json
    NSDictionary *dic = [model gyd_JSONDictionary];
    NSString *str = [model gyd_JSONString];
    NSData *data = [model gyd_JSONData];
    //json转model
    GYDModel *model = [GYDModel gyd_modelWithJSONString:str];
    
}
//json转model一定会调用这个方法
+ (instancetype)gyd_modelWithJSONDictionary:(NSDictionary *)dic {
    GYDTestModel *model = [super gyd_modelWithJSONDictionary:dic];
    model.isOpen = [[GYDDictionary stringForKey:@"status" inDictionary:dic] isEqualToString:@"open"];
    return model;
}
//model转json一定会调用这个方法
- (NSMutableDictionary *)gyd_JSONDictionary {
    NSMutableDictionary *dic = [self gyd_JSONDictionary];
    dic[@"status"] = self.isOpen ? @"open" : @"close";
    return dic;
}

////json转model一定会调用这个方法
//+ (instancetype)gyd_modelWithJSONDictionary:(NSDictionary *)dic {
//    GYDTestModel *model = [super gyd_modelWithJSONDictionary:dic];
//    model.isOpen = [[GYDDictionary stringForKey:@"status" inDictionary:dic] isEqualToString:@"open"];
//    model.isOpen = [model.status isEqualToString:@"open"];
//    return model;
//}
////model转json一定会调用这个方法
//- (NSMutableDictionary *)gyd_JSONDictionary {
//    self.status = self.isOpen ? @"open" : @"close";
//    NSMutableDictionary *dic = [self gyd_JSONDictionary];
//    return dic;
//}

@end

@interface GYDTestJsonObject2 : GYDTestJsonObject1

GYDJSONProperty(int, f);
GYDJSONProperty(NSString *, g);
GYDJSONPropertyNamed(NSNumber *, h, i);

GYDJSONPropertyArray(NSString, *, j);

@end

@implementation GYDTestJsonObject2

@end


@interface GYDJSONObjectTests : XCTestCase

@end



//只是临时做个试验，还没写正式的测试用例

@implementation GYDJSONObjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testPropertyInfo {
//    NSArray<GYDJSONPropertyInfo *> *infoArray = [GYDTestJsonObject1 gyd_propertyInfoArray];
//    NSArray<GYDJSONPropertyInfo *> *infoArray2 = [GYDTestJsonObject2 gyd_propertyInfoArray];
//
//    NSLog(@"%@", infoArray);
//    NSLog(@"%@", infoArray2);
    
}
- (void)testExample {
    
    GYDTestJsonObject1 *obj1 = [[GYDTestJsonObject1 alloc] init];
    obj1.a = 1;
    obj1.b = @"b\nbb";
//    obj1.c = @"ccc";
    obj1.f = @[@"eee", @"eee"];
    NSDictionary *dic = [obj1 gyd_JSONDictionary];
    
    NSLog(@"%@", [obj1 gyd_JSONString]);
    obj1 = [GYDTestJsonObject1 gyd_modelWithJSONDictionary:dic];
    
    
    BOOL r = [GYDJSONSerialization isValidJSONObject:@(1)];
    r = [GYDJSONSerialization isValidJSONObject:@"1"];
    
    r = [GYDJSONSerialization isValidJSONObject:[NSNull null]];

    r = [GYDJSONSerialization isValidJSONObject:@[@"a", @"b"] ];
    r = [GYDJSONSerialization isValidJSONObject:@{
                                                  @"12" : [@[@"a", @"b"] mutableCopy],
                                                  }];
//    NSString *json3 = [GYDJSONSerialization stringWithJSONObject:@(1)];
    NSDictionary *a = @{
                        @(12) : [@[@"a", @"b"] mutableCopy],
                        };
    NSString *json = [GYDJSONSerialization stringWithJSONObject:a];
    a = [a mutableCopy];
    
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
