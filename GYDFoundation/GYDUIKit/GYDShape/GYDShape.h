//
//  GYDShape.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int32_t, GYDDrawMode) {
    /** 普通覆盖（会按透明度比例绘制） */
    GYDDrawModeNormal    = kCGBlendModeNormal,
    /** 清除 */
    GYDDrawModeClear     = kCGBlendModeClear,
    /** 清除并重新绘制 */
    GYDDrawModeClearAndDraw  = kCGBlendModeCopy,
};

@interface GYDShape : NSObject

/** 绘制方式 */
@property (nonatomic)   GYDDrawMode drawMode;

/** 边框颜色，默认值为nil，表示不画边框 */
@property (nonatomic, nullable) UIColor *lineColor;
/** 填充颜色，默认值为nil，表示不画填充 */
@property (nonatomic, nullable) UIColor *fillColor;
/** 线条宽度，默认值为1 */
@property (nonatomic)   CGFloat lineWidth;
/** 虚线宽度，>0有效 */
@property (nonatomic)   CGFloat dashWidth;
/** 虚线空白宽度---，dashWidth有效且此值大于0时有效，为0时虚实等宽 */
@property (nonatomic)   CGFloat dashClearWidth;

/** 绘图到 */
- (void)drawInContext:(nonnull CGContextRef)context;

#pragma mark - 子类必须重写

/** 子类根据自己形状重写path */
- (void)addPathInContext:(nonnull CGContextRef)context;

///** 动画类才有 */
//- (void)updateWithTimeOffset:(CGFloat)timeOffset;

@end
