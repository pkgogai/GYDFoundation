//
//  GYDShapeView.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDShape.h"

/**
 self.backgroundColor必须有透明度，否则系统认定这个view的颜色是不透明的，就不处理透明情况了，绘制的透明图形也就直接变成了黑色。具体要怎样才能让系统强制按有透明度来处理呢？opaque等设置没用。
 */
@interface GYDShapeView : UIView

- (void)addShape:(GYDShape *)shape;
- (void)removeShape:(GYDShape *)shape;

@end
