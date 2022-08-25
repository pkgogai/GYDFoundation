//
//  GYDCustomFunctionDemo.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/8/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDCustomFunctionDemo.h"
#import "GYDDemoMenu.h"
#import "NSObject+GYDCustomFunction.h"

@implementation GYDCustomFunctionDemo

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"GYDCustomFunction" desc:@"为NSObject扩展自定义的事件" order:50 vcClass:self];
    menu.action = ^{
        [[[self alloc] init] test1];
    };
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)test1 {
    [self gyd_setFunction:@"打印日志" withAction:^id _Nullable(id  _Nonnull obj, id  _Nullable arg) {
        NSLog(@"%@, %@", obj, arg);
        return nil;
    }];
    [self gyd_callFunction:@"打印日志" withArg:@"1"];
}

@end
