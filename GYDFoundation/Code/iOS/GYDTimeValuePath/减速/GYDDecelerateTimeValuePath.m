//
//  GYDDecelerateTimeValuePath.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDDecelerateTimeValuePath.h"
#import "GYDUniformVelocityTimeValuePath.h"
#import "GYDAccelerateVelocityTimeValuePath.h"

@implementation GYDDecelerateTimeValuePath
{
    /** 起始点 */
    CGFloat         _startValue;
    
    CGFloat         _stopValue;
    
    BOOL            _backward;  //反向，对于速度小于0的，先把速度和值取反按速度大于0计算，结果再反转回来，这样方便
    
    /** 移动路径，减速 > 回弹加速 > 匀速 > 减速 > 停止 */
    NSMutableArray *_pathArray;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _normalAcceleratedVelocity  = 5000;
        _maxAcceleratedVelocity     = 8000;
        _backAcceleratedVelocity    = 50000;
        _minUniformVelocity            = 1000;
    }
    return self;
}


/** 设置起始值、速度，计算出结束的值和时间，并可修改结束值和时间。最终计算出路径。如果修改时间，则不保证速度限制 */
- (BOOL)startDecelerateWithVelocity:(CGFloat)velocity value:(CGFloat)value targetTimeValue:(void (^ _Nullable)(NSTimeInterval offsetTime, CGFloat * _Nonnull value))targetBlock {
    if (_normalAcceleratedVelocity <= 0) {
        return NO;
    }
    if (_backAcceleratedVelocity <= 0) {
        return NO;
    }
    _pathArray = [NSMutableArray array];
    
    if (velocity < 0) {
        _backward = YES;
        velocity = - velocity;
        value = - value;
    } else {
        _backward = NO;
    }
    
    //先计算自然停止位置
    GYDAccelerateVelocityTimeValuePath *step1 = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:0 value:value velocity:velocity acceleration: -_normalAcceleratedVelocity];
    _stopValue = step1.originValue;
    NSTimeInterval stopTime = step1.originTime;
    
    //接收用户处理
    if (targetBlock) {
        if (_backward) {
            _stopValue = - _stopValue;
            targetBlock(stopTime, &_stopValue);
            _stopValue = - _stopValue;
        } else {
            targetBlock(stopTime, &_stopValue);
        }
    }
    _startTime = 0;
    _startValue = value;
    step1.originTime += _startTime;
    
    
    //针对停的较近的，向_maxAcceleratedVelocity修正加速度
    if (_stopValue < step1.originValue && _stopValue > value && (_maxAcceleratedVelocity > _normalAcceleratedVelocity || _maxAcceleratedVelocity <= 0)) {
        
        step1 = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:_startTime value:value velocity:velocity originValue:_stopValue];
        if (step1.acceleration < - _maxAcceleratedVelocity && _maxAcceleratedVelocity > 0) {
            //超出，需要回弹，修正加速度
            step1 = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:_startTime value:value velocity:velocity acceleration: - _maxAcceleratedVelocity];
        } else {
            //正好停止
        }
    }
    
    
    if (_stopValue == step1.originValue) {
        //正好，不需要处理
        step1.startTime = _startTime;
        step1.stopTime = step1.originTime;
        _stopTime = step1.stopTime;
        [_pathArray addObject:step1];
        
    } else if (_stopValue > step1.originValue) {
        //停到更远，[先加速到最低速度]，再匀速，最后减速
        if (velocity < _minUniformVelocity || _minUniformVelocity <= 0) {
            //初始速度低，可以加速
            step1 = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:_startTime value:value velocity:velocity acceleration:_backAcceleratedVelocity];
            CGFloat s1 = (_stopValue - step1.originValue) * _normalAcceleratedVelocity / (_normalAcceleratedVelocity + _backAcceleratedVelocity);
            NSTimeInterval t1 = 0;  //第一步匀加速的时长
            [step1 getOffsetTime:&t1 atOffsetValue:s1 withDirection:NO];
            CGFloat maxV = t1 * _backAcceleratedVelocity;
            
            GYDAccelerateVelocityTimeValuePath *step2 = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:step1.originTime + t1 value:step1.originValue + s1 velocity:maxV originValue:_stopValue];
            if (maxV <= _minUniformVelocity || _minUniformVelocity <= 0) {
                //没有匀速阶段
                step1.startTime = _startTime;
                step1.stopTime = step1.originTime + t1;
                [_pathArray addObject:step1];
                
                step2.startTime = step1.stopTime;
                
                step2.stopTime = step2.originTime;
                [_pathArray addObject:step2];
                
            } else {
                //可以加速到匀速阶段
                t1 = _minUniformVelocity / _backAcceleratedVelocity;
                step1.startTime = _startTime;
                step1.stopTime = step1.originTime + t1;
                [_pathArray addObject:step1];
                
                s1 = 0.5 * _minUniformVelocity * t1;
                GYDUniformVelocityTimeValuePath *uPath = [GYDUniformVelocityTimeValuePath timeValuePathWithTime:step1.stopTime value:s1 + step1.originValue velocity:_minUniformVelocity];
                uPath.startTime = step1.stopTime;
                
                NSTimeInterval t2 = _minUniformVelocity / _normalAcceleratedVelocity;
                CGFloat s2 = 0.5 * _minUniformVelocity * t2;
                uPath.stopTime = (_stopValue - step1.originValue - s1 - s2) / _minUniformVelocity + uPath.startTime;
                
                [_pathArray addObject:uPath];
                
                step2.startTime = uPath.stopTime;
                step2.originTime = step2.startTime + t2;
                step2.stopTime = step2.originTime;
                
                [_pathArray addObject:step2];
                
            }
            _stopTime = step2.stopTime;
        } else {
            //初始速度高，不用加速
            GYDUniformVelocityTimeValuePath *uPath = [GYDUniformVelocityTimeValuePath timeValuePathWithTime:_startTime value:value velocity:velocity];
            uPath.startTime = _startTime;
            
            CGFloat t2 = velocity / _normalAcceleratedVelocity;
            CGFloat s2 = 0.5 * velocity * t2;
            uPath.stopTime = (_stopValue - value - s2) / velocity + uPath.startTime;
            
            GYDAccelerateVelocityTimeValuePath *step2 = [[GYDAccelerateVelocityTimeValuePath alloc] init];
            step2.acceleration = - _normalAcceleratedVelocity;
            step2.originValue = _stopValue;
            step2.originTime = uPath.stopTime + t2;
            step2.startTime = uPath.stopTime;
            step2.stopTime = step2.originTime;
            
            [_pathArray addObject:uPath];
            [_pathArray addObject:step2];
            
            _stopTime = step2.stopTime;
        }
        
    } else {
        //停到更近
        
        GYDAccelerateVelocityTimeValuePath *backPath = nil;
        if (_stopValue > value) {
            //先要有段减速到达_stopValue位置
            NSTimeInterval t1 = 0;
            [step1 getOffsetTime:&t1 atOffsetValue:step1.originValue - _stopValue withDirection:NO];
            step1.startTime = _startTime;
            step1.stopTime = step1.originTime - t1;
            [_pathArray addObject:step1];
            
            
            backPath = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:step1.stopTime value:_stopValue velocity:2 * (step1.originValue - _stopValue) / t1 acceleration:-_backAcceleratedVelocity];
            backPath.startTime = step1.stopTime;
        } else {
            backPath = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:_startTime value:value velocity:velocity acceleration:-_backAcceleratedVelocity];
            backPath.startTime = _startTime;
        }
        //到达_stopValue位置后开始回弹
        CGFloat s_back = (backPath.originValue - _stopValue) * _normalAcceleratedVelocity / (_backAcceleratedVelocity + _normalAcceleratedVelocity);
        
        NSTimeInterval t_back = 0;
        [backPath getOffsetTime:&t_back atOffsetValue:s_back withDirection:NO];
        backPath.stopTime = backPath.originTime + t_back;
        
        [_pathArray addObject:backPath];
        
        GYDAccelerateVelocityTimeValuePath *endPath = [[GYDAccelerateVelocityTimeValuePath alloc] init];
        endPath.acceleration = _normalAcceleratedVelocity;
        endPath.originValue = _stopValue;
        endPath.originTime = backPath.stopTime + t_back * _backAcceleratedVelocity / _normalAcceleratedVelocity;
        
        endPath.startTime = backPath.stopTime;
        endPath.stopTime = endPath.originTime;
        
        [_pathArray addObject:endPath];
        
        _stopTime = endPath.stopTime;
        
    }
    
    return YES;
}

- (CGFloat)valueAtTime:(NSTimeInterval)time {
    CGFloat value = 0;
    if (time < _startTime) {
        value = _startValue;
    } else if (time > _stopTime) {
        value = _stopValue;
    } else {
        for (GYDTimeValuePath *path in _pathArray) {
            if (time >= path.startTime && time <= path.stopTime) {
                value = [path valueAtTime:time];
                break;
            }
        }
    }
    if (_backward) {
        value = -value;
    }
    return value;
}

- (CGFloat)velocityAtTime:(NSTimeInterval)time {
    CGFloat velocity = 0;
    if (time >= _startTime && time <= _stopTime) {
        for (GYDTimeValuePath *path in _pathArray) {
            if (time >= path.startTime && time <= path.stopTime) {
                velocity = [path velocityAtTime:time];
            }
        }
    }
    if (_backward) {
        velocity = - velocity;
    }
    return velocity;
}

#pragma mark - 描述

- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"dece:o=%@,s=%@,min_v=%@,a=%@,max_a=%@,back_a=%@", [GYDTimeValuePath descriptionValue:_backward?-_startValue:_startValue], [GYDTimeValuePath descriptionValue:_backward?-_stopValue:_stopValue], [GYDTimeValuePath descriptionValue:_minUniformVelocity], [GYDTimeValuePath descriptionValue:_normalAcceleratedVelocity], [GYDTimeValuePath descriptionValue:_maxAcceleratedVelocity], [GYDTimeValuePath descriptionValue:_backAcceleratedVelocity]];
//    for (GYDTimeValuePath *path in _pathArray) {
//        string = [string stringByAppendingFormat:@"\n%@, %f,%f", path, path.startTime, path.stopTime];
//    }
    return string;
}

- (NSString *)debugDescription {
    NSString *string = [NSString stringWithFormat:@"减速路径：开始=%@, 停止=%@, 匀速最小值=%@, 加速度=%@, 最大加速度=%@, 回弹加速度=%@", [GYDTimeValuePath descriptionValue:_backward?-_startValue:_startValue], [GYDTimeValuePath descriptionValue:_backward?-_stopValue:_stopValue], [GYDTimeValuePath descriptionValue:_minUniformVelocity], [GYDTimeValuePath descriptionValue:_normalAcceleratedVelocity], [GYDTimeValuePath descriptionValue:_maxAcceleratedVelocity], [GYDTimeValuePath descriptionValue:_backAcceleratedVelocity]];
    return string;
}

@end
