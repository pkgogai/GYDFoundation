//
//  GYDTimeValuePathTestView.m
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePathTestView.h"
#import "GYDTimeValuePathItemView.h"
#import "GYDUniformVelocityTimeValuePath.h"
#import "GYDAccelerateVelocityTimeValuePath.h"
#import "GYDSineTimeValuePath.h"
#import "GYDDecelerateTimeValuePath.h"
#import "UIView+GYDView.h"

@implementation GYDTimeValuePathTestView
{
    UIScrollView *_scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self testUniformVelocityTimeValuePath];
        [self testAccelerateVelocityTimeValuePath];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor grayColor];
        [self addSubview:_scrollView];
        
        NSArray<NSArray *> *timeValuePathArrayArray = @[
            [self uniformVelocityTimeValuePathTestArray],
            [self accelerateVelocityTimeValuePathTestArray],
            [self sinTimeValuePathTestArray],
            [self decelerateTimeValuePathTestArray]
        ];
        
        for (NSInteger i = 0; i < timeValuePathArrayArray.count; i++) {
            NSArray *timeValuePathArray = timeValuePathArrayArray[i];
            UIScrollView *scrollView = [self scrollViewWithTimeValuePathArray:timeValuePathArray];
            scrollView.frame = CGRectMake(0, 50 + 330 * i, frame.size.width, 320);
            [_scrollView addSubview:scrollView];
        }
        
        _scrollView.contentSize = CGSizeMake(0, 50 + 330 * timeValuePathArrayArray.count);
        return  self;
        
        CGFloat space = 5;
        CGFloat width = (frame.size.width - 3 * space) / 2;
        
        GYDUniformVelocityTimeValuePath *uniformVelocityPath = [GYDUniformVelocityTimeValuePath timeValuePathWithTime:10 value:10 velocity:1];
        GYDTimeValuePathItemView *unView = [[GYDTimeValuePathItemView alloc] initWithFrame:CGRectMake(space, 50, width, width + 20)];
        unView.timeValuePath = uniformVelocityPath;
        unView.timeValueFrame = CGRectMake(0, 0, 1, 1);
        [_scrollView addSubview:unView];
        
        
        GYDSineTimeValuePath *sinPath = [[GYDSineTimeValuePath alloc] init];
        sinPath.rotationRate = 1;
        sinPath.radius = 1;
        sinPath.originTime = 0;
        sinPath.originValue = 0;
        
        GYDTimeValuePathItemView *sinView = [[GYDTimeValuePathItemView alloc] initWithFrame:CGRectMake(unView.rightX + space, unView.y, width, width + 20)];
        sinView.timeValuePath = sinPath;
        sinView.timeValueFrame = CGRectMake(0, -1, 1, 2);
        [_scrollView addSubview:sinView];
        
        
        
        
        
    }
    return self;
}

- (UIScrollView *)scrollViewWithTimeValuePathArray:(NSArray *)array {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 320)];
    CGFloat x = 5;
    for (GYDTimeValuePath *path in array) {
        GYDTimeValuePathItemView *view = [[GYDTimeValuePathItemView alloc] initWithFrame:CGRectMake(x, 0, 300, 320)];
        view.backgroundColor = [UIColor whiteColor];
        view.timeValuePath = path;
        view.timeValueFrame = CGRectMake(-1, -1, 2, 2);
        [scrollView addSubview:view];
        x += 300 + 5;
    }
    scrollView.contentSize = CGSizeMake(x, 320);
    scrollView.backgroundColor = [UIColor grayColor];
    return scrollView;
}

- (BOOL)isValue1:(CGFloat)value1 nearValue2:(CGFloat)value2 {
    CGFloat offset = value1 - value2;
    if (offset > -0.00001 && offset < 0.00001) {
        return YES;
    }
    return NO;
}
#pragma mark - 匀速
- (void)testUniformVelocityTimeValuePath {
    NSArray *array = [self uniformVelocityTimeValuePathTestArray];
    for (GYDUniformVelocityTimeValuePath *path in array) {
        for (int i = 0; i < 10; i ++) {
            CGFloat time = (rand() % 10000) * 0.01;
            CGFloat value = [path valueAtTime:time];
            CGFloat velocity = path.velocity;
            
            GYDUniformVelocityTimeValuePath *tmp = [GYDUniformVelocityTimeValuePath timeValuePathWithTime:time value:value velocity:velocity];
            if (![self isValue1:path.originValue nearValue2:tmp.originValue] || ![self isValue1:path.velocity nearValue2:tmp.velocity]) {
                NSLog(@"创建方法出错%@,%@", path, tmp);
                NSLog(@"%f,%f,%f", time, value, velocity);
            }
            
            CGFloat time2 = (rand() % 10000) * 0.01;
            if (time2 == time) {
                continue;
            }
            CGFloat value2 = [path valueAtTime:time2];
            tmp = [GYDUniformVelocityTimeValuePath timeValuePathWithTime1:time value1:value time2:time2 value2:value2];
            if (![self isValue1:path.originValue nearValue2:tmp.originValue] || ![self isValue1:path.velocity nearValue2:tmp.velocity]) {
                NSLog(@"创建方法出错%@,%@", path, tmp);
                NSLog(@"%f,%f,%f", time, value, velocity);
            }
        }
    }
}
- (NSArray *)uniformVelocityTimeValuePathTestArray {
    NSArray *array = @[
                       ({
                           GYDUniformVelocityTimeValuePath *path = [[GYDUniformVelocityTimeValuePath alloc] init];
                           path.originValue = 0;
                           path.velocity = 1;
                           path;
                       }),
                       ({
                           GYDUniformVelocityTimeValuePath *path = [[GYDUniformVelocityTimeValuePath alloc] init];
                           path.originValue = 0;
                           path.velocity = 0;
                           path;
                       }),
                       ({
                           GYDUniformVelocityTimeValuePath *path = [[GYDUniformVelocityTimeValuePath alloc] init];
                           path.originValue = -0.5;
                           path.velocity = 1;
                           path;
                       }),
                       ({
                           GYDUniformVelocityTimeValuePath *path = [[GYDUniformVelocityTimeValuePath alloc] init];
                           path.originValue = 0.5;
                           path.velocity = 1;
                           path;
                       }),
                       ({
                           GYDUniformVelocityTimeValuePath *path = [[GYDUniformVelocityTimeValuePath alloc] init];
                           path.originValue = -0.5;
                           path.velocity = -0.5;
                           path;
                       }),
                       ({
                           GYDUniformVelocityTimeValuePath *path = [[GYDUniformVelocityTimeValuePath alloc] init];
                           path.originValue = 0.5;
                           path.velocity = 0.5;
                           path;
                       }),
                       ];
    return array;
}

#pragma mark - 匀加速
- (void)testAccelerateVelocityTimeValuePath {
    NSArray *array = [self accelerateVelocityTimeValuePathTestArray];
    for (GYDAccelerateVelocityTimeValuePath *path in array) {
        for (int i = 0; i < 10; i ++) {
            CGFloat time = (rand() % 1000) * 0.01;
            CGFloat value = [path valueAtTime:time];
            CGFloat velocity = (time - path.originTime) * path.acceleration;
            CGFloat originValue = [path valueAtTime:path.originTime];
            
            if (path.acceleration == 0 || time == path.originTime) {
                continue;
            }
            
            GYDAccelerateVelocityTimeValuePath *tmp = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:time value:value velocity:velocity acceleration:path.acceleration];
            if (![self isValue1:path.acceleration nearValue2:tmp.acceleration] || ![self isValue1:path.originValue nearValue2:tmp.originValue] || ![self isValue1:path.originTime nearValue2:tmp.originTime]) {
                NSLog(@"创建方法出错%@,%@", path, tmp);
                NSLog(@"%f,%f,%f,%f", time, value, velocity, path.acceleration);
            }
            tmp = [GYDAccelerateVelocityTimeValuePath timeValuePathWithTime:time value:value velocity:velocity originValue:originValue];
            if (![self isValue1:path.acceleration nearValue2:tmp.acceleration] || ![self isValue1:path.originValue nearValue2:tmp.originValue] || ![self isValue1:path.originTime nearValue2:tmp.originTime]) {
                NSLog(@"创建方法出错%@,%@", path, tmp);
                NSLog(@"%f,%f,%f,%f", time, value, velocity, path.acceleration);
            }
        }
    }
}
- (NSArray *)accelerateVelocityTimeValuePathTestArray {
    NSArray *array = @[
                       ({
                           GYDAccelerateVelocityTimeValuePath *path = [[GYDAccelerateVelocityTimeValuePath alloc] init];
                           path.originValue = 0;
                           path.originTime = 0;
                           path.acceleration = 0;
                           path;
                       }),
                       ({
                           GYDAccelerateVelocityTimeValuePath *path = [[GYDAccelerateVelocityTimeValuePath alloc] init];
                           path.originValue = 0.5;
                           path.originTime = -0.5;
                           path.acceleration = 1;
                           path;
                       }),
                       ({
                           GYDAccelerateVelocityTimeValuePath *path = [[GYDAccelerateVelocityTimeValuePath alloc] init];
                           path.originValue = 0.5;
                           path.originTime = -0.5;
                           path.acceleration = -1;
                           path;
                       }),
                       ({
                           GYDAccelerateVelocityTimeValuePath *path = [[GYDAccelerateVelocityTimeValuePath alloc] init];
                           path.originValue = -0.5;
                           path.originTime = 0.5;
                           path.acceleration = -0.5;
                           path;
                       }),
                       ];
    return array;
}

- (NSArray *)sinTimeValuePathTestArray {
    NSArray *array = @[
                       ({
                           GYDSineTimeValuePath *path = [[GYDSineTimeValuePath alloc] init];
                           path.originTime = 0;
                           path.originValue = 0;
                           path.radius = 1;
                           path.rotationRate = 1;
                           path;
                       }),
                       ({
                           GYDSineTimeValuePath *path = [[GYDSineTimeValuePath alloc] init];
                           path.originTime = -0.5;
                           path.originValue = -0.5;
                           path.radius = 0.5;
                           path.rotationRate = 1;
                           path;
                       }),
                       ({
                           GYDSineTimeValuePath *path = [[GYDSineTimeValuePath alloc] init];
                           path.originTime = 0.5;
                           path.originValue = 0.5;
                           path.radius = 1;
                           path.rotationRate = 2;
                           path;
                       }),
                       ];
    return array;
}
- (NSArray *)decelerateTimeValuePathTestArray {
    NSArray *array = @[
                       ({
                           GYDDecelerateTimeValuePath *path = [[GYDDecelerateTimeValuePath alloc] init];
                           path.normalAcceleratedVelocity = 2;
                           path.maxAcceleratedVelocity = 5;
                           path.backAcceleratedVelocity = 20;
                           path.minUniformVelocity = 1;
                           [path startDecelerateWithVelocity:2 value:0 targetTimeValue:nil];
                           path;
                       }),
                       ({
                           GYDDecelerateTimeValuePath *path = [[GYDDecelerateTimeValuePath alloc] init];
                           path.normalAcceleratedVelocity = 2;
                           path.maxAcceleratedVelocity = 5;
                           path.backAcceleratedVelocity = 20;
                           path.minUniformVelocity = 1;
                           [path startDecelerateWithVelocity:2 value:0 targetTimeValue:^(NSTimeInterval offsetTime, CGFloat * _Nonnull value) {
                               *value = *value / 2;
                           }];
                           path;
                       }),
                       ({
                           GYDDecelerateTimeValuePath *path = [[GYDDecelerateTimeValuePath alloc] init];
                           path.normalAcceleratedVelocity = 10;
                           path.maxAcceleratedVelocity = 50;
                           path.backAcceleratedVelocity = 100;
                           path.minUniformVelocity = 1;
                           [path startDecelerateWithVelocity:2 value:0 targetTimeValue:^(NSTimeInterval offsetTime, CGFloat * _Nonnull value) {
                               *value = *value * 4;
                           }];
                           path;
                       }),
                       ({
                           GYDDecelerateTimeValuePath *path = [[GYDDecelerateTimeValuePath alloc] init];
                           path.normalAcceleratedVelocity = 2;
                           path.maxAcceleratedVelocity = 5;
                           path.backAcceleratedVelocity = 20;
                           path.minUniformVelocity = 1;
                           [path startDecelerateWithVelocity:2 value:0 targetTimeValue:^(NSTimeInterval offsetTime, CGFloat * _Nonnull value) {
                               *value = *value / 5;
                           }];
                           path;
                       }),
                       ({
                           GYDDecelerateTimeValuePath *path = [[GYDDecelerateTimeValuePath alloc] init];
                           path.normalAcceleratedVelocity = 5;
                           path.maxAcceleratedVelocity = 10;
                           path.backAcceleratedVelocity = 20;
                           path.minUniformVelocity = 3;
                           [path startDecelerateWithVelocity:1 value:0 targetTimeValue:^(NSTimeInterval offsetTime, CGFloat * _Nonnull value) {
                               *value = *value * 8;
                           }];
                           path;
                       }),
                       ];
    return array;
}

@end
