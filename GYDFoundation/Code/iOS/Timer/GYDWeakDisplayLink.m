//
//  GYDWeakDisplayLink.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2019/4/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDWeakDisplayLink.h"
#import <UIKit/UIKit.h>
#import "GYDWeakTarget.h"

@implementation GYDWeakDisplayLink
{
    CADisplayLink *_link;
}

- (CADisplayLink *)displayLink {
    return _link;
}

+ (instancetype)displayLinkStartWithWeakTarget:(id)target
                                 selector:(SEL)aSelector {
    GYDWeakDisplayLink *weakDisplayLink = [[self alloc] init];
    
    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
    [weakTarget setWeakTarget:target selector:aSelector];
    weakTarget.selectorObject = weakDisplayLink;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:weakTarget selector:@selector(callOnce)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    weakDisplayLink->_link = link;
    
    return weakDisplayLink;
}

+ (instancetype)displayLinkStartWithAction:(void (^)(GYDWeakDisplayLink * _Nonnull))action {
    GYDWeakDisplayLink *weakDisplayLink = [[self alloc] init];
    
    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
    weakTarget.action = action;
    weakTarget.selectorObject = weakDisplayLink;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:weakTarget selector:@selector(callOnce)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    weakDisplayLink->_link = link;
    
    return weakDisplayLink;
}

- (void)dealloc {
    [_link invalidate];
    _link = nil;
}
- (void)invalidate {
    [_link invalidate];
    _link = nil;
}

@end
