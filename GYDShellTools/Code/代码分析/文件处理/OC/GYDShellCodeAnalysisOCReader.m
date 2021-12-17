//
//  GYDShellCodeAnalysisOCReader.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/2.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisOCReader.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellTask.h"

@implementation GYDShellCodeAnalysisOCReader

+ (NSMutableArray<GYDShellCodeAnalysisReaderWord *> *)wordArrayWithFile:(NSString *)filePath {
    if (!filePath.length) {
        GYDFoundationError(@"没有路径");
        return nil;
    }
    GYDShellCodeAnalysisOCReader *reader = [[GYDShellCodeAnalysisOCReader alloc] init];
    NSString *code = [reader codeContentWithFileAtPath:filePath];
    NSMutableArray *array = [reader wordArrayWithFileContent:code];
    [reader mergeOCWordInWordArray:array];
    return array;
}

- (NSString *)codeContentWithFileAtPath:(NSString *)filePath {
    filePath = [self escapePathByBackslash:filePath];
    
    NSString *command = [NSString stringWithFormat:@"clang -E %@", filePath];
    
    GYDShellTask *task = [[GYDShellTask alloc] init];
    [task executeShellPath:nil command:command progress:nil];
    NSString *output = [self fileContentWithPreprocess:task.standardOutput fileName:filePath.lastPathComponent];
    if (task.standardError.length > 0) {
//            GYDFoundationWarning(@"%@", task.standardError);
    }
    return output;
}

//路径参数加反斜杠转义
- (nonnull NSString *)escapePathByBackslash:(NSString *)path {
    if (!path) {
        return @"";
    }
    
    NSString *str = [path stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    
    return str;
}


/** 仅保留当前文件内容 */
- (nonnull NSString *)fileContentWithPreprocess:(NSString *)pre fileName:(NSString *)fileName {
    self.lineNumberArray = [NSMutableArray array];
    
    NSMutableString *result = [NSMutableString string];
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:pre];
    BOOL inFile = NO;
    NSInteger line = 1;
    while ([search hasCurrentCharacter]) {
        NSString *str = [search subLine];
        if ([str hasPrefix:@"#"]) {
            GYDStringSearch *fileSearch = [[GYDStringSearch alloc] initWithString:str];
            fileSearch.index++;
            if ([fileSearch hasCurrentString:@"pragma"]) {
                continue;
            }
            [fileSearch skipWhitespaceCharacters];
            NSString *lineNumberString = [fileSearch subStringToString:@" "];
            if ([lineNumberString integerValue] < 1) {
                GYDFoundationError(@"文件提取失败%@, %zd\n%@", fileName, line, str);
                return nil;
            }
            [fileSearch skipWhitespaceCharacters];
            unichar c = [fileSearch currentCharacter];
            if (c != '\'' && c != '\"') {
                GYDFoundationError(@"文件提取失败%@, %zd\n%@", fileName, line, str);
                return nil;
            }
            fileSearch.index++;
            NSString *path = [fileSearch subEscapeStringToCharacter:c];
            if (!path) {
                GYDFoundationError(@"文件提取失败%@, %zd\n%@", fileName, line, str);
                return nil;
            }
            if ([fileName isEqualToString:path.lastPathComponent]) {
                inFile = YES;
                line = [lineNumberString integerValue];
            } else {
                inFile = NO;
            }
        } else {
            if (inFile) {
                [result appendString:str];
                [result appendString:@"\n"];
                GYDShellCodeAnalysisReaderLineNumber *l = [[GYDShellCodeAnalysisReaderLineNumber alloc] init];
                l.line = line;
                l.toIndex = result.length - 1;
                [self.lineNumberArray addObject:l];
                line++;
            }
        }
    }
    return result;
}

#pragma mark - 组合OC关联单词，如@interface
- (void)mergeOCWordInWordArray:(NSMutableArray *)wordArray {
    static NSSet *atWordSet = nil;    //@符号后面跟着的文字
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        atWordSet = [NSSet setWithObjects:@"implementation", @"interface", @"protocol", @"end", @"property", @"synthesize", @"try", @"catch", @"finally", @"selector", @"autoreleasepool", @"available", @"class", @"import", @"optional", @"required", @"@protected", @"private", @"public", @"throw", @"synchronized", @"dynamic", @"encode", @"package", nil];
    });
    
    for (NSInteger i = 0; i < wordArray.count; i++) {
        GYDShellCodeAnalysisReaderWord *word = wordArray[i];
        if ([word.word isEqualToString:@"@"]) {
            if (i + 1 < wordArray.count) {
                GYDShellCodeAnalysisReaderWord *nextWord = wordArray[i + 1];
                if ([atWordSet containsObject:nextWord.word]) {
                    word.word = [@"@" stringByAppendingString:nextWord.word];
                    [wordArray removeObjectAtIndex:i + 1];
                    continue;
                }
                
                NSString *text = nil;
                BOOL isAt = YES;
                NSInteger j = i + 1;
                while (j < wordArray.count) {
                    nextWord = wordArray[j];
                    if (nextWord.type == GYDShellCodeAnalysisWordTypeText) {
                        //追加
                        if (!text) {
                            text = @"";
                        }
                        text = [text stringByAppendingString:[nextWord.word substringWithRange:NSMakeRange(1, nextWord.word.length - 2)]];
                        isAt = NO;
                    } else if ([nextWord.word isEqualToString:@"@"] && isAt == NO) {
                        isAt = YES;
                    } else {
                        break;
                    }
                    j ++;
                }
                if (text) {
                    word.word = [NSString stringWithFormat:@"@\"%@\"", text];
                    while (j > i + 1) {
                        j --;
                        [wordArray removeObjectAtIndex:j];
                    }
                    continue;
                }
//                if (![@[@"{", @"[", @"("] containsObject:nextWord.word]) {
//                    GYDFoundationInfo(@"@符号后面的字符:%@", nextWord);
//                }
            }
        }
        
    }
}
@end
