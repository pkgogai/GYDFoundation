//
//  GYDUrl.h
//  GYDFoundation
//
//  Created by 宫亚东 on 16/3/3.
//  Copyright © 2016年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYDUrl : NSObject

#pragma mark - 初始化方法

- (instancetype)init;
- (instancetype)initWithCompleteURL:(NSString *)url;

#pragma mark - URL的属性操作
/** 协议头，如http,ftp,https，没有的就当成http */
@property (nonatomic, readwrite)    NSString *scheme;

/** host，如www.lagou.com,www.baidu.com。遇到aaaa?k=v这种，aaaa算在host上 */
@property (nonatomic, readwrite)    NSString *host;

/** 路径，不包含host和参数，如：http://www.lagou.com/aaa/bbb/?key=value 的path是 aaa/bbb/ */
@property (nonatomic, readwrite)    NSString *path;

/** #号后面的部分，如：https://www.lagou.com/aaa#abc 中的abc */
@property (nonatomic, readwrite)    NSString *fragment;

/** 全部的参数 */
@property (nonatomic, copy)         NSDictionary<NSString *, NSString *> *allArgs;

#pragma mark - URL的参数操作

/** 所有get参数的key */
@property (nonatomic, readonly)     NSArray<NSString *> *allArgKeys;

/** 修改或追加参数 */
- (void)updateArgsWithKeyValueDictionary:(NSDictionary<NSString *, NSString *> *)dictionary;

/** 设置get参数，已经考虑了参数的转义 */
- (void)setArgValue:(NSString *)value forKey:(NSString *)key;



/** 获取get参数，已经考虑了参数的转义 */
- (NSString *)argValueForKey:(NSString *)key;
/** 移除get参数，已经考虑了参数的转义 */
- (void)removeArgKey:(NSString *)key;

#pragma mark - 完整的URL操作
/** 完整的url */
@property (nonatomic, readwrite)    NSString *completeURL;
/** 描述==url */
- (NSString *)description;

#pragma mark - URL上，get参数的转义

/** url参数编码 */
+ (NSString *)argValueEncode:(NSString *)value;
/** url参数解码 */
+ (NSString *)argValueDecode:(NSString *)value;

/** 将参数组成字符串，不包括开头的连接符，例：a=1&b=2&c=3 */
+ (NSString *)argStringEncodeWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary;

@end
