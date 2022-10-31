//
//  UIView+GYDPanToMove.h
//  Pods
//
//  Created by gongyadong on 2022/9/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UIViewGYDPanToMoveActionBlock)(UIView *view, CGPoint from, CGPoint *to);

@interface UIView (GYDPanToMove)

- (void)gyd_setMovePanGestureRecognizerEnable:(BOOL)enable action:(UIViewGYDPanToMoveActionBlock)action;

@end

NS_ASSUME_NONNULL_END
