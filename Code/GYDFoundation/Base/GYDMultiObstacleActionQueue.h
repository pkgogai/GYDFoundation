//
//  GYDMultiObstacleActionQueue.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/2/1.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYDMultiObstacleActionQueue;

typedef void(^GYDMultiObstacleActionBlock)(void);
typedef void(^GYDMultiObstacleActionValueChangedBlock)(GYDMultiObstacleActionQueue * _Nonnull queue, BOOL hasObstacle);

/**
 可以被阻碍执行的操作队列，在有阻碍时暂停，在没有阻碍时执行操作。
 是同步处理，与线程无关。
*/
@interface GYDMultiObstacleActionQueue : NSObject

/** 是否有阻碍 */
- (BOOL)hasObstacle;

/** 添加阻碍 */
- (void)addObstacle:(nullable NSString *)obstacle;

/** 移除阻碍，obstacle=nil表示移除全部 */
- (void)removeObstacle:(nullable NSString *)obstacle;

/** 添加新事件，当没有阻碍（或者所有阻碍都被移除）时执行方法 */
- (void)addAction:(nonnull GYDMultiObstacleActionBlock)action;

/** 同一个key只有一个Action，重复的会被覆盖，并且移动到队尾执行，action == nil 表示删除 */
- (void)addUniqueAction:(nullable GYDMultiObstacleActionBlock)action forKey:(nonnull NSString *)key;

/** 阻碍状态改变时调用 */
@property (nonatomic, nullable) GYDMultiObstacleActionValueChangedBlock valueChangedAction;

/** 设置阻碍状态改变时调用的block，同时要不要现在就调用一次 */
- (void)setValueChangedAction:(GYDMultiObstacleActionValueChangedBlock _Nullable)valueChangedAction callNow:(BOOL)callNow;


@end
