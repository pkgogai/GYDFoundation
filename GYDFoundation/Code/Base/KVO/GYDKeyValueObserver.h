//
//  GYDKeyValueObserver.h
//  GYDDevelopment
//
//  Created by 宫亚东 on 2018/12/12.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 KVO所有回调都在同一个方法里，父类、子类、类别中同一个方法处理起来比较麻烦。
 本类只是分离了这个处理，对线程关系没有任何影响，规则都是系统方法原本的。
 
 用法
 
 //添加监听
 id obs = [view gyd_addObserverForKeyPath:@"frame" ……{
    NSLog(@"view的frame发生了变化");
 }];
 
 //触发监听
 view.frame = CGRectMake(0, 0, 100, 100);
 
 //移除监听
 obs = nil;
 
 id obs = [GYDKeyValueObserver observerForObject:view keyPath:@"frame" options:略 changeAction:……{
    NSLog(@"view的frame发生了变化");
 }];
 
 */

typedef void(^GYDKeyValueObserverChangeBlock)(NSDictionary<NSKeyValueChangeKey, id> * _Nullable change);

@interface GYDKeyValueObserver : NSObject

/**
 监听obj的keyPath对应值的变化。
 注意block内不要循环引用。
 obj和action为nil的话，return nil。
 */
+ (nonnull instancetype)observerForObject:(nonnull id)obj keyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options changeAction:(nonnull GYDKeyValueObserverChangeBlock)action;

@end

@interface NSObject (GYDKeyValueObserver)

/**
 监听自己keyPath对应值的变化。
 注意block内不要循环引用。
 action为nil的话，return nil。
 */
- (nonnull GYDKeyValueObserver *)gyd_addObserverForKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options changeAction:(nonnull GYDKeyValueObserverChangeBlock)action;

@end
