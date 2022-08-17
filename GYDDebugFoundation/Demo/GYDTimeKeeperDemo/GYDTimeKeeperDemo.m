//
//  GYDTimeKeeperDemo.m
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/7/25.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import "GYDTimeKeeperDemo.h"
#include "gyd_timekeeper.h"

@implementation GYDTimeKeeperDemo

- (void)test {
    //创建计时者，并申请2次打点（take）的空间
    gyd_timekeeper_t *t = gyd_timekeeper_create(2);
    //开始打点计时
    sleep(1);
    gyd_timekeeper_take(t, "sleep1");
    for (int i = 0; i < 10000; i++) {
    }
    gyd_timekeeper_take(t, "for10000");
    
    //打点次数超出，这时候要再去分配内存，影响统计。规则见内部实现
    gyd_timekeeper_take(t, "out");
    
    gyd_timekeeper_print_seconds(t);
    
    gyd_timekeeper_free(t);
    t = nil;
}

- (void)testGlobal3 {
    //创建下标为3的全局计时器（0、1、2还是空的），并申请10次打点的空间。
    gyd_timekeeper_global_create(3, 10);
    //先暂停，暂时不统计
    gyd_timekeeper_global_pause(3);
    for (int i = 0; i < 10; i++) {
        [self step3];
    }
    gyd_timekeeper_global_take(3, "10次step3中for循环消耗的时间");
    gyd_timekeeper_global_print_milliseconds(3);
    gyd_timekeeper_global_free(3);
}

- (void)step3 {
    usleep(10);
    //继续统计
    gyd_timekeeper_global_goon(3);
    for (int i = 0; i < 1000; i++) {
    }
    //暂停统计。
    gyd_timekeeper_global_pause(3);
    
}

@end
