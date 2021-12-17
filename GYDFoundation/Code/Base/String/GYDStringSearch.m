//
//  GYDStringSearch.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDStringSearch.h"

@implementation GYDStringSearch
{
    /** 存放字符串的缓存区，注意：为避免字符串末尾有'\0'，缓冲区长度要比字符串长度+1，浪费1位总比溢出1位强 */
    unichar *_stringBuffer;
    /** 搜索时临时用的，每次用时都要检查创建，不可跨方法使用 */
    unichar *_tmpBuffer;
}
- (void)dealloc
{
    if (_stringBuffer) {
        free(_stringBuffer);
        _stringBuffer = NULL;
    }
    if (_tmpBuffer) {
        free(_tmpBuffer);
        _tmpBuffer = NULL;
    }
}

+ (instancetype)searchWithString:(nonnull NSString *)string {
    return [[self alloc] initWithString:string];
}

- (nonnull instancetype)initWithString:(nonnull NSString *)string
{
    self = [super init];
    if (self) {
        _index = 0;
        _stringLength = string.length;
        
        _stringBuffer = malloc((_stringLength + 1) * sizeof(unichar));
        _stringBuffer[_stringLength] = '\0';
        [string getCharacters:_stringBuffer];
    }
    return self;
}

/** 当前处理到的位置，设置负数表示末尾 */
- (void)setIndex:(NSInteger)index {
    if (index < 0 || index > _stringLength) {
        index = _stringLength;
    }
    _index = index;
}

#pragma mark - 与当前位置无关的操作

/** 获取指定下标的字符，不移动下标，负数表示从后向前数。越界则返回0（\0） */
- (unichar)charAtIndex:(NSInteger)index {
    if (index < 0) {
        index = _stringLength + index;
        if (index < 0) {
            return 0;
        }
    } else {
        if (index >= _stringLength) {
            return 0;
        }
    }
    return _stringBuffer[index];
}

#pragma mark - 针对当前位置的判断，不会修改位置

/** 是否有内容 */
- (BOOL)hasCurrentCharacter {
    return _index < _stringLength;
}

/** 获取当前下标的字符，不移动下标。越界则返回0（\0） */
- (unichar)currentCharacter {
    return _stringBuffer[_index];   //初始化的时候已经确保\0，并且修改_index时也确保范围了，所以不判断也没关系
}

/** 判断当前的字符是不是 character */
- (BOOL)hasCurrentCharacter:(unichar)character {
    return _stringBuffer[_index] == character;
}

/** 判断当前的字符串是不是 string */
- (BOOL)hasCurrentString:(nonnull NSString *)string {
    if (_index + string.length > _stringLength) {
        return NO;
    }
    for (NSInteger i = 0; i < [string length]; i ++) {
        if (_stringBuffer[_index + i] != [string characterAtIndex:i]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 跳过字符，会修改位置

/** 跳过接下来的空白字符(包括换行) */
- (void)skipWhitespaceCharacters {
    NSCharacterSet *spaceCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    while (_index < _stringLength && [spaceCharSet characterIsMember:_stringBuffer[_index]]) {
        _index ++;
    }
}

/** 跳过接下来的所有character，并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipCharacter:(unichar)character ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters {
    NSCharacterSet *spaceCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    int n = 0;
    while (_index < _stringLength) {
        if (_stringBuffer[_index] == character) {
            n ++;
        } else if (ignoreWhitespaceCharacters && [spaceCharSet characterIsMember:_stringBuffer[_index]]) {
            //直接跳过
        } else {
            break;
        }
        _index ++;
    }
    return n;
}

/** 跳过接下来的所有符合characterSet的字符，并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipCharacterInCharacterSet:(nonnull NSCharacterSet *)characterSet ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters {
    NSCharacterSet *spaceCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    int n = 0;
    while (_index < _stringLength) {
        if ([characterSet characterIsMember:_stringBuffer[_index]]) {
            n ++;
        } else if (ignoreWhitespaceCharacters && [spaceCharSet characterIsMember:_stringBuffer[_index]]) {
            //直接跳过
        } else {
            break;
        }
        _index ++;
    }
    return n;
}

/** 跳过接下来的所有符合characterSet的字符，并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipCharacterInString:(nonnull NSString *)string ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:string];
    return [self skipCharacterInCharacterSet:characterSet ignoreWhitespaceCharacters:ignoreWhitespaceCharacters];
}

/** 跳过接下来所有符合条件的字符串（是整个字符串不是其中的字符），并返回跳过的次数，中间是否忽略空白字符(空白字符不计数) */
- (int)skipString:(nonnull NSString *)string ignoreWhitespaceCharacters:(BOOL)ignoreWhitespaceCharacters {
    NSCharacterSet *spaceCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    int n = 0;
    while (_index < _stringLength) {
        if ([self hasCurrentString:string]) {
            n ++;
            _index += string.length;
        } else if (ignoreWhitespaceCharacters && [spaceCharSet characterIsMember:_stringBuffer[_index]]) {
            //直接跳过
            _index ++;
        } else {
            break;
        }
    }
    return n;
}


#pragma mark - 从当前位置向后截取，会修改下标到参与字符的最右侧

/** 获取当前下标的字符，并移动下标 */
- (unichar)subCharacter {
    if (_index < _stringLength) {
        return _stringBuffer[_index ++];
    } else {
        return 0;
    }
}
- (BOOL)getSubCharacter:(unichar *_Nonnull)character {
    if (_index < _stringLength) {
        *character = _stringBuffer[_index ++];
        return YES;
    }
    return NO;
}

/** 搜索指定字符串，并截取之前的，搜到的情况下，下标会移动到参数右侧 */
- (nullable NSString *)subStringToString:(nonnull NSString *)string {
    if (string.length < 1) {
        return nil;
    }
    unichar *searchBuffer = NULL;
    if (string.length <= _stringLength) {
        if (!_tmpBuffer) {
            _tmpBuffer = malloc((_stringLength + 1) * sizeof(unichar));
        }
        searchBuffer = _tmpBuffer;
    } else {
        searchBuffer = malloc((string.length + 1) * sizeof(unichar));
    }
    searchBuffer[string.length] = '\0';
    [string getCharacters:searchBuffer];
    //TODO: 改成c函数 strstr()会更好一点吧
    NSString *resultString = nil;
    
    for (NSInteger searchIndex = _index; searchIndex < _stringLength; searchIndex ++) {
        int i = 0;
        while (searchIndex + i < _stringLength && i < string.length && _stringBuffer[searchIndex + i] == searchBuffer[i]) {
            i ++;
        }
        if (i == string.length) {   // 要改正用 >= 的习惯，有问题早发现早解决。
            resultString = [NSString stringWithCharacters:_stringBuffer + _index length:searchIndex - _index];
            _index = searchIndex + i;
            break;
        }
    }
    if (searchBuffer != _tmpBuffer) {
        free(searchBuffer);
    }
    return resultString;
}
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString toString:(nonnull NSString *)string {
    NSString *tmp = [self subStringToString:string];
    if (tmp) {
        *subString = tmp;
        return YES;
    }
    return NO;
}

/** 截取指定长度的字符串，length==0表示到结尾，负数表示向前截取，length值过大则截取到边界。最后index一定是停留在右边 */
- (nonnull NSString *)subStringWithLength:(NSInteger)length {
    if (length == 0 || length > _stringLength - _index) {
        length = _stringLength - _index;
    } else if (length < 0) {
        if (_index + length < 0) {
            length = _index;
            _index = 0;
        } else {
            length = -length;
            _index -= length;
        }
    }
    NSString *resultString = [NSString stringWithCharacters:_stringBuffer + _index length:length];
    _index += length;
    return resultString;
}
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString withLength:(NSInteger)length {
    NSString *tmp = [self subStringWithLength:length];
    if (tmp) {
        *subString = tmp;
        return YES;
    }
    return NO;
}

/** 截取一行 */
- (nullable NSString *)subLine {
    if (_index >= _stringLength) {
        return nil;
    }
    NSCharacterSet *charset = [NSCharacterSet newlineCharacterSet];
    NSString *str = [self subStringToCharacterSet:charset indexMoveToRight:YES];
    if (str) {
//        [self skipCharacterInCharacterSet:charset ignoreWhitespaceCharacters:NO];
        return str;
    } else {
        return [self subStringWithLength:0];
    }
}

/** 截取接下来符合characterSet的字符串 */
- (nullable NSString *)subStringInCharacterSet:(nonnull NSCharacterSet *)characterSet {
    NSInteger i = _index;
    for (; i < _stringLength; i++) {
        if (![characterSet characterIsMember:_stringBuffer[i]]) {
            break;
        }
    }
    if (i == _index) {
        return nil;
    } else {
        NSString *resultString = [NSString stringWithCharacters:_stringBuffer + _index length:i - _index];
        _index = i;
        return resultString;
    }
}
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString inCharacterSet:(nonnull NSCharacterSet *)characterSet {
    NSString *tmp = [self subStringInCharacterSet:characterSet];
    if (tmp) {
        *subString = tmp;
        return YES;
    }
    return NO;
}

/** 截取到characterSet前的字符串，moveToRight==YES表示index停留在找到字符的右边，否则是左边 */
- (nullable NSString *)subStringToCharacterSet:(nonnull NSCharacterSet *)characterSet indexMoveToRight:(BOOL)moveToRight {
    NSInteger i = _index;
    for (; i < _stringLength; i++) {
        if ([characterSet characterIsMember:_stringBuffer[i]]) {
            break;
        }
    }
    if (i == _stringLength) {
        return nil;
    } else {
        NSString *resultString = [NSString stringWithCharacters:_stringBuffer + _index length:i - _index];
        if (moveToRight) {
            _index = i + 1;
        } else {
            _index = i;
        }
        return resultString;
    }
}
- (BOOL)getSubString:(NSString *_Nullable *_Nonnull)subString toCharacterSet:(nonnull NSCharacterSet *)characterSet indexMoveToRight:(BOOL)moveToRight {
    NSString *tmp = [self subStringToCharacterSet:characterSet indexMoveToRight:moveToRight];
    if (tmp) {
        *subString = tmp;
        return YES;
    }
    return NO;
}

/** (\)转义解码后搜索指定字符，并提取之前的，用于提取引号内的字符串 character==0表示截取到结尾 */
- (nullable NSString *)subEscapeStringToCharacter:(unichar)character {
    if (!_tmpBuffer) {
        _tmpBuffer = malloc((_stringLength + 1) * sizeof(unichar));
    }
    NSInteger resultLength = 0;
    NSInteger searchIndex = _index;
    
    while (searchIndex < _stringLength) {
        if (_stringBuffer[searchIndex] == character) {
            _index = searchIndex + 1;
            return [NSString stringWithCharacters:_tmpBuffer length:resultLength];
        } else if (_stringBuffer[searchIndex] == '\\') {
            //跳过转义
            searchIndex ++;
            if (searchIndex >= _stringLength) {
                break;
            }
            
            unichar tmpChar = _stringBuffer[searchIndex];
            
            if (tmpChar == 'x') {
                //1~2位16进制
                searchIndex ++;
                if (searchIndex >= _stringLength) {
                    break;
                }
                tmpChar = _stringBuffer[searchIndex];
                if (is16HexCharacter(tmpChar)) {
                    _tmpBuffer[resultLength] = valueOfHexCharacter(tmpChar);
                    searchIndex ++;
                    if (searchIndex >= _stringLength) {
                        break;
                    }
                    tmpChar = _stringBuffer[searchIndex];
                    if (is16HexCharacter(tmpChar)) {
                        _tmpBuffer[resultLength] = _tmpBuffer[resultLength] * 16 + valueOfHexCharacter(tmpChar);
                        searchIndex ++;
                    }
                    resultLength ++;
                } else {
                    //\x后面却没有接16进制的内容，当成\0处理？
                    _tmpBuffer[resultLength ++] = 0;
                }
                
            } else if (tmpChar >= '0' && tmpChar <= '7') {  //\0只是\???中的一个特例而已\077等同于\77
                //1~3位8进制
                
                _tmpBuffer[resultLength] = valueOfHexCharacter(tmpChar);
                
                searchIndex ++;
                if (searchIndex >= _stringLength) {
                    break;
                }
                tmpChar = _stringBuffer[searchIndex];
                
                if (is8HexCharacter(tmpChar)) {
                    _tmpBuffer[resultLength] = _tmpBuffer[resultLength] * 8 + valueOfHexCharacter(tmpChar);
                    
                    searchIndex ++;
                    if (searchIndex >= _stringLength) {
                        break;
                    }
                    tmpChar = _stringBuffer[searchIndex];
                    
                    if (is8HexCharacter(tmpChar)) {
                        _tmpBuffer[resultLength] = _tmpBuffer[resultLength] * 8 + valueOfHexCharacter(tmpChar);
                    }
                }
                
                resultLength ++;
            } else {
                if (tmpChar == 'a') {
                    _tmpBuffer[resultLength ++] = '\a';
                } else if (tmpChar == 'b') {
                    _tmpBuffer[resultLength ++] = '\b';
                } else if (tmpChar == 'f') {
                    _tmpBuffer[resultLength ++] = '\f';
                } else if (tmpChar == 'n') {
                    _tmpBuffer[resultLength ++] = '\n';
                } else if (tmpChar == 'r') {
                    _tmpBuffer[resultLength ++] = '\r';
                } else if (tmpChar == 't') {
                    _tmpBuffer[resultLength ++] = '\t';
                } else if (tmpChar == 'v') {
                    _tmpBuffer[resultLength ++] = '\v';
                } else {
                    _tmpBuffer[resultLength ++] = tmpChar;
                }
                searchIndex ++;
            }
        } else {
            _tmpBuffer[resultLength ++] = _stringBuffer[searchIndex];
            searchIndex ++;
        }
    }
    if (character == 0) {
        _index = searchIndex;
        return [NSString stringWithCharacters:_tmpBuffer length:resultLength];
    }
    return nil;
}
- (BOOL)getSubEscapeString:(NSString *_Nullable *_Nonnull)subString toCharacter:(unichar)character {
    NSString *tmp = [self subEscapeStringToCharacter:character];
    if (tmp) {
        *subString = tmp;
        return YES;
    }
    return NO;
}

/** 截取接下来的注释 /(*)xxx(*)/，和//xx\n 两种形式 */
- (nullable NSString *)subDescString {
    NSString *desc = nil;
    if ([self hasCurrentString:@"/*"]) {
        _index += 2;
        desc = [self subStringToString:@"*/"];
        if ([desc hasPrefix:@"*"]) {
            desc = [desc substringFromIndex:1];
        }
    } else if ([self hasCurrentString:@"//"]) {
        _index += 2;
        desc = [self subStringToString:@"\n"];
        if (!desc) {
            desc = [self subStringWithLength:0];
        }
    }
    return desc;
}
- (BOOL)getSubDescString:(NSString *_Nullable *_Nonnull)subString {
    NSString *tmp = [self subDescString];
    if (tmp) {
        *subString = tmp;
        return YES;
    }
    return NO;
}

#pragma mark - C
static bool is16HexCharacter (unichar c) {
    if (c >= '0' && c <= '9') {
        return true;
    } else if (c >= 'a' && c <= 'f') {
        return true;
    } else if (c >= 'A' && c <= 'F') {
        return true;
    }
    return false;
}
//static bool is10HexCharacter (unichar c) {
//    if (c >= '0' && c <= '9') {
//        return true;
//    }
//    return false;
//}
static bool is8HexCharacter (unichar c) {
    if (c >= '0' && c <= '7') {
        return true;
    }
    return false;
}
static unichar valueOfHexCharacter (unichar c) {
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    }
    return 0;
}


@end
