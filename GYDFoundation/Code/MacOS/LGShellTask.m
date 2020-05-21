//
//  LGShellTask.m
//  lib-base
//
//  Created by 宫亚东 on 2019/8/21.
//

#import "LGShellTask.h"

@implementation LGShellTask

+ (int)executeShellCommand:(nonnull NSString *)command output:(out NSString * _Nullable * _Nullable)output {
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/sh";
    task.arguments = @[@"-c", command];
    task.standardOutput = pipe;
    
    [task launch];
    
    [task waitUntilExit];
    
    NSData *data = [fileHandle readDataToEndOfFile];
    if (output) {
        *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return task.terminationStatus;
};

@end
