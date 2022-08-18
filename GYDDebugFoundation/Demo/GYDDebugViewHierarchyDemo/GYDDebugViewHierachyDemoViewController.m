//
//  GYDDebugViewHierachyDemoViewController.m
//  GYDDebugFoundationDemo
//
//  Created by gongyadong on 2022/8/17.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugViewHierachyDemoViewController.h"
#import "GYDDebugViewHierarchyWindowControl.h"
#import "GYDDemoMenu.h"

@implementation GYDDebugViewHierachyDemoViewController

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"ViewHierachy" desc:@"展示视图层级" order:100];
    menu.action = ^{
        GYDDebugViewHierarchyWindowControl.show = !GYDDebugViewHierarchyWindowControl.show;
    };
    [menu addToMenu:@"调试窗口"];
    
    menu = [GYDDemoMenu menuWithName:@"调试窗口" desc:nil order:100];
    [menu addToMenu:GYDDemoMenuRootName];
}

@end
