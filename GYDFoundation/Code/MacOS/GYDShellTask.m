//
//  GYDShellTask.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/10.
//

#import "GYDShellTask.h"
#import "GYDFoundationPrivateHeader.h"

@interface GYDShellTask ()

@property (nonatomic) NSTask *task;
@property (nonatomic) GYDShellTaskProgressBlock progress;

@property (nonatomic) NSFileHandle *outputFileHandle;

@property (nonatomic) NSFileHandle *errorFileHandle;

@end


@implementation GYDShellTask

/** 同步执行，有输出或错误信息时回调 progress */
- (int)executeShellPath:(nullable NSString *)shellPath command:(nonnull NSString *)command progress:(nullable GYDShellTaskProgressBlock)progress {
    if (_task) {
        GYDFoundationError(@"一次完结前不能进行第二次调用");
    }
    if (shellPath.length < 1) {
        shellPath = @"/bin/zsh";
    }
    _standardOutput = [[NSMutableString alloc] init];
    _standardError = [[NSMutableString alloc] init];
    _progress = progress;
    
    _task = [[NSTask alloc] init];
    _task.launchPath = shellPath;
    _task.arguments = @[@"-c", command];
    
    if (_progress) {
        NSPipe *pipe = [NSPipe pipe];
        _outputFileHandle = [pipe fileHandleForReading];
        _task.standardOutput = pipe;
        
        pipe = [NSPipe pipe];
        _errorFileHandle = [pipe fileHandleForReading];
        _task.standardError = pipe;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readCompletionNotification:) name:NSFileHandleReadCompletionNotification object:_outputFileHandle];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readCompletionNotification:) name:NSFileHandleReadCompletionNotification object:_errorFileHandle];
        [_outputFileHandle readInBackgroundAndNotify];
        [_errorFileHandle readInBackgroundAndNotify];
        
        [_task launch];
        [_task waitUntilExit];
        
        NSData *outputData = nil;
        NSData *errorData = nil;
        if (@available(macOS 10.15, *)) {
            NSError *readError = nil;
            outputData = [_outputFileHandle readDataToEndOfFileAndReturnError:&readError];
            if (!outputData) {
                GYDFoundationWarning(@"standardOutput读取失败：%@", [readError localizedDescription]);
                outputData = [NSData data];
            }
            errorData = [_errorFileHandle readDataToEndOfFileAndReturnError:&readError];
            if (!errorData) {
                GYDFoundationWarning(@"standardError读取失败：%@", [readError localizedDescription]);
                errorData = [NSData data];
            }
        } else {
            outputData = [_outputFileHandle readDataToEndOfFile];
            errorData = [_errorFileHandle readDataToEndOfFile];
        }
        if (outputData.length || errorData.length) {
            NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
            NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];

            [_standardOutput appendString:outputString];
            [_standardError appendString:errorString];
            progress(outputString, errorString);
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } else {
        [_task launch];
        [_task waitUntilExit];
    }
    int status = _task.terminationStatus;
    _task = nil;
    _progress = nil;
    _outputFileHandle = nil;
    _errorFileHandle = nil;
    return status;
}

- (void)readCompletionNotification:(NSNotification *)notification {
    NSData *data = notification.userInfo[NSFileHandleNotificationDataItem];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSFileHandle *fileHandle = notification.object;
    if (fileHandle == _outputFileHandle) {
        [_standardOutput appendString:string];
        if (self.progress) {
            self.progress(string, nil);
        }
    } else if (fileHandle == _errorFileHandle) {
        [_standardError appendString:string];
        if (self.progress) {
            self.progress(nil, string);
        }
    }
    //以后还要检查一下progress()过程中取消等特殊情况
    [fileHandle readInBackgroundAndNotify];
}

+ (int)executeShellPath:(nullable NSString *)shellPath command:(nonnull NSString *)command standardOutput:(out NSString * _Nullable * _Nullable)output standardError:(out NSString * _Nullable * _Nullable)error {
    if (shellPath.length < 1) {
        shellPath = @"/bin/zsh";
    }
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = shellPath;
    task.arguments = @[@"-c", command];
    
    NSFileHandle *outputFileHandle = nil;
    NSFileHandle *errorFileHandle = nil;
    if (output) {
        NSPipe *pipe = [NSPipe pipe];
        outputFileHandle = [pipe fileHandleForReading];
        task.standardOutput = pipe;
    }
    if (error) {
        NSPipe *pipe = [NSPipe pipe];
        errorFileHandle = [pipe fileHandleForReading];
        task.standardError = pipe;
    }
    
    [task launch];
    [task waitUntilExit];
    
    if (@available(macOS 10.15, *)) {
        NSError *readError = nil;
        if (output) {
            NSData *data = [outputFileHandle readDataToEndOfFileAndReturnError:&readError];
            if (!data) {
                GYDFoundationWarning(@"standardOutput读取失败：%@", [readError localizedDescription]);
                data = [NSData data];
            }
            *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (error) {
            NSData *data = [errorFileHandle readDataToEndOfFileAndReturnError:&readError];
            if (!data) {
                GYDFoundationWarning(@"standardError读取失败：%@", [readError localizedDescription]);
                data = [NSData data];
            }
            *error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    } else {
        if (output) {
            NSData *data = [outputFileHandle readDataToEndOfFile];
            *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (error) {
            NSData *data = [errorFileHandle readDataToEndOfFile];
            *error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    
    return task.terminationStatus;
};

@end
