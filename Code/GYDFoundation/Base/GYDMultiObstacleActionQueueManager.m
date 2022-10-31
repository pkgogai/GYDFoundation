//
//  GYDMultiObstacleActionQueueManager.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/2/1.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDMultiObstacleActionQueueManager.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDMultiObstacleActionQueueManager
{
    NSMutableDictionary<NSString *, GYDMultiObstacleActionQueue *> *_queueDictionary;
}
/** 来一个全局默认的，应该也没必要使用多个吧 */
+ (nonnull instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static GYDMultiObstacleActionQueueManager *defaultManager = nil;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queueDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

/** 是否有阻碍 */
- (BOOL)hasObstacleForBrakeIdentifier:(nonnull NSString *)brakeIdentifier {
    if (!brakeIdentifier) {
        GYDFoundationError(@"brakeIdentifier 不能为空");
        return NO;
    }
    return _queueDictionary[brakeIdentifier].hasObstacle;
}

/** 添加阻碍 */
- (void)addObstacle:(nullable NSString *)obstacle forBrakeIdentifier:(nonnull NSString *)brakeIdentifier {
    if (!brakeIdentifier) {
        GYDFoundationError(@"brakeIdentifier 不能为空");
        return;
    }
    GYDMultiObstacleActionQueue *queue = _queueDictionary[brakeIdentifier];
    if (!queue) {
        queue = [[GYDMultiObstacleActionQueue alloc] init];
        _queueDictionary[brakeIdentifier] = queue;
    }
    
    [queue addObstacle:obstacle];
}

/** 移除阻碍，type=nil表示移除全部 */
- (void)removeObstacle:(nullable NSString *)obstacle forBrakeIdentifier:(nonnull NSString *)brakeIdentifier {
    if (!brakeIdentifier) {
        GYDFoundationError(@"brakeIdentifier 不能为空");
        return;
    }
    GYDMultiObstacleActionQueue *queue = _queueDictionary[brakeIdentifier];
    if (!queue) {
        return;
    }
    [queue removeObstacle:obstacle];
    //removeObstacle有可能触发action，这中间不一定会执行什么代码呢。所以后面的代码不要依赖前面。
    queue = _queueDictionary[brakeIdentifier];
    if (!queue) {
        return;
    }
    if (![queue hasObstacle]) {
        [_queueDictionary removeObjectForKey:brakeIdentifier];
    }
}

/** 添加新事件，当没有阻碍（或者所有阻碍都被移除）时执行方法 */
- (void)addAction:(nonnull GYDMultiObstacleActionBlock)action forBrakeIdentifier:(nonnull NSString *)brakeIdentifier {
    if (!brakeIdentifier) {
        GYDFoundationError(@"brakeIdentifier 不能为空");
        return;
    }
    if (!action) {
        GYDFoundationError(@"GYDMultiObstacleActionBlock 不能为空");
        return;
    }
    GYDMultiObstacleActionQueue *queue = _queueDictionary[brakeIdentifier];
    if (queue) {
        [queue addAction:action];
        return;
    }
    
    action = action;
    action();
}

/** 同一个key只有一个Action，重复的会被覆盖，并且移动到队尾执行 */
- (void)addUniqueAction:(nullable GYDMultiObstacleActionBlock)action forKey:(nonnull NSString *)key brakeIdentifier:(nonnull NSString *)brakeIdentifier {
    if (!brakeIdentifier) {
        GYDFoundationError(@"brakeIdentifier 不能为空");
        return;
    }
    GYDMultiObstacleActionQueue *queue = _queueDictionary[brakeIdentifier];
    if (queue) {
        [queue addUniqueAction:action forKey:key];
        return;
    }
    if (action) {
        action = action;
        action();
    }
}

@end
