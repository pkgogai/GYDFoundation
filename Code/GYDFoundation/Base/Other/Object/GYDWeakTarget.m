//
//  GYDWeakTarget.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/11/19.
//

#import "GYDWeakTarget.h"

@implementation GYDWeakTarget

- (void)setWeakTarget:(id)target selector:(SEL)selector {
    _target = target;
    _selector = selector;
}

- (void)callOnceWithSelectorObject:(id)obj {
    //block方式
    if (self.action) {
        self.action(obj);
        return;
    }
    //selector方式
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
