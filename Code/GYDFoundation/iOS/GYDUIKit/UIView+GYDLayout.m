//
//  UIView+GYDLayout.m
//  GYDDevelopment
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "UIView+GYDLayout.h"
#import <objc/runtime.h>
#import "GYDFoundationPrivateHeader.h"

@implementation UIView (GYDLayout)

- (BOOL)gyd_noHidden {
    return !self.hidden;
}

#pragma mark - 子视图操作父视图的setNeedsLayout 和 layoutIfNeeded
static char GYDLayoutViewAssociatedObjectKey;

- (void)setGyd_isLayoutView:(BOOL)isLayoutView {
    objc_setAssociatedObject(self, &GYDLayoutViewAssociatedObjectKey, @(isLayoutView), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)gyd_isLayoutView {
    NSNumber *isLayoutView = objc_getAssociatedObject(self, &GYDLayoutViewAssociatedObjectKey);
    if (isLayoutView) {
        return [isLayoutView boolValue];
    }
    return [self.nextResponder isKindOfClass:[UIViewController class]];
//    return [self.nextResponder isKindOfClass:[UIViewController class]] && ((UIViewController *)self.nextResponder).view == self;
}

- (void)gyd_layoutViewSetNeedsLayout {
    for (UIView *view = self; view; view = view.superview) {
        if (view.gyd_isLayoutView) {
            [view setNeedsLayout];
            return;
        }
    }
    NSMutableString *msg = [[NSMutableString alloc] init];
    for (UIView *view = self; view; view = view.superview) {
        [msg appendFormat:@"%@,", NSStringFromClass([view class])];
    }
    GYDFoundationWarning(@"没有用来layout的view:%@",msg);
}

- (void)gyd_layoutViewLayoutIfNeeded {
    for (UIView *view = self; view; view = view.superview) {
        if (view.gyd_isLayoutView) {
            [view layoutIfNeeded];
            return;
        }
    }
    NSMutableString *msg = [[NSMutableString alloc] init];
    for (UIView *view = self; view; view = view.superview) {
        [msg appendFormat:@"%@,", NSStringFromClass([view class])];
    }
    GYDFoundationWarning(@"没有用来layout的view:%@",msg);
}


@end
