//
//  GYDShellCodeAnalysisXibFileAnalysis.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/11/15.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisXibFileAnalysis.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellCodeAnalysisSwiftReader.h"
#import "GYDShellCodeAnalysisFileItem.h"

@implementation GYDShellCodeAnalysisXibFileAnalysis

+ (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path {
    GYDShellCodeAnalysisXibFileAnalysis *tools = [[self alloc] init];
    return [tools preprocessFileAtPath:path];
}

- (NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *)preprocessFileAtPath:(NSString *)path {
    NSMutableArray *wordArray = [GYDShellCodeAnalysisSwiftReader wordArrayWithFile:path];
    
    GYDShellCodeAnalysisFileAnalysisResultItem *item = [[GYDShellCodeAnalysisFileAnalysisResultItem alloc] init];
    item.itemClass = @"Xib+Storyboard";
    item.fileName = [path lastPathComponent];
    item.category = item.fileName;
    item.includeTypes = [NSMutableSet set];
    NSInteger step = 0;
    for (GYDShellCodeAnalysisReaderWord *word in wordArray) {
        if (step == 0) {
            if (word.type == GYDShellCodeAnalysisWordTypeKey && [word.word isEqualToString:@"customClass"]) {
                step = 1;
            }
        } else if (step == 1) {
            if (word.type == GYDShellCodeAnalysisWordTypeSymbol && [word.word isEqualToString:@"="]) {
                step = 2;
            } else {
                step = 0;
            }
        } else {
            if (word.type == GYDShellCodeAnalysisWordTypeText) {
                [item.includeTypes addObject:[word.word substringWithRange:NSMakeRange(1, word.word.length - 2)]];
            }
            step = 0;
        }
    }
    return @[item];
}

@end
