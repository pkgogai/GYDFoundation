//
//  NSDate+GYDDateFormat.m
//  GYDFoundation
//
//  Created by gongyadong on 2017/5/8.
//  Copyright © 2017 宫亚东. All rights reserved.
//

#import "NSDate+GYDDateFormat.h"

@implementation NSDate (GYDDateFormat)

+ (NSDateFormatter *)gyd_dateFormatterWithString:(NSString *)string {
    static NSMutableDictionary *dic = nil;
    NSDateFormatter *format = dic[string];
    if (!format) {
        if (!dic) {
            dic = [NSMutableDictionary dictionary];
        }
        //消耗大约相当于调用17个OC方法（第一次消耗约增加10倍），有必要做缓存？
        format = [[NSDateFormatter alloc] init];
        NSLocale *lc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [format setDateFormat:string];
        [format setLocale:lc];
        dic[string] = format;
    }
    return format;
}

- (NSString *)gyd_stringWithDateFormat:(NSString *)dateFormat useCache:(BOOL)useCache {
    NSDateFormatter *dateFormatter = nil;
    if (useCache) {
        dateFormatter = [NSDate gyd_dateFormatterWithString:dateFormat];
    } else {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *lc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setDateFormat:dateFormat];
        [dateFormatter setLocale:lc];
    }
    return [dateFormatter stringFromDate:self];
}

+ (NSString *)gyd_stringWithTimeSinceReferenceDate:(NSTimeInterval)time dateFormat:(NSString *)dateFormat useCache:(BOOL)useCache {
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:time] gyd_stringWithDateFormat:dateFormat useCache:useCache];
}




@end
