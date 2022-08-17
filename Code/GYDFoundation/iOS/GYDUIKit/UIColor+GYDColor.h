//
//  UIColor+GYDColor.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/6/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 颜色定义
/**
 16进制颜色，例如：
 GYDColorRGB(ff0000);   //红色
 GYDColorRGBA(00ff00,0.5);  //半透明绿色
 GYDColorGray(ff)       //白色
 */
#define GYDColorRGB(rrggbb)      [UIColor colorWithRed:(((0x##rrggbb)>>16)&0xFF)/255.0 \
green:(((0x##rrggbb)>>8)&0xFF)/255.0 \
blue:((0x##rrggbb)&0xFF)/255.0 \
alpha:1.0]

#define GYDColorRGBA(rrggbb, alpha)  [UIColor colorWithRed:(((0x##rrggbb)>>16)&0xFF)/255.0 \
green:(((0x##rrggbb)>>8)&0xFF)/255.0 \
blue:((0x##rrggbb)&0xFF)/255.0 \
alpha:(alpha)]

#define GYDColorGray(ff) GYDColorRGB(ff##ff##ff)

@interface UIColor (GYDColor)

/** 红，绿，蓝，不透明度。如红色：0xFF0000FF */
+ (nonnull UIColor *)gyd_colorWithRGBAValue:(uint32_t)value;
/** 不透明度，红，绿，蓝。如红色：0xFFFF0000 */
+ (nonnull UIColor *)gyd_colorWithARGBValue:(uint32_t)value;
/** 红绿蓝，不透明度。例：(0xF1F2F3,0.4) */
+ (nonnull UIColor *)gyd_colorWithRGBValue:(uint32_t)value alpha:(CGFloat)alpha;

/** 字符串转颜色，参数为6或8位十六进制数组成的字符串，可以加"#"或"0x"或"0X"开头，否则是nil */
+ (nullable UIColor *)gyd_colorWithRGBAString:(nonnull NSString *)string;

/** 字符串转颜色，参数为6或8位十六进制数组成的字符串，可以加"#"或"0x"或"0X"开头，否则是nil */
+ (nullable UIColor *)gyd_colorWithARGBString:(nonnull NSString *)string;

/** 两种颜色值中间的过渡颜色值，progress为过渡比例，通过16进制每两位一组计算过渡值 */
+ (uint32_t)gyd_valueBetweenValue1:(uint32_t)value1 value2:(uint32_t)value2 progress:(CGFloat)progress;

/** 判断两个颜色是否相同 */
- (BOOL)gyd_isEqualToColor:(nonnull UIColor *)color;

@end
