//
//  GYDShellCodeAnalysisReader.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/25.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    //字符、数字、下划线组成的单词
    GYDShellCodeAnalysisWordTypeKey,
    //字符串文本
    GYDShellCodeAnalysisWordTypeText,
    //特殊符号
    GYDShellCodeAnalysisWordTypeSymbol,
//    //系统单词@ 开头的那种
//    GYDShellCodeAnalysisWordTypeOCKey,
} GYDShellCodeAnalysisWordType;


@interface GYDShellCodeAnalysisReaderWord : NSObject

/** 内容 */
@property (nonatomic) NSString *word;

/** 类型 */
@property (nonatomic) GYDShellCodeAnalysisWordType type;

/** 行号 */
@property (nonatomic) NSInteger lineNumber;

/** {深度，还未使用 */
@property (nonatomic) NSInteger level;


@end

/** 内部记录行号用的，如line = 1, toIndex = 10,表示下标10之前都是第1行 */
@interface GYDShellCodeAnalysisReaderLineNumber : NSObject

@property (nonatomic) NSInteger line;

@property (nonatomic) NSInteger toIndex;

@end


@interface GYDShellCodeAnalysisReader : NSObject

//记录行号和下标的数组
@property (nonatomic, strong) NSMutableArray<GYDShellCodeAnalysisReaderLineNumber *> *lineNumberArray;

//解析
- (NSMutableArray<GYDShellCodeAnalysisReaderWord *> *)wordArrayWithFileContent:(NSString *)fileContent;

@end

NS_ASSUME_NONNULL_END
