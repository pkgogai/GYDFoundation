//
//  GYDJSONSerialization.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/11.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 JSON序列化方法，加简单的类型判断。
 */
@interface GYDJSONSerialization : NSObject

#pragma mark - JSON <-> NSData

+ (nullable NSData *)dataWithJSONObject:(nullable id)obj;
+ (nullable id)JSONObjectWithData:(nullable NSData *)data;

+ (nullable NSDictionary *)JSONDictionaryWithData:(nullable NSData *)data;
+ (nullable NSMutableDictionary *)JSONMutableDictionaryWithData:(nullable NSData *)data;

+ (nullable NSArray *)JSONArrayWithData:(nullable NSData *)data;
+ (nullable NSMutableArray *)JSONMutableArrayWithData:(nullable NSData *)data;


#pragma mark - JSON <-> NSString

+ (nullable NSString *)stringWithJSONObject:(nullable id)obj;
+ (nullable id)JSONObjectWithString:(nullable NSString *)string;

+ (nullable NSDictionary *)JSONDictionaryWithString:(nullable NSString *)string;
+ (nullable NSMutableDictionary *)JSONMutableDictionaryWithString:(nullable NSString *)string;

+ (nullable NSArray *)JSONArrayWithString:(nullable NSString *)string;
+ (nullable NSMutableArray *)JSONMutableArrayWithString:(nullable NSString *)string;

/** 验证是否是JSON对象：
 第一层必须是：NSArray, NSDictionary
 内部支持的对象有：NSString, NSNumber, NSArray, NSDictionary, or NSNull
 NSDictionary的key必须是：NSString，
 NSNumber 必须有效，不能是NaN或infinity
 */
+ (BOOL)isValidJSONObject:(nullable id)obj;

@end
