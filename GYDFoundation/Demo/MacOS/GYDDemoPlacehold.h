//
//  GYDLogExample.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GYDLog.h"

#define ExampleIsDevelopment 1

#define GYDLogErrorType(type, format, ...) [GYDLog logType:type lv:0 fun:__func__ msg:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]

#define GYDLogWarningType(type, format, ...) [GYDLog logType:type lv:1 fun:__func__ msg:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]

#define GYDLogInfoType(type, format, ...) [GYDLog logType:type lv:2 fun:__func__ msg:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]

#define GYDLogVerboseType(type, format, ...) [GYDLog logType:type lv:3 fun:__func__ msg:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]

#if ExampleIsDevelopment == 1
#   define GYDLogDebugType(type, format, ...) [GYDLog logType:type lv:4 fun:__func__ msg:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]
#else
#   define GYDLogDebugType(type, format, ...)
#endif


#define GYDLogError(format, ...)    GYDLogErrorType(nil, format, ##__VA_ARGS__)
#define GYDLogWarning(format, ...)  GYDLogWarningType(nil, format, ##__VA_ARGS__)

#pragma mark - 分类
#define GYDLogSwitch(isOn)          [GYDLog setLogType:@"debug" on:isOn];
#define GYDLogInfo(format, ...)     GYDLogInfoType(@"debug", format, ##__VA_ARGS__)
#define GYDLogVerbose(format, ...)  GYDLogVerboseType(@"debug", format, ##__VA_ARGS__)
#define GYDLogDebug(format, ...)    GYDLogDebugType(@"debug", format, ##__VA_ARGS__)

#define GYDLogHttpSwitch(isOn)          [GYDLog setLogType:@"http" on:isOn];
#define GYDLogHttpInfo(format, ...)     GYDLogInfoType(@"http", format, ##__VA_ARGS__)
#define GYDLogHttpVerbose(format, ...)  GYDLogVerboseType(@"http", format, ##__VA_ARGS__)
#define GYDLogHttpDebug(format, ...)    GYDLogDebugType(@"http", format, ##__VA_ARGS__)

#define GYDLogKVOSwitch(isOn)          [GYDLog setLogType:@"KVO" on:isOn];
#define GYDLogKVOInfo(format, ...)     GYDLogInfoType(@"KVO", format, ##__VA_ARGS__)
#define GYDLogKVOVerbose(format, ...)  GYDLogVerboseType(@"KVO", format, ##__VA_ARGS__)
#define GYDLogKVODebug(format, ...)    GYDLogDebugType(@"KVO", format, ##__VA_ARGS__)

@interface GYDLogExample : NSObject

+ (void)ready;

@end
