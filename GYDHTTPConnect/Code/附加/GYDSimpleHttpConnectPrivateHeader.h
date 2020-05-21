//
//  GYDSimpleHttpConnectPrivateHeader.h
//  GYDHttpConnect
//
//  Created by 宫亚东 on 2017/11/28.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDSimpleHttpConnect.h"

@interface GYDSimpleHttpConnect ()

@property (nonatomic, nullable) GYDSimpleHttpConnectQueue   *connectQueue;
@property (nonatomic, nullable) GYDSimpleHttpConnectSession *session;

@property (nonatomic, nullable) GYDSimpleHttpConnectRequestConfigBlock      requestConfigBlock;
@property (nonatomic, nullable) GYDSimpleHttpConnectResponseHandleBlock     responseHandleBlock;
@property (nonatomic, nullable) GYDSimpleHttpConnectUploadProgressBlock     uploadProgressBlock;
@property (nonatomic, nullable) GYDSimpleHttpConnectDownloadProgressBlock   downloadProgressBlock;
@property (nonatomic, nullable) GYDSimpleHttpConnectCompletionBlock         completionBlock;

/** 用于记录上传下载任务的 */
@property (nonatomic, nullable) NSURLSessionDataTask    *task;

- (void)start;


#pragma mark - 用到的NSURLSessionDataDelegate中的方法

NS_ASSUME_NONNULL_BEGIN

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data;

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error;

NS_ASSUME_NONNULL_END


@end

@interface GYDSimpleHttpConnectSession ()

- (void)loadConnect:(nonnull GYDSimpleHttpConnect *)connect withRequest:(nonnull NSURLRequest *)request;

- (void)cancelConnect:(nonnull GYDSimpleHttpConnect *)connect;

@end

@interface GYDSimpleHttpConnectQueue ()

- (void)addConnect:(nonnull GYDSimpleHttpConnect *)connect;
- (void)removeConnect:(nonnull GYDSimpleHttpConnect *)connect;

@end
