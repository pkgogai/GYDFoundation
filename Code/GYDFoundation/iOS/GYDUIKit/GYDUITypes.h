//
//  GYDUIStructToArray.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/10/14.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef union {
    CGPoint pointValue;
    CGSize sizeValue;
    CGRect rectValue;
    UIEdgeInsets edgeInsetsValue;
    
    CGFloat arrayValue[4];
} GYDUIStructUnion;

//未验证：用swift重载 + - 后，在OC中大概率不能用，就不试了

static inline UIEdgeInsets UIEdgeInsetsAddInsets(UIEdgeInsets insets1, UIEdgeInsets insets2) {
    insets1.top += insets2.top;
    insets1.left += insets2.left;
    insets1.bottom += insets2.bottom;
    insets1.right += insets2.right;
    return insets1;
}

static inline UIEdgeInsets UIEdgeInsetsSubInsets(UIEdgeInsets insets1, UIEdgeInsets insets2) {
    insets1.top -= insets2.top;
    insets1.left -= insets2.left;
    insets1.bottom -= insets2.bottom;
    insets1.right -= insets2.right;
    return insets1;
}

NS_ASSUME_NONNULL_END
