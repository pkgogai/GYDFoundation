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
} GYDUIStructToArray;

NS_ASSUME_NONNULL_END
