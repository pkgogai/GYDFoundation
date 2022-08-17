//
//  gyd_timekeeper.c
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/13.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#include "gyd_timekeeper.h"
#import <mach/mach_time.h>

#pragma mark - 创建销毁
/** 创建 */
gyd_timekeeper_t * gyd_timekeeper_create(int count) {
    if (count < 1) {
        count = 100;
    }
    gyd_timekeeper_t* info = malloc(sizeof(gyd_timekeeper_t));
    info->data = malloc(count * sizeof(gyd_timekeeper_item_t));
    info->count = count;
    info->index = 0;
    info->pause_time = 0;
    info->base_time = mach_absolute_time();
    return info;
}
/** 释放 */
void gyd_timekeeper_free(gyd_timekeeper_t *info) {
    if (!info) {
        return;
    }
    free(info->data);
    free(info);
}

#pragma mark - 计时，计数
/** 打点 */
void gyd_timekeeper_take(gyd_timekeeper_t *info, const char *tag) {
    if (info->index >= info->count) {
        printf("gyd_debug_time统计（%d,%s）超过预设数量%d", info->index, tag ?: "", info->count);
        if (info->count > 1000) {
            return;
        }
        info->count += 100;
        info->data = realloc(info->data, info->count * sizeof(gyd_timekeeper_item_t));
    }
    info->data[info->index].tag = tag;
    
    info->data[info->index].offset_time = (info->pause_time ?: mach_absolute_time()) - info->base_time;
    
    info->index ++;
}
/** 当前时长 */
double gyd_timekeeper_get_seconds(gyd_timekeeper_t *info) {
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    double step = (double)timebase.numer / timebase.denom / 1000 / 1000 / 1000;
    uint64_t offset = (info->pause_time ?: mach_absolute_time()) - info->base_time;
    
    return step * offset;
}
/** 获取时钟计数 */
uint64_t gyd_timekeeper_get_mach_time(gyd_timekeeper_t *info) {
    uint64_t offset = (info->pause_time ?: mach_absolute_time()) - info->base_time;
    return offset;
}

/// 打印结果
/// @param info 记录的信息
/// @param div 结果默认纳秒，再此基础上可以添加除数
void gyd_timekeeper_print(gyd_timekeeper_t *info, double div) {
    if (info->index == 0) {
        return;
    }
    //不开发的方法就不需要判断了
//    if (div == 0) {
//        div = 1;
//    }
    uint64_t lastTime = 0;
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    double step = (double)timebase.numer / timebase.denom / div;
    for (int i = 0; i < info->index; i++) {
        gyd_timekeeper_item_t item = info->data[i];
        printf("relative:%lf, absolute:%lf,tag:%s\n", (item.offset_time - lastTime) * step, item.offset_time * step, item.tag ?: "");
        lastTime = item.offset_time;
    }
}
/** 打印结果 */
void gyd_timekeeper_print_seconds(gyd_timekeeper_t *info) {
    printf("单位秒(s)\n");
    gyd_timekeeper_print(info, 1000 * 1000 * 1000);
}
/** 打印结果 */
void gyd_timekeeper_print_milliseconds(gyd_timekeeper_t *info) {
    printf("单位毫秒(ms)\n");
    gyd_timekeeper_print(info, 1000 * 1000);
}

#pragma mark - 调整
/** 重置到开始状态 */
void gyd_timekeeper_reset(gyd_timekeeper_t *info) {
    info->index = 0;
    info->pause_time = 0;
    info->base_time = mach_absolute_time();
}
/** 暂停计时 */
void gyd_timekeeper_pause(gyd_timekeeper_t *info) {
    if (info->pause_time == 0) {
        info->pause_time = mach_absolute_time();
    }
}
/** 恢复计时 */
void gyd_timekeeper_goon(gyd_timekeeper_t *info) {
    if (info->pause_time == 0) {
        return;
    }
    info->base_time += mach_absolute_time() - info->pause_time;
    info->pause_time = 0;
}

#pragma mark - 单独一次计时

/** 获取时钟计数 */
uint64_t gyd_get_mach_time(void) {
    return mach_absolute_time();
}
/** 通过之前获取的时钟计数，计算到现在的秒数 */
double gyd_get_seconds_from_mach_time(uint64_t time) {
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    double step = (double)timebase.numer / timebase.denom / 1000 / 1000 / 1000;
    uint64_t offset = mach_absolute_time() - time;
    
    return step * offset;
}


#pragma mark - 加一套全局的，方便跨函数使用，用法看前面的函数
static gyd_timekeeper_t **global_timekeeper = NULL;
static int global_timekeeper_count = -1;

/** 创建 */
void gyd_timekeeper_global_create(int index, int count) {
    if (!global_timekeeper) {
        global_timekeeper_count = index + 1;
        global_timekeeper = malloc(global_timekeeper_count * sizeof(gyd_timekeeper_t *));
        //memset 0
    } else {
        if (index >= global_timekeeper_count) {
            global_timekeeper_count = index + 1;
            global_timekeeper = realloc(global_timekeeper, global_timekeeper_count * sizeof(gyd_timekeeper_t *));
            //memset 0
        }
    }
    //if != 0 err
    global_timekeeper[index] = gyd_timekeeper_create(count);
}
/** 释放 */
void gyd_timekeeper_global_free(int index) {
    //if == 0 return
    gyd_timekeeper_free(global_timekeeper[index]);
    global_timekeeper[index] = NULL;
}
/** 打点 */
void gyd_timekeeper_global_take(int index, const char *tag) {
    gyd_timekeeper_take(global_timekeeper[index], tag);
}
/** 当前时长（秒） */
double gyd_timekeeper_global_get_seconds(int index) {
    return gyd_timekeeper_get_seconds(global_timekeeper[index]);
}
/** 获取时钟计数 */
uint64_t gyd_timekeeper_global_get_mach_time(int index) {
    return gyd_timekeeper_get_mach_time(global_timekeeper[index]);
}
/** 打印结果 */
void gyd_timekeeper_global_print_seconds(int index) {
    gyd_timekeeper_print_seconds(global_timekeeper[index]);
}
/** 打印结果 */
void gyd_timekeeper_global_print_milliseconds(int index) {
    gyd_timekeeper_print_milliseconds(global_timekeeper[index]);
}
/** 重置到开始状态 */
void gyd_timekeeper_global_reset(int index) {
    gyd_timekeeper_reset(global_timekeeper[index]);
}
/** 暂停计时 */
void gyd_timekeeper_global_pause(int index) {
    gyd_timekeeper_pause(global_timekeeper[index]);
}
/** 恢复计时 */
void gyd_timekeeper_global_goon(int index) {
    gyd_timekeeper_goon(global_timekeeper[index]);
}
