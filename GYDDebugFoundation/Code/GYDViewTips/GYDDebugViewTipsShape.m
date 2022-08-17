//
//  GYDDebugViewTipsShape.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/1/4.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDebugViewTipsShape.h"
#import "GYDRectShape.h"
#import "GYDLineShape.h"
#import "UIColor+GYDColor.h"

static CGPoint rightTopPoint(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
}
static CGPoint leftBottomPoint(CGRect rect) {
    return CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
}
static CGPoint rightBottomPoint(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

@implementation GYDDebugViewTipsShape
{
    GYDRectShape *_tipsRectShape;
    GYDRectShape *_localRectShape;
    GYDLineShape *_lineShape[4];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tipsRectShape = ({
            GYDRectShape *shape = [[GYDRectShape alloc] init];
            shape.cornerRadius = 0;
            shape.lineWidth = 1;
            shape;
        });
        _localRectShape = ({
            GYDRectShape *shape = [[GYDRectShape alloc] init];
            shape.cornerRadius = 0;
            shape.lineWidth = 1;
            shape;
        });
        for (int i = 0; i < 4; i++) {
            _lineShape[i] = ({
                GYDLineShape *shape = [[GYDLineShape alloc] init];
                shape.lineWidth = 1;
                shape;
            });
        }
        
    }
    return self;
}

- (void)setLocationRect:(CGRect)locationRect {
    _localRectShape.rectValue = locationRect;
    [self updateLineShapeValue];
}
- (CGRect)locationRect {
    return _localRectShape.rectValue;
}

- (void)setTipsRect:(CGRect)tipsRect {
    _tipsRectShape.rectValue = tipsRect;
    [self updateLineShapeValue];
}
- (CGRect)tipsRect {
    return _tipsRectShape.rectValue;
}

- (void)setColorRGBValue:(uint32_t)colorRGBValue {
    _colorRGBValue = colorRGBValue;
    _tipsRectShape.fillColor = [UIColor gyd_colorWithRGBValue:colorRGBValue alpha:0.4];
    _localRectShape.fillColor = [UIColor gyd_colorWithRGBValue:colorRGBValue alpha:0.1];
    
    _tipsRectShape.lineColor = [UIColor gyd_colorWithRGBValue:colorRGBValue alpha:1];
    _localRectShape.lineColor = [UIColor gyd_colorWithRGBValue:colorRGBValue alpha:1];
    for (int i = 0; i < 4; i++) {
        _lineShape[i].lineColor = [UIColor gyd_colorWithRGBValue:colorRGBValue alpha:0.8];
    }
    
}

- (void)updateLineShapeValue {
    _lineShape[0].point1 = _localRectShape.rectValue.origin;
    _lineShape[0].point2 = _tipsRectShape.rectValue.origin;
    
    _lineShape[1].point1 = rightTopPoint(_localRectShape.rectValue);
    _lineShape[1].point2 = rightTopPoint(_tipsRectShape.rectValue);
    
    _lineShape[2].point1 = leftBottomPoint(_localRectShape.rectValue);
    _lineShape[2].point2 = leftBottomPoint(_tipsRectShape.rectValue);
    
    _lineShape[3].point1 = rightBottomPoint(_localRectShape.rectValue);
    _lineShape[3].point2 = rightBottomPoint(_tipsRectShape.rectValue);
}

- (void)drawInContext:(CGContextRef)context {
    [_localRectShape drawInContext:context];
    for (int i = 0; i < 4; i++) {
        [_lineShape[i] drawInContext:context];
    }
    [_tipsRectShape drawInContext:context];
}

@end
