//
//  GYDShellGitCommitCheckDiffModel.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//
#define GYD_FOUNDATION_DEVELOPMENT 1

#import "GYDShellGitCommitCheckDiffModel.h"
#import "GYDStringSearch.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDShellGitCommitCheckDiffModel

+ (NSArray<GYDShellGitCommitCheckDiffModel *> *)diffModelArrayWithContent:(NSString *)content {
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    GYDShellGitCommitCheckDiffModel *currentModel = nil;
    NSInteger currentLine = 0;
    BOOL inFile = NO;
    for (NSString *l in lines) {
        if ([l hasPrefix:@"diff"]) {
            inFile = NO;
            currentModel = [[GYDShellGitCommitCheckDiffModel alloc] init];
            [resultArray addObject:currentModel];
            currentModel.changedLineNumbers = [NSMutableArray array];
            
        } else if ([l hasPrefix:@"@"]) {
            inFile = YES;
            GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:l];
            [search subStringToString:@"+"];
            NSString *number = [search subStringToString:@","];
            currentLine = number.integerValue;
            
        } else if (inFile) {
            if ([l hasPrefix:@"+"]) {
                [currentModel.changedLineNumbers addObject:@(currentLine)];
                currentLine ++;
            } else if ([l hasPrefix:@" "]) {
                currentLine ++;
            }
        } else if([l hasPrefix:@"+++ "]) {
            GYDStringSearch *search = [[GYDStringSearch alloc] initWithString:l];
            search.index = 4;
            NSString *filePath = nil;
            if ([search hasCurrentCharacter:'"']) {
                search.index ++;
                filePath = [search subEscapeStringToCharacter:'"'];
            } else if ([search hasCurrentCharacter:'\'']) {
                search.index ++;
                filePath = [search subEscapeStringToCharacter:'\''];
            } else {
                filePath = [search subEscapeStringToCharacter:0];
            }
            if ([filePath hasPrefix:@"b"]) {
                currentModel.filePath = [filePath substringFromIndex:1];
            } else {
//                GYDFoundationWarning(@"解析文件路径失败：%@", l);
            }
        }
    }
    return resultArray;
}

@end
