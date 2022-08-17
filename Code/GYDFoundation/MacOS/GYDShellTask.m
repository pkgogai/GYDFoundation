//
//  GYDShellTask.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/8/10.
//

#import "GYDShellTask.h"
#import "GYDFoundationPrivateHeader.h"

@interface GYDShellTask ()
{
    NSMutableData *_outputTmpData;
    NSMutableData *_errorTmpData;
    //记录一下输出是否都处理完了，经过测试，output和error必须都返回0长度时，才能保证处理完毕，所以需要分别记录output和error
    BOOL _outputDidEnd;
    BOOL _errorDidEnd;
}
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
    _outputTmpData = nil;
    _errorTmpData = nil;
    _outputDidEnd = NO;
    _errorDidEnd = NO;
    _progress = progress;
    
    _task = [[NSTask alloc] init];
    _task.launchPath = shellPath;
    
    if (@available(macOS 10.13, *)) {
        if (self.currentDirectoryURL) {
            _task.currentDirectoryURL = self.currentDirectoryURL;
        }
    }
    
    _task.arguments = @[@"-c", command];
    
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
    while (!_outputDidEnd || !_errorDidEnd) {
        BOOL r = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        if (!r) {
            break;
        }
    }
    if (_outputTmpData && _errorTmpData) {
        GYDFoundationError(@"命令行执行结果组装字符串失败:output:%@,error:%@", _outputTmpData, _errorTmpData);
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    int status = _task.terminationStatus;
    _task = nil;
    _progress = nil;
    _outputFileHandle = nil;
    _errorFileHandle = nil;
    return status;
}

- (void)readCompletionNotification:(NSNotification *)notification {
    NSData *data = notification.userInfo[NSFileHandleNotificationDataItem];
    NSFileHandle *fileHandle = notification.object;
    
    if (fileHandle == _outputFileHandle) {
        if (data.length < 1) {
            _outputDidEnd = YES;
            return;
        }
        if (_outputTmpData) {
            [_outputTmpData appendData:data];
            NSString *string = [[NSString alloc] initWithData:_outputTmpData encoding:NSUTF8StringEncoding];
            if (string) {
                _outputTmpData = nil;
                [_standardOutput appendString:string];
                if (self.progress) {
                    self.progress(string, nil);
                }
            }
        } else {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (string) {
                [_standardOutput appendString:string];
                if (self.progress) {
                    self.progress(string, nil);
                }
            } else {
                _outputTmpData = [NSMutableData dataWithData:data];
            }
        }
    } else if (fileHandle == _errorFileHandle) {
        if (data.length < 1) {
            _errorDidEnd = YES;
            return;
        }
        if (_errorTmpData) {
            [_errorTmpData appendData:data];
            NSString *string = [[NSString alloc] initWithData:_errorTmpData encoding:NSUTF8StringEncoding];
            if (string) {
                _errorTmpData = nil;
                [_standardError appendString:string];
                if (self.progress) {
                    self.progress(nil, string);
                }
            }
        } else {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (string) {
                [_standardError appendString:string];
                if (self.progress) {
                    self.progress(nil, string);
                }
            } else {
                _errorTmpData = [NSMutableData dataWithData:data];
            }
        }
    } else {
        return;
    }
    //以后还要检查一下progress()过程中取消等特殊情况
    [fileHandle readInBackgroundAndNotify];
}



+ (int)executeShellPath:(nullable NSString *)shellPath command:(nonnull NSString *)command standardOutput:(out NSString * _Nullable * _Nullable)output standardError:(out NSString * _Nullable * _Nullable)error {
    GYDShellTask *task = [[self alloc] init];
    int r = [task executeShellPath:shellPath command:command progress:nil];
    if (output) {
        *output = task.standardOutput;
    }
    if (error) {
        *error = task.standardError;
    }
    return r;
}

@end
