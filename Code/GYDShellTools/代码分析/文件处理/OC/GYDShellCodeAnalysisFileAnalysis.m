//
//  GYDShellCodeAnalysisFileAnalysis.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/27.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisFileAnalysis.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellCodeAnalysisOCReader.h"
#import "GYDShellCodeAnalysisFileItem.h"

@implementation GYDShellCodeAnalysisFileAnalysis
{
    //解析函数早晚要拆开的，所以用成员变量
    GYDShellCodeAnalysisFileItem *_currentFile;
    GYDShellCodeAnalysisClassItem *_currentClass;
    
    //按行号记录注释
    NSMutableArray *_descArray;
    NSMutableArray *_descLastLine;
}

+ (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path {
    GYDShellCodeAnalysisFileAnalysis *tools = [[self alloc] init];
    return [tools preprocessFileAtPath:path];
}

- (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path {
    
    //按行号记录注释
    _descArray = [NSMutableArray array];
    _descLastLine = [NSMutableArray array];
    
    GYDShellCodeAnalysisFileItem *fileItem = [[GYDShellCodeAnalysisFileItem alloc] init];
    [self completeFileItemInfoAndDescInfo:fileItem withSourceFileAtPath:path];
    
    NSMutableArray *wordArray = [GYDShellCodeAnalysisOCReader wordArrayWithFile:path];
    [self completeFileItemInfo:fileItem fromWordArray:wordArray];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (GYDShellCodeAnalysisClassItem *c in fileItem.classArray) {
        GYDShellCodeAnalysisFileAnalysisResultItem *item = [[GYDShellCodeAnalysisFileAnalysisResultItem alloc] init];
        item.itemClass = c.name;
        item.category = c.categoryName;
        item.superClassName = c.superClassName;
        item.desc = c.classDesc;
        item.hasLoadFun = c.hasLoadFun;
        item.createTime = fileItem.creatTime;
        item.author = fileItem.author;
        item.fileName = fileItem.fileName;
        item.lineNumber = c.lineNumber;
        
        item.includeTypes = [NSMutableSet set];
        if (c.superClassName.length > 0) {
            [item.includeTypes addObject:c.superClassName];
        }
        if (fileItem.includeTypes.count > 0) {
            [item.includeTypes unionSet:fileItem.includeTypes];
        }
        if (c.includeTypes.count > 0) {
            [item.includeTypes unionSet:c.includeTypes];
        }
        [item.includeTypes removeObject:item.itemClass];

        [resultArray addObject:item];
    }
    return resultArray;
}

#pragma mark - 初步解析文件处理
- (void)completeFileItemInfo:(GYDShellCodeAnalysisFileItem *)fileItem fromWordArray:(NSArray<GYDShellCodeAnalysisReaderWord *> *)wordArray {
    _currentFile = fileItem;
    _currentFile.classArray = [NSMutableArray array];
    _currentFile.includeTypes = [NSMutableSet set];
    
    for (NSInteger i = 0; i < wordArray.count; i++) {
        GYDShellCodeAnalysisReaderWord *word = wordArray[i];
        NSInteger backupIndex = i;
        if ([word.word isEqualToString:@"@interface"]) {
            _currentClass = [[GYDShellCodeAnalysisClassItem alloc] init];
            _currentClass.lineNumber = word.lineNumber;
            _currentClass.classDesc = [self descBeforeIndex:word.lineNumber breakIndex:(backupIndex > 0) ? wordArray[backupIndex - 1].lineNumber : 0];
            _currentClass.includeTypes = [NSMutableSet set];
            [_currentFile.classArray addObject:_currentClass];
            if (i + 4 >= wordArray.count) {
                GYDFoundationWarning(@"类不够完整：%@", [self descWithWordArray:wordArray startIndex:backupIndex]);
                continue;
            }
            _currentClass.name = wordArray[i + 1].word;
            i++;
            if ([@":" isEqualToString:wordArray[i + 1].word]) {
                _currentClass.superClassName = wordArray[i + 2].word;
                i += 2;
            } else if ([@"(" isEqualToString:wordArray[i + 1].word]) {
                if ([@")" isEqualToString:wordArray[i + 2].word]) {
                    i += 2;
                    _currentClass.categoryName = @"";
                } else if ([@")" isEqualToString:wordArray[i + 3].word]) {
                    _currentClass.categoryName = wordArray[i + 2].word;
                    i += 3;
                } else {
                    GYDFoundationWarning(@"类不够完整：%@", [self descWithWordArray:wordArray startIndex:backupIndex]);
                }
            }
        } else if ([word.word isEqualToString:@"@implementation"]) {
            _currentClass = [[GYDShellCodeAnalysisClassItem alloc] init];
            if (backupIndex > 0) {
                _currentClass.classDesc = [self descBeforeIndex:word.lineNumber breakIndex:(backupIndex > 0) ? wordArray[backupIndex - 1].lineNumber : 0];
            }
            _currentClass.includeTypes = [NSMutableSet set];
            [_currentFile.classArray addObject:_currentClass];
            if (i + 2 >= wordArray.count) {
                GYDFoundationWarning(@"类不够完整：%@", [self descWithWordArray:wordArray startIndex:backupIndex]);
                continue;
            }
            _currentClass.name = wordArray[i + 1].word;
            i++;
            if ([@"(" isEqualToString:wordArray[i + 1].word]) {
                if (i + 3 >= wordArray.count) {
                    GYDFoundationWarning(@"类不够完整：%@", [self descWithWordArray:wordArray startIndex:backupIndex]);
                    continue;
                }
                if ([@")" isEqualToString:wordArray[i + 2].word]) {
                    i += 2;
                } else if ([@")" isEqualToString:wordArray[i + 3].word]) {
                    _currentClass.categoryName = wordArray[i + 2].word;
                    i += 3;
                } else {
                    GYDFoundationWarning(@"类不够完整：%@", [self descWithWordArray:wordArray startIndex:backupIndex]);
                }
            }
            
        } else if ([word.word isEqualToString:@"@end"]) {
            _currentClass = nil;
        } else {
            if ([word.word isEqualToString:@"+"]) {
                NSArray *loadFun = @[@"+", @"(", @"void", @")", @"load", @"{"];
                BOOL isEqual = YES;
                if (i + loadFun.count >= wordArray.count) {
                    isEqual = NO;
                } else {
                    for (NSInteger j = 1; j < loadFun.count; j ++) {
                        if (![wordArray[i + j].word isEqualToString:loadFun[j]]) {
                            isEqual = NO;
                            break;
                        }
                    }
                }
                
                if (isEqual == YES && _currentClass) {
                    _currentClass.hasLoadFun = YES;
                }
            }
            if (word.type != GYDShellCodeAnalysisWordTypeKey) {
                continue;
            }
            if (word.word.length < 1) {
                GYDFoundationWarning(@"关键字为空：%@", [self descWithWordArray:wordArray startIndex:backupIndex]);
                continue;
            }
//            if (![[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[word.word characterAtIndex:0]]) {
//                continue;
//            }
            static NSSet *ignoreWordSet = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                ignoreWordSet = [NSSet setWithObjects:@"CGRect", @"NSInteger", @"NSUInteger", @"CGPoint", @"CGFloat", @"CGSize", @"CGFloat", @"Class", @"BOOL", @"NS_ASSUME_NONNULL_BEGIN", @"NS_ASSUME_NONNULL_END", @"HTTPMethod", nil];
            });
            if ([ignoreWordSet containsObject:word.word]) {
                continue;
            }
            if (_currentClass) {
                [_currentClass.includeTypes addObject:word.word];
            } else {
                [_currentFile.includeTypes addObject:word.word];
            }
        }
    }
}

- (void)completeFileItemInfoAndDescInfo:(GYDShellCodeAnalysisFileItem *)fileItem withSourceFileAtPath:(NSString *)filePath {
    //文件名
    fileItem.fileName = [filePath lastPathComponent];
    //读取文件内容
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:fileContent];
    //例子：//  Created by 宫亚东 on 2018/8/21.
    if (![search subStringToString:@"//  Created by "]) {
        return;
    }
    NSString *authorLine = [search subLine];
    NSRange range = [authorLine rangeOfString:@" on " options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return;
    }
    fileItem.author = [authorLine substringToIndex:range.location];
    
    NSString *time = [authorLine substringFromIndex:range.location + range.length];
    if ([time hasSuffix:@"."]) {
        time = [time substringToIndex:time.length - 1];
    }
    fileItem.creatTime = time;
    
    NSInteger line = 0;
    GYDStringSearch *lineSearch = [[GYDStringSearch alloc] initWithString:fileContent];
    while (1) {
        [search skipWhitespaceCharacters];
        NSString *desc = [search subDescString];
        if (desc) {
            [_descArray addObject:[desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            while (search.index > lineSearch.index) {
                if (![lineSearch subLine] ) {
                    GYDFoundationError(@"越界");
                    break;
                }
                line ++;
            }
            [_descLastLine addObject:@(line)];
            continue;
        }
        if (![search subLine]) {
            break;
        }
    }
}

- (NSString *)descBeforeIndex:(NSInteger)startIndex breakIndex:(NSInteger)breakIndex {
    for (NSInteger i = _descLastLine.count - 1; i >= 0; i--) {
        NSInteger line = [_descLastLine[i] integerValue];
        if (line < startIndex) {
            if (line > breakIndex) {
                return _descArray[i];
            } else {
                return nil;
            }
        }
    }
    return nil;
}

#pragma mark - 工具方法
- (NSString *)descWithWordArray:(NSArray<GYDShellCodeAnalysisReaderWord *> *)wordArray startIndex:(NSInteger)startIndex {
    NSMutableString *desc = [NSMutableString string];
    for (NSInteger i = startIndex; i < wordArray.count && i < startIndex + 10; i++) {
        [desc appendString:[wordArray[i] description]];
        [desc appendString:@"\n"];
    }
    return desc;
}

@end
