//
//  UIImage+GYDImage.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "UIImage+GYDImage.h"
#import "GYDFoundationPrivateHeader.h"
#import <Accelerate/Accelerate.h>   //图像模糊时使用
#import "GYDCircleShape.h"
#import "GYDRectShape.h"
#import "GYDLineShape.h"

@implementation UIImage (GYDImage)

#pragma mark ----- 加载图片 -----

//没实现
/** 通过[[UIImage alloc] initXXX]创建，不缓存 */
//+ (nullable UIImage *)imageWithoutCacheNamed:(nonnull NSString *)name {
//
//    return nil;
//}

#pragma mark ----- 纯色图片 -----
/** 纯色图片，边长1.0 */
+ (nonnull UIImage *)gyd_imageWithColor:(nonnull UIColor *)color {
    return [self gyd_imageWithColor:color size:CGSizeMake(1, 1)];
}
/** 指定大小的纯色图片 */
+ (nonnull UIImage *)gyd_imageWithColor:(nonnull UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark ----- 圆形图片 -----

/** 圆形，半径，边框颜色，填充颜色，线条宽度，dashWidth=0是实线，dashWidth>0是虚线长度，dashClearWidth>0是虚线间隙的长度，=0表示和dashWidth相同，颜色为nil的忽略 */
+ (nonnull UIImage *)gyd_imageWithCircleRadius:(CGFloat)radius
                                   borderColor:(nullable UIColor *)borderColor
                                     fillColor:(nullable UIColor *)fillColor
                                     lineWidth:(CGFloat)lineWidth
                                     dashWidth:(CGFloat)dashWidth
                                dashClearWidth:(CGFloat)dashClearWidth {
    GYDCircleShape *circle = [[GYDCircleShape alloc] init];
    circle.lineColor = borderColor;
    circle.fillColor = fillColor;
    circle.lineWidth = lineWidth;
    circle.dashWidth = dashWidth;
    circle.dashClearWidth = dashClearWidth;
    circle.centerX = radius;
    circle.centerY = radius;
    circle.r = radius - lineWidth * 0.5;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius * 2, radius * 2), NO, [UIScreen mainScreen].scale);
    [circle drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark ----- 圆角矩形图片 -----
/** 矩形：宽，高，圆角，边线颜色，填充颜色，虚线宽度>0为虚线 */
+ (nonnull UIImage *)gyd_imageWithRectWidth:(CGFloat)width
                                     height:(CGFloat)height
                               cornerRadius:(CGFloat)cornerRadius
                                borderColor:(nullable UIColor *)borderColor
                                  fillColor:(nullable UIColor *)fillColor
                                  lineWidth:(CGFloat)lineWidth
                                  dashWidth:(CGFloat)dashWidth
                             dashClearWidth:(CGFloat)dashClearWidth {
    GYDRectShape *rect = [[GYDRectShape alloc] init];
    rect.lineColor = borderColor;
    rect.fillColor = fillColor;
    rect.lineWidth = lineWidth;
    rect.dashWidth = dashWidth;
    rect.dashClearWidth = dashClearWidth;
    rect.rectValue = CGRectMake(0.5 * lineWidth, 0.5 * lineWidth, width - lineWidth, height - lineWidth);
    rect.cornerRadius = cornerRadius;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [UIScreen mainScreen].scale);
    [rect drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark ----- 线条图片 -----
/** 画线：长，宽，颜色，dashWidth>0表示虚线。虚线是虚实相隔，每段长度都是dashWidth，dashClearWidth>0则dashWidth和dashClearWidth分别代表虚实长度 */
+ (nonnull UIImage *)gyd_imageWithLineWidth:(CGFloat)width
                                     height:(CGFloat)height
                                      color:(nullable UIColor *)color
                                  dashWidth:(CGFloat)dashWidth
                             dashClearWidth:(CGFloat)dashClearWidth {
    
    GYDLineShape *line = [[GYDLineShape alloc] init];
    line.lineColor = color;
    line.lineWidth = (width < height ? width : height);
    line.dashWidth = dashWidth;
    line.dashClearWidth = dashClearWidth;
    CGFloat halfWidth = line.lineWidth * 0.5;
    line.point1 = CGPointMake(halfWidth, halfWidth);
    line.point2 = CGPointMake(width - halfWidth, height - halfWidth);
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [UIScreen mainScreen].scale);
    [line drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark ----- 通过视图获得图片 -----
/** 通过view生成图片，默认是符合屏幕比例的高清图 */
+ (nonnull UIImage *)gyd_imageWithView:(nonnull UIView *)view {
    return [self gyd_imageWithView:view scale:[UIScreen mainScreen].scale];
}
/** 通过view生成图片，scale表示几倍图，0表示屏幕比例 */
+ (nonnull UIImage *)gyd_imageWithView:(nonnull UIView *)view scale:(CGFloat)scale {
    if (scale == 1) {
        UIGraphicsBeginImageContext(view.frame.size);
    } else {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    }
    
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES]; ??????
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/** 截取view指定范围的图片， */
+ (nonnull UIImage *)gyd_imageWithView:(nonnull UIView *)view scale:(CGFloat)scale rect:(CGRect)rect {
    if (scale == 1) {
        UIGraphicsBeginImageContext(rect.size);
    } else {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-rect.origin.x, -rect.origin.y));
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark ----- 图片处理 -----
/** 模糊图片，radius模糊半径，useOriginal是否使用原件处理，如果为NO，则会根据radius先压缩图片再进行模糊以减少性能消耗 */
- (nonnull UIImage *)gyd_blurImageWithRadius:(int)radius useOriginal:(BOOL)useOriginal {
    //缩小----------
    CGImageRef img;
    BOOL imgIsCreate = NO;
    CGSize size = self.size;
    if (useOriginal || radius < 4 || size.width < 2 || size.height < 2) {
        img = self.CGImage;
        imgIsCreate = NO;
    } else {
        //设置图片压缩比例
        CGFloat scale = radius / 4;
        if (size.width < scale) {
            scale = size.width;
        }
        if (size.height < scale) {
            scale = size.height;
        }
        size.width = size.width / scale;
        size.height = size.height / scale;
        
        UIGraphicsBeginImageContext(size);
        CGContextRef cf = UIGraphicsGetCurrentContext();
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        img = CGBitmapContextCreateImage(cf);
        UIGraphicsEndImageContext();
        imgIsCreate = YES;
    }
    
    int boxSize = radius*2 +1;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);    //耗时最长的函数
    
    vImage_Buffer inBuffer, outBuffer;
    
    outBuffer.width = inBuffer.width = CGImageGetWidth(img);
    outBuffer.height = inBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    CGBitmapInfo bitmapInfo =  CGImageGetBitmapInfo(img);
    if (imgIsCreate) {
        CGImageRelease(img);
    }
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    void *tmpBuffer = malloc(inBuffer.rowBytes * inBuffer.height);
    outBuffer.data = tmpBuffer;
    
    vImage_Error error = vImageTentConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize,NULL, kvImageEdgeExtend);
    
    //outBuffer = inBuffer;
    if (error) {
        GYDFoundationWarning(@"模糊失败:vImage_Error=%lld", (long long)error);
        free(tmpBuffer);
        CFRelease(inBitmapData);
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             bitmapInfo);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(tmpBuffer);
    CFRelease(inBitmapData);
    
    return returnImage;
}

/** 图片截取 */
- (nonnull UIImage *)gyd_subimageWithRect:(CGRect)rect {
    CGImageRef cg = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *returnImage = [UIImage imageWithCGImage:cg];
    CGImageRelease(cg);
    return returnImage;
}

/** 图片拉伸（没测试，比如图片角度对不对之类的，就需要测试） */
- (nonnull UIImage *)gyd_scaleImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

/** 从中间拉伸后的 */
- (nonnull UIImage *)gyd_stretchableImageFromCenter {
    CGSize size = self.size;
    return [self stretchableImageWithLeftCapWidth:0.5 * size.width topCapHeight:0.5 * size.height];
}

@end
