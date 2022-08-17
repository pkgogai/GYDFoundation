//
//  GYDFoundationPrivateHeader.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDFoundation.h"

//是否是开发模式
#ifndef GYD_FOUNDATION_DEVELOPMENT
#   define GYD_FOUNDATION_DEVELOPMENT 0
#endif

#define GYDFoundationError(format, ...)     [GYDFoundation function:__func__ line:__LINE__ makeError:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]

#define GYDFoundationWarning(format, ...)   [GYDFoundation function:__func__ line:__LINE__ makeWarning:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]

#if GYD_FOUNDATION_DEVELOPMENT == 1
#   define GYDFoundationInfo(format, ...)   [GYDFoundation function:__func__ line:__LINE__ makeInfo:[NSString stringWithFormat:@"" format, ##__VA_ARGS__]]
#else
#   define GYDFoundationInfo(format, ...)
#endif


@interface GYDFoundation ()

/** 函数发生了错误，应该立刻解决 */
+ (void)function:(nonnull const char *)fun line:(NSInteger)line makeError:(nonnull NSString *)errorString;

/** 函数发出了警告，需要注意 */
+ (void)function:(nonnull const char *)fun line:(NSInteger)line makeWarning:(nonnull NSString *)warningString;

/** 打印信息 */
+ (void)function:(nonnull const char *)fun line:(NSInteger)line makeInfo:(nonnull NSString *)infoString;

@end
