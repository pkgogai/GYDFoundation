//
//  GYDLogControlView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GYDDebugControlViewLocation) {
    GYDDebugControlViewLocationNormal = 0,
    GYDDebugControlViewLocationHead = 1,
    GYDDebugControlViewLocationTail = 2,
};

/**
 日志窗口上面的操作条
 */
@interface GYDDebugControlView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)addControlItemView:(UIView *)view location:(GYDDebugControlViewLocation)location;

- (void)removeView:(UIView *)view;

@end

