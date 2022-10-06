//
//  GYDDebugInfoDemo.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/9/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugInfoDemo.h"
#import "GYDDemoMenu.h"
#import "UIView+GYDDebugInfo.h"

@implementation GYDDebugInfoDemo

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"" desc:@"记录view在什么方法中创建" order:100 vcClass:self];
    menu.name = UIView.gyd_recordCreateInfo ? @"已记录View创建信息" : @"未记录View创建信息";
    __weak GYDDemoMenu *weakMenu = menu;
    menu.action = ^{
        GYDDemoMenu *strongMenu = weakMenu;if (!strongMenu) {return;}
        UIView.gyd_recordCreateInfo = !UIView.gyd_recordCreateInfo;
        strongMenu.name = UIView.gyd_recordCreateInfo ? @"已记录View创建信息" : @"未记录View创建信息";
    };
    
    [menu addToMenu:@"调试信息"];
    
    menu = [GYDDemoMenu menuWithName:@"调试信息" desc:nil order:101];
    [menu addToMenu:GYDDemoMenuRootName];
}

@end
