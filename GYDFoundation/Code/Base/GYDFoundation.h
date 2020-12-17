//
//  GYDFoundation.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

//数组字典
#import "GYDDictionary.h"
#import "NSDictionary+GYDDictionary.h"
#import "NSArray+GYDArray.h"

//字符串
#import "GYDStringSearch.h"
#import "NSString+GYDString.h"
#import "NSString+GYDEscape.h"
#import "GYDMd5.h"

//其它
#import "NSObject+GYDObject.h"
#import "GYDFile.h"
#import "GYDMultiObstacleActionQueueManager.h"
#import "NSObject+GYDCustomFunction.h"
#import "GYDJSONSerialization.h"
#import "GYDLog.h"


//数据库
#if GYD_FOUNDATION_USED_DATABASE == 1
#import "GYDDatabase.h"
#import "GYDDatabase+SQL.h"
#import "GYDDatabase+Version.h"
#endif

//http链接
#if GYD_FOUNDATION_USED_HTTPCONNECT == 1
#import "GYDSimpleHttpConnect.h"
#endif

//json-model互转
#if GYD_FOUNDATION_USED_JSON_OBJECT == 1
#import "NSObject+GYDJSONObject.h"
#endif

@protocol GYDFoundationLogDelegate <NSObject>

@optional
/**
 函数发生了错误，应该立刻解决。
 如果不实现则是：NSAssert(0, @"** GYDFoundation Error **\n%s %zd %@", fun, line, errorString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeError:(nonnull NSString *)errorString;

/**
 函数发出了警告，需要注意
 如果不实现则是：NSLog(@"** GYDFoundation Warning **\n%s %zd %@", fun, line, warningString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeWarning:(nonnull NSString *)warningString;

/**
 打印信息，默认关闭，如需开启，subspec 加上 Development
 如果不实现则是：NSLog(@"** GYDFoundation Info **\n%s %zd %@", fun, line, infoString);
 */
- (void)function:(nonnull const char *)fun line:(NSInteger)line makeInfo:(nonnull NSString *)infoString;

@end

@interface GYDFoundation : NSObject

/** 用来处理错误 */
@property (nonatomic, class, nullable) id<GYDFoundationLogDelegate>delegate;


@end
