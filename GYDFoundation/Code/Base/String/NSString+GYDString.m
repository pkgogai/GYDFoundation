//
//  NSString+GYDString.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "NSString+GYDString.h"

@implementation NSString (GYDString)

#pragma mark - 字符串处理

- (nonnull NSString *)gyd_substringWithIndex:(NSInteger)index length:(NSInteger)length {
    NSInteger stringLength = self.length;
    NSInteger left;
    NSInteger right;
    
    if (index < 0) {
        left = stringLength + index;
    } else {
        left = index;
    }
    
    if (length > 0) {
        right = left + length;
    } else if (length < 0) {
        right = left;
        left = right + length;
    } else {
        right = stringLength - left;
    }
    
    if (right <= 0 || left >= stringLength) {
        return @"";
    }
    
    if (left < 0) {
        left = 0;
    }
    if (right > stringLength) {
        right = stringLength;
    }
    
    NSString *resultString = [self substringWithRange:NSMakeRange(left, right - left)];
    return resultString;
}

#pragma mark - 字符串比较

/** 两个字符串是否相同,nil == nil, nil != @"" */
+ (BOOL)gyd_isString:(nullable NSString *)str1 equalToString:(nullable NSString *)str2 {
    return str1 ? ([str2 isEqualToString:str1]) : (str1 == str2);
}

/** 两个字符串是否相同,nil == @"" */
+ (BOOL)gyd_isStringValue:(nullable NSString *)str1 equalToStringValue:(nullable NSString *)str2 {
    return (str2.length > 0) ? [str1 isEqualToString:str2] : (str1.length == 0);
}

#pragma mark - 补充容易被误用的缺失方法
- (long)longValue {
    return (long)[self longLongValue];
}

@end
