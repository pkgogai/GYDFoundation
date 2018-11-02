//
//  GYDStringSearch.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

/*
 2018年08月22日getSubxxx方法，参数改为_Nonnull，里面也不再检查参数为NULL的情况
 */

#import <Foundation/Foundation.h>

/**
 搜索字符串
 */
@interface GYDStringSearch : NSObject

/** 当前处理到的位置，范围[0~length]，设置负数表示末尾 */
@property (nonatomic)   NSInteger index;
@property (nonatomic, readonly) NSInteger stringLength;

+ (nonnull instancetype)searchWithString:(nonnull NSString *)string;

- (nonnull instancetype)initWithString:(nonnull NSString *)string;

#pragma mark - 与当前位置无关的操作

/** 获取指定下标的字符，不移动下标，负数表示从后向前数。越界则返回0（\0） */
- (unichar)charAtIndex:(NSInteger)index;

#pragma mark - 针对当前位置的判断，不会修改位置

/** 获取当前下标的字符，不移动下标。修改index时做了判断，所以不会越界。末尾返回0（\0） */
- (unichar)currentCharacter;

/** 判断当前的字符是不是 character */
- (BOOL)hasCurrentCharacter:(unichar)character;

/** 判断当前的字符串是不是 string，string=@""的话永远为YES */
- (BOOL)hasCurrentString:(nonnull NSString *)string;

#pragma mark - 跳过字符，会修改位置

/** 跳过接下来的空白字符(包括换行) */
- (void)skipWhitespaceCharacters;

/** 跳过接下来的所有character，并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipCharacter:(unichar)character ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters;

/** 跳过接下来的所有符合characterSet的字符，并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipCharacterInCharacterSet:(nonnull NSCharacterSet *)characterSet ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters;

/** 跳过接下来的所有符合characterSet的字符，并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipCharacterInString:(nonnull NSString *)string ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters;

/** 跳过接下来所有符合条件的字符串（是整个字符串不是其中的字符），并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipString:(nonnull NSString *)string ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters;


#pragma mark - 从当前位置向后截取，会修改下标到参与字符的最右侧

/** 获取当前下标的字符，并移动下标 */
- (unichar)subCharacter;
- (BOOL)getSubCharacter:(unichar *_Nonnull)character;

/** 搜索指定字符串，并截取之前的，搜到的情况下，下标会移动到参数右侧 */
- (nullable NSString *)subStringToString:(nonnull NSString *)string;
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString toString:(nonnull NSString *)string;

/** 截取指定长度的字符串，length==0表示到结尾，负数表示向前截取，length值过大则截取到边界。最后index一定是停留在右边 */
- (nonnull NSString *)subStringWithLength:(NSInteger)length;
//一定是YES
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString withLength:(NSInteger)length;

/** 截取接下来符合characterSet的字符串 */
- (nullable NSString *)subStringInCharacterSet:(nonnull NSCharacterSet *)characterSet;
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString inCharacterSet:(nonnull NSCharacterSet *)characterSet;

/** 截取到characterSet前的字符串，moveToRight==YES表示index停留在找到字符的右边，否则是左边 */
- (nullable NSString *)subStringToCharacterSet:(nonnull NSCharacterSet *)characterSet indexMoveToRight:(BOOL)moveToRight;
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString toCharacterSet:(nonnull NSCharacterSet *)characterSet indexMoveToRight:(BOOL)moveToRight;

/** (\)转义解码后搜索指定字符，并提取之前的，用于提取引号内的字符串 */
- (nullable NSString *)subEscapeStringToCharacter:(unichar)character;
- (BOOL)getSubEscapeString:(NSString *_Nullable *_Nonnull)subString toCharacter:(unichar)character;

/** 截取接下来的注释 /(*)xxx(*)/，和//xx\n 两种形式 */
- (nullable NSString *)subDescString;
- (BOOL)getSubDescString:(NSString *_Nullable *_Nonnull)subString;

///** 截取接下来的正整型数字 */
//- (nullable NSNumber *)subULong;
//- (BOOL)getSubULong:(unsigned long *_Nullable)number;
//
///** 截取接下来的数字，负数、整数、浮点数 */
//- (nullable NSNumber *)subDouble;
//- (BOOL)getSubDouble:(double *_Nullable)number;
//
///** 截取接下来的正整型数字 */
//- (nullable NSDate *)subTime;
//- (BOOL)getSubTime:(NSDate *_Nullable)time;

@end
