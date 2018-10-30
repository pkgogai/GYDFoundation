//
//  GYDCircleShape.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDShape.h"

@interface GYDCircleShape : GYDShape

#pragma mark - 真实属性
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGFloat r;

#pragma mark - 映射属性
@property (nonatomic, readwrite) CGRect rectValue;

@end
