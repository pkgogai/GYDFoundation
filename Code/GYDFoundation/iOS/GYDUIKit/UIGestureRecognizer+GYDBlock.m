//
//  UIGestureRecognizer+GYDBlock.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2022/6/30.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "UIGestureRecognizer+GYDBlock.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (GYDBlock)

static char UIGestureRecognizerGYDBlockActionBlockKey;

- (instancetype)initWithActionBlock_gyd:(UIGestureRecognizerGYDBlockActionBlock)action {
    self = [self initWithTarget:self action:@selector(gyd_doGestureRecognizerAction)];
    if (self) {
        objc_setAssociatedObject(self, &UIGestureRecognizerGYDBlockActionBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}

- (void)gyd_doGestureRecognizerAction {
    UIGestureRecognizerGYDBlockActionBlock block = objc_getAssociatedObject(self, &UIGestureRecognizerGYDBlockActionBlockKey);
    if (!block) {
        return;
    }
    block(self);
}

@end
