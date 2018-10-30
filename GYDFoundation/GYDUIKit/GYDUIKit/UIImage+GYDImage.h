//
//  UIImage+GYDImage.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GYDImageNamed(name) [UIImage imageNamed:name]
#define GYDImageWithoutCacheNamed(name) [UIImage imageWithoutCacheNamed:name]

@interface UIImage (GYDImage)

#pragma mark ----- 加载图片 -----
/** 通过[[UIImage alloc] initXXX]创建，不缓存 */
//+ (nullable UIImage *)imageWithoutCacheNamed:(nonnull NSString *)name NS_DEPRECATED_IOS(1_0, 1_0, "没实现");

#pragma mark ----- 纯色图片 -----
/** 纯色图片，边长1.0 */
+ (nonnull UIImage *)gyd_imageWithColor:(nonnull UIColor *)color;
/** 指定大小的纯色图片 */
+ (nonnull UIImage *)gyd_imageWithColor:(nonnull UIColor *)color size:(CGSize)size;

#pragma mark ----- 圆形图片 -----

/** 圆形，半径，边框颜色，填充颜色，线条宽度，dashWidth=0是实线，dashWidth>0是虚线长度，dashClearWidth>0是虚线间隙的长度，=0表示和dashWidth相同，颜色为nil的忽略 */
+ (nonnull UIImage *)gyd_imageWithCircleRadius:(CGFloat)radius
                                   borderColor:(nullable UIColor *)borderColor
                                     fillColor:(nullable UIColor *)fillColor
                                     lineWidth:(CGFloat)lineWidth
                                     dashWidth:(CGFloat)dashWidth
                                dashClearWidth:(CGFloat)dashClearWidth;

#pragma mark ----- 圆角矩形图片 -----
/** 矩形：宽，高，圆角，边线颜色，填充颜色，虚线宽度>0为虚线 */
+ (nonnull UIImage *)gyd_imageWithRectWidth:(CGFloat)width
                                     height:(CGFloat)height
                               cornerRadius:(CGFloat)cornerRadius
                                borderColor:(nullable UIColor *)borderColor
                                  fillColor:(nullable UIColor *)fillColor
                                  lineWidth:(CGFloat)lineWidth
                                  dashWidth:(CGFloat)dashWidth
                             dashClearWidth:(CGFloat)dashClearWidth;

#pragma mark ----- 线条图片 -----
/** 画线：长，宽，颜色，dashWidth>0表示虚线。虚线是虚实相隔，每段长度都是dashWidth，dashClearWidth>0则dashWidth和dashClearWidth分别代表虚实长度 */
+ (nonnull UIImage *)gyd_imageWithLineWidth:(CGFloat)width
                                     height:(CGFloat)height
                                      color:(nullable UIColor *)color
                                  dashWidth:(CGFloat)dashWidth
                             dashClearWidth:(CGFloat)dashClearWidth;

#pragma mark ----- 通过视图获得图片 -----
/** 通过view生成图片，默认是符合屏幕比例的高清图 */
+ (nonnull UIImage *)gyd_imageWithView:(nonnull UIView *)view;
/** 通过view生成图片，scale表示几倍图，0表示屏幕比例 */
+ (nonnull UIImage *)gyd_imageWithView:(nonnull UIView *)view scale:(CGFloat)scale;
/** 截取view指定范围的图片， */
+ (nonnull UIImage *)gyd_imageWithView:(nonnull UIView *)view scale:(CGFloat)scale rect:(CGRect)rect;

#pragma mark ----- 图片处理 -----
/** 模糊图片，radius模糊半径，useOriginal是否使用原件处理，如果为NO，则会根据radius先压缩图片再进行模糊以减少性能消耗 */
- (nonnull UIImage *)gyd_blurImageWithRadius:(int)radius useOriginal:(BOOL)useOriginal;

/** 图片截取 */
- (nonnull UIImage *)gyd_subimageWithRect:(CGRect)rect;

/** 图片拉伸（没测试，比如图片角度对不对之类的，就需要测试） */
- (nonnull UIImage *)gyd_scaleImageWithSize:(CGSize)size;

/** 从中间拉伸后的 */
- (nonnull UIImage *)gyd_stretchableImageFromCenter;

@end

