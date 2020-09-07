//
//  GYDShellArgHanlder.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellArgHanlder.h"

@implementation GYDShellArgHanlder
{
    int _argc;
    const char **_argv;
    NSString *_fullPath;
}

- (instancetype)initWithArgc:(int)argc argv:(const char * _Nonnull *)argv {
    self = [super init];
    if (self) {
        _argc = argc;
        _argv = argv;
        if (_argc > 0) {
            _fullPath = [NSString stringWithUTF8String:_argv[0]];
        }
    }
    return self;
}

- (NSString *)fullPath {
    return _fullPath;
}

- (NSString *)directoryPath {
    return [_fullPath stringByDeletingLastPathComponent];
}

- (NSString *)fileName {
    return [_fullPath lastPathComponent];
}

- (NSInteger)argCount {
    return _argc;
}
/** 通过下标获取参数。下标从0开始，（0对应argv[1]） */
- (NSString *)argAtIndex:(NSInteger)index {
    if (index < 0) {
        return nil;
    }
    if (index >= _argc) {
        return nil;
    }
    return [NSString stringWithUTF8String:_argv[index]];
}

@end
