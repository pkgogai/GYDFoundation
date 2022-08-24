//
//  GYDEdgeInsetsObject.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/8/23.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 对应 UIEdgeInsets
 方便放入数组和字典
 */
@interface GYDEdgeInsetsObject : NSObject
{
    @public
    CGFloat _top;
    CGFloat _left;
    CGFloat _right;
    CGFloat _bottom;
}
@end

NS_ASSUME_NONNULL_END
