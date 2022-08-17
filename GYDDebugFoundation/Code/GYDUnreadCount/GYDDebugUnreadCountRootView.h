//
//  GYDDebugUnreadCountRootView.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/3/30.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDUnreadCountManager.h"

NS_ASSUME_NONNULL_BEGIN
/**
 展示红点关系的视图
 */
@interface GYDDebugUnreadCountRootView : UIScrollView

/*
 根据红点关系生成标签视图，并用来更新UI。关系改变要重新设置。
 */
- (void)updateWithUnreadCountManager:(GYDUnreadCountManager *)manager;

@end

NS_ASSUME_NONNULL_END
