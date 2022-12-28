//
//  GYDDebugUnreadCountWindowControl.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/30.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDUnreadCountManager.h"

NS_ASSUME_NONNULL_BEGIN
/**
 红点关系窗口的控制
 [!image-name:E9A17609-ADB4-4856-9272-313864C03126.jpge]
 */
@interface GYDDebugUnreadCountWindowControl : NSObject

/** 只能显示1个manager */
+ (void)showWithUnreadCountManager:(GYDUnreadCountManager *)manager;
/** 隐藏 */
+ (void)hide;

/** 判断是否已经显示 */
+ (BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
