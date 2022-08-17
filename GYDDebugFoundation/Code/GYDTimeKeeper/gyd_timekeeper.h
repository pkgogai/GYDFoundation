//
//  gyd_timekeeper.h
//  GYDFoundation
//
//  Created by gongyadong on 2022/7/13.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#ifndef gyd_timekeeper_h
#define gyd_timekeeper_h

#include <stdio.h>

/*
 不要用 block ，block会改变代码缩进，影响代码的git提交记录
 
 */

typedef struct {
    //给个标签，方便区分不同的计时点
    const char *tag;
    //绝对时差，暂时用mach_absolute_time(iOS10以后还有个mach_continuous_time可以包含锁屏时间)
    uint64_t offset_time;
} gyd_timekeeper_item_t;

typedef struct {
    //记录打点的数组
    gyd_timekeeper_item_t *data;
    //用于计算时长，最初值是开始的时间点，暂停等操作可以修改这个值
    uint64_t base_time;
    //暂停时记录的时间点
    uint64_t pause_time;
    //数组内存总数
    int count;
    //本次打点的下标
    int index;
} gyd_timekeeper_t;

#pragma mark - 创建销毁
/** 创建：申请count长的数组用于记录打点（take） */
gyd_timekeeper_t * gyd_timekeeper_create(int count);
/** 释放：内部的空间是malloc出来的，需要free */
void gyd_timekeeper_free(gyd_timekeeper_t *info);

#pragma mark - 计时，计数
/** 打点：记录一个点位，打印信息时tag会随着一起打印，方便查看。为了减少对时间的影响，tag直接记录指针值，没有copy */
void gyd_timekeeper_take(gyd_timekeeper_t *info, const char *tag);
/** 当前时长（秒）：从create或reset开始累计 */
double gyd_timekeeper_get_seconds(gyd_timekeeper_t *info);
/** 获取时钟计数：从create或reset开始累计 */
uint64_t gyd_timekeeper_get_mach_time(gyd_timekeeper_t *info);
/** 打印结果（秒）：每2个相邻点位的时差，以及每个点位的时间 */
void gyd_timekeeper_print_seconds(gyd_timekeeper_t *info);
/** 打印结果（毫秒） */
void gyd_timekeeper_print_milliseconds(gyd_timekeeper_t *info);

#pragma mark - 调整
/** 重置到开始状态 */
void gyd_timekeeper_reset(gyd_timekeeper_t *info);
/** 暂停计时 */
void gyd_timekeeper_pause(gyd_timekeeper_t *info);
/** 恢复计时 */
void gyd_timekeeper_goon(gyd_timekeeper_t *info);

#pragma mark - 单独一次计时

/** 获取时钟计数 */
uint64_t gyd_get_mach_time(void);
/** 通过之前获取的时钟计数，计算到现在的秒数 */
double gyd_get_seconds_from_mach_time(uint64_t time);


#pragma mark - 加一套全局的，方便跨函数使用，用法看前面的函数
/** 创建，index表示使用全局的第几个gyd_timekeeper_t */
void gyd_timekeeper_global_create(int index, int count);
/** 释放 */
void gyd_timekeeper_global_free(int index);
/** 打点 */
void gyd_timekeeper_global_take(int index, const char *tag);
/** 当前时长（秒） */
double gyd_timekeeper_global_get_seconds(int index);
/** 获取时钟计数 */
uint64_t gyd_timekeeper_global_get_mach_time(int index);
/** 打印结果 */
void gyd_timekeeper_global_print_seconds(int index);
/** 打印结果 */
void gyd_timekeeper_global_print_milliseconds(int index);
/** 重置到开始状态 */
void gyd_timekeeper_global_reset(int index);
/** 暂停计时 */
void gyd_timekeeper_global_pause(int index);
/** 恢复计时 */
void gyd_timekeeper_global_goon(int index);


#endif /* gyd_timekeeper_h */
