//
//  GYDTimeValuePathDisplayView.h
//  GYDTimeValuePath
//
//  Created by 宫亚东 on 2018/4/28.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDTimeValuePath.h"

/**
 显示轨迹以及0点的坐标轴，4个label在4角显示坐标。横坐标time右为正，纵坐标value上为正。
 */
@interface GYDTimeValuePathDisplayView : UIView

@property (nonatomic)   GYDTimeValuePath *timeValuePath;
@property (nonatomic)   CGRect  timeValueFrame;//(startTime,minValue)-(timeLength,valueLength)

@end
