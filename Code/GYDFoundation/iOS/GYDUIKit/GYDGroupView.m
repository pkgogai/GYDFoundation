//
//  GYDGroupView.m
//  GYDFoundation
//
//  Created by gongyadong on 2022/11/3.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDGroupView.h"

@implementation GYDGroupView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}

@end
