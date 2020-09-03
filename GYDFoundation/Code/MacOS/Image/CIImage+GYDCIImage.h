//
//  CIImage+GYDCIImage.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/03.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIImage (GYDCIImage)

- (nonnull NSImage *)gyd_NSImage;

- (nonnull NSData *)gyd_PNGData;

/** 根据灰度生成单色图片，0为foreColor, 255为backColor，例如生成特殊颜色的二维码图片 */
- (nonnull CIImage *)gyd_imageWithForeColor:(CIColor *)foreColor backColor:(CIColor *)backColor;

@end

NS_ASSUME_NONNULL_END
