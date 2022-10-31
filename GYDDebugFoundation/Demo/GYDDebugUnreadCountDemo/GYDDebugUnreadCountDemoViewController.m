//
//  GYDDebugUnreadCountDemoViewController.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/8/18.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDDebugUnreadCountDemoViewController.h"
#import "GYDDebugUnreadCountWindowControl.h"
#import "GYDDemoMenu.h"

@implementation GYDDebugUnreadCountDemoViewController

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"红点关系" desc:@"展示红点关系" order:100 vcClass:self];
    menu.action = ^{
        
        GYDUnreadCountManager *manager = [[GYDUnreadCountManager alloc] init];
        //定义红点关系
        [manager bindTypeArray:@[@"消息", @"设置", @"新闻", @"循环A"] toType:@"APP"];
        [manager bindTypeArray:@[@"通知", @"聊天", @"天气"] toType:@"消息"];
        [manager bindTypeArray:@[@"开PUSH", @"完善信息"] toType:@"设置"];
        [manager bindTypeArray:@[@"天气", @"新闻列表"] toType:@"新闻"];
        [manager bindType:@"循环B" toType:@"循环A"];
        [manager bindType:@"循环C" toType:@"循环B"];
        [manager bindType:@"循环A" toType:@"循环B"];
        [manager bindType:@"循环的处理效果" toType:@"循环B"];
        
        //初始值
        [manager setValue:-1 forType:@"天气"];
        [manager setValue:10 forType:@"聊天"];
        [manager setValue:-1 forType:@"循环的处理效果"];
        [self gyd_unreadCountAddNotificationForType:@"聊天" manager:manager callNow:NO action:^(GYDUnreadCountManagerActionParameter arg) {
//            NSInteger value = arg.value;
            //值被改变，可以选择保存或者展示新值
        }];
        
        
        [GYDDebugUnreadCountWindowControl showWithUnreadCountManager:manager];
    };
    [menu addToMenu:@"调试窗口"];
}

@end
