//
//  GYDDebugWindow.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/24.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用于将view展示成置顶窗口
 */
@interface GYDDebugWindow : UIWindow

- (instancetype)initWithRootView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
