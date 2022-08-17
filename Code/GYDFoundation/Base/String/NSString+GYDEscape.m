//
//  NSString+GYDEscape.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/2.
//

#import "NSString+GYDEscape.h"
#import "GYDStringSearch.h"
#import "NSData+GYDEscape.h"
#import "GYDMd5.h"

@implementation NSString (GYDEscape)

/*
 按反斜杠的转义解析一次，如：
 --------
 a\"b\nc
 被双引号包围，表示里面的内容是需要解析的，将被解析成
 a"b
 c
 --------
 注意：例子中的引号也是字符串的一部分
 */
- (nonnull NSString *)gyd_unescapeStringByBackslash {
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:self];
    NSString *str = [search subEscapeStringToCharacter:0];
    return str;
}

/*
 将里面的特殊字符（单引号，双引号，换行）改为反斜杠转义的样子，如：
 -----
 a"b\c(换行)d
 -----
 将被转换成
 -----
 a\"b\\c\nd
 -----
 注意：例子中的引号也是字符串的一部分
 */
- (nonnull NSString *)gyd_escapeStringByBackslash {
    NSString *str = [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    return str;
}


/*
 如果字符串在引号内，则将其反转义一次
 例如：character指定为双引号时
 --------
 "a\"b\nc"
 被双引号包围，表示里面的内容是需要解析的，将被解析成
 a"b
 c
 --------
 a \" b
 没有被引号包围，表示这里的内容就是原文，将不操作直接返回
 a \" b
 --------
 注意：例子中的引号也是字符串的一部分
 */
- (nonnull NSString *)gyd_unescapeStringByBackslashIfIncludeByCharacter:(unichar)character {
    NSString *str = nil;
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:self];
    if ([search subCharacter] == character) {
        str = [search subEscapeStringToCharacter:character];
    }
    return str ?: self;
}

#pragma mark - base64处理

- (nonnull NSString *)gyd_base64Value {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data gyd_base64Value];
}

/** 注意，解析失败返回nil */
+ (nullable instancetype)gyd_stringWithBase64Code:(nonnull NSString *)base64Code {
    NSData *data = [NSData gyd_dataWithBase64String:base64Code];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - MD5处理

- (nonnull NSString *)gyd_MD5Value {
    GYDMd5 *m = [[GYDMd5 alloc] init];
    [m addString:self];
    return [m MD5];
}

@end
