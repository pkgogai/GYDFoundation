//
//  UIGestureRecognizer+GYDBlock.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2022/6/30.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UIGestureRecognizerGYDBlockActionBlock)(UIGestureRecognizer *gr);

@interface UIGestureRecognizer (GYDBlock)

- (instancetype)initWithActionBlock_gyd:(UIGestureRecognizerGYDBlockActionBlock)action;

@end

NS_ASSUME_NONNULL_END
