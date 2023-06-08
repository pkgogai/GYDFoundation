//
//  GYDValueTools.h
//  GYDDevelopment
//
//  Created by gongyadong on 2023/3/14.
//  Copyright © 2023 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDValueTools : NSObject

/**
 输入一个范围，适配一个比较整齐的刻度，
 minValue~maxValue: 范围
 wantCount: 期望的刻度数量
 step: 比较整齐的刻度 1,2,5*10^n，如10, 2, 0.5
 stepHead: step 的有效部分，只有3种值：1,2,5
 baseValue  <= minValue，baseValue + step * count >= maxValue，并且留出step*spaceScale的空隙
 如：输入3.01, 3.41, 5，则：baseValue = 3, step = 0.1, count = 6, stepHead = 1
 [!image-name:4A2C18C1-6C51-49B6-B9FD-8727AE3815CE.jpge]
 */
+ (void)fitMinValue:(double)minValue maxValue:(double)maxValue wantCount:(NSInteger)wantCount spaceScale:(double)spaceScale toBaseValue:(double *)baseValue step:(double *)step count:(NSInteger *)count stepHead:(nullable NSInteger *)stepHead;

@end

NS_ASSUME_NONNULL_END
