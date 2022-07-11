//
//  GYDDecelerateTimeValuePath.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/27.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDTimeValuePath.h"

/**
 渐变减速路径，带边界回弹效果
 
 正好停止：减速（normal,max之间）>停止
 停的更远时，初始速度大于uniformVelocity：匀速>减速>停止
 停的更远时，初始速度小于uniformVelocity：回弹加速>匀速>减速>停止
 
 停的比max更近：减速max > 终点 > 回弹减速到反向 > 减速 > 停止
 
 
 ---2018年01月09日----
 【可选】提前指定边界对于从边界外向边界内，并且落点也在比正常停止要更靠近边界的位置时，一开始就应该启用回弹加速（效果等同于不设置minUniformVelocity）
 
 */
@interface GYDDecelerateTimeValuePath : GYDTimeValuePath


#pragma mark - 计算参数

/** 正常加速度，范围>0，一定要赋值正确 */
@property (nonatomic)   CGFloat normalAcceleratedVelocity;

/** 最大加速度，想要停的近的时候需要更大的加速度，因此有个限制。<=0表示不限制；>0表示限制，但有效的范围>normalAcceleratedVelocity */
@property (nonatomic) CGFloat maxAcceleratedVelocity;

/** 回弹加速度，边界反弹时使用，范围>0，一定要赋值正确 */
@property (nonatomic) CGFloat backAcceleratedVelocity;

/** 匀速阶段允许的最小速度，想要停的比用最小加速度还更远时，如果初始速度比这个还小，就先加速到这个速度匀速一段时间后再减速，<=0表示最大 */
@property (nonatomic) CGFloat minUniformVelocity;

/** 设置起始值、速度，计算出结束的值和时间，并可修改结束值和时间。最终计算出路径。如果修改时间，则不保证速度限制 */
- (BOOL)startDecelerateWithVelocity:(CGFloat)velocity value:(CGFloat)value targetTimeValue:(void (^ _Nullable)(NSTimeInterval offsetTime, CGFloat * _Nonnull value))targetBlock;

@end

/*
 2018年01月08日  所谓做的越多错的越多，这些没什么效果，分支却多，费力不讨好的逻辑就应该去掉。
 去掉 minAcceleratedVelocity， 停的更远时允许的最小的加速度
 
 去掉 normalUniformVelocity 匀速阶段允许的最大速度，想要停的比最小加速度还要更远时，如果初始速度太大，就先减速到这个速度，匀速运行一段距离后再继续减速。回弹效果中使用这个速度作为上限
 
 - (nonnull instancetype)timeValuePathWithVelocity:(CGFloat)velocity value:(CGFloat)value targetTimeValue:(void (^ _Nullable)(NSTimeInterval offsetTime, CGFloat value, void (^ _Nonnull changeTime)(NSTimeInterval offsetTime), void (^ _Nonnull changeValue)(CGFloat value)))targetBlock;
 去掉修改时间的方法，原本时间短则不计较匀速限制，时间长则把时间做二次抛物计算。
 
 停的比max更近：减速max > 终点 > 回弹减速到反向 > [大于匀速则匀速] > 减速 > 停止  去掉匀速阶段，回弹时间长速度慢会难看
 
 去掉 代理 - (void)decelerateTimeValuePathChanged:(GYDDecelerateTimeValuePath *)path; 有需要的话用子类去做
 */




