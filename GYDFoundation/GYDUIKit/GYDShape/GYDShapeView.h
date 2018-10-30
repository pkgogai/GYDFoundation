//
//  GYDShapeView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDShape.h"

@interface GYDShapeView : UIView

- (void)addShape:(GYDShape *)shape;
- (void)removeShape:(GYDShape *)shape;

@end

