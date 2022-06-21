//
//  GYDShellGitCommitCheckToolsDemo.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDShellGitCommitCheckToolsDemo.h"
#import "GYDFoundationPrivateHeader.h"
#import "GYDShellArgKeyValueHandler.h"
#import "GYDShellGitCommitCheckTools.h"
#import "GYDShellFeishuToolsDemo.h"

@implementation GYDShellGitCommitCheckToolsDemo

+ (int)exampleMainArgc:(int)argc argv:(const char * _Nonnull * _Nonnull)argv {
    
    GYDShellArgKeyValueHandler *argHanlder = [[GYDShellArgKeyValueHandler alloc] initWithArgc:argc argv:argv];
    if ([argHanlder argCount] == 1) {
        printf("\n------- git提交检查 --------\n");
        printf("版本：1.2.2, %s\n", __DATE__);
        printf(
               "参数如下\n"
               "    -git_path git项目路径，在这里检查文件变更。\n"
               "    -feishu 飞书配置路径。\n"
               "    -notes 记录release节点的文件路径，也别用作配置文件。\n"
               "    -send_to 飞书消息发给谁，例如\"APP组\"。\n"
               "如：\n"
               "    git_commit_check -path \"git/gyd-ios-app\" -feishu \"~/Tools/config/feishu.plist\" -notes \"~/Tools/config/ios_app.plist\" -send_to \"APP组\"\n"
               "\n"
               "1.2.2:\n"
               "    fix:代码以“#pragma”开头时，没有计算行数\n"
               "1.2.1:\n"
               "    配置文件中添加文件名单设置，如:config.checkList添加“*.h”则检查所有头文件。\n"
               "    配置文件中添加黑名单设置，如:config.whiteList添加“*View.h”则“TestView.h”不会被检查。\n"
               "1.2.0\n"
               "    飞书信息提取到配置文件里，与其它发飞书消息的工具共同维护同一个配置文件。\n"
               "    将主要参数放到配置文件里，方便不同的项目有不同的参数。\n"
               );
        return 0;
    }
    
    NSString *gitPath = [argHanlder argForKey:@"git_path"];
    NSString *feishuConfigPath = [argHanlder argForKey:@"feishu"];
    NSString *notes = [argHanlder argForKey:@"notes"];
    NSString *sendTo = [argHanlder argForKey:@"send_to"];
    if (gitPath.length < 1) {
        GYDFoundationWarning(@"缺少git_path");
        return 1;
    }
    if (notes.length < 1) {
        GYDFoundationWarning(@"缺少notes");
        return 1;
    }
    
    GYDShellFeishuToolsDemo *feishuTools = [GYDShellFeishuToolsDemo sharedInstance];
    [feishuTools setConfigFilePath:feishuConfigPath];
    
    GYDShellGitCommitCheckTools *tools = [[GYDShellGitCommitCheckTools alloc] init];
    tools.notesPath = notes;
    tools.gitRootPath = gitPath;
    tools.sendTo = sendTo;
    BOOL r = [tools check];
    
    printf("结束\n");
    return r;
}

@end
