//
//  GYDUrl.m
//  GYDFoundation
//
//  Created by 宫亚东 on 16/3/3.
//  Copyright © 2016年 宫亚东. All rights reserved.
//

#import "GYDUrl.h"

typedef NS_ENUM(int, GYDUrlCompareState) {
    //需要组装
    GYDUrlCompareStateNeedEncode = -1,
    //已同步
    GYDUrlCompareStateAllRight   = 0,
    //需要拆分
    GYDUrlCompareStateNeedDecode = 1,
};

@implementation GYDUrl
{
    NSString *_scheme;
    NSString *_host;
    NSString *_path;
    NSString *_fragment;
    NSMutableDictionary *_argDic;
    NSString *_completeURL;
    GYDUrlCompareState _urlCompareState;
}

#pragma mark - 初始化方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        _urlCompareState = GYDUrlCompareStateNeedDecode;
    }
    return self;
}
- (instancetype)initWithCompleteURL:(NSString *)url
{
    self = [super init];
    if (self) {
        _completeURL = url;
        _urlCompareState = GYDUrlCompareStateNeedDecode;
    }
    return self;
}

#pragma mark - URL的属性操作

/** 协议头，如http,ftp,https */
- (void)setScheme:(NSString *)scheme{
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    _scheme = scheme;
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}
- (NSString *)scheme{
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    return _scheme;
}

/** host，如www.lagou.com,www.baidu.com */
- (void)setHost:(NSString *)host{
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    _host = host;
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}
- (NSString *)host{
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    return _host;
}

/** 路径，不包含host和参数，如：http://www.lagou.com/aaa/bbb/?key=value 的path是 aaa/bbb/ */
- (void)setPath:(NSString *)path{
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    _path = path;
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}
- (NSString *)path{
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    return _path;
}

/** #号后面的部分，如：https://www.lagou.com/aaa#abc 中的abc */
- (void)setFragment:(NSString *)fragment {
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    _fragment = fragment;
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}
- (NSString *)fragment {
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    return _fragment;
}

- (void)setAllArgs:(NSDictionary<NSString *,NSString *> *)allArgs {
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    _argDic = [allArgs mutableCopy];
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}

- (NSDictionary<NSString *,NSString *> *)allArgs {
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    return [_argDic copy];
}

/** 所有get参数的key */
- (NSArray *)allArgKeys{
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    return [_argDic allKeys];
}

/** 修改或追加参数 */
- (void)updateArgsWithKeyValueDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    [_argDic setValuesForKeysWithDictionary:dictionary];
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}

/** 设置get参数 */
- (void)setArgValue:(NSString *)value forKey:(NSString *)key{
    if (!key) {
        return;
    }
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    if (value) {
        [_argDic setObject:value forKey:key];
    } else {
        [_argDic removeObjectForKey:key];
    }
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}
/** 获取get参数 */
- (NSString *)argValueForKey:(NSString *)key{
    if (!key) {
        return nil;
    }
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    return [_argDic objectForKey:key];
}
/** 移除get参数 */
- (void)removeArgKey:(NSString *)key{
    if (!key) {
        return;
    }
    if (_urlCompareState == GYDUrlCompareStateNeedDecode) {
        [self urlDecode];
    }
    [_argDic removeObjectForKey:key];
    _urlCompareState = GYDUrlCompareStateNeedEncode;
}

#pragma mark - 完整的URL操作

/** 完整的url */
- (void)setCompleteURL:(NSString *)completeURL{
    _completeURL = completeURL;
    _urlCompareState = GYDUrlCompareStateNeedDecode;
}
- (NSString *)completeURL{
    if (_urlCompareState == GYDUrlCompareStateNeedEncode) {
        [self urlEncode];
    }
    return _completeURL;
}
/** 描述==url */
- (NSString *)description{
    return [self completeURL];
}

#pragma mark - URL的组装和解析

- (void)urlEncode{
    _completeURL = [NSString stringWithFormat:@"%@://%@%@%@", _scheme ?: @"http", _host ?: @"", _host.length>0 ? @"/" : @"", _path ?: @""];
    if (_argDic.count>0) {
        _completeURL = [_completeURL stringByAppendingFormat:@"?%@", [GYDUrl argStringEncodeWithDictionary:_argDic]];
    }
    if (_fragment.length > 0) {
        _completeURL = [_completeURL stringByAppendingFormat:@"#%@", _fragment];
    }
    _urlCompareState = GYDUrlCompareStateAllRight;
}
- (void)urlDecode{
    if (!_completeURL) {
        _completeURL = @"";
    }
    NSRange unUseRange = NSMakeRange(0, _completeURL.length);
    
    NSRange range = [_completeURL rangeOfString:@"#" options:0 range:unUseRange];
    if (range.length > 0) {
        _fragment = [_completeURL substringFromIndex:range.location + range.length];
        unUseRange.length = range.location;
    } else {
        _fragment = @"";
    }
    
    _argDic = [NSMutableDictionary dictionary];
    range = [_completeURL rangeOfString:@"?" options:0 range:unUseRange];
    if (range.length > 0) {
        NSString *query = [_completeURL substringWithRange:NSMakeRange(range.location+range.length, (unUseRange.length+unUseRange.location) - (range.location+range.length))];
        
        unUseRange.length = range.location;
        
        NSArray *array = [query componentsSeparatedByString:@"&"];
        for (NSString *string in array) {
            range = [string rangeOfString:@"="];
            if (range.length>0) {
                [_argDic setObject:[GYDUrl argValueDecode:[string substringFromIndex:range.location+range.length]] forKey:[GYDUrl argValueDecode:[string substringToIndex:range.location]]];
            }
        }
    }
    
    range = [_completeURL rangeOfString:@"://" options:0 range:unUseRange];
    if (range.length>0) {
        _scheme = [_completeURL substringToIndex:range.location];
        unUseRange.location = range.location + range.length;
        unUseRange.length -= unUseRange.location;
    } else {
        _scheme = @"http";
    }
    
    range = [_completeURL rangeOfString:@"/" options:0 range:unUseRange];
    if (range.length>0) {
        NSInteger offset = range.location - unUseRange.location;
        _host = [_completeURL substringWithRange:NSMakeRange(unUseRange.location, offset)];
        unUseRange.location = range.location + range.length;
        unUseRange.length -= offset + range.length;
        
        _path = [_completeURL substringWithRange:unUseRange];
        
    } else {
        //遇到这种 aaaa?k=v aaaa算在host上
        _host = [_completeURL substringWithRange:unUseRange];
    }
    
    _urlCompareState = GYDUrlCompareStateAllRight;
}

#pragma mark - URL上，get参数的编解码

/** url参数编码 */
+ (NSString *)argValueEncode:(NSString *)value{
    static NSMutableCharacterSet *charset = nil;
    if (!charset) {
        //防止多线程同时调用，中间过程用一个临时变量
        NSMutableCharacterSet *tmp = [NSMutableCharacterSet letterCharacterSet];
        [tmp formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
        [tmp addCharactersInString:@"-_.!~*'()"];
        charset = tmp;
    }
    return [value stringByAddingPercentEncodingWithAllowedCharacters:charset];
}
/** url参数解码 */
+ (NSString *)argValueDecode:(NSString *)value{
    //[value stringByRemovingPercentEncoding]有可能解析失败
    return [value stringByRemovingPercentEncoding] ?: @"";
}

/** 将参数组成字符串，不包括开头的连接符，例：a=1&b=2&c=3 */
+ (NSString *)argStringEncodeWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in dictionary) {
        if (string.length) {
            [string appendString:@"&"];
        }
        [string appendFormat:@"%@=%@", [GYDUrl argValueEncode:key], [GYDUrl argValueEncode:dictionary[key]]];
    }
    return string;
}

@end
