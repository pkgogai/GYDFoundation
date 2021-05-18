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
    GYDWeakTarget *weakTarget = [[GYDWeakTarget alloc] init];
    [weakTarget setWeakTarget:target selector:aSelector];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:weakTarget selector:@selector(callOnce)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    GYDWeakDisplayLink *weakDisplayLink = [[self alloc] init];
    weakDisplayLink->_link = link;
    weakTarget.selectorObject = weakDisplayLink;
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
