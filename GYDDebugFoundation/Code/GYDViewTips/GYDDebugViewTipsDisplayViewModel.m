//
//  GYDDebugViewTipsDisplayViewModel.m
//  GYDDevelopment
//
//  Created by gongyadong on 2020/12/30.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDDebugViewTipsDisplayViewModel.h"
#import "GYDDecelerateTimeValuePath.h"
#import "GYDUniformVelocityTimeValuePath.h"
#import "GYDTimeValuePathTimer.h"

@implementation GYDDebugViewTipsDisplayViewModel
{
    
    /** 偷个懒吧，分解成x、y两个方向的动画，虽然这样效果会变差 */
    GYDDecelerateTimeValuePath *_xPath;
    GYDDecelerateTimeValuePath *_yPath;
//    GYDDecelerateTimeValuePath *_wPath;
//    GYDDecelerateTimeValuePath *_hPath;
    
    NSTimeInterval _baseTime;
}

- (void)setTipsCenter:(CGPoint)tipsCenter {
    _tipsCenter = tipsCenter;
    _xPath = nil;
    _yPath = nil;
}

- (void)tipsAnimateToCenter:(CGPoint)tipsCenter {
    if (tipsCenter.x == _tipsCenter.x && tipsCenter.y == _tipsCenter.y) {
        return;
    }
    
    NSTimeInterval offsetTime = [GYDTimeValuePathTimer systemUptime] - _baseTime;
    
    CGPoint o = tipsCenter;
    if (_xPath || _tipsCenter.x != tipsCenter.x) {
        CGFloat v = 0;
        CGFloat s = 0;
        if (_xPath) {
            v = [_xPath velocityAtTime:offsetTime];
            s = [_xPath valueAtTime:offsetTime];
        } else {
            _xPath = [self createTimeValuePath];
            s = _tipsCenter.x;
        }
        [_xPath startDecelerateWithVelocity:v value:s targetTimeValue:^(NSTimeInterval offsetTime, CGFloat * _Nonnull value) {
            *value = tipsCenter.x;
        }];
    }
    if (_yPath || _tipsCenter.y != tipsCenter.y) {
        CGFloat v = 0;
        CGFloat s = 0;
        if (_yPath) {
            v = [_yPath velocityAtTime:offsetTime];
            s = [_yPath valueAtTime:offsetTime];
        } else {
            _yPath = [self createTimeValuePath];
            s = _tipsCenter.y;
        }
        [_yPath startDecelerateWithVelocity:v value:s targetTimeValue:^(NSTimeInterval offsetTime, CGFloat * _Nonnull value) {
            *value = tipsCenter.y;
        }];
    }
    _tipsCenter = tipsCenter;
    _baseTime += offsetTime;
}

- (CGPoint)tipsAnimateCenter {
    if (!_xPath && !_yPath) {
        return _tipsCenter;
    }
    CGPoint p = _tipsCenter;
    NSTimeInterval time = [GYDTimeValuePathTimer systemUptime] - _baseTime;
    if (_xPath) {
        if (_xPath.stopTime > time) {
            p.x = [_xPath valueAtTime:time];
        } else {
            _xPath = nil;
        }
    }
    if (_yPath) {
        if (_yPath.stopTime > time) {
            p.y = [_yPath valueAtTime:time];
        } else {
            _yPath = nil;
        }
    }
    return p;
}

- (GYDDecelerateTimeValuePath *)createTimeValuePath {
    GYDDecelerateTimeValuePath *path = [[GYDDecelerateTimeValuePath alloc] init];
    path.normalAcceleratedVelocity = 8000;
    path.maxAcceleratedVelocity = 10000;
    path.backAcceleratedVelocity = 10000;
    path.minUniformVelocity = 0;
    return path;
}



- (NSString *)debugDescription {
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"local:%@ tips:%@", NSStringFromCGRect(self.shape.locationRect), NSStringFromCGPoint(self.tipsCenter)];
    if ([self.tipsView isKindOfClass:[UILabel class]]) {
        [desc appendFormat:@" label:%@", ((UILabel *)self.tipsView).text];
    }
    return desc;
}

@end
