//
//  GYDKeyValueObserver.h
//  GYDDevelopment
//
//  Created by 宫亚东 on 2018/12/12.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GYDKeyValueObserverChangeBlock)(NSDictionary<NSKeyValueChangeKey, id> * _Nullable change);

@interface GYDKeyValueObserver : NSObject

/** 监听obj的keyPath对应值的变化，注意不要循环引用，obj和action为nil的话，return nil */
+ (nonnull instancetype)observerForObject:(nonnull id)obj keyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options changeAction:(nonnull GYDKeyValueObserverChangeBlock)action;

@end

@interface NSObject (GYDKeyValueObserver)

/** 监听自己keyPath对应值的变化，注意不要循环引用，obj和action为nil的话，return nil */
- (nonnull GYDKeyValueObserver *)gyd_addObserverForKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options changeAction:(nonnull GYDKeyValueObserverChangeBlock)action;

@end
