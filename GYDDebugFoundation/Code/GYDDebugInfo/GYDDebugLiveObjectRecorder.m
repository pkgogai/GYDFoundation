//
//  GYDDebugLiveObjectRecorder.m
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/7/21.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugLiveObjectRecorder.h"
#include "gyd_class_property.h"

static NSRecursiveLock *lock = NULL;
static BOOL ignore = NO;
static NSMutableSet *set = NULL;
static BOOL isPause = NO;
static BOOL isStop = NO;

@implementation GYDDebugLiveObjectRecorder

/** 重新开始（清空）记录 */
+ (void)restart {
    
    [lock lock];
    set = [NSMutableSet set];
    isStop = NO;
    [lock unlock];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSRecursiveLock alloc] init];
        
        isStop = NO;
        
        gyd_exchangeSelector([NSObject class], @selector(init), self, @selector(init_liveObjRecorder));
        gyd_exchangeSelector([NSObject class], NSSelectorFromString(@"dealloc"), self, @selector(dealloc_liveObjRecorder));
    });
}

/** 是否暂停记录新对象 */
+ (void)setPause:(BOOL)pause {
    [lock lock];
    isPause = pause;
    [lock unlock];
}

+ (BOOL)pause {
    return isPause;
}

/** 清空记录并停止 */
+ (void)clearAndStop {
    [lock lock];
    set = nil;
    isStop = NO;
    [lock unlock];
}

/**
 获取记录着的对象
 警告：这些对象不一定是在什么线程使用，出现线程问题实属正常。
 */
+ (NSSet<NSObject *> *)liveObjects {
    NSMutableSet *result = [NSMutableSet set];
    [lock lock];
    if (!ignore) {
        ignore = YES;
        for (NSNumber *p in set) {
            NSObject *obj = (__bridge NSObject *)(CFTypeRef)[p longLongValue];
            [result addObject:obj];
        }
        ignore = NO;
    }
    [lock unlock];
    return result;
}

/** 打印记录的情况 */
+ (void)print {
    [lock lock];
    if (!ignore) {
        ignore = YES;
        NSMutableDictionary<NSString *, NSNumber *> *dic = [NSMutableDictionary dictionary];
        for (NSNumber *p in set) {
            __unsafe_unretained NSObject *obj = (__bridge NSObject *)(CFTypeRef)[p longLongValue];
            NSString *k = NSStringFromClass(obj.class);
            dic[k] = @([dic[k] integerValue] + 1);
        }
        printf("存活对象：\n%s\n", [[dic description] cStringUsingEncoding:NSUTF8StringEncoding]);
        ignore = NO;
    }
    [lock unlock];
}

#pragma mark - 替换的方法

- (instancetype)init_liveObjRecorder
{
    self = [self init_liveObjRecorder];
    if (self) {
        if (!isStop) {
            [lock lock];
            if (!ignore && !isStop && !isPause) {
                ignore = YES;
                long long p = (long long)self;
                [set addObject:@(p)];
                ignore = NO;
            }
            [lock unlock];
        }
    }
    return self;
}

- (void)dealloc_liveObjRecorder {
    if (!isStop) {
        [lock lock];
        if (!ignore && !isStop) {
            ignore = YES;
            long long p = (long long)self;
            [set removeObject:@(p)];
            ignore = NO;
        }
        [lock unlock];
    }
    [self dealloc_liveObjRecorder];
}


@end
