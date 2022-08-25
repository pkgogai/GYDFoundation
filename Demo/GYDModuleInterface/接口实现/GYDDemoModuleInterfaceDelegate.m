//
//  GYDDemoModuleInterfaceDelegate.m
//  GYDDevelopment
//
//  Created by gongyadong on 2021/6/19.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import "GYDDemoModuleInterfaceDelegate.h"
#import "GYDDemoModuleInterface.h"
#import "GYDDemoMenu.h"

@interface GYDDemoModuleInterfaceDelegate ()<GYDDemoModuleInterfaceProtocol>

@end

@implementation GYDDemoModuleInterfaceDelegate

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"模块接口" desc:@"定义接口协议，一个模块里实现，其它模块调用。" order:55 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (UIViewController *)createDemoViewController {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.title = @"Demo";
    return viewController;
}

@end
