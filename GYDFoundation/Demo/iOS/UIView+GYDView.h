//
//  UIView+GYDView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/7/2.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GYDView)

/** 左边界x坐标 */
@property (nonatomic) CGFloat x;
/** 上边界y坐标 */
@property (nonatomic) CGFloat y;

/** 中心点x坐标 */
@property (nonatomic) CGFloat centerX;
/** 中心点y坐标 */
@property (nonatomic) CGFloat centerY;

/** 右边界x坐标 */
@property (nonatomic) CGFloat rightX;
/** 下边界y坐标 */
@property (nonatomic) CGFloat bottomY;

/** 宽 */
@property (nonatomic) CGFloat width;
/** 高 */
@property (nonatomic) CGFloat height;

/** 左上角坐标 */
@property (nonatomic) CGPoint origin;
/** 大小 */
@property (nonatomic) CGSize  size;






@end
