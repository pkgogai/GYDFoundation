//
//  GYDUnreadCountManager.m
//  GYDDevelopment
//
//  Created by 宫亚东 on 2018/10/20.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDUnreadCountManager.h"
#import "GYDFoundationPrivateHeader.h"

NSString * const GYDUnreadCountChangedNotification = @"GYDUnreadCountChangedNotification";

@implementation GYDUnreadCountManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _superTypes = [NSMutableDictionary dictionaryWithCapacity:7];
        _subTypes = [NSMutableDictionary dictionaryWithCapacity:7];
        _values = [NSMutableDictionary dictionaryWithCapacity:7];
        _cachedRecursiveSubTypes = [NSMutableDictionary dictionaryWithCapacity:7];
        _cachedRecursiveSuperTypes = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    return self;
}

#pragma mark - 值

/** 设置状态值 */
- (void)setValue:(NSInteger)value forType:(nonnull NSString *)type {
    if (!type) {
        GYDFoundationError(@"type不能为nil");
        return;
    }
    
    NSSet *superTypeSet = _cachedRecursiveSuperTypes[type];
    NSNumber *oldValue = _values[type];
    //值没变，并且层级关系也没变。没必要处理了
    if ([oldValue integerValue] == value && superTypeSet) {
        return;
    }
    _values[type] = @(value);
    
    if (!superTypeSet) {
        NSMutableArray *needEnumTypes = [NSMutableArray arrayWithObject:type];
        NSMutableSet *allTypes = [NSMutableSet set];
        while (needEnumTypes.count > 0) {
            NSString *tmpType = needEnumTypes[0];
            [needEnumTypes removeObjectAtIndex:0];
            if ([allTypes containsObject:tmpType]) {    //防止绑定关系有死循环，a包含b,b包含a
                continue;
            }
            [allTypes addObject:tmpType];
            
            NSMutableSet *set = _superTypes[tmpType];
            if (set) {
                [needEnumTypes addObjectsFromArray:set.allObjects];
            }
        }
        superTypeSet = allTypes;
        _cachedRecursiveSuperTypes[type] = superTypeSet;
    }
    
    //发送通知
    for (NSString *tmp in superTypeSet) {
        NSInteger value = [self valueForType:tmp];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GYDUnreadCountChangedNotification object:tmp userInfo:@{
            @"value" : @(value),
            @"source" : type
        }];
    }
}
/** 获取状态总值（统计所有子节点） */
- (NSInteger)valueForType:(nonnull NSString *)type {
    if (!type) {
        GYDFoundationError(@"type不能为nil");
        return 0;
    }
    NSSet *subTypeSet = _cachedRecursiveSubTypes[type];
    if (!subTypeSet) {
        NSMutableArray *needEnumTypes = [NSMutableArray arrayWithObject:type];
        NSMutableSet *allTypes = [NSMutableSet set];
        while (needEnumTypes.count > 0) {
            NSString *tmpType = needEnumTypes[0];
            [needEnumTypes removeObjectAtIndex:0];
            if ([allTypes containsObject:tmpType]) {
                continue;
            }
            [allTypes addObject:tmpType];
            
            NSMutableSet *set = _subTypes[tmpType];
            if (set) {
                [needEnumTypes addObjectsFromArray:set.allObjects];
            }
        }
        subTypeSet = allTypes;
        _cachedRecursiveSubTypes[type] = subTypeSet;
    }
    
    NSInteger value = 0;
    BOOL redDot = NO;
    for (NSString *type in subTypeSet) {
        NSInteger i = [_values[type] integerValue];
        if (i < 0) {
            redDot = YES;
        } else {
            value += i;
        }
    }
    if (value > 0) {
        return value;
    }
    if (redDot) {
        return -1;
    }
    return 0;
}

#pragma mark - 细节值

/** 获取自身的设置，不统计子节点 */
- (NSInteger)selfValueForType:(nonnull NSString *)type {
    if (!type) {
        GYDFoundationError(@"type不能为nil");
        return 0;
    }
    return [_values[type] integerValue];
}

#pragma mark - 关系

///** 按组操作，block结束后统一处理 */
//- (void)inGroup:(void(^)(void))block {
//
//}

/** 绑定subType到superType上，需要注意别绑乱了 */
- (void)bindType:(nonnull NSString *)subType toType:(nonnull NSString *)superType {
    if (!subType) {
        GYDFoundationError(@"type不能为nil");
        return;
    }
    if (!superType) {
        GYDFoundationError(@"type不能为nil");
        return;
    }
    NSMutableSet *set = _subTypes[superType];
    if ([set containsObject:subType]) {
        return;
    }
    
    [_cachedRecursiveSuperTypes removeAllObjects];
    [_cachedRecursiveSubTypes removeAllObjects];
    
    //添加绑定关系，双向的。
    if (!set) {
        set = [NSMutableSet setWithCapacity:0];
        _subTypes[superType] = set;
    }
    [set addObject:subType];
    
    set = _superTypes[subType];
    if (!set) {
        set = [NSMutableSet setWithCapacity:0];
        _superTypes[subType] = set;
    }
    [set addObject:superType];
}
/** 解除subType到superType的绑定 */
- (void)removeType:(nonnull NSString *)subType fromType:(nonnull NSString *)superType {
    if (!subType) {
        GYDFoundationError(@"type不能为nil");
        return;
    }
    if (!superType) {
        GYDFoundationError(@"type不能为nil");
        return;
    }
    
    [_cachedRecursiveSuperTypes removeAllObjects];
    [_cachedRecursiveSubTypes removeAllObjects];
    
    //移除操作很可能这辈子都用不到，就写简单点。
    NSMutableSet *set = _subTypes[superType];
    [set removeObject:subType];
    
    set = _superTypes[subType];
    [set removeObject:superType];
}

/** 数组的方式绑定能方便一点吧 */
- (void)bindTypeArray:(nonnull NSArray<NSString *> *)subTypeArray toType:(nonnull NSString *)superType {
    for (NSString *type in subTypeArray) {
        [self bindType:type toType:superType];
    }
}

///** 注册value变化事件 */
//- (void)addTarget:(nonnull id)target action:(nonnull SEL)valueChangeAction forType:(nonnull NSString *)type {
//    if (!type) {
//        GYDFoundationError(@"type不能为nil");
//        return;
//    }
//    if (!target) {
//        GYDFoundationWarning(@"target不应该为nil");
//        return;
//    }
//    NSMutableArray *array = _targetActions[type];
//    if (!array) {
//        array = [NSMutableArray arrayWithCapacity:1];
//        _targetActions[type] = array;
//    }
//    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
//    [weakTarget setWeakTarget:target selector:valueChangeAction];
//    [array addObject:weakTarget];
//}
///** 移除注册的事件，type为nil表示次target所有的事件都移除 */
//- (void)removeTarget:(nonnull id)target action:(nullable SEL)action forType:(nullable NSString *)type {
//    if (!target) {
//        GYDFoundationWarning(@"target不应该为nil");
//        return;
//    }
//    if (type) {
//        NSMutableArray *array = _targetActions[type];
//        for (NSInteger i = 0; i < array.count; i++) {
//            GYDWeakTarget *weakTarget = array[i];
//            if (weakTarget.target == target) {
//                if (!action || weakTarget.selector == action) {
//                    [array removeObjectAtIndex:i];
//                    i--;
//                }
//            }
//        }
//        return;
//    }
//
//    for (NSString *tmpType in _targetActions) {
//        [self removeTarget:target action:action forType:tmpType];
//    }
//}

#pragma mark - 调试

- (NSString *)debugDescription {
    return [self description];
}

- (NSString *)description {
    NSMutableSet *allTypes = [NSMutableSet set];
    if (_superTypes.count) {
        [allTypes addObjectsFromArray:_superTypes.allKeys];
    }
    if (_subTypes.count) {
        [allTypes addObjectsFromArray:_subTypes.allKeys];
    }
    if (_values.count) {
        [allTypes addObjectsFromArray:_values.allKeys];
    }
    
    NSMutableString *desc = [NSMutableString string];
    
    for (NSString *type in _subTypes) {
        [allTypes removeObject:type];
        [desc appendFormat:@"%@:{", [self debugItemDescForType:type]];  //会把_cachedRecursiveSubTypes 准备好
        NSSet *subTypeSet = _cachedRecursiveSubTypes[type];
        for (NSString *subType in subTypeSet) {
            [desc appendFormat:@"%@,", [self debugItemDescForType:subType]];
        }
        [desc appendString:@"}\n"];
    }
    for (NSString *type in allTypes) {
        [desc appendFormat:@"%@\n", [self debugItemDescForType:type]];
    }
    return desc;
}

- (NSString *)debugItemDescForType:(NSString *)type {
    NSString *desc = type;
    NSInteger value = [self selfValueForType:type];
    if (value != 0) {
        desc = [desc stringByAppendingFormat:@"(%@)", @(value)];
    }
    NSInteger allValue = [self valueForType:type];
    if (allValue != value) {
        desc = [desc stringByAppendingFormat:@":%@", @(allValue)];
    }
    return desc;
}

@end



@implementation NSObject (GYDUnreadCountManagerNotification)

- (void)gyd_unreadCountAddNotificationForType:(nullable NSString *)type manager:(GYDUnreadCountManager *)manager callNow:(BOOL)callNow action:(void(^ _Nonnull)(GYDUnreadCountManagerActionParameter arg))action {
    if (!action) {
        return;
    }
    [self gyd_defaultNotificationCenterAddObserverForName:GYDUnreadCountChangedNotification object:type usingBlock:^(NSNotification * _Nonnull note) {
        GYDUnreadCountManagerActionParameter arg;
        arg.type = note.object;
        arg.value = [note.userInfo[@"value"] integerValue];
        arg.sourceType = note.userInfo[@"source"];
        action(arg);
    }];
    if (callNow) {
        action = action;
        GYDUnreadCountManagerActionParameter arg;
        arg.type = type;
        arg.sourceType = type;
        arg.value = [manager valueForType:type];
        action(arg);
    }
}

@end
