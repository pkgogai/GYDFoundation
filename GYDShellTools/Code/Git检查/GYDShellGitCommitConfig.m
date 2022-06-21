//
//  GYDShellGitCommitConfig.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/1/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//
#define GYD_FOUNDATION_DEVELOPMENT 1

#import "GYDShellGitCommitConfig.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDShellGitCommitConfig
{
    NSString *_filePath;
    NSMutableDictionary *_root;
    NSMutableDictionary *_configDic;
    NSNumber *_weeks;
    NSArray *_brachArray;
    //检查名单
    NSArray *_checkList;
    //白名单
    NSArray *_whiteList;
    NSMutableDictionary *_releaseNotesDic;
    NSMutableSet *_allCommits;
    BOOL _didChanged;
}

- (instancetype)initWithFileAtPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _filePath = filePath;
        _root = (NSMutableDictionary *)[[NSDictionary dictionaryWithContentsOfFile:_filePath] gyd_recursiveMutableCopyIfNeed];
        if (!_root) {
            _root = [NSMutableDictionary dictionary];
        }
        
        _configDic = (NSMutableDictionary *)[GYDDictionary dictionaryForKey:@"config" inDictionary:_root];
        if (!_configDic) {
            _configDic = [NSMutableDictionary dictionary];
            _root[@"config"] = _configDic;
            _didChanged = YES;
        }
        
        _weeks = [GYDDictionary numberWithLongLongValueObjectForKey:@"log_weeks" inDictionary:_configDic];
        if (!_weeks) {
            _weeks = @(5);
            _configDic[@"log_weeks"] = _weeks;
            _didChanged = YES;
        }
        
        _brachArray = [GYDDictionary arrayForKey:@"brach" inDictionary:_configDic];
        for (NSInteger i = 0; i < _brachArray.count; i++) {
            if (![_brachArray[i] isKindOfClass:[NSString class]]) {
                [(NSMutableArray *)_brachArray removeObjectAtIndex:i];
                _didChanged = YES;
                i--;
            }
        }
        
        _checkList = [GYDDictionary arrayForKey:@"checkList" inDictionary:_configDic];
        for (NSInteger i = 0; i < _checkList.count; i++) {
            if (![_checkList[i] isKindOfClass:[NSString class]]) {
                [(NSMutableArray *)_checkList removeObjectAtIndex:i];
                _didChanged = YES;
                i--;
            }
        }
        
        _whiteList = [GYDDictionary arrayForKey:@"whileList" inDictionary:_configDic];
        for (NSInteger i = 0; i < _whiteList.count; i++) {
            if (![_whiteList[i] isKindOfClass:[NSString class]]) {
                [(NSMutableArray *)_whiteList removeObjectAtIndex:i];
                _didChanged = YES;
                i--;
            }
        }
        
        if (!_brachArray.count) {
            _brachArray = @[@"master", @"origin/dev", @"origin/release_*"];
            _configDic[@"brach"] = _brachArray;
            _didChanged = YES;
        }
        
        _releaseNotesDic = (NSMutableDictionary *)[GYDDictionary dictionaryForKey:@"notes" inDictionary:_root];
        if (!_releaseNotesDic) {
            _releaseNotesDic = [NSMutableDictionary dictionary];
            _root[@"notes"] = _releaseNotesDic;
            _didChanged = YES;
        }
        
        _allCommits = [NSMutableSet set];
        [_releaseNotesDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                [_allCommits addObjectsFromArray:obj];
            }
        }];
        
        
        [self saveIfNeeded];
        
    }
    return self;
}

- (NSInteger)weeks {
    return [_weeks integerValue];
}

/** 分支是否符合记录条件 */
- (BOOL)matchBrach:(NSString *)brach {
    for (NSString *m in _brachArray) {
        if ([brach gyd_matchingWildcardString:m]) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)containsCommit:(NSString *)commit {
    return [_allCommits containsObject:commit];
}

- (void)addCommit:(NSString *)commit forBrach:(NSString *)brach {
    NSMutableArray *array = (NSMutableArray *)[GYDDictionary arrayForKey:brach inDictionary:_releaseNotesDic];
    if (!array) {
        array = [NSMutableArray array];
        _releaseNotesDic[brach] = array;
    }
    
    if (![array containsObject:commit]) {
        [array addObject:commit];
    }
    
    _didChanged = YES;
//    [_allCommits addObject:commit];
}

/** 判断文件是否需要检查 */
- (BOOL)matchFilePath:(NSString *)filePath {
    if ([filePath hasPrefix:@"/"]) {
        filePath = [filePath substringFromIndex:1];
    }
    //跳过白名单
    for (NSString *white in _whiteList) {
        if ([filePath gyd_matchingWildcardString:white]) {
            GYDFoundationInfo(@"匹配白名单，跳过[%@]：%@", white ,filePath);
            return NO;
        }
    }
    //符合检查名单的才检查
    for (NSString *check in _checkList) {
        if ([filePath gyd_matchingWildcardString:check]) {
            GYDFoundationInfo(@"匹配检查名单，进行检查[%@]：%@", check ,filePath);
            return YES;
        }
    }
    GYDFoundationInfo(@"不匹配名单，跳过：%@" ,filePath);
    return NO;
}

- (void)saveIfNeeded {
    if (_didChanged) {
        [_root writeToFile:_filePath atomically:YES];
    }
}

@end
