//
//  GYDShape.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDShape.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDShape

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineWidth = 1;
        self.drawMode = GYDDrawModeNormal;
    }
    return self;
}

/** 绘图到 */
- (void)drawInContext:(nonnull CGContextRef)context {
    CGPathDrawingMode drawingMode;
    if (self.lineColor) {
        if (self.fillColor) {
            drawingMode = kCGPathFillStroke;
        } else {
            drawingMode = kCGPathStroke;
        }
    } else if (self.fillColor) {
        drawingMode = kCGPathFill;
    } else {
        return;
    }
    CGContextSetBlendMode(context, (int32_t)self.drawMode);
    [self.lineColor setStroke];
    [self.fillColor setFill];
    
    CGContextSetLineWidth(context, self.lineWidth);
    if (self.dashWidth > 0) {
        CGFloat lengths[] = {_dashWidth, _dashClearWidth>0?_dashClearWidth:_dashWidth};
        CGContextSetLineDash(context, 0, lengths, 2);
    } else {
        CGContextSetLineDash(context, 0, NULL, 0);
    }
    
    [self addPathInContext:context];
    
    CGContextDrawPath(context, drawingMode);
}

#pragma mark - 子类需重写

/** 子类根据自己形状重写path */
- (void)addPathInContext:(nonnull CGContextRef)context {
    GYDFoundationError(@"子类必须实现此方法");
}

@end
