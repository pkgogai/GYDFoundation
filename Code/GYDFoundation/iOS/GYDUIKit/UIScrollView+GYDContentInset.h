//
//  UIScrollView+GYDContentInset.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/8/23.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 为UIScrollView叠加多个contentInset设置，通过不同的key来区分。
 每次设置时，会将所有值都累加到一起，设置为contentInset
 */
@interface UIScrollView (GYDContentInset)

- (void)gyd_setContentInset:(UIEdgeInsets)inset forKey:(NSString *)key;

- (UIEdgeInsets)gyd_contentInsetForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
