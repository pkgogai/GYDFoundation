//
//  NSString+GYDEscape.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/14.
//

#import <Foundation/Foundation.h>

#pragma mark - 字符串转义

@interface NSString (GYDEscape)

#pragma mark - 反斜杠转义处理

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
- (nonnull NSString *)gyd_unescapeStringByBackslash;
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
- (nonnull NSString *)gyd_escapeStringByBackslash;


/*
 如果字符串在引号内，则将其反转义一次，没有或者反转义失败的话返回self自身
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
 "a \" b\"
 前面有引号，但是按照转义处理，后面的引号会被转移掉，不算被引号包围，将不操作直接返回
 “a \" b\"
 --------
 注意：例子中的引号也是字符串的一部分
 */
- (nonnull NSString *)gyd_unescapeStringByBackslashIfIncludeByCharacter:(unichar)character;

#pragma mark - base64处理

- (nonnull NSString *)gyd_base64Value;

/** 注意，解析失败返回nil */
+ (nullable instancetype)gyd_stringWithBase64Code:(nonnull NSString *)base64Code;

#pragma mark - md5处理

- (nonnull NSString *)gyd_MD5Value;

@end
