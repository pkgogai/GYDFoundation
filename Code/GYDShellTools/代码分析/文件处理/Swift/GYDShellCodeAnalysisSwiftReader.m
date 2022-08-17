//
//  GYDShellCodeAnalysisSwiftReader.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/2.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisSwiftReader.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDShellCodeAnalysisSwiftReader

+ (NSMutableArray<GYDShellCodeAnalysisReaderWord *> *)wordArrayWithFile:(NSString *)filePath {
    if (!filePath.length) {
        GYDFoundationError(@"没有路径");
        return nil;
    }
    GYDShellCodeAnalysisSwiftReader *reader = [[GYDShellCodeAnalysisSwiftReader alloc] init];
    
    NSString *code = [reader codeContentWithFileAtPath:filePath];
    [reader resetLineNumberArrayWithFileContent:code];
    NSMutableArray *array = [reader wordArrayWithFileContent:code];
    return array;
}

- (void)resetLineNumberArrayWithFileContent:(NSString *)fileContent {
    self.lineNumberArray = [NSMutableArray array];
    GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:fileContent];
    NSInteger line = 1;
    while ([search hasCurrentCharacter]) {
        [search subLine];
        GYDShellCodeAnalysisReaderLineNumber *l = [[GYDShellCodeAnalysisReaderLineNumber alloc] init];
        l.line = line;
        if ([search hasCurrentCharacter]) {
            l.toIndex = search.index - 1;
        } else {
            //直接到末尾，如果最后连续两个\n，会算作同一行，没关系
            l.toIndex = search.index;
        }
    }
}

#pragma mark - 读取文件

- (NSString *)codeContentWithFileAtPath:(NSString *)filePath {
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!fileContent) {
        GYDFoundationWarning(@"读取文件失败：%@, err=%@", filePath, [error localizedDescription]);
    }
    return fileContent;
}


@end
