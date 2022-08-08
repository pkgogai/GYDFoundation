//
//  UIView+GYDFrame.h
//  GYDDevelopment
//
//  Created by 宫亚东 on 2017/3/22.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GYDFrame)

/** 左边界x坐标 */
@property (nonatomic) CGFloat gyd_x;
/** 上边界y坐标 */
@property (nonatomic) CGFloat gyd_y;

/** 中心点x坐标 */
@property (nonatomic) CGFloat gyd_centerX;
/** 中心点y坐标 */
@property (nonatomic) CGFloat gyd_centerY;

/** 右边界x坐标，修改次值时移动view，不改变size */
@property (nonatomic) CGFloat gyd_rightX;
- (void)gyd_setRightX:(CGFloat)rightX changeWidth:(BOOL)changeWidth;

/** 下边界y坐标，修改次值时移动view，不改变size */
@property (nonatomic) CGFloat gyd_bottomY;
- (void)gyd_setBottomY:(CGFloat)bottomY changeHeight:(BOOL)changeHeight;

/** 宽 */
@property (nonatomic) CGFloat gyd_width;
/** 高 */
@property (nonatomic) CGFloat gyd_height;

/** 左上角坐标 */
@property (nonatomic) CGPoint gyd_origin;
@property (nonatomic) CGPoint gyd_originInt; //取整
/** 大小 */
@property (nonatomic) CGSize  gyd_size;
@property (nonatomic) CGSize  gyd_sizeInt; //取整
/** bounds.size */
@property (nonatomic) CGSize  gyd_boundsSize;
@property (nonatomic) CGSize  gyd_boundsSizeInt; //取整

/** frame */
@property (nonatomic) CGRect gyd_frameInt;  //取整

@end
