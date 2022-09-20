//
//  UIImage+GYDDebugInfo.h
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/9/7.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GYDDebugInfo)

#pragma mark - 图片名字
@property (nonatomic, copy) NSString *gyd_imageName;

@end

NS_ASSUME_NONNULL_END

/*
 给UIImage加文件名
 准备先处理这几个方法，
 + (nullable UIImage *)imageNamed:(NSString *)name;      // load from main bundle
 + (nullable UIImage *)imageWithContentsOfFile:(NSString *)path;
 - (nullable instancetype)initWithContentsOfFile:(NSString *)path;
 - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight API_UNAVAILABLE(tvos);
 - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets API_AVAILABLE(ios(5.0)); // create a resizable version of this image. the interior is tiled when drawn.
 - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode API_AVAILABLE(ios(6.0)); // the interior is resized according to the resizingMode
 
 下面的方法不管了，谁有需要谁自己写
 + (nullable UIImage *)imageNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection API_AVAILABLE(ios(8.0));
 + (nullable UIImage *)systemImageNamed:(NSString *)name API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 + (nullable UIImage *)systemImageNamed:(NSString *)name withConfiguration:(nullable UIImageConfiguration *)configuration API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 
 + (nullable UIImage *)systemImageNamed:(NSString *)name compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 

 + (nullable UIImage *)imageNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle withConfiguration:(nullable UIImageConfiguration *)configuration API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));

 
 + (nullable UIImage *)imageWithData:(NSData *)data;
 + (nullable UIImage *)imageWithData:(NSData *)data scale:(CGFloat)scale API_AVAILABLE(ios(6.0));
 - (nullable instancetype)initWithData:(NSData *)data;
 - (nullable instancetype)initWithData:(NSData *)data scale:(CGFloat)scale API_AVAILABLE(ios(6.0));
 
 + (nullable UIImage *)animatedImageNamed:(NSString *)name duration:(NSTimeInterval)duration API_AVAILABLE(ios(5.0));  // read sequence of files with suffix starting at 0 or 1
 + (nullable UIImage *)animatedResizableImageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets duration:(NSTimeInterval)duration API_AVAILABLE(ios(5.0)); // sequence of files
 + (nullable UIImage *)animatedResizableImageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode duration:(NSTimeInterval)duration API_AVAILABLE(ios(6.0));
 + (nullable UIImage *)animatedImageWithImages:(NSArray<UIImage *> *)images duration:(NSTimeInterval)duration API_AVAILABLE(ios(5.0));
  
 - (UIImage *)imageWithAlignmentRectInsets:(UIEdgeInsets)alignmentInsets API_AVAILABLE(ios(6.0));
 - (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode API_AVAILABLE(ios(7.0));
 - (UIImage *)imageFlippedForRightToLeftLayoutDirection API_AVAILABLE(ios(9.0));
 @property (nonatomic, readonly) BOOL flipsForRightToLeftLayoutDirection API_AVAILABLE(ios(9.0));
 - (UIImage *)imageWithHorizontallyFlippedOrientation API_AVAILABLE(ios(10.0));
 - (UIImage *)imageWithBaselineOffsetFromBottom:(CGFloat)baselineOffset API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 - (UIImage *)imageWithoutBaseline API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 - (nullable UIImage *)imageByApplyingSymbolConfiguration:(UIImageSymbolConfiguration *)configuration API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 - (UIImage *)imageWithTintColor:(UIColor *)color API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 - (UIImage *)imageWithTintColor:(UIColor *)color renderingMode:(UIImageRenderingMode)renderingMode API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0));
 
 */
