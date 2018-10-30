//
//  GYDShapeView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDShapeView.h"

@implementation GYDShapeView
{
    NSMutableArray *_shapeArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _shapeArray = [NSMutableArray array];
    }
    return self;
}

- (void)addShape:(GYDShape *)shape{
    if (shape) {
        [_shapeArray addObject:shape];
        [self setNeedsDisplay];
    }
}
- (void)removeShape:(GYDShape *)shape{
    if (shape) {
        [_shapeArray removeObject:shape];
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i=0; i<_shapeArray.count; i++) {
        GYDShape *shape = _shapeArray[i];
        [shape drawInContext:context];
    }
    
}

@end
