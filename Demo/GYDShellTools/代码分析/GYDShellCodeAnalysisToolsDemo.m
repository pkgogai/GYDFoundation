//
//  GYDShellCodeAnalysisToolsDemo.m
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/19.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDShellCodeAnalysisToolsDemo.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellArgKeyValueHandler.h"
#import "GYDShellCodeAnalysisTools.h"

@implementation GYDShellCodeAnalysisToolsDemo

+ (int)exampleMainArgc:(int)argc argv:(const char * _Nonnull * _Nonnull)argv {
    
    GYDShellArgKeyValueHandler *argHanlder = [[GYDShellArgKeyValueHandler alloc] initWithArgc:argc argv:argv];
    if ([argHanlder argCount] == 1) {
        printf("\n------- 分析项目 --------\n");
        printf("版本：1.1, %s\n", __DATE__);
        printf("参数如下\n");
        printf("-config 配置文件路径\n");
        printf("-action 要做什么，多个值用逗号分隔。如：analysis,find_unuse\n");
        printf("    analysis表示解析文件，是一切的前提，解析一次后会留下缓存文件，之后可以不再解析\n");
        printf("    find_unuse表示发现没使用的类\n");
        printf("如：\n");
        printf("code_analysis -config \"一堆路径/config.plist\" -action \"analysis,find_unuse\"\n");
        return 0;
    }
    NSString *config = [argHanlder argForKey:@"config"];
    NSString *action = [argHanlder argForKey:@"action"];
    
    if (!config) {
        config = [argHanlder.fullPath stringByAppendingPathComponent:@"config.plist"];
    }
    if (!action) {
        action = @"find_unuse";
    }
    
    GYDShellCodeAnalysisTools *tools = [[GYDShellCodeAnalysisTools alloc] init];
    tools.configPath = config;
    [tools loadConfig];
    if ([action containsString:@"analysis"]) {
        [tools analysisFiles];
    }
    if ([action containsString:@"find_unuse"]) {
        [tools findUnusedClass];
    }
    printf("结束\n");
    return 0;
}

@end
