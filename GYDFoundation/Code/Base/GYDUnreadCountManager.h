//
//  GYDUnreadCountManager.h
//  GYDDevelopment
//
//  Created by 宫亚东 on 2018/10/20.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+GYDNotificationAutoRemove.h"

/**
 状态值规则：
 value == 0 表示光头，无红点无数字
 value < 0 表示有红点，不计数(实际使用值-1)
 value > 0 表示计数，如未读消息数。
 
 所有统计中，计数优先，红点其次。
 */

//typedef struct {
//    /** 数量 */
//    int count;
//    /** 红点 */
//    BOOL redDot;
//} GYDUnreadCountState;

NS_ASSUME_NONNULL_BEGIN

//红点改变的通知
extern NSString * _Nonnull const GYDUnreadCountChangedNotification;

@interface GYDUnreadCountManager : NSObject
{
    //便于调试
@public
    //记录绑定关系，双向的，一边记录每个节点的直属父节点，另一边记录每个节点的直属子节点。
    NSMutableDictionary<NSString *, NSMutableSet *> *_superTypes;
    NSMutableDictionary<NSString *, NSMutableSet *> *_subTypes;
    
    //记录所有节点本身的值
    NSMutableDictionary<NSString *, NSNumber *> *_values;
    
    
    //暂时不用缓存
    //缓存每个节点的递归计算出来的所有父节点，当这个节点的值改变时，触发自身以及所有父节点的事件。以后改为数组，按层次顺序记录，
    NSMutableDictionary<NSString *, NSSet *> *_cachedRecursiveSuperTypes;

    //缓存每个节点的递归出来的所有子节点，方便取值
    NSMutableDictionary<NSString *, NSSet *> *_cachedRecursiveSubTypes;
}

#pragma mark - 值

/** 设置状态值 */
- (void)setValue:(NSInteger)value forType:(nonnull NSString *)type;
/** 获取状态总值（统计所有子节点） */
- (NSInteger)valueForType:(nonnull NSString *)type;

#pragma mark - 细节值

/** 获取自身的设置，不统计子节点 */
- (NSInteger)selfValueForType:(nonnull NSString *)type;

#pragma mark - 关系

///** 按组操作，block结束后统一处理 */
//- (void)inGroup:(void(^)(void))block;

/** 绑定subType到superType上，需要注意别绑乱了 */
- (void)bindType:(nonnull NSString *)subType toType:(nonnull NSString *)superType;
/** 解除subType到superType的绑定 */
- (void)removeType:(nonnull NSString *)subType fromType:(nonnull NSString *)superType;

/** 数组的方式绑定能方便一点吧 */
- (void)bindTypeArray:(nonnull NSArray<NSString *> *)subTypeArray toType:(nonnull NSString *)superType;

///*
// @{
//     @"节点1" : @{
//             @"节点2" : @{
//                     @"节点3" : [NSNull null],
//                     @"节点4" : [NSNull null]
//             },
//             @"节点5" : @{
//                     @"节点6" : [NSNull null],
//                     @"节点7" : [NSNull null]
//             }
//
//     }
// }
// */
///** 直接按字典层级绑定 */
//- (void)bindTypeMapDictionary:(NSDictionary *)map;


//
///** 获取绑定过的所有子节点，没注册的type返回nil,注册过但没有子节点的返回空数组 */
//- (nullable NSArray *)allSubTypesForType:(nonnull NSString *)type;
///** 获取绑定过的所有父节点，没注册的type返回nil,注册过但没有父节点的返回空数组 */
//- (nullable NSArray *)allSuperTypsForType:(nonnull NSString *)type;

//改为直接使用通知
///** 注册value变化事件，目前只有相关节点 setValue 时触发，bindType时并不触发 */
//- (void)addTarget:(nonnull id)target action:(nonnull SEL)valueChangeAction forType:(nonnull NSString *)type;
///** 移除注册的事件，type为nil表示次target所有的事件都移除 */
//- (void)removeTarget:(nonnull id)target action:(nullable SEL)action forType:(nullable NSString *)type;

#pragma mark - 调试
- (nonnull NSString *)debugItemDescForType:(nonnull NSString *)type;

@end

#pragma mark - 注册通知

typedef struct {
    NSString * _Nullable type;
    NSInteger value;
    NSString * _Nullable sourceType;
} GYDUnreadCountManagerActionParameter;


@interface NSObject (GYDUnreadCountManagerNotification)

- (void)gyd_unreadCountAddNotificationForType:(nullable NSString *)type manager:(GYDUnreadCountManager *)manager callNow:(BOOL)callNow action:(void(^ _Nonnull)(GYDUnreadCountManagerActionParameter arg))action;

@end

NS_ASSUME_NONNULL_END
