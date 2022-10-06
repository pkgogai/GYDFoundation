//
//  UIView+GYDPanToMove.m
//  Pods
//
//  Created by gongyadong on 2022/9/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "UIView+GYDPanToMove.h"
#import <objc/runtime.h>

@implementation UIView (GYDPanToMove)

static char panKey;
static char actionKey;

- (void)gyd_setMovePanGestureRecognizerEnable:(BOOL)enable action:(UIViewGYDPanToMoveActionBlock)action {
    if (!enable) {
        objc_setAssociatedObject(self, &panKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return;
    }
    
    objc_setAssociatedObject(self, &actionKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, &panKey);
    if (pan) {
        return;
    }
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gyd_movePanGestureRecognizerAction:)];
    [self addGestureRecognizer:pan];
}


- (void)gyd_movePanGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self.superview];
    CGPoint from = self.center;
    CGPoint to = from;
    to.x += p.x;
    to.y += p.y;
    UIViewGYDPanToMoveActionBlock action = objc_getAssociatedObject(self, &actionKey);
    if (action) {
        action(self, from, &to);
    }
    p.x -= to.x - from.x;
    p.y -= to.y - from.y;
    [pan setTranslation:p inView:self.superview];
    self.center = to;
}

@end
