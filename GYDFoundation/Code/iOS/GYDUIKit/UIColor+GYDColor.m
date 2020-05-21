//
//  UIColor+GYDColor.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/6/29.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "UIColor+GYDColor.h"
#import "GYDFoundationPrivateHeader.h"

@implementation UIColor (GYDColor)

/** 红，绿，蓝，不透明度。如红色：0xFF0000FF */
+ (nonnull UIColor *)gyd_colorWithRGBAValue:(uint32_t)value {
    return [UIColor colorWithRed:((value >> 24) & 0xFF) / 255.0 \
                           green:((value >> 16) & 0xFF) / 255.0 \
                            blue:((value >>  8) & 0xFF) / 255.0 \
                           alpha:((value >>  0) & 0xFF) / 255.0];
}
/** 不透明度，红，绿，蓝。如红色：0xFFFF0000 */
+ (nonnull UIColor *)gyd_colorWithARGBValue:(uint32_t)value {
    return [UIColor colorWithRed:((value >> 16) & 0xFF) / 255.0 \
                           green:((value >>  8) & 0xFF) / 255.0 \
                            blue:((value >>  0) & 0xFF) / 255.0 \
                           alpha:((value >> 24) & 0xFF) / 255.0];
}

/** 红绿蓝，不透明度。例：(0xF1F2F3,0.4) */
+ (nonnull UIColor *)gyd_colorWithRGBValue:(uint32_t)value alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((value >> 16) & 0xFF) / 255.0 \
                           green:((value >>  8) & 0xFF) / 255.0 \
                            blue:((value >>  0) & 0xFF) / 255.0 \
                           alpha:alpha];
}

/** 字符串转颜色，参数为6或8位十六进制数组成的字符串，可以加"#"或"0x"或"0X"开头，否则是nil */
+ (nullable UIColor *)gyd_colorWithRGBAString:(nonnull NSString *)string {
    return [self gyd_colorWithHexString:string alphaAtHead:NO];
}

/** 字符串转颜色，参数为6或8位十六进制数组成的字符串，可以加"#"或"0x"或"0X"开头，否则是nil */
+ (nullable UIColor *)gyd_colorWithARGBString:(nonnull NSString *)string {
    return [self gyd_colorWithHexString:string alphaAtHead:YES];
}

+ (nullable UIColor *)gyd_colorWithHexString:(nonnull NSString *)string alphaAtHead:(BOOL)alphaAtHead {
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    } else if ([string hasPrefix:@"0x"] || [string hasPrefix:@"0X"]) {
        string = [string substringFromIndex:2];
    }
    if (string.length == 8) {
        uint32_t c = 0;
        [[NSScanner scannerWithString:string] scanHexInt:&c];
        if (alphaAtHead) {
            return [self gyd_colorWithARGBValue:c];
        } else {
            return [self gyd_colorWithRGBAValue:c];
        }
    } else if (string.length == 6) {
        uint32_t c = 0;
        [[NSScanner scannerWithString:string] scanHexInt:&c];
        return [self gyd_colorWithRGBValue:c alpha:1];
    } else {
        GYDFoundationWarning(@"参数格式错误，要求为6或8位十六进制数组成的字符串，可以加#或0x或0X开头:%@", string);
        return nil;
    }
}

/** 两种颜色值中间的过渡颜色值，progress为过渡比例，通过16进制每两位一组计算过渡值 */
+ (uint32_t)gyd_valueBetweenValue1:(uint32_t)value1 value2:(uint32_t)value2 progress:(CGFloat)progress {
    CGFloat r1,r2,g1,g2,b1,b2,a1,a2;
    r1 = ((value1 >> 24) & 0xFF) / 255.0;
    g1 = ((value1 >> 16) & 0xFF) / 255.0;
    b1 = ((value1 >> 8) & 0xFF) / 255.0;
    a1 = ((value1 >> 0) & 0xFF) / 255.0;
    
    r2 = ((value2 >> 24) & 0xFF) / 255.0;
    g2 = ((value2 >> 16) & 0xFF) / 255.0;
    b2 = ((value2 >> 8) & 0xFF) / 255.0;
    a2 = ((value2 >> 0) & 0xFF) / 255.0;
    
    return ((uint32_t)(r1 + (r2-r1)*progress) << 24) \
    + ((uint32_t)(g1 + (g2-g1)*progress) << 16) \
    + ((uint32_t)(b1 + (b2-b1)*progress) << 8) \
    + ((uint32_t)(a1 + (a2-a1)*progress));
}

/** 判断两个颜色是否相同 */
- (BOOL)gyd_isEqualToColor:(nonnull UIColor *)color {
    return CGColorEqualToColor(self.CGColor, color.CGColor);
}

@end
