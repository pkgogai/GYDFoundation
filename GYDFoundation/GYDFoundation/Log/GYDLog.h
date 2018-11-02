//
//  GYDLog.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2018/8/21.
//  Copyright © 2018年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 用于设置LOG参数的结构
/**
 根据log级别来进行的设置
 */
typedef struct {
    BOOL print:1;   //printToCommandLine，是否打印到控制台
    BOOL save:1;    //saveToFile，是否保存到文件里
    uint32_t cachedUbound:30;    //为每种log设置在缓存中的范围上限。缓存数组中，超过这个数的就删除掉，级别越重要的log，这个设置应该越大。
    //例如有3种log，其中lv1设置100，lv2设置60，lv3设置40，则lv1、lv2、lv3按发生顺序混合在一起后，从第40条开始，之后的lv3都会被删除，剩下的数据里第60条以后的lv2都会被删除，第100条以后的lv1都会被删除，显示的最大数量就是100。
    const char * _Nullable prefix; //按等级附加的前缀，存文件或者显示时使用
    
} GYDLogSetting;

#pragma mark - 记录LOG的类需要遵守的协议

/**
 记录LOG的类需要遵守的协议
 */
@protocol GYDLogItemModelProtocol <NSObject>

/** LOG种类 */
@property (nonatomic, nullable)   NSString *type;
/** 级别 */
@property (nonatomic)   NSInteger lv;
/** 时间 */
@property (nonatomic, nonnull)   NSDate *date;
/** 来自函数 */
@property (nonatomic, nonnull)   const char *fun;
/** log内容 */
@property (nonatomic, nullable)   NSString *msg;

@end

#pragma mark -

/**
 LOG缓存数组变化的回调
 */
@protocol GYDLogCacheArrayChangedDelegate <NSObject>

/** 缓存的消息数组改变，log有值表示是因为来了新log而引起的改变，log没值表示是修改缓存上限等操作引起的改变 */
- (void)logCacheArrayDidChangedWithNewLog:(nullable id<GYDLogItemModelProtocol>)log;

@end

#pragma mark -

/**
 LOG处理，所有设置方法都必须在主线程使用，只有
 + (void)logType:(nonnull NSString *)type lv:(NSUInteger)lv fun:(const char *)fun msg:(nonnull NSString *)msg;
 可以在其它线程调用
 
 使用建议：使用宏定义再套一层
 log分级可以设置为5级，分别代表error,waring,info,verbose,debug，
 调试时，根据不同的log等级(lv)，将GYDLogSettings中打印(print)，保存(save)，缓存(cachedUbound)，前缀(prefix)都进行设置，并为Log区分不同的类型(type)，为每个类型(type)设置开关状态，在调试过程中，也可以随时修改这些设置。
 外发时，setCheckLogType:为NO，不检查类型，可以节约一点点性能，也不需要打印，可以将error,waring级别的log保存，info,verbose级别只记录为缓存(设置cachedUbound数)，在crash的时候，通过logCacheArray获取当前缓存的log。debug忽略
 **注意**：分线程的LOG是异步到UI线程记录的。
 
 */
@interface GYDLog : NSObject

#pragma mark - 文件位置设置，在设置成功filePath之后的log才能被保存到文件

/** 设置log文件存储路径，并打开文件，开始写入 */
+ (BOOL)setLogFilePath:(nonnull NSString *)filePath errorMessage:(NSString * _Nullable * _Nullable)errorMessage;
/** 同步log文件的操作，（log文件是异步写入的，所以crash的时候，先同步一下再上报文件会更完整） */
+ (void)synchronizeLogFile;
/** 关闭log文件，没什么用 */
+ (void)closeFile;

#pragma mark - LOG分级设置，设置好LOG分级后，LOG才能被按照设置进行处理

/** log分级数量，使用时lv要小于lvCount */
@property (nonatomic, class) NSUInteger lvCount;
/** 根据log级别进行设置 */
+ (void)setLogSetting:(GYDLogSetting)setting forLv:(NSUInteger)lv;
/** 获取对应log级别的设置 */
+ (GYDLogSetting)logSettingForLv:(NSUInteger)lv;


#pragma mark - LOG种类的设置，不设置默认就都是开的

/** 设置是否检查log种类的开关，默认YES，外发时所有种类都使用，为了节约一点点效率，就可以不检查这里的开关了。 */
@property (nonatomic, class) BOOL checkLogType;
/** 根据log种类设置开关，默认是on */
+ (void)setLogType:(nonnull NSString *)type on:(BOOL)on;
/** 获取设置过的开关状态 */
+ (BOOL)isLogTypeOn:(nonnull NSString *)type;
/** 所有设置过或使用过的开关种类都记录在案 */
+ (nonnull NSArray *)allTypesThatHaveBeenUsed;


#pragma mark - LOG使用
/** 设置用于记录log的model类型 */
@property (nonatomic, class, nullable)    Class<GYDLogItemModelProtocol> logItemModelClass;

/** 获取log数组，新log排在前面，注意，没有copy，没必要的话不要操作，真要操作也要在UI线程进行 */
@property (nonatomic, class, readonly, nonnull)  NSMutableArray *logCacheArray;
/** log缓存数组改变时给代理发消息 */
@property (nonatomic, class, nullable, weak)    id<GYDLogCacheArrayChangedDelegate>logCacheArrayChangedDelegate;

/** log语句，可以在不同线程使用，如果不在主线程，内部会async到主线程处理 */
+ (void)logType:(nullable NSString *)type lv:(NSUInteger)lv fun:(const char *_Nonnull)fun msg:(nonnull NSString *)msg;


@end
