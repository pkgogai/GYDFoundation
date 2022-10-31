//
//  GYDLogExample.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDemoPlacehold.h"

@implementation GYDLogExample

+ (void)ready {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"test.txt"];
    NSString *errMessage = nil;
    if ([GYDLog setLogFilePath:path errorMessage:&errMessage]) {
        NSLog(@"设置路径成功：%@", path);
    } else {
        NSLog(@"设置路径失败：%@", errMessage);
    }
    
    
    
#if ExampleIsDevelopment == 1
    
    GYDLog.lvCount = 5;
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = YES;
        setting.cachedUbound = 300;
        setting.prefix = "[****ERROR****:]";
        setting;
    }) forLv:0];
    
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = YES;
        setting.cachedUbound = 250;
        setting.prefix = "[!!!WARING!!!:]";
        setting;
    }) forLv:1];
    
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = YES;
        setting.cachedUbound = 200;
        setting.prefix = "[INFO:]";
        setting;
    }) forLv:2];
    
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = YES;
        setting.cachedUbound = 100;
        setting.prefix = "[VERBOSE:]";
        setting;
    }) forLv:3];
    
    [GYDLog setLogSetting:({
        GYDLogSetting setting;
        setting.print = YES;
        setting.save = YES;
        setting.cachedUbound = 100;
        setting.prefix = "[DEBUG:]";
        setting;
    }) forLv:4];
    
    [GYDLog setCheckLogType:YES];
    
    GYDLogSwitch(YES);
    GYDLogHttpSwitch(YES);
    
#else
    
    GYDLog.lvCount = 4;
    [GYDLog setLogSetting:({
        GYDLogSettings setting;
        setting.print = NO;
        setting.save = YES;
        setting.cachedUbound = 50;
        setting.prefix = "[****ERROR****:]";
        setting;
    }) forLv:0];
    
    [GYDLog setLogSetting:({
        GYDLogSettings setting;
        setting.print = NO;
        setting.save = YES;
        setting.cachedUbound = 50;
        setting.prefix = "[!!!WARING!!!:]";
        setting;
    }) forLv:1];
    
    [GYDLog setLogSetting:({
        GYDLogSettings setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 50;
        setting.prefix = "[INFO:]";
        setting;
    }) forLv:2];
    
    [GYDLog setLogSetting:({
        GYDLogSettings setting;
        setting.print = NO;
        setting.save = NO;
        setting.cachedUbound = 50;
        setting.prefix = "[VERBOSE:]";
        setting;
    }) forLv:3];
    
    [GYDLog setCheckLogType:NO];
#endif
    
}

+ (void)test {
    GYDLogHttpSwitch(YES);  //打开 GYDLogHttpXXX 的LOG
    
    GYDLogHttpDebug();   //空log，只包含时间和函数名，
    GYDLogHttpInfo("记录一下:%@", @"");
    GYDLogHttpDebug("调试一下");
    GYDLogWarning("警告一下");
    
    //好多log，眼睛花了
    GYDLogHttpSwitch(NO);   //把不相关的类型关掉，世界一下子清净了
    
}

@end
