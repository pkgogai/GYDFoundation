//
//  GYDLineShape.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLineShape.h"

@implementation GYDLineShape

- (void)addPathInContext:(CGContextRef)context {
    CGContextMoveToPoint(context, _point1.x, _point1.y);
    CGContextAddLineToPoint(context, _point2.x, _point2.y);
}

@end
