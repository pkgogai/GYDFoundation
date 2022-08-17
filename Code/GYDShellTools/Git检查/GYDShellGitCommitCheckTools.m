//
//  GYDShellGitCommitCheckTools.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//
#define GYD_FOUNDATION_DEVELOPMENT 1

#import "GYDShellGitCommitCheckTools.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellFeishuToolsDemo.h"
#import "GYDShellGitCommitConfig.h"
#import "GYDShellTask.h"
#import "GYDShellGitCommitCheckDiffModel.h"
#import "GYDShellCodeAnalysisFileAnalysis.h"

@implementation GYDShellGitCommitCheckTools
{
    
}
/** 进行检查 */
- (int)check {
    NSString *notesPath = [self.notesPath stringByStandardizingPath];
    NSString *rootPath = [self.gitRootPath stringByStandardizingPath];

    NSString *notesDirPath = [notesPath stringByDeletingLastPathComponent];
    NSURL *rootURL = [NSURL fileURLWithPath:rootPath];
    
    NSString *errorMsg = nil;
    BOOL tmpBool = [GYDFile makeSureDirectoryAtPath:notesDirPath errorMessage:&errorMsg];
    if (!tmpBool) {
        GYDFoundationWarning(@"目录创建失败: %@\n%@", notesDirPath, errorMsg);
        return 1;
    }
    
    GYDShellGitCommitConfig *config = [[GYDShellGitCommitConfig alloc] initWithFileAtPath:notesPath];
    
    GYDShellTask *task = [[GYDShellTask alloc] init];
    task.currentDirectoryURL = rootURL;
    
    int r = [task executeShellPath:nil command:@"git log --since=5.weeks --pretty=tformat:\"%H,%D\"" progress:nil];
    GYDFoundationInfo(@"5周内的提交节点：\n%@", task.standardOutput);
    if (task.standardError.length > 0) {
        GYDFoundationWarning(@"获取git节点信息失败：%@", task.standardError);
    }
    if (r) {
        GYDFoundationWarning(@"错误码：%d", r);
        return 1;
    }
    NSString *currentCommit = nil;
    NSString *currentCommitMessage = nil;
    NSString *currentReleaseBrach = nil;
    NSString *baseCommit = nil;
    NSArray *lines = [task.standardOutput componentsSeparatedByString:@"\n"];
    for (NSString *l in lines) {
        NSArray *words = [l componentsSeparatedByString:@","];
        if (words.count < 1) {
            GYDFoundationWarning(@"git节点分析错误：%@", task.standardOutput);
            [config saveIfNeeded];
            return 1;
        }
        NSString *commit = words.firstObject;
        //其他行只用来查找基准节点。
        if ([config containsCommit:commit]) {
            baseCommit = commit;
            break;
        }
        if (!currentCommit) {
            //第一行是当前节点的处理
            currentCommit = words.firstObject;
            currentCommitMessage = l;
            for (NSInteger i = 1; i < words.count; i++) {
                NSString *brach = [words[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([config matchBrach:brach]) {
                    currentReleaseBrach = brach;
                    [config addCommit:commit forBrach:brach];
                }
            }
        }
    }
    [config saveIfNeeded];

    if (!currentCommit) {
        GYDFoundationInfo(@"已处处理过此节点");
        return 0;
    }
    if (!baseCommit) {
        GYDFoundationWarning(@"找不到基准节点");
        return 1;
    }
    task = [[GYDShellTask alloc] init];
    task.currentDirectoryURL = rootURL;
    r = [task executeShellPath:nil command:[NSString stringWithFormat:@"git diff %@ %@", baseCommit, currentCommit] progress:nil];
    GYDFoundationInfo(@"git diff %@ %@：\n%@", baseCommit, currentCommit, task.standardOutput);
    if (task.standardError.length > 0) {
        GYDFoundationWarning(@"%@", task.standardError);
    }
    if (r) {
        GYDFoundationWarning(@"错误码：%d", r);
        return 1;
    }
    
    NSArray *diffResult = [GYDShellGitCommitCheckDiffModel diffModelArrayWithContent:task.standardOutput];
    
    NSMutableDictionary<NSString *, NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *> *resultUserClassDic = [NSMutableDictionary dictionary];
    GYDFoundationInfo(@"开始查找无注释类");
    
    for (GYDShellGitCommitCheckDiffModel *model in diffResult) {
        if (model.changedLineNumbers.count < 1) {
            continue;
        }
        NSString *filePath = model.filePath;
        if (filePath.length < 1) {
            GYDFoundationWarning(@"没有文件名");
            continue;
        }
        if (![config matchFilePath:filePath]) {
            continue;
        }
        filePath = [rootPath stringByAppendingPathComponent:filePath];
        
        NSArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *classArray = [GYDShellCodeAnalysisFileAnalysis preprocessFileAtPath:filePath];
        for (GYDShellCodeAnalysisFileAnalysisResultItem *item in classArray) {
            if (item.category) {
                continue;
            }
            if (item.superClassName.length < 1) {
                continue;
            }
            if ([item.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 2) {
                continue;
            }
            if ([model.changedLineNumbers containsObject:@(item.lineNumber)]) {
                GYDFoundationInfo(@"文件：%@，行：%zd", filePath, item.lineNumber);
                task = [[GYDShellTask alloc] init];
                task.currentDirectoryURL = rootURL;
                NSString *command = [NSString stringWithFormat:@"git blame -L %zd,%zd \"%@\"", item.lineNumber, item.lineNumber, [filePath gyd_escapeStringByBackslash]];
                r = [task executeShellPath:nil command:command progress:nil];
                if (r) {
                    GYDFoundationWarning(@"错误码：%d", r);
                    continue;
                }
                GYDStringSearch *nameSearch = [[GYDStringSearch alloc] initWithString:task.standardOutput];
                [nameSearch subStringToString:@"("];
                NSString *author = [nameSearch subStringToString:@" "];
                if (author.length < 0) {
                    GYDFoundationWarning(@"没找到作者：%@", task.standardOutput);
                    continue;
                }
                author = [[GYDShellFeishuToolsDemo sharedInstance] feishuUserWithGitAuthor:author];
                
                NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> *resultClassArray = resultUserClassDic[author];
                if (!resultClassArray) {
                    resultClassArray = [NSMutableArray array];
                    resultUserClassDic[author] = resultClassArray;
                }
                [resultClassArray addObject:item];
            }
        }
    }
    
    if (resultUserClassDic.count < 1) {
        return 0;
    }
    NSMutableArray *feishuMessageArray = [NSMutableArray array];
    [feishuMessageArray addObject:[GYDShellFeishuMessageItem messageWithText:[NSString stringWithFormat:@"当前节点：%@", currentCommitMessage]]];
    [resultUserClassDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<GYDShellCodeAnalysisFileAnalysisResultItem *> * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSMutableString *message = [NSMutableString stringWithFormat:@"%@:%zd个类:", key, obj.count];
        
        NSString *userId = [[GYDShellFeishuToolsDemo sharedInstance] idForUserName:key];
        if (!userId) {
            userId = key;
        }
        for (NSInteger i = 0; i < 50 && i < obj.count; i++) {
            [message appendFormat:@"\n%@", obj[i].itemClass];
        }
        [feishuMessageArray addObject:[GYDShellFeishuMessageItem messageWithAtUserId:userId]];
        [feishuMessageArray addObject:[GYDShellFeishuMessageItem messageWithText:message]];
    }];
    
    NSString *sendTo = self.sendTo;
    if (sendTo.length > 0) {
        BOOL feishuResult = [[GYDShellFeishuToolsDemo sharedInstance] sendMessageToUser:sendTo withTitle:@"近期提交的类缺少注释" messageItemArray:feishuMessageArray output:&errorMsg];
        if (!feishuResult) {
            GYDFoundationWarning(@"发送飞书消息失败：\n%@", errorMsg);
            return 1;
        }
    }
    
    return 0;
}

@end
