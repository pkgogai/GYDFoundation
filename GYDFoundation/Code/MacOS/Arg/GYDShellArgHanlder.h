//
//  GYDShellArgHanlder.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于处理参数，如：path a1 a2
 [argCount] = 3
 [argAtIndex:0] = path
 [argAtIndex:1] = a1
 [argAtIndex:2] = a2
 
 没有实现——但真正的shell命令，参数应该是这样的：
 减号接一个字母作为选项，可以后接参数，多个选项只有其中一个有参数时可以合并，如“-a -b” === “-ab”
 两个减号接一个单纯作为选项，也可以接参数。如“--ab”
 但由于不知道参数开头就是两个减号，与一个选项相同时，该如何区分，所以暂时没进行开发
*/

@interface GYDShellArgHanlder : NSObject

// fullPath == directoryPath/fileName

/** shell脚本的完整路径(等同于[argAtIndex:0]) */
@property (nonatomic, readonly, nonnull) NSString *fullPath;

/** shell脚本的目录*/
@property (nonatomic, readonly, nonnull) NSString *directoryPath;
/** shell脚本的文件名 */
@property (nonatomic, readonly, nonnull) NSString *fileName;


- (nonnull instancetype)initWithArgc:(int)argc argv:(const char * _Nonnull * _Nonnull)argv;

/** 参数个数，包括脚本路径在内的个数 */
- (NSInteger)argCount;

/** 通过下标获取参数。0是脚本路径，1以及之后是真正的参数，下标越界则为nil */
- (nullable NSString *)argAtIndex:(NSInteger)index;

@end
