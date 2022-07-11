//
//  GYDLogSpaceCellModel.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLogTableViewCellModel.h"

@interface GYDLogSpaceCellModel : GYDLogTableViewCellModel

@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat height;

- (BOOL)shouldClick;
- (nullable NSString *)identifier;

@end
