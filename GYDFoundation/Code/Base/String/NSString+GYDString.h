//
//  NSString+GYDString.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GYDString)

#pragma mark - 字符串处理

/**
 截取指定位置的字符串，
 index<0表示从后向前数，
 length==0表示截取到尾部，length<0表示向前截取。
 例如(-2，2)表示截取最后2个字符。(-2,-2)表示截取倒数第4、第3两个字符
 范围外的字符忽略，例如@"abc"，截取(-1,5)=@"c"，截取(-10,8)=@"a"
 */
- (nonnull NSString *)gyd_substringWithIndex:(NSInteger)index length:(NSInteger)length;

#pragma mark - 字符串比较

/** 两个字符串是否相同,nil == nil, nil != @"" */
+ (BOOL)gyd_isString:(nullable NSString *)str1 equalToString:(nullable NSString *)str2;

/** 两个字符串是否相同,nil == @"" */
+ (BOOL)gyd_isStringValue:(nullable NSString *)str1 equalToStringValue:(nullable NSString *)str2;

#pragma mark - 补充容易被误用的缺失方法
- (long)longValue;

@end
