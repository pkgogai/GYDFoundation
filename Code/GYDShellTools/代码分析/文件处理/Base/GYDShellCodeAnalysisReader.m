//
//  GYDShellCodeAnalysisReader.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/25.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisReader.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDShellCodeAnalysisReaderWord

- (NSString *)debugDescription {
    return [self description];
}
- (NSString *)description {
    char *type = NULL;
    if (self.type == GYDShellCodeAnalysisWordTypeKey) {
        type = "key";
    } else if (self.type == GYDShellCodeAnalysisWordTypeText) {
        type = "text";
    } else if (self.type == GYDShellCodeAnalysisWordTypeSymbol) {
        type = "symbol";
    } else {
        type = "unknowe";
    }
    return [NSString stringWithFormat:@"%4zd%8s:  %@", self.lineNumber, type, self.word];
}

@end

@implementation GYDShellCodeAnalysisReaderLineNumber

@end


@implementation GYDShellCodeAnalysisReader
{
    NSInteger _currentLineNumberIndex;
}

#pragma mark - 分解单词和符号

- (NSMutableArray<GYDShellCodeAnalysisReaderWord *> *)wordArrayWithFileContent:(NSString *)fileContent {
    
    NSCharacterSet *whiteCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSMutableCharacterSet *nameCharSet = [NSMutableCharacterSet letterCharacterSet];
    [nameCharSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [nameCharSet addCharactersInString:@"_"];
    
    NSMutableCharacterSet *whiteAndNameCharSet = [nameCharSet mutableCopy];
    [whiteAndNameCharSet formUnionWithCharacterSet:whiteCharSet];
    
//        _currentIndex = 0;
    NSMutableArray *wordArray = [NSMutableArray array];
    
    _currentLineNumberIndex = 0;
    
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:fileContent];
    while (1) {
        [search skipWhitespaceCharacters];
        if (![search hasCurrentCharacter]) {
            break;
        }
        NSInteger beginIndex = search.index;
        NSString *name = [search subStringInCharacterSet:nameCharSet];
        if (name.length) {
            GYDShellCodeAnalysisReaderWord *word = [[GYDShellCodeAnalysisReaderWord alloc] init];
            word.word = name;
            word.type = GYDShellCodeAnalysisWordTypeKey;
            word.lineNumber = [self lineForIndex:beginIndex];
            [wordArray addObject:word];
            continue;
        }
        unichar c = [search subCharacter];
        if (c == '"' || c == '\'') {
            NSString *str = [search subEscapeStringToCharacter:c];
            if (!str) {
                GYDFoundationWarning(@"解析出错<=====\n%@\n=====>", fileContent);
                break;
            }
            GYDShellCodeAnalysisReaderWord *word = [[GYDShellCodeAnalysisReaderWord alloc] init];
            word.word = [NSString stringWithFormat:@"%c%@%c", c, [str gyd_escapeStringByBackslash], c];
            word.type = GYDShellCodeAnalysisWordTypeText;
            word.lineNumber = [self lineForIndex:beginIndex];
            [wordArray addObject:word];
            continue;
        }
            
        if (c == '+' || c == '-' || c == '<' || c == '>') {
            unichar c2 = [search currentCharacter];
            unichar allowChars[6][2] = {
                {'+', '+'},
                {'-', '-'},
                {'+', '='},
                {'-', '='},
                {'>', '='},
                {'<', '='},
            };
            NSString *str = nil;
            for (int i = 0; i < 6; i++) {
                if (allowChars[i][0] == c && allowChars[i][1] == c2) {
                    str = [NSString stringWithFormat:@"%c%c", c, c2];
                    break;
                    
                }
            }
            if (str) {
                GYDShellCodeAnalysisReaderWord *word = [[GYDShellCodeAnalysisReaderWord alloc] init];
                word.word = str;
                word.type = GYDShellCodeAnalysisWordTypeSymbol;
                word.lineNumber = [self lineForIndex:beginIndex];
                [wordArray addObject:word];
                [search subCharacter];
                continue;
            }
        }
        GYDShellCodeAnalysisReaderWord *word = [[GYDShellCodeAnalysisReaderWord alloc] init];
        word.word = [NSString stringWithFormat:@"%c", c];
        word.type = GYDShellCodeAnalysisWordTypeSymbol;
        word.lineNumber = [self lineForIndex:beginIndex];
        [wordArray addObject:word];
        continue;
    }
    return wordArray;
}

- (NSInteger)lineForIndex:(NSInteger)index {
    while (_currentLineNumberIndex < _lineNumberArray.count) {
        GYDShellCodeAnalysisReaderLineNumber *lineNumber = _lineNumberArray[_currentLineNumberIndex];
        if (index < lineNumber.toIndex) {
            return lineNumber.line;
        }
        _currentLineNumberIndex ++;
    }
    return 0;
}



@end
