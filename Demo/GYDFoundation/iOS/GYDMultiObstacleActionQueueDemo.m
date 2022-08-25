//
//  GYDMultiObstacleActionQueueDemo.m
//  GYDFoundationDemo
//
//  Created by gongyadong on 2022/8/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDMultiObstacleActionQueueDemo.h"
#import "GYDMultiObstacleActionQueueManager.h"
#import "GYDDemoMenu.h"

@implementation GYDMultiObstacleActionQueueDemo

+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"GYDMultiObstacleActionQueue" desc:@"可以阻碍导致延后执行的操作队列" order:60 vcClass:self];
    menu.action = ^{
        [[[self alloc] init] test1];
    };
    [menu addToMenu:GYDDemoMenuRootName];
}

- (void)test1 {
    
    /*
     场景举例：
     1. webview ua异步修改，需要修改完成之后再执行其它代码
     2. 用户同意隐私弹窗之前，第三方库、埋点等代码暂不执行，延后到用户同意隐私弹窗后执行。
     */
    
    //weak一下，免得block里有警告不好看。全局对象，不存在引用问题。
    __weak GYDMultiObstacleActionQueueManager *manager = [GYDMultiObstacleActionQueueManager defaultManager];
    //没有阻碍，log1 顺利执行
    [manager addAction:^{
        NSLog(@"1");
    } forBrakeIdentifier:@"log"];
    
    [manager addObstacle:@"障碍1" forBrakeIdentifier:@"log"];
    [manager addObstacle:@"障碍2" forBrakeIdentifier:@"log"];
    
    //有障碍1，障碍2阻碍，这些暂时不会执行
    [manager addAction:^{
        NSLog(@"3");
    } forBrakeIdentifier:@"log"];
    [manager addUniqueAction:^{
            NSLog(@"-");
    } forKey:@"action1" brakeIdentifier:@"log"];
    [manager addAction:^{
        NSLog(@"4");
    } forBrakeIdentifier:@"log"];
    //和log-有着相同的key，log-被移除
    [manager addUniqueAction:^{
            NSLog(@"5");
    } forKey:@"action1" brakeIdentifier:@"log"];
    
    NSLog(@"2");
    
    [manager removeObstacle:@"障碍1" forBrakeIdentifier:@"log"];
    [manager removeObstacle:@"障碍2" forBrakeIdentifier:@"log"];
    //阻碍都被移除了，log345 被按顺序执行
    
    //嵌套使用的效果
    [manager addAction:^{
        NSLog(@"6");
        [manager addAction:^{
            NSLog(@"7");
        } forBrakeIdentifier:@"log"];
        NSLog(@"8");
        
        [manager addObstacle:@"障碍1" forBrakeIdentifier:@"log"];
        
        [manager addAction:^{
            NSLog(@"10");
        } forBrakeIdentifier:@"log"];
        
        NSLog(@"9");
        
        [manager removeObstacle:@"障碍1" forBrakeIdentifier:@"log"];
        
        NSLog(@"11");
    } forBrakeIdentifier:@"log"];
    
}

- (void)test3 {
    /*
     场景举例
     1. 多个操作共用一个loading。
     */
    GYDMultiObstacleActionQueue *queue = [[GYDMultiObstacleActionQueue alloc] init];
    queue.valueChangedAction = ^(GYDMultiObstacleActionQueue * _Nonnull queue, BOOL hasObstacle) {
        if (hasObstacle) {
            NSLog(@"start loading");
        } else {
            NSLog(@"stop loading");
        }
    };
    //有请求在，触发start loading
    [queue addObstacle:@"request1"];
    [queue addObstacle:@"request2"];
    
    
    [queue removeObstacle:@"request1"];
    [queue removeObstacle:@"request2"];
    //所有请求都结束了，触发stop loading
}

@end
