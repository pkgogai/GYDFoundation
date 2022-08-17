//
//  GYDShellConnectTools.m
//  GYDFoundation
//
//  Created by 宫亚东 on 2020/09/07.
//  Copyright © 2020 宫亚东. All rights reserved.
//

#import "GYDShellConnectTools.h"

@implementation GYDShellConnectTools

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeoutTimeInterval = 20;
    }
    return self;
}

- (void)syncSend {
    GYDSimpleHttpConnect *connect = [[GYDSimpleHttpConnect alloc] init];
    connect.url = self.url;
    connect.HTTPMethod = self.method;
    connect.postData = self.bodyData;
    
    _resultCode = GYDSimpleHttpConnectResultCodeSuccess;
    _resultHttpStatusCode = 0;
    _resultData = nil;
    _resultString = nil;
    _resultJSONObject = nil;
    
    __block BOOL timeout = YES;
    
    dispatch_semaphore_t lock = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        GYDSimpleHttpConnectSession * connectSession = [[GYDSimpleHttpConnectSession alloc] initWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegateQueue:[NSOperationQueue currentQueue]];
        
        [connect startInConnectQueue:nil withSession:connectSession requestConfig:^(GYDSimpleHttpConnect * _Nonnull connect, NSMutableURLRequest * _Nonnull request) {
            if (self.headerField) {
                for (NSString *headerKey in self.headerField) {
                    [request setValue:self.headerField[headerKey] forHTTPHeaderField:headerKey];
                }
            }
        } uploadProgress:nil response:nil downloadProgress:nil completion:^(GYDSimpleHttpConnect * _Nonnull connect, GYDSimpleHttpConnectResultCode resultCode, NSData * _Nullable data, NSString * _Nullable filePath) {
            self->_resultCode = resultCode;
            self->_resultHttpStatusCode = connect.httpStatusCode;
            self->_resultData = data;
            if (data) {
                self->_resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                self->_resultJSONObject = [GYDJSONSerialization JSONObjectWithData:data];
            }
            timeout = NO;
            dispatch_semaphore_signal(lock);
        }];
    });
    
    dispatch_semaphore_wait(lock, (self.timeoutTimeInterval > 0) ? dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeoutTimeInterval * NSEC_PER_SEC)) : DISPATCH_TIME_FOREVER);
    //因请求超时而过来的，取消一下之前的请求。
    [connect cancel];
    if (timeout) {
        _resultCode = GYDSimpleHttpConnectResultCodeCompletedError;
    }
}

@end
