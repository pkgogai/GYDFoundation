//
//  GYDLog.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import "GYDLog.h"
#import "GYDFile.h"
#import "GYDLogItemModel.h"

@implementation GYDLog

static NSFileHandle *_LogFileHandle = nil;  //文件句柄
static dispatch_queue_t _Queue = nil;       //记录文件的线程队列
static NSDateFormatter *_FileDataFormatter = nil;   //记录文件用的时间格式
static NSMutableArray *_LogArray = nil;     //临时缓存log数组，可以用来在crash时保存，或者显示到界面等


static GYDLogSetting   *_LogSetting = NULL;   //按log分级区分的设置
static NSUInteger       _LvCount = 0;           //log分级数量

static NSMutableDictionary *_LogTypeDictionary = nil;   //记录log种类开关
static BOOL _CheckLogType = YES;                        //是否按log种类检查，外发时就没必要检查了


static Class _LogItemModelClass = nil;

__weak static id<GYDLogCacheArrayChangedDelegate> _LogCacheArrayChangedDelegate;

+ (void)initialize
{
    if (self == [GYDLog class]) {
        if (_Queue) {
            return;
        }
        _Queue = dispatch_queue_create("gydlog", NULL);
        
        _FileDataFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        _FileDataFormatter.locale = locale;
        [_FileDataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.ss"];
        
        _LogArray = [NSMutableArray array];
        
        _LogTypeDictionary = [NSMutableDictionary dictionary];
    }
}

#pragma mark - 文件位置设置，在设置成功filePath之后的log才能被保存到文件

/** log文件存储路径 */
+ (BOOL)setLogFilePath:(nonnull NSString *)filePath errorMessage:(NSString * _Nullable * _Nullable)errorMessage {
    
    if (![GYDFile makeSureFileAtPath:filePath errorMessage:errorMessage]) {
        return NO;
    }
    //创建句柄
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!fileHandle) {
        if (errorMessage) {
            *errorMessage = [NSString stringWithFormat:@"创建文件句柄失败：%@", filePath];
        }
        return NO;
    }
    [fileHandle seekToEndOfFile];
    
    //记录句柄
    dispatch_sync(_Queue, ^{
        if (_LogFileHandle) {
            [_LogFileHandle closeFile];
        }
        _LogFileHandle = fileHandle;
    });
    
    return YES;
}
/** 同步log文件的操作，（log文件是异步写入的，所以crash的时候，先同步一下再上报文件会更完整） */
+ (void)synchronizeLogFile {
    dispatch_sync(_Queue, ^{
        
    });
}
/** 关闭log文件 */
+ (void)closeFile {
    dispatch_sync(_Queue, ^{
        if (_LogFileHandle) {
            [_LogFileHandle closeFile];
        }
        _LogFileHandle = nil;
    });
}


#pragma mark - LOG分级设置，设置好LOG分级后，LOG才能被按照设置进行处理

+ (void)setLvCount:(NSUInteger)lvCount {
    dispatch_async(_Queue, ^{
        if (lvCount <= _LvCount) {
            _LvCount = lvCount;
        } else {
            GYDLogSetting *tmp = malloc(sizeof(GYDLogSetting) * lvCount);
            memset(tmp, 0, sizeof(GYDLogSetting) * lvCount);
            if (_LogSetting) {
                memcpy(tmp, _LogSetting, sizeof(GYDLogSetting) * _LvCount);
                free(_LogSetting);
            }
            _LogSetting = tmp;
            _LvCount = lvCount;
        }
    });

}
+ (NSUInteger)lvCount {
    __block NSUInteger count = 0;
    dispatch_sync(_Queue, ^{
        count = _LvCount;
    });
    return count;
}

/** 根据log级别进行设置 */
+ (void)setLogSetting:(GYDLogSetting)setting forLv:(NSUInteger)lv {
    dispatch_sync(_Queue, ^{
        if (lv < _LvCount) {
            _LogSetting[lv] = setting;
            BOOL change = NO;
            for (NSUInteger i = setting.cachedUbound; i < _LogArray.count; i ++) {
                if (((id<GYDLogItemModelProtocol>)_LogArray[i]).lv == lv) {
                    [_LogArray removeObjectAtIndex:i];
                    i --;
                    change = YES;
                }
            }
            if (change) {
                if (_LogCacheArrayChangedDelegate && [_LogCacheArrayChangedDelegate respondsToSelector:@selector(logCacheArrayDidChangedWithNewLog:)]) {
                    [_LogCacheArrayChangedDelegate logCacheArrayDidChangedWithNewLog:nil];
                }
            }
        }
    });
}
/** 获取对应log级别的设置 */
+ (GYDLogSetting)logSettingForLv:(NSUInteger)lv {
    __block GYDLogSetting setting;
    dispatch_sync(_Queue, ^{
        if (lv < _LvCount) {
            setting = _LogSetting[lv];
        }
        
        setting.print = 0;
        setting.save = 0;
        setting.cachedUbound = 0;
        setting.prefix = NULL;
    });
    return setting;
}


#pragma mark - LOG种类的设置，不设置默认就都是开的

/** 设置是否检查log种类的开关，外发时所有种类都使用，为了节约一点点效率，就可以不检查这里的开关了。 */
+ (void)setCheckLogType:(BOOL)check {
    dispatch_async(_Queue, ^{
        _CheckLogType = check;
    });
}
+ (BOOL)checkLogType {
    __block BOOL check = NO;
    dispatch_sync(_Queue, ^{
        check = _CheckLogType;
    });
    return check;
}
/** 根据log种类设置开关 */
+ (void)setLogType:(NSString *)type on:(BOOL)on {
    dispatch_async(_Queue, ^{
        _LogTypeDictionary[type] = @(on);
    });
}
/** 获取设置过的开关状态 */
+ (BOOL)isLogTypeOn:(NSString *)type {
    __block BOOL r = NO;
    dispatch_sync(_Queue, ^{
        NSNumber *isOn = [_LogTypeDictionary objectForKey:type];
        if (isOn == nil) {
            r = YES;
        } else {
            r = [isOn boolValue];
        }
    });
    return r;
}

/** 所有设置过或使用过的开关种类都记录在案 */
+ (NSArray *)allTypesThatHaveBeenUsed {
    __block NSArray *r = nil;
    dispatch_sync(_Queue, ^{
        r = [_LogTypeDictionary allKeys];
    });
    return r;
}


#pragma mark - LOG使用

/** 设置用于记录log的model类型 */
+ (void)setLogItemModelClass:(Class<GYDLogItemModelProtocol>)logItemModelClass {
    dispatch_async(_Queue, ^{
        _LogItemModelClass = logItemModelClass;
    });
}
+ (Class<GYDLogItemModelProtocol>)logItemModelClass {
    __block Class<GYDLogItemModelProtocol> r = nil;
    dispatch_sync(_Queue, ^{
        r = _LogItemModelClass;
    });
    return r;
}

/** 获取log数组，新log排在前面 */
+ (NSArray *)logCacheArray {
    __block NSArray *r = nil;
    dispatch_sync(_Queue, ^{
        r = [_LogArray copy];
    });
    return r;
}

+ (void)setLogCacheArrayChangedDelegate:(id<GYDLogCacheArrayChangedDelegate>)logCacheArrayChangedDelegate {
    dispatch_async(_Queue, ^{
        _LogCacheArrayChangedDelegate = logCacheArrayChangedDelegate;
    });
}
+ (id<GYDLogCacheArrayChangedDelegate>)logCacheArrayChangedDelegate {
    __block id r = nil;
    dispatch_sync(_Queue, ^{
        r = _LogCacheArrayChangedDelegate;
    });
    return r;
}


/** 根据log种类的开关来打log */
+ (void)logType:(NSString *)type lv:(NSUInteger)lv fun:(const char *)fun msg:(NSString *)msg {
    dispatch_async(_Queue, ^{
        if (lv >= _LvCount) {
            NSLog(@"本LOG级别：%llu 超过范围，LOG级别要求小于 %llu", (unsigned long long)lv, (unsigned long long)_LvCount);
            return;
        }
        
        GYDLogSetting setting = _LogSetting[lv];
        NSDate *date = nil;
        //存储
        if (setting.save && _LogFileHandle != nil) {  //
            const char *prefix = setting.prefix ?: "";
            date = [NSDate date];
            dispatch_async(_Queue, ^{
                NSString *str = [NSString stringWithFormat:@"%@%@%s%s%@\n", [_FileDataFormatter stringFromDate:date], type ?: @"", prefix, fun, msg];
                [_LogFileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            });
        }
        
        //如果有需要，根据log种类判断log开关
        if (_CheckLogType && type) {
            NSNumber *isOn = [_LogTypeDictionary objectForKey:type];
            if (isOn == nil) {
                _LogTypeDictionary[type] = @(YES);
                isOn = @(YES);
            }
            if (![isOn boolValue]) {
                return;
            }
        }
        
        //打印
        if (setting.print) {
            NSLog(@"%@%s%s%@\n", type ?: @"", setting.prefix ?: "", fun, msg);
        }
        
        //缓存
        if (setting.cachedUbound > 0) {
            if (!date) {
                date = [NSDate date];
            }
            id<GYDLogItemModelProtocol> model = [[_LogItemModelClass ?: [GYDLogItemModel class] alloc] init];
            model.type = type;
            model.lv = lv;
            model.date = date;
            model.fun = fun;
            model.msg = msg;
            [_LogArray insertObject:model atIndex:0];
            
            //遍历所有级别LOG是否超出缓存界限，因为每添加一个Log都会检查1次，所以最多只会有1个超限的，只需要检查每个级别的界限的下一个元素是不是本级别的LOG来判断是否超限。
            NSUInteger deleteIndex = -1;    //最大值
            for (NSUInteger i = 0; i < _LvCount; i++) {
                if (deleteIndex < _LogSetting[i].cachedUbound) {    //每次只加入一条，既然要在缓存限制内删除一条，那就不会再超限
                    continue;
                }
                if (_LogArray.count > _LogSetting[i].cachedUbound) {
                    id<GYDLogItemModelProtocol> tmp = _LogArray[_LogSetting[i].cachedUbound];
                    if (tmp.lv == i) {
                        deleteIndex = _LogSetting[i].cachedUbound;
                    }
                }
            }
            if (deleteIndex < _LogArray.count) {
                [_LogArray removeObjectAtIndex:deleteIndex];
            }
            if (_LogCacheArrayChangedDelegate && [_LogCacheArrayChangedDelegate respondsToSelector:@selector(logCacheArrayDidChangedWithNewLog:)]) {
                [_LogCacheArrayChangedDelegate logCacheArrayDidChangedWithNewLog:model];
            }
        }
    });
}

/** 缓存的日志内容 */
+ (NSString *)cachedLogs {
    NSMutableString *allLogs = [NSMutableString string];
    dispatch_sync(_Queue, ^{
        for (id<GYDLogItemModelProtocol> model in _LogArray) {
            [allLogs appendFormat:@"%@[%zd]%s%@\n", [_FileDataFormatter stringFromDate:model.date], model.lv, model.fun, model.msg];
        }
    });
    return allLogs;
}

@end
