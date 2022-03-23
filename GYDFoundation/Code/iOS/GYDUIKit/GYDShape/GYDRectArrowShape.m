//
//  GYDRectArrowShape.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/2/18.
//

#import "GYDRectArrowShape.h"

@implementation GYDRectArrowShape

- (void)addPathInContext:(CGContextRef)context {
    
    CGRect frame = self.rectValue;
    CGFloat left = frame.origin.x;
    CGFloat top = frame.origin.y;
    CGFloat right = left + frame.size.width;
    CGFloat down = top + frame.size.height;
    CGFloat r = self.cornerRadius;
    CGPoint arrowLocation = self.arrowLocation;
    
    //找出所在方向距离是正数，并最小的边
    //方向0上 1右 2下 3左
    CGFloat fx[4];
    fx[0] = top - arrowLocation.y;
    fx[1] = arrowLocation.x - right;
    fx[2] = arrowLocation.y - down;
    fx[3] = left - arrowLocation.x;
    NSInteger arrowForword = -1;
    for (NSInteger i = 1; i < 4; i++) {
        if (fx[i] < 0) {
            continue;
        }
        if (arrowForword < 0 || fx[i] < fx[arrowForword]) {
            arrowForword = i;
        }
    }
    
    CGContextMoveToPoint(context, left+r, top);
    
    //上
    if (arrowForword == 0) {
        CGContextAddLineToPoint(context, arrowLocation.x - fx[arrowForword], top);
        CGContextAddLineToPoint(context, arrowLocation.x, top - fx[arrowForword]);
        CGContextAddLineToPoint(context, arrowLocation.x + fx[arrowForword], top);
    }
    CGContextAddLineToPoint(context, right-r, top);
    if (r > 0) {
        CGContextAddArc(context, right-r, top+r, r, -M_PI_2, 0, 0);
    }
    
    //右
    if (arrowForword == 1) {
        CGContextAddLineToPoint(context, right, arrowLocation.y - fx[arrowForword]);
        CGContextAddLineToPoint(context, right + fx[arrowForword], arrowLocation.y);
        CGContextAddLineToPoint(context, right, arrowLocation.y + fx[arrowForword]);
    }
    CGContextAddLineToPoint(context, right, down-r);
    if (r > 0) {
        CGContextAddArc(context, right-r, down-r, r, 0, M_PI_2, 0);
    }
    
    //下
    if (arrowForword == 2) {
        CGContextAddLineToPoint(context, arrowLocation.x + fx[arrowForword], down);
        CGContextAddLineToPoint(context, arrowLocation.x, down + fx[arrowForword]);
        CGContextAddLineToPoint(context, arrowLocation.x - fx[arrowForword], down);
    }
    CGContextAddLineToPoint(context, left+r, down);
    if (r > 0) {
        CGContextAddArc(context, left+r, down-r, r, M_PI_2, M_PI, 0);
    }
    
    //左
    if (arrowForword == 3) {
        CGContextAddLineToPoint(context, left, arrowLocation.y + fx[arrowForword]);
        CGContextAddLineToPoint(context, left - fx[arrowForword], arrowLocation.y);
        CGContextAddLineToPoint(context, left, arrowLocation.y - fx[arrowForword]);
    }
    CGContextAddLineToPoint(context, left, top+r);
    if (r > 0) {
        CGContextAddArc(context, left+r, top+r, r, M_PI, -M_PI_2, 0);
    }
    
}

@end
