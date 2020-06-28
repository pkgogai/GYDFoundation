//
//  GYDSineTimeValuePath.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDSineTimeValuePath.h"

@implementation GYDSineTimeValuePath

- (CGFloat)valueAtTime:(NSTimeInterval)time {
    return _originValue + _radius * sin((time - _originTime) * _rotationRate * 2 * M_PI);
}

#pragma mark - 描述

- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"sin:o=(%@,%@),l=%@,r=%@", [GYDTimeValuePath descriptionValue:_originTime], [GYDTimeValuePath descriptionValue:_originValue], [GYDTimeValuePath descriptionValue:_radius], [GYDTimeValuePath descriptionValue:_rotationRate]];
    return string;
}
- (NSString *)debugDescription {
    NSString *string = [NSString stringWithFormat:@"正弦：起始点=(%@,%@)，幅度=%@，转速=%@(圈/秒)", [GYDTimeValuePath descriptionValue:_originTime], [GYDTimeValuePath descriptionValue:_originValue], [GYDTimeValuePath descriptionValue:_radius], [GYDTimeValuePath descriptionValue:_rotationRate]];
    return string;
}

@end
