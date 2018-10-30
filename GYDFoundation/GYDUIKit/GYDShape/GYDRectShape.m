//
//  GYDRectShape.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDRectShape.h"

@implementation GYDRectShape

- (void)setOrigin:(CGPoint)origin{
    _rectValue.origin = origin;
}
- (CGPoint)origin{
    return _rectValue.origin;
}
- (void)setSize:(CGSize)size{
    _rectValue.size = size;
}
- (CGSize)size{
    return _rectValue.size;
}
- (void)setX:(CGFloat)x{
    _rectValue.origin.x = x;
}
- (CGFloat)x{
    return _rectValue.origin.x;
}
- (void)setY:(CGFloat)y{
    _rectValue.origin.y = y;
}
- (CGFloat)y{
    return _rectValue.origin.x;
}
- (void)setWidth:(CGFloat)width{
    _rectValue.size.width = width;
}
- (CGFloat)width{
    return _rectValue.size.width;
}
- (void)setHeight:(CGFloat)height{
    _rectValue.size.height = height;
}
- (CGFloat)height{
    return _rectValue.size.height;
}

- (void)addPathInContext:(CGContextRef)context{
    if (self.cornerRadius>0) {
        CGRect frame = self.rectValue;
        CGFloat left = frame.origin.x;
        CGFloat top = frame.origin.y;
        CGFloat right = left + frame.size.width;
        CGFloat down = top + frame.size.height;
        CGFloat r = self.cornerRadius;
        CGContextMoveToPoint(context, left+r, top);
        
        CGContextAddLineToPoint(context, right-r, top);
        CGContextAddArc(context, right-r, top+r, r, -M_PI_2, 0, 0);
        
        CGContextAddLineToPoint(context, right, top+r);
        CGContextAddArc(context, right-r, down-r, r, 0, M_PI_2, 0);
        
        CGContextAddLineToPoint(context, left+r, down);
        CGContextAddArc(context, left+r, down-r, r, M_PI_2, M_PI, 0);
        
        CGContextAddLineToPoint(context, left, top+r);
        CGContextAddArc(context, left+r, top+r, r, M_PI, -M_PI_2, 0);
        
    } else {
        CGContextAddRect(context, self.rectValue);
    }
}
@end
