//
//  GYDRectShape.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDShape.h"

@interface GYDRectShape : GYDShape

#pragma mark - 真实属性
/** 矩形 */
@property (nonatomic) CGRect rectValue;
/** 圆角 */
@property (nonatomic) CGFloat cornerRadius;

#pragma mark - 映射属性
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


@end
