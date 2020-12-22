//
//  GYDShellTinifyToolsDemo.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/12/22.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellTinifyToolsDemo.h"
#import "GYDShellTinifyTools.h"
#import "GYDShellArgKeyValueHandler.h"

@implementation GYDShellTinifyToolsDemo

+ (int)exampleMainWithArgc:(int)argc argv:(const char * _Nonnull * _Nonnull)argv; {
    GYDShellArgKeyValueHandler *argHanlder = [[GYDShellArgKeyValueHandler alloc] initWithArgc:argc argv:argv];
    if ([argHanlder argCount] == 1) {
        printf("\n------- 压缩图片 --------\n");
        printf("版本：1, %s\n", __DATE__);
        printf("参数如下\n");
        printf("-key tinify上申请的key，多个key用逗号分隔\n");
        printf("-path 图片目录，深度遍历\n");
        printf("-log 记录文件，放在git仓库中同步\n");
        printf("如：\n");
        printf("compress_image -key \"aaaaa,bbbbb\" -path \"Images.xcassets的路径\" -log \"plist文件的路径\"\n");
        return 0;
    }
    NSString *key = [argHanlder argForKey:@"key"];
    NSString *path = [argHanlder argForKey:@"path"];
    NSString *log = [argHanlder argForKey:@"log"];
    if (key.length < 1) {
        NSLog(@"不加参数直接运行查看说明");
        return 1;
    }
    if (path.length < 1) {
        NSLog(@"不加参数直接运行查看说明");
        return 1;
    }
    GYDShellTinifyTools *tools = [[GYDShellTinifyTools alloc] init];
    tools.apiKeys = [key componentsSeparatedByString:@","];
    BOOL r = [tools compressImagesAtPath:path resursive:YES historyFile:log];
    if (!r) {
        return 1;
    }
    return 0;
}

@end
