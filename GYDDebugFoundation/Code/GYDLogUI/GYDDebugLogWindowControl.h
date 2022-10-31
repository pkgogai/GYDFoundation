//
//  GYDDebugLogWindowControl.h
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/4/21.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDDebugWindow.h"
NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugLogWindowControl : NSObject

@property (nonatomic, class, readonly) GYDDebugWindow *window;

/**
 show则创建，否则隐藏
 */
@property (nonatomic, class, getter=isShow) BOOL show;

@end

NS_ASSUME_NONNULL_END
