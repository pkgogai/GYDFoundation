//
//  GYDDemoModuleInterfaceDelegate.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/6/19.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDemoModuleInterfaceDelegate.h"
#import "GYDDemoModuleInterface.h"

@interface GYDDemoModuleInterfaceDelegate ()<GYDDemoModuleInterfaceProtocol>

@end

@implementation GYDDemoModuleInterfaceDelegate

- (UIViewController *)createDemoViewController {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.title = @"Demo";
    return viewController;
}

@end
