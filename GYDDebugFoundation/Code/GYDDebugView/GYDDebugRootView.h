//
//  GYDDebugRootView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDDebugControlView.h"

NS_ASSUME_NONNULL_BEGIN
extern const CGFloat GYDLogViewMinWidth;//45
/**
 日志窗口框架，控制按钮和主界面外部控制。
 */
@interface GYDDebugRootView : UIView

/** 控制条，自带全屏按钮 */
@property (nonatomic, readonly) GYDDebugControlView *controlView;

/** 主界面 */
@property (nonatomic) UIView *contentView;

@end

NS_ASSUME_NONNULL_END
