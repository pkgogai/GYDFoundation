//
//  UIImage+GYDDebugInfo.m
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/9/7.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "UIImage+GYDDebugInfo.h"
#import <objc/runtime.h>
#include "gyd_class_property.h"

@implementation UIImage (GYDDebugInfo)

#pragma mark - 图片名字
static char ImageNameKey;
- (void)setGyd_imageName:(NSString *)gyd_imageName {
    objc_setAssociatedObject(self, &ImageNameKey, gyd_imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)gyd_imageName {
    return objc_getAssociatedObject(self, &ImageNameKey);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gyd_exchangeClassSelector(self, @selector(imageNamed:), self, @selector(GYDDebugInfo_imageNamed:));
        gyd_exchangeClassSelector(self, @selector(imageWithContentsOfFile:), self, @selector(GYDDebugInfo_imageWithContentsOfFile:));
        
        gyd_exchangeSelector(self, @selector(initWithContentsOfFile:), self, @selector(initWithContentsOfFile_GYDDebugInfo:));
        
        gyd_exchangeSelector(self, @selector(stretchableImageWithLeftCapWidth:topCapHeight:), self, @selector(GYDDebugInfo_stretchableImageWithLeftCapWidth:topCapHeight:));
        gyd_exchangeSelector(self, @selector(resizableImageWithCapInsets:), self, @selector(GYDDebugInfo_resizableImageWithCapInsets:));
        gyd_exchangeSelector(self, @selector(resizableImageWithCapInsets:resizingMode:), self, @selector(GYDDebugInfo_resizableImageWithCapInsets:resizingMode:));
    });
}

+ (UIImage *)GYDDebugInfo_imageNamed:(NSString *)name {
    UIImage *image = [self GYDDebugInfo_imageNamed:name];
    image.gyd_imageName = name;
    return image;
}
+ (UIImage *)GYDDebugInfo_imageWithContentsOfFile:(NSString *)path {
    UIImage *image = [self GYDDebugInfo_imageWithContentsOfFile:path];
    image.gyd_imageName = [[path lastPathComponent] stringByDeletingPathExtension];
    return image;
}

- (instancetype)initWithContentsOfFile_GYDDebugInfo:(NSString *)path {
    UIImage *image = [self initWithContentsOfFile_GYDDebugInfo:path];
    image.gyd_imageName = [[path lastPathComponent] stringByDeletingPathExtension];
    return image;
}

- (UIImage *)GYDDebugInfo_stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight {
    UIImage *image = [self GYDDebugInfo_stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    image.gyd_imageName = self.gyd_imageName;
    return image;
}
- (UIImage *)GYDDebugInfo_resizableImageWithCapInsets:(UIEdgeInsets)capInsets {
    UIImage *image = [self GYDDebugInfo_resizableImageWithCapInsets:capInsets];
    image.gyd_imageName = self.gyd_imageName;
    return image;
}
- (UIImage *)GYDDebugInfo_resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode {
    UIImage *image = [self GYDDebugInfo_resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    image.gyd_imageName = self.gyd_imageName;
    return image;
}


/*
 + (nullable UIImage *)imageNamed:(NSString *)name;      // load from main bundle
 + (nullable UIImage *)imageWithContentsOfFile:(NSString *)path;
 - (nullable instancetype)initWithContentsOfFile:(NSString *)path;
 - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight API_UNAVAILABLE(tvos);
 
 - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets API_AVAILABLE(ios(5.0)); // create a resizable version of this image. the interior is tiled when drawn.
 - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode API_AVAILABLE(ios(6.0)); // the interior is resized according to the resizingMode
 */

@end
