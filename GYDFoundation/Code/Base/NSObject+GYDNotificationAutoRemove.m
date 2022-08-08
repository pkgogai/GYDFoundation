//
//  NSObject+GYDNotificationBlock.m
//  GYDDevelopment
//
//  Created by gongyadong on 2020/12/2.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "NSObject+GYDNotificationAutoRemove.h"
#import <objc/runtime.h>

@interface NSObjectGYDNotificationAutoRemoveHolder : NSObject

@property (nonatomic, strong) id<NSObject> observer;
@property (nonatomic, strong) NSNotificationCenter *notifacationCenter;

@end


@implementation NSObjectGYDNotificationAutoRemoveHolder

- (void)dealloc
{
    [_notifacationCenter removeObserver:_observer];
}

@end

@implementation NSObject (GYDNotificationAutoRemove)

static char GYDNotificationAutoRemoveHolderKey;

- (void)gyd_notificationCenter:(NSNotificationCenter *)notificationCenter addObserverForName:(nullable NSString *)name object:(nullable id)obj usingBlock:(void (^)(NSNotification *note))block {
    if (!notificationCenter) {
        notificationCenter = [NSNotificationCenter defaultCenter];
    }
    NSMutableArray *array = objc_getAssociatedObject(self, &GYDNotificationAutoRemoveHolderKey);
    if (!array) {
        array = [NSMutableArray arrayWithCapacity:1];
        objc_setAssociatedObject(self, &GYDNotificationAutoRemoveHolderKey, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSObjectGYDNotificationAutoRemoveHolder *holder = [[NSObjectGYDNotificationAutoRemoveHolder alloc] init];
    [array addObject:holder];
    holder.notifacationCenter = notificationCenter;
    holder.observer = [notificationCenter addObserverForName:name object:obj queue:nil usingBlock:block];
}

//dealloc时会自动调用
- (void)gyd_notificationCenterRemoveObserver:(NSNotificationCenter *)notificationCenter {
    if (!notificationCenter) {
        notificationCenter = [NSNotificationCenter defaultCenter];
    }
    NSMutableArray *array = objc_getAssociatedObject(self, &GYDNotificationAutoRemoveHolderKey);
    for (NSInteger i = array.count - 1; i >= 0; i--) {
        NSObjectGYDNotificationAutoRemoveHolder *holder = array[i];
        if (holder.notifacationCenter == notificationCenter) {
            [array removeObjectAtIndex:i];
        }
    }
}

#pragma mark - defaultCenter

- (void)gyd_defaultNotificationCenterAddObserverForName:(nullable NSString *)name object:(nullable id)obj usingBlock:(void (^)(NSNotification *note))block {
    [self gyd_notificationCenter:nil addObserverForName:name object:obj usingBlock:block];
}

- (void)gyd_defaultNotificationCenterRemoveObserver {
    [self gyd_notificationCenterRemoveObserver:nil];
}

#pragma mark - all
- (void)gyd_allNotificationRemoveObserver {
    objc_setAssociatedObject(self, &GYDNotificationAutoRemoveHolderKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
