//
//  GYDShellCodeAnalysisSwiftFileAnalysis.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/2.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisSwiftFileAnalysis.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellCodeAnalysisSwiftReader.h"

@implementation GYDShellCodeAnalysisSwiftFileAnalysis

+ (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path {
    GYDShellCodeAnalysisSwiftFileAnalysis *tools = [[self alloc] init];
    return [tools preprocessFileAtPath:path];
}

- (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path {
    NSMutableArray *wordArray = [GYDShellCodeAnalysisSwiftReader wordArrayWithFile:path];
    
    GYDShellCodeAnalysisFileAnalysisResultItem *item = [[GYDShellCodeAnalysisFileAnalysisResultItem alloc] init];
    item.itemClass = @"Swift";
    item.fileName = [path lastPathComponent];
    item.category = item.fileName;
    item.includeTypes = [NSMutableSet set];
    for (GYDShellCodeAnalysisReaderWord *word in wordArray) {
        if (word.type == GYDShellCodeAnalysisWordTypeKey) {
            [item.includeTypes addObject:word.word];
        }
    }
    return @[item];
}

@end
