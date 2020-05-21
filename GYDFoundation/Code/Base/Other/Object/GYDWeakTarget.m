//
//  GYDWeakTarget.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/11/19.
//

#import "GYDWeakTarget.h"

@implementation GYDWeakTarget
{
    __weak id _target;
    SEL _selector;
}

- (void)setTarget:(id)target {
    _target = target;
}
- (id)target {
    return _target;
}

- (void)setSelector:(SEL)selector {
    _selector = selector;
}
- (SEL)selector {
    return _selector;
}

- (void)setWeakTarget:(id)target selector:(SEL)selector {
    _target = target;
    _selector = selector;
}

- (void)callOnceWithSelectorObject:(id)obj {
    if (!_selector) {
        return;
    }
    if (![_target respondsToSelector:_selector]) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSString *actionName = NSStringFromSelector(_selector);
    if ([actionName containsString:@":"]) {
        [_target performSelector:_selector withObject:obj];
    } else {
        [_target performSelector:_selector];
    }
#pragma clang diagnostic pop
}

- (void)callOnce {
    [self callOnceWithSelectorObject:_selectorObject];
}

@end
