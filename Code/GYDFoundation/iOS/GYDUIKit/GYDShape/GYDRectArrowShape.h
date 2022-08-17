//
//  GYDRectArrowShape.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/2/18.
//

#import "GYDShape.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDRectArrowShape : GYDShape

/** 矩形 */
@property (nonatomic) CGRect rectValue;
/** 圆角 */
@property (nonatomic) CGFloat cornerRadius;
/** 箭头目标 */
@property (nonatomic) CGPoint arrowLocation;

@end

NS_ASSUME_NONNULL_END
