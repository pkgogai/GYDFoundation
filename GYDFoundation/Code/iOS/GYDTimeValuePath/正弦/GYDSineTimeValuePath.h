//
//  GYDSineTimeValuePath.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePath.h"

/**
 正弦曲线的路径
 */
@interface GYDSineTimeValuePath : GYDTimeValuePath

/** 转速，每秒多少圈 */
@property (nonatomic)   CGFloat rotationRate;

/** 角度为0时的坐标 */
@property (nonatomic)   CGFloat originValue;

/** 角度为0时的时间 */
@property (nonatomic)   NSTimeInterval originTime;

/** 半径，位移最大值 */
@property (nonatomic)   CGFloat radius;

@end
