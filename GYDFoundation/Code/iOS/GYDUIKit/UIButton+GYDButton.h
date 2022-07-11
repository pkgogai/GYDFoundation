//
//  UIButton+GYDButton.h
//  GYDFoundationDevelopment
//
//  Created by 宫亚东 on 2018/11/10.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIButtonGYDButtonActionBlock)(UIButton * _Nonnull button);

@interface UIButton (GYDButton)

/** 设置点击事件，唯一 */
- (void)gyd_setClickActionBlock:(nonnull UIButtonGYDButtonActionBlock)block;

/** 执行点击事件 */
- (void)gyd_doClickAction;


@end
