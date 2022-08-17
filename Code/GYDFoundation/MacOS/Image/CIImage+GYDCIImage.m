//
//  CIImage+GYDCIImage.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/03.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "CIImage+GYDCIImage.h"

@implementation CIImage (GYDCIImage)

- (nonnull NSImage *)gyd_NSImage {
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:self fromRect:self.extent];
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:self.extent.size];
    CGImageRelease(cgImage);
    
    return image;
}

- (nonnull NSData *)gyd_PNGData {
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCIImage:self];
    NSData *imageData = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
    
    return imageData;
}

- (nonnull CIImage *)gyd_imageWithForeColor:(CIColor *)foreColor backColor:(CIColor *)backColor {
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"
                                  keysAndValues:@"inputImage", self, @"inputColor0", foreColor, @"inputColor1",backColor, nil];
    return filter.outputImage;
}

@end
