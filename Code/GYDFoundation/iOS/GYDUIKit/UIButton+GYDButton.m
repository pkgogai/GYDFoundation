//
//  UIButton+GYDButton.m
//  GYDFoundationDevelopment
//
//  Created by 宫亚东 on 2018/11/10.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "UIButton+GYDButton.h"
#import <objc/runtime.h>

@implementation UIButton (GYDButton)

static char UIButtonGYDButtonActionBlockKey;
- (void)gyd_setClickActionBlock:(nonnull UIButtonGYDButtonActionBlock)block {
    [self removeTarget:self action:@selector(gyd_doClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(gyd_doClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, &UIButtonGYDButtonActionBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)gyd_doClickAction {
    UIButtonGYDButtonActionBlock block = objc_getAssociatedObject(self, &UIButtonGYDButtonActionBlockKey);
    if (block) {
        block(self);
    }
}

@end
