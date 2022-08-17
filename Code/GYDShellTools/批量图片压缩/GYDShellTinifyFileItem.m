//
//  GYDShellTinifyFileItem.m
//  GYDFoundation
//
//  Created by gongyadong on 2020/12/17.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellTinifyFileItem.h"

@implementation GYDShellTinifyFileItem

- (NSString *)description {
    return [self gyd_JSONString];
}
- (NSString *)debugDescription {
    return [self description];
}

@end
