//
//  GYDShellArgKeyValueHandler.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellArgKeyValueHandler.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDShellArgKeyValueHandler
{
    NSMutableDictionary *_dic;
}
- (instancetype)initWithArgc:(int)argc argv:(const char **)argv {
    self = [super initWithArgc:argc argv:argv];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
        for (NSInteger i = 1; i + 1 < argc; i += 2) {
            if (argv[i][0] != '-') {
                GYDFoundationError(@"key必须以-开头：%s", argv[i]);
                return nil;
            }
            NSString *key = [NSString stringWithUTF8String:argv[i] + 1];
            NSString *value = [NSString stringWithUTF8String:argv[i + 1]];
            _dic[key] = value;
        }
    }
    return self;
}

- (nullable NSString *)argForKey:(nonnull NSString *)key {
    return _dic[key];
}

- (NSDictionary *)argDictionary {
    return _dic;
}

@end
