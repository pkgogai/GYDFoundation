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
 描述，
 参数，
 坐标图GYDTimeValuePathDisplayView
 */
@interface GYDTimeValuePathItemView : UIView

@property (nonatomic)   NSString *title;
@property (nonatomic)   GYDTimeValuePath *timeValuePath;
@property (nonatomic)   CGRect  timeValueFrame;//(startTime,minValue)-(timeLength,valueLength)

@end
