//
//  GYDSimpleHttpConnectSession.m
//  GYDHttpConnect
//
//  Created by 宫亚东 on 2017/11/28.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import "GYDSimpleHttpConnectSession.h"
#import "GYDSimpleHttpConnectPrivateHeader.h"

@interface GYDSimpleHttpConnectSession ()<NSURLSessionDataDelegate>

@end

@implementation GYDSimpleHttpConnectSession
{
    
    /** 系统原生session，及其配置 */
    NSURLSession                *_session;
    NSURLSessionConfiguration   *_sessionConfiguration;
    NSOperationQueue            *_sessionQueue;
    
    /** task->connect，用于代理回调时快速找到对应的connect */
    NSMutableDictionary *_taskToConnectDictionary;
    
    //这个暂时删了，本身每个session的连接可能就只有一个，多写一个dictionary完全没必要。
    //    /** connect->task，用于取消connect时快速找到task */
    //    NSMutableDictionary *_connectToTaskDictionary
}

/** 等同于 - initWithConfiguration:nil delegateQueue:nil */
- (nonnull instancetype)init {
    return [self initWithConfiguration:nil delegateQueue:nil];
}

/** configuration默认使用 [NSURLSessionConfiguration defaultSessionConfiguration]，queue默认使用当前线程队列 */
- (nonnull instancetype)initWithConfiguration:(nullable NSURLSessionConfiguration *)configuration delegateQueue:(nullable NSOperationQueue *)queue {
    self = [super init];
    if (self) {
        if (configuration) {
            _sessionConfiguration = [configuration copy];
        } else {
            _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        if (queue) {
            _sessionQueue = queue;
        } else {
            _sessionQueue = [NSOperationQueue currentQueue];
        }
        _session = nil;
        
        _taskToConnectDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadConnect:(GYDSimpleHttpConnect *)connect withRequest:(NSURLRequest *)request {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:_sessionConfiguration delegate:self delegateQueue:_sessionQueue];
    }
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    connect.task = task;
    [_taskToConnectDictionary setObject:connect forKey:task];
    [task resume];
}

- (void)cancelConnect:(nonnull GYDSimpleHttpConnect *)connect {
    if (connect.task) {
        [_taskToConnectDictionary removeObjectForKey:connect.task];
        [connect.task cancel];
        connect.task = nil;
    }
    if (_taskToConnectDictionary.count < 1) {
        [_session invalidateAndCancel];
        _session = nil;
    }
}
#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    GYDSimpleHttpConnect *connect = [_taskToConnectDictionary objectForKey:task];
    [connect URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    GYDLogDebug(@"%ld", (long)dataTask.countOfBytesExpectedToReceive);
    GYDSimpleHttpConnect *connect = [_taskToConnectDictionary objectForKey:dataTask];
    [connect URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    GYDLogDebug(@"%ld", (long)dataTask.countOfBytesExpectedToReceive);
    GYDSimpleHttpConnect *connect = [_taskToConnectDictionary objectForKey:dataTask];
    [connect URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    GYDSimpleHttpConnect *connect = [_taskToConnectDictionary objectForKey:task];
    [connect URLSession:session task:task didCompleteWithError:error];
}

@end
