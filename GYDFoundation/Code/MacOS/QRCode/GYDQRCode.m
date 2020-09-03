//
//  GYDQRCode.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/02.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDQRCode.h"
#import <AppKit/AppKit.h>
#import <CoreImage/CoreImage.h>
#import "CIImage+GYDCIImage.h"

@implementation GYDQRCode

+ (nonnull CIImage *)QRCodeCIImageWithString:(nonnull NSString *)string size:(NSInteger)size level:(GYDQRCodeCorrectionLevel)level {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //输入信息
    NSData *inputData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:inputData forKey:@"inputMessage"];
    
    //设置容错率
    NSString *levelString = @"M";
    if (level == GYDQRCodeCorrectionLevelM) {
        //
    } else if (level == GYDQRCodeCorrectionLevelL) {
        levelString = @"L";
    } else if (level == GYDQRCodeCorrectionLevelQ) {
        levelString = @"Q";
    } else if (level == GYDQRCodeCorrectionLevelH) {
        levelString = @"H";
    }
    [filter setValue:levelString forKey:@"inputCorrectionLevel"];
    
    CIImage *ciImage = filter.outputImage;
    
    //调整大小
    CGSize oSize = ciImage.extent.size;
    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(size / oSize.width, size / oSize.height)];
    
    return ciImage;
}
/** 将文字生成二维码图片 */
+ (nonnull NSImage *)QRCodeImageWithString:(nonnull NSString *)string size:(NSInteger)size {
    CIImage *ciImage = [self QRCodeCIImageWithString:string size:size level:GYDQRCodeCorrectionLevelM];
    return [ciImage gyd_NSImage];
}

/** 将文字生成二维码图片数据 */
+ (nonnull NSData *)QRCodeImageDataWithString:(nonnull NSString *)string size:(NSInteger)size {
    CIImage *ciImage = [self QRCodeCIImageWithString:string size:size level:GYDQRCodeCorrectionLevelM];
    return [ciImage gyd_PNGData];
}

@end
