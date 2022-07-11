//
//  GYDLogSpaceCellView.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLogSpaceCellView.h"

@implementation GYDLogSpaceCellView
{
    GYDLogSpaceCellModel *_model;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (CGFloat)updateWithModel:(GYDLogSpaceCellModel *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight {
    if (!onlyCalculateHeight) {
        _model = model;
        self.backgroundColor = model.color;
    }
    return model.height;
}

@end
