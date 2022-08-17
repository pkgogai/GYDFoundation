//
//  GYDMultiObstacleActionQueue.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/2/1.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDMultiObstacleActionQueue.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDMultiObstacleActionQueue
{
    NSMutableSet *_obstacleSet;
    NSMutableArray *_actionArray;   //GYDMultiObstacleActionBlock 和 key
    NSMutableDictionary<NSString *, GYDMultiObstacleActionBlock> *_uniqueActionDic;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _obstacleSet = [NSMutableSet set];
        _actionArray = [NSMutableArray array];
        _uniqueActionDic = [NSMutableDictionary dictionary];
    }
    return self;
}
/** 是否有阻碍 */
- (BOOL)hasObstacle {
    return [_obstacleSet count] > 0;
}

/** 添加阻碍 */
- (void)addObstacle:(nullable NSString *)obstacle {
    [_obstacleSet addObject:obstacle ?: [NSNull null]];
}

/** 移除阻碍，obstacle=nil表示移除全部 */
- (void)removeObstacle:(nullable NSString *)obstacle {
    if (obstacle) {
        [_obstacleSet removeObject:obstacle];
    } else {
        [_obstacleSet removeAllObjects];
    }
    while (_obstacleSet.count < 1 && _actionArray.count > 0) {
        id key = _actionArray[0];
        [_actionArray removeObjectAtIndex:0];
        
        GYDMultiObstacleActionBlock action = NULL;
        if ([key isKindOfClass:[NSString class]]) {
            action = _uniqueActionDic[key];
            [_uniqueActionDic removeObjectForKey:key];
        } else {
            action = (GYDMultiObstacleActionBlock)key;
        }
        if (action) {
            action();
        }
    }
}

/** 添加新事件，当没有阻碍（或者所有阻碍都被移除）时执行方法 */
- (void)addAction:(nonnull GYDMultiObstacleActionBlock)action {
    if (!action) {
        GYDFoundationError(@"GYDMultiObstacleActionBlock 不能为空");
        return;
    }
    if (_obstacleSet.count > 0) {
        [_actionArray addObject:action];
        return;
    }
    action = action;
    action();
}

/** 同一个key只有一个Action，重复的会被覆盖，并且移动到队尾执行 */
- (void)addUniqueAction:(nonnull GYDMultiObstacleActionBlock)action forKey:(nonnull NSString *)key {
    if (!action) {
        GYDFoundationError(@"GYDMultiObstacleActionBlock 不能为空");
        return;
    }
    if (!key) {
        GYDFoundationError(@"key不能为空");
        return;
    }
    if (_obstacleSet.count > 0) {
//        if (!_uniqueActionDic[key]) {
//            [_actionArray addObject:key];
//        }
        [_actionArray removeObject:key];
        [_actionArray addObject:key];
        _uniqueActionDic[key] = action;
        return;
    }
    
    action = action;
    action();
}

@end
