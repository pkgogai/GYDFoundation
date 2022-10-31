//
//  NSDate+GYDDateFormat.h
//  GYDFoundation
//
//  Created by gongyadong on 2017/5/8.
//  Copyright © 2017 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//yyyy年MM月dd日 HH时mm分ss.SSS秒

@interface NSDate (GYDDateFormat)

/**
 创建NSDateFormatter的耗时大约相当于调用17次空的OC方法（第一次消耗约10倍），没必要用cache。
 但为了兼顾早期代码，保持原方法名不变。cache 非线程安全，
 */
- (NSString *)gyd_stringWithDateFormat:(NSString *)dateFormat useCache:(BOOL)useCache;

/** 同上 */
+ (NSString *)gyd_stringWithTimeSinceReferenceDate:(NSTimeInterval)time dateFormat:(NSString *)dateFormat  useCache:(BOOL)useCache;

@end

NS_ASSUME_NONNULL_END
