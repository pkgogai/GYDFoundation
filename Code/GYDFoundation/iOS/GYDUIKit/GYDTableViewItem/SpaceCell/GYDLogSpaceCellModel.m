//
//  GYDLogSpaceCellModel.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/10/25.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLogSpaceCellModel.h"
#import "GYDLogSpaceCellView.h"

@implementation GYDLogSpaceCellModel

- (BOOL)shouldClick {
    return NO;
}

- (NSString *)identifier {
    return @"space";
}

- (Class)viewClass {
    return [GYDLogSpaceCellView class];
}

@end
