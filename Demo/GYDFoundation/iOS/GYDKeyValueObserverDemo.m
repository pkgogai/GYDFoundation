//
//  GYDKeyValueObserverDemo.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/8/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDKeyValueObserverDemo.h"
#import "GYDKeyValueObserver.h"
#import "GYDDemoMenu.h"
@implementation GYDKeyValueObserverDemo
{
    GYDKeyValueObserver *_o1;
}

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"GYDKeyValueObserver" desc:@"安全的KVO" order:65 vcClass:self];
    menu.action = ^{
        [[[self alloc] init] test1];
    };
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)test1 {
    UIView *view = [[UIView alloc] init];
    
    _o1 = [view gyd_addObserverForKeyPath:@"frame" options:NSKeyValueObservingOptionNew changeAction:^(id  _Nullable object, NSDictionary<NSKeyValueChangeKey,id> * _Nullable change) {
        NSLog(@"o1: %@", change);
    }];
    GYDKeyValueObserver *o2 = [view gyd_addObserverForKeyPath:@"frame" options:NSKeyValueObservingOptionNew changeAction:^(id  _Nullable object, NSDictionary<NSKeyValueChangeKey,id> * _Nullable change) {
        NSLog(@"o2: %@", change);
    }];;
    NSLog(@"此时 o1, o2 都在监听 frame");
    view.frame = CGRectMake(0, 0, 100, 100);
    o2 = nil;   //o2的监听已经释放
    NSLog(@"此时只有 o1 在监听 frame");
    view.frame = CGRectMake(0, 0, 200, 200);
    
    //o1 也去监听别的东西了
    _o1 = [view gyd_addObserverForKeyPath:@"bounds" options:NSKeyValueObservingOptionNew changeAction:^(id  _Nullable object, NSDictionary<NSKeyValueChangeKey,id> * _Nullable change) {
        NSLog(@"o1: %@", change);
    }];
    NSLog(@"此时没有监听 frame");
    view.frame = CGRectMake(0, 0, 200, 200);
}

@end
