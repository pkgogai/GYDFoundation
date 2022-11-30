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
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"记录View创建信息" desc:@"打开后，新alloc的View可用" order:100 vcClass:self];
    __weak GYDDemoMenu *weakMenu = menu;
    menu.action = ^{
        GYDDemoMenu *strongMenu = weakMenu;if (!strongMenu) {return;}
        UIView.gyd_recordCreateInfo = !UIView.gyd_recordCreateInfo;
    };
    
    [menu addToMenu:@"调试信息"];
    
    menu = [GYDDemoMenu menuWithName:@"调试信息" desc:nil order:101];
    [menu addToMenu:GYDDemoMenuRootName];
}

@end
