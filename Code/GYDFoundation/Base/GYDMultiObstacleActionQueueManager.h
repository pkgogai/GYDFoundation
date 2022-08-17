//
//  GYDMultiObstacleActionQueueManager.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/2/1.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDMultiObstacleActionQueue.h"

/**
 管理多个GYDMultiObstacleActionQueue的工具
 让没有 GYDMultiObstacleActionQueue 与 有GYDMultiObstacleActionQueue但没有阻碍 效果等同。
 使得没有阻碍的GYDMultiObstacleActionQueue可以及时释放掉。
*/
@interface GYDMultiObstacleActionQueueManager : NSObject

/** 来一个全局默认的，应该也没必要使用多个吧 */
+ (nonnull instancetype)defaultManager;

/** 是否有阻碍 */
- (BOOL)hasObstacleForBrakeIdentifier:(nonnull NSString *)brakeIdentifier;

/** 添加阻碍 */
- (void)addObstacle:(nullable NSString *)obstacle forBrakeIdentifier:(nonnull NSString *)brakeIdentifier;

/** 移除阻碍，type=nil表示移除全部 */
- (void)removeObstacle:(nullable NSString *)obstacle forBrakeIdentifier:(nonnull NSString *)brakeIdentifier;

/** 添加新事件，当没有阻碍（或者所有阻碍都被移除）时执行方法 */
- (void)addAction:(nonnull GYDMultiObstacleActionBlock)action forBrakeIdentifier:(nonnull NSString *)brakeIdentifier;

/** 同一个key只有一个Action，重复的会被覆盖，并且移动到队尾执行 */
- (void)addUniqueAction:(nonnull GYDMultiObstacleActionBlock)action forKey:(nonnull NSString *)key brakeIdentifier:(nonnull NSString *)brakeIdentifier;

@end
