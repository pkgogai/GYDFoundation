//
//  NSObject+GYDNotificationBlock.h
//  GYDDevelopment
//
//  Created by gongyadong on 2020/12/2.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 通知 block形式，随self而释放，还没测过
 */
@interface NSObject (GYDNotificationAutoRemove)

- (void)gyd_notificationCenter:(nullable NSNotificationCenter *)notificationCenter addObserverForName:(nullable NSString *)name object:(nullable id)obj usingBlock:(void (^)(NSNotification *note))block;

//self被释放时会自动调用
- (void)gyd_notificationCenterRemoveObserver:(nullable NSNotificationCenter *)notificationCenter;

#pragma mark - defaultCenter 等同于上面 notificationCenter 传 nil

- (void)gyd_defaultNotificationCenterAddObserverForName:(nullable NSString *)name object:(nullable id)obj usingBlock:(void (^)(NSNotification *note))block;

- (void)gyd_defaultNotificationCenterRemoveObserver;

#pragma mark - all
- (void)gyd_allNotificationRemoveObserver;

@end

NS_ASSUME_NONNULL_END
