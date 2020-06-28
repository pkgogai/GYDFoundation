//
//  GYDTimeValuePathItemView.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDTimeValuePath.h"

/**
 一个高度20的label显示标题描述，下面是坐标图GYDTimeValuePathDisplayView
 */
@interface GYDTimeValuePathItemView : UIView

@property (nonatomic)   GYDTimeValuePath *timeValuePath;
@property (nonatomic)   CGRect  timeValueFrame;//(startTime,minValue)-(timeLength,valueLength)

@end
