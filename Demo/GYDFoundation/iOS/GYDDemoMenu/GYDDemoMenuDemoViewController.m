//
//  GYDDemoMenuDemoViewController.m
//  GYDDevelopment
//
//  Created by gongyadong on 2020/12/24.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDDemoMenuDemoViewController.h"
#import "GYDUIKit.h"
#import "GYDDemoMenuTreeView.h"

@implementation GYDDemoMenuDemoViewController
{
    GYDDemoMenuTreeView *_menuView;
}

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"DemoMenu" desc:nil order:1 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *dic = GYDDemoMenu.menuDictionary;
    GYDDemoMenu.menuDictionary = nil;
    {
        GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"a" desc:@"1" order:100];
        [menu addToMenu:GYDDemoMenuRootName];
        [menu addToMenu:@"d"];
    }
    {
        GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"b" desc:nil order:101];
        [menu addToMenu:GYDDemoMenuRootName];
        [menu addToMenu:@"d"];
    }
    {
        GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"c" desc:nil order:102];
        [menu addToMenu:@"a"];
    }
    {
        GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"d" desc:nil order:103];
        [menu addToMenu:@"a"];
        [menu addToMenu:@"b"];
    }
    {
        GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"a" desc:@"2" order:104];
        [menu addToMenu:@"e"];
    }
    {
        GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"k" desc:nil order:105];
        [menu addToMenu:@"h"];
    }
    {
        GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"h" desc:nil order:106];
        [menu addToMenu:@"k"];
    }
    
    _menuView = [[GYDDemoMenuTreeView alloc] initWithFrame:CGRectZero];
    
    GYDDemoMenu.menuDictionary = dic;
    
    [self.view addSubview:_menuView];
    
    if (@available(iOS 11.0, *)) {
        _menuView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _menuView.frame = self.view.bounds;
    _menuView.contentInset = self.view.gyd_safeAreaInsets;
}



@end
