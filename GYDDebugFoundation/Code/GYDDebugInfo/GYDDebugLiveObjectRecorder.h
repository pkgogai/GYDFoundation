//
//  GYDDebugLiveObjectRecorder.h
//  GYDDebugFoundation
//
//  Created by gongyadong on 2022/7/21.
//  Copyright © 2022 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 记录存活的对象，如果怀疑app内有NSObject类的内存泄漏
 app运行稳定后，进行几次怀疑有内存泄漏的操作，当单例等特殊对象都创建好。调用restart开始记录，
 再进行一次怀疑有内存泄漏的操作，会记录下这期间新创建并存活着的所有NSObject对象。
 pause = YES 暂停记录新对象，继续使用app一段时间。
 获取或直接打印依然存活的对象。
 警告：由于这些对象不一定是在什么线程创建和使用的，因此获取这些对象后，app很可能会出现线程安全问题，建议重启app后再进行其它测试。
 
 todo：研究一下怎么暂停线程，这样在主线程获取对象并统计期间，将别的线程都暂停了，应该就安全了吧？
 
 */
@interface GYDDebugLiveObjectRecorder : NSObject

/** 重新开始（清空）记录 */
+ (void)restart;

/** 是否暂停记录新对象 */
@property (nonatomic, class) BOOL pause;

/** 清空记录并停止 */
+ (void)clearAndStop;

/**
 获取记录着的对象
 警告：这些对象不一定是在什么线程使用，出现线程问题实属正常。
 */
+ (NSSet<NSObject *> *)liveObjects;

/** 打印记录的情况 */
+ (void)print;


@end

NS_ASSUME_NONNULL_END
