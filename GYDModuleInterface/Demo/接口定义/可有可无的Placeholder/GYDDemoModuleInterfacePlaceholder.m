//
//  GYDDemoModuleInterfacePlaceholder.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/6/19.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDemoModuleInterfacePlaceholder.h"
#import "GYDDemoModuleInterface.h"

@interface GYDDemoModuleInterfacePlaceholder ()<GYDDemoModuleInterfaceProtocol>

@end

@implementation GYDDemoModuleInterfacePlaceholder

+ (void)load {
    if (!GYDDemoModuleInterface.delegate) {
        GYDDemoModuleInterface.delegate = [[self alloc] init];
    }
}


- (UIViewController *)createDemoViewController {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = @"占位";
    return vc;
}

@end
