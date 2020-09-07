//
//  GYDShellConnectTools.h
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDSimpleHttpConnect.h"
#import "GYDJSONSerialization.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYDShellConnectTools : NSObject

@property (nonatomic)   NSString *url;
@property (nonatomic)   NSString *method;
@property (nonatomic)   NSData  *bodyData;
@property (nonatomic)   NSDictionary *headerField;

@property (nonatomic, readonly) GYDSimpleHttpConnectResultCode resultCode;
@property (nonatomic, readonly) NSInteger resultHttpStatusCode;
@property (nonatomic, readonly) NSData *resultData;
@property (nonatomic, readonly) NSString *resultString;
@property (nonatomic, readonly) NSObject *resultJSONObject;

- (void)syncSend;

@end

NS_ASSUME_NONNULL_END
