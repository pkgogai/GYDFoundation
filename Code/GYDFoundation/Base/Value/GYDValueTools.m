//
//  GYDValueTools.m
//  GYDDevelopment
//
//  Created by gongyadong on 2023/3/14.
//  Copyright © 2023 宫亚东. All rights reserved.
//

#import "GYDValueTools.h"

@implementation GYDValueTools

+ (void)fitMinValue:(double)minValue maxValue:(double)maxValue wantCount:(NSInteger)wantCount spaceScale:(double)spaceScale toBaseValue:(double *)baseValue step:(double *)step count:(NSInteger *)count stepHead:(nullable NSInteger *)stepHead {
    //先确保大小顺序
    if (minValue > maxValue) {
        CGFloat tmp = minValue;
        minValue = maxValue;
        maxValue = tmp;
    }
    if (wantCount < 1) {
        wantCount = 5;
    }
    
    CGFloat offset = (maxValue - minValue) / wantCount;
    if (offset == 0) {
        //间距小到接近0，那就根据值本身来设置范围。
        offset = minValue / wantCount;
        if (offset == 0) {
            //值本身也小到接近0，那就定死一个 -1 ~ 1的范围
            *baseValue = -1;
            *step = 1;
            *count = 2;
            return;
        }
        if (offset < 0) {
            offset = -offset;
        }
    }
    //移动小数点，取开头2~20的范围，设置整数刻度
    NSInteger ten = 0;
    while (offset > 20) {
        offset /= 10;
        ten ++;
    }
    while (offset < 2) {
        offset *= 10;
        ten --;
    }
    if (offset > 10) {
        offset = 20;
    } else if (offset > 5) {
        offset = 10;
    } else {
        offset = 5;
    }
    if (stepHead) {
        if (offset == 5) {
            *stepHead = offset;
        } else {
            *stepHead = offset / 10;
        }
    }
    //再把小数点移回去
    while (ten > 0) {
        offset *= 10;
        ten --;
    }
    while (ten < 0) {
        offset /= 10;
        ten ++;
    }
    
    //最终取值的时候，上下边距至少留下spaceScale * step的空白区间
    *baseValue = floor(minValue / offset - spaceScale) * offset;
    *step = offset;
    *count = ceil(maxValue / offset + spaceScale - *baseValue / offset);
}

@end
