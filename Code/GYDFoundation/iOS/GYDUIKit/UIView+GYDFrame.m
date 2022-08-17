//
//  UIView+GYDFrame.m
//  GYDDevelopment
//
//  Created by 宫亚东 on 2017/3/22.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import "UIView+GYDFrame.h"

@implementation UIView (GYDFrame)

- (void)setGyd_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)gyd_x {
    return self.frame.origin.x;
}

- (void)setGyd_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)gyd_y {
    return self.frame.origin.y;
}

-(void)setGyd_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)gyd_centerX {
    return self.center.x;
}

- (void)setGyd_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)gyd_centerY {
    return self.center.y;
}

- (void)setGyd_rightX:(CGFloat)rightX {
    CGRect frame = self.frame;
    frame.origin.x = rightX - frame.size.width;
    self.frame = frame;
}
- (CGFloat)gyd_rightX {
    CGRect frame = self.frame;
    return frame.origin.x + frame.size.width;
}
- (void)gyd_setRightX:(CGFloat)rightX changeWidth:(BOOL)changeWidth {
    CGRect frame = self.frame;
    if (changeWidth) {
        frame.size.width = rightX - frame.origin.x;
    } else {
        frame.origin.x = rightX - frame.size.width;
    }
    self.frame = frame;
}

- (void)setGyd_bottomY:(CGFloat)bottomY {
    CGRect frame = self.frame;
    frame.origin.y = bottomY - frame.size.height;
    self.frame = frame;
}
- (CGFloat)gyd_bottomY {
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height;
}
- (void)gyd_setBottomY:(CGFloat)bottomY changeHeight:(BOOL)changeHeight {
    CGRect frame = self.frame;
    if (changeHeight) {
        frame.size.height = bottomY - frame.origin.y;
    } else {
        frame.origin.y = bottomY - frame.size.height;
    }
    self.frame = frame;
}

- (void)setGyd_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)gyd_width {
    return self.frame.size.width;
}

- (void)setGyd_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)gyd_height {
    return self.frame.size.height;
}

- (void)setGyd_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)gyd_origin {
    return self.frame.origin;
}
- (void)setGyd_originInt:(CGPoint)origin {
    origin.x = (NSInteger)origin.x;
    origin.y = (NSInteger)origin.y;
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)gyd_originInt {
    CGPoint origin = self.frame.origin;
    origin.x = (NSInteger)origin.x;
    origin.y = (NSInteger)origin.y;
    return origin;
}

- (void)setGyd_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)gyd_size {
    return self.frame.size;
}
- (void)setGyd_sizeInt:(CGSize)size {
    size.width = (NSInteger)size.width;
    size.height = (NSInteger)size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)gyd_sizeInt {
    CGSize size = self.frame.size;
    size.width = (NSInteger)size.width;
    size.height = (NSInteger)size.height;
    return size;
}

- (void)setGyd_boundsSize:(CGSize)size {
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}
- (CGSize)gyd_boundsSize {
    return self.bounds.size;
}
- (void)setGyd_boundsSizeInt:(CGSize)size {
    size.width = (NSInteger)size.width;
    size.height = (NSInteger)size.height;
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}
- (CGSize)gyd_boundsSizeInt {
    CGSize size = self.bounds.size;
    size.width = (NSInteger)size.width;
    size.height = (NSInteger)size.height;
    return size;
}

- (void)setGyd_frameInt:(CGRect)frame {
    frame.origin.x = (NSInteger)frame.origin.x;
    frame.origin.y = (NSInteger)frame.origin.y;
    frame.size.width = (NSInteger)frame.size.width;
    frame.size.height = (NSInteger)frame.size.height;
    self.frame = frame;
    
}
- (CGRect)gyd_frameInt {
    CGRect frame = self.frame;
    frame.origin.x = (NSInteger)frame.origin.x;
    frame.origin.y = (NSInteger)frame.origin.y;
    frame.size.width = (NSInteger)frame.size.width;
    frame.size.height = (NSInteger)frame.size.height;
    return frame;
}

@end
