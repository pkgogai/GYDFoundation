//
//  GYDKeyValueObserver.m
//  GYDDevelopment
//
//  Created by 宫亚东 on 2018/12/12.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDKeyValueObserver.h"

@interface GYDKeyValueObserver ()

@property (nonatomic, weak) id obj;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) void *context;
@property (nonatomic, copy) GYDKeyValueObserverChangeBlock action;

@end

@implementation GYDKeyValueObserver

+ (nonnull instancetype)observerForObject:(nonnull id)obj keyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options customContext:(nullable void *)context changeAction:(nonnull GYDKeyValueObserverChangeBlock)action {
    if (!obj) {
        return nil;
    }
    if (!action) {
        return nil;
    }
    GYDKeyValueObserver *o = [[GYDKeyValueObserver alloc] init];
    o.obj = obj;
    o.keyPath = keyPath;
    if (context) {
        o.context = context;
    } else {
        o.context = (__bridge void *)o;
    }
    o.action = action;
    [obj addObserver:o forKeyPath:keyPath options:options context:o.context];
    return o;
}

- (void)dealloc
{
    [_obj removeObserver:self forKeyPath:_keyPath context:_context];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.action) {
        self.action(change);
    }
}

@end


@implementation NSObject (GYDKeyValueObserver)

- (nonnull GYDKeyValueObserver *)gyd_addObserverForKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options changeAction:(nonnull GYDKeyValueObserverChangeBlock)action {
    return [GYDKeyValueObserver observerForObject:self keyPath:keyPath options:options customContext:NULL changeAction:action];
}

@end
