//
//  GYDCircleShape.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDCircleShape.h"

@implementation GYDCircleShape

- (void)setRectValue:(CGRect)rectValue{
    _centerX = rectValue.origin.x+rectValue.size.width/2;
    _centerY = rectValue.origin.y+rectValue.size.height/2;
    if (rectValue.size.width > 0) {
        _r = rectValue.size.width;
    } else {
        _r = - rectValue.size.width;
    }
    if (rectValue.size.height > 0 && _r > rectValue.size.height) {
        _r = rectValue.size.height;
    } else if (rectValue.size.height < 0 && _r > -rectValue.size.height) {
        _r = -rectValue.size.height;
    }
    _r = _r/2;
}

- (CGRect)rectValue{
    return CGRectMake(_centerX - _r, _centerY - _r, _r *2, _r *2);
}

- (void)addPathInContext:(CGContextRef)context{
    CGContextAddArc(context, _centerX, _centerY, _r, 0, M_PI *2, 0);
}

@end
