//
//  GYDShellCodeAnalysisClassItem.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/27.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisClassItem : NSObject

@property (nonatomic) NSString *name;

@property (nonatomic) NSString *categoryName;

@property (nonatomic) NSString *superClassName;

@property (nonatomic) NSString *classDesc;

@property (nonatomic) BOOL hasLoadFun;

@property (nonatomic) NSMutableSet<NSString *> *includeTypes;

@property (nonatomic) NSInteger lineNumber;

@end

NS_ASSUME_NONNULL_END
