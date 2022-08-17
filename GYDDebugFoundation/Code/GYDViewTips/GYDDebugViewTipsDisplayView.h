//
//  GYDDebugViewTipsDisplayView.h
//  GYDDevelopment
//
//  Created by gongyadong on 2021/1/4.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDShapeView.h"
#import "GYDDebugViewTipsDisplayViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDDebugViewTipsDisplayView : GYDShapeView

- (void)addItem:(GYDDebugViewTipsDisplayViewModel *)item;

- (void)removeItem:(GYDDebugViewTipsDisplayViewModel *)item;

- (void)removeAll;

@end

NS_ASSUME_NONNULL_END
