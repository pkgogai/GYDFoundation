//
//  Type2View.m
//  iOSExample
//
//  Created by 宫亚东 on 2018/10/31.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "Type2View.h"
#import "Type2Model.h"

@implementation Type2View
{
    Type2Model *_model;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (CGFloat)updateWithModel:(nonnull Type2Model *)model width:(CGFloat)width onlyCalculateHeight:(BOOL)onlyCalculateHeight {
    //type2样式
    self.backgroundColor = [UIColor redColor];
    return 10;
}

@end
