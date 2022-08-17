//
//  GYDQRCode.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/02.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

//容错率L 7%,M 15%,Q 25%,H 30%
typedef enum : NSUInteger {
    GYDQRCodeCorrectionLevelL,
    GYDQRCodeCorrectionLevelM,  //推荐
    GYDQRCodeCorrectionLevelQ,
    GYDQRCodeCorrectionLevelH,
} GYDQRCodeCorrectionLevel;

@interface GYDQRCode : NSObject

/** 生成二维码的基础方法，可继续通过CIImage的类别进行加工 */
+ (nonnull CIImage *)QRCodeCIImageWithString:(nonnull NSString *)string size:(NSInteger)size level:(GYDQRCodeCorrectionLevel)level;

/** 将文字生成二维码图片 */
+ (nonnull NSImage *)QRCodeImageWithString:(nonnull NSString *)string size:(NSInteger)size;

/** 将文字生成二维码图片数据 */
+ (nonnull NSData *)QRCodeImageDataWithString:(nonnull NSString *)string size:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
