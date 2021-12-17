//
//  GYDShellCodeAnalysisFileItem.h
//  GYDFoundation
//
//  Created by gongyadong on 2021/10/27.
//  Copyright © 2021 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDShellCodeAnalysisClassItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellCodeAnalysisFileItem : NSObject

@property (nonatomic) NSString *fileName;

@property (nonatomic) NSString *creatTime;

@property (nonatomic) NSString *author;

@property (nonatomic) NSMutableSet<NSString *> *includeTypes;

@property (nonatomic) NSMutableArray<GYDShellCodeAnalysisClassItem *> *classArray;

@end

NS_ASSUME_NONNULL_END
