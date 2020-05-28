//
//  GYDSimpleHttpConnect.m
//  GYDHttpConnect
//
//  Created by 宫亚东 on 2017/11/28.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import "GYDSimpleHttpConnect.h"
#import "GYDSimpleHttpConnectPrivateHeader.h"
#import "GYDFoundationPrivateHeader.h"

@implementation GYDSimpleHttpConnect
{
    //接收数据时，选择data方式就创建_downloadData，选择file方式就创建_downloadFilePath和_downloadFileHandle
    /** 用于接收数据 */
    NSMutableData   *_downloadData;
    /** 用于接收数据 */
    NSString        *_downloadFilePath;
    /** 用于接收数据 */
    NSFileHandle    *_downloadFileHandle;
    
    
    /** 需要下载的总长度 */
    NSInteger       _downloadDataLength;
    /** 当前已经下载的长度 */
    NSInteger       _downloadDataDidReceiveLength;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeoutInterval = 30;
    }
    return self;
}
+ (nonnull instancetype)connectWithUrl:(nonnull NSString *)url {
    GYDSimpleHttpConnect *connect = [[self alloc] init];
    connect.url = url;
    return connect;
}

- (void)startInConnectQueue:(nullable GYDSimpleHttpConnectQueue *)connectQueue
                withSession:(nullable GYDSimpleHttpConnectSession *)session
              requestConfig:(nullable GYDSimpleHttpConnectRequestConfigBlock)requestConfigBlock
             uploadProgress:(nullable GYDSimpleHttpConnectUploadProgressBlock)uploadProgressBlock
                   response:(nullable GYDSimpleHttpConnectResponseHandleBlock)responseHandleBlock
           downloadProgress:(nullable GYDSimpleHttpConnectDownloadProgressBlock)downloadProgressBlock
                 completion:(nullable GYDSimpleHttpConnectCompletionBlock)completionBlock
{
    if (_isLoading) {
        return;
    }
    
    _isLoading = YES;
    _httpStatusCode = 0;
    
    
    self.connectQueue   = connectQueue;
    self.session        = session;
    self.requestConfigBlock = requestConfigBlock;
    self.uploadProgressBlock = uploadProgressBlock;
    self.responseHandleBlock = responseHandleBlock;
    self.downloadProgressBlock = downloadProgressBlock;
    self.completionBlock = completionBlock;
    
    if (connectQueue) {
        [connectQueue addConnect:self];
    } else {
        [self start];
    }
}

- (BOOL)isWaitingByQueue {
    return [_connectQueue containsWaitingConnect:self];
}

/** 取消 */
- (void)cancel {
    if (!_isLoading) {
        return;
    }
    _httpStatusCode = 0;
    
    [self clean];
    
}

/** 成员变量里不是需要暴露的返回值都在这里清理掉（目前就httpStatusCode一个） */
- (void)clean {
    _isLoading = NO;
    
    _downloadData = nil;
    _downloadFilePath = nil;
    if (_downloadFileHandle) {
        [_downloadFileHandle closeFile];
        _downloadFileHandle = nil;
    }
    
    _downloadDataLength = 0;
    _downloadDataDidReceiveLength = 0;
    
    _requestConfigBlock     = nil;
    _uploadProgressBlock    = nil;
    _responseHandleBlock    = nil;
    _downloadProgressBlock  = nil;
    _completionBlock        = nil;
    
    if (_session) {
        [_session cancelConnect:self];
        _session = nil;
    }
    if (_connectQueue) {
        [_connectQueue removeConnect:self];
        _connectQueue = nil;
    }
    
}

- (void)start {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:_timeoutInterval];
    NSString *HTTPMethod = @"GET";
    if (self.postData) {
        HTTPMethod = @"POST";
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", (int)[self.postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:self.postData];
    } else if (self.postFilePath.length > 0) {
        HTTPMethod = @"POST";
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:self.postFilePath];
    }
    if (self.HTTPMethod) {
        request.HTTPMethod = self.HTTPMethod;
    } else {
        request.HTTPMethod = HTTPMethod;
    }
    
    if (_requestConfigBlock) {
        _requestConfigBlock(self, request);
    }
    if (!_session) {
        _session = [[GYDSimpleHttpConnectSession alloc] initWithConfiguration:nil delegateQueue:nil];
    }
    [_session loadConnect:self withRequest:request];
}



#pragma mark - 用到的NSURLSessionDataDelegate中的方法

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    if (_uploadProgressBlock) {
        _uploadProgressBlock(self, (NSInteger)totalBytesSent, (NSInteger)totalBytesExpectedToSend);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    if ([response respondsToSelector:@selector(statusCode)]) {
        _httpStatusCode = [((NSHTTPURLResponse *)response) statusCode];
    }
    //服务器超过400的错误码也会返回有用信息，所以即使知道出错，也要继续接受数据
//    if (_httpStatusCode >= 400) {
//        completionHandler(NSURLSessionResponseCancel);
//        GYDSimpleHttpConnectCompletionBlock completionBlock = _completionBlock;
//        [self clean];
//        if (completionBlock) {
//            completionBlock(self, GYDSimpleHttpConnectResultCodeResponseError, nil, nil);
//        }
//        return;
//    }
    if ([response respondsToSelector:@selector(expectedContentLength)]) {
        _downloadDataLength = (NSInteger)[response expectedContentLength];
    } else {
        _downloadDataLength = -1;
    }
    __weak typeof(self) weakSelf = self;
    void(^responseHandle)(GYDSimpleHttpConnectResponseHandleType responseType) = ^(GYDSimpleHttpConnectResponseHandleType responseType) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        switch (responseType) {
            case GYDSimpleHttpConnectResponseHandleTypeCancel:
            {
                completionHandler(NSURLSessionResponseCancel);
                [strongSelf clean];
            }
                break;
            case GYDSimpleHttpConnectResponseHandleTypeAllowAndSaveAsNil:
                completionHandler(NSURLSessionResponseAllow);
                break;
            case GYDSimpleHttpConnectResponseHandleTypeAllowAndSaveAsData:
                strongSelf->_downloadData = [[NSMutableData alloc] init];
                completionHandler(NSURLSessionResponseAllow);
                break;
            case GYDSimpleHttpConnectResponseHandleTypeAllowAndSaveAsFile:
                if ([strongSelf createDownloadFilePathAndHandle]) {
                    completionHandler(NSURLSessionResponseAllow);
                } else {
                    completionHandler(NSURLSessionResponseCancel);
                    GYDSimpleHttpConnectCompletionBlock completionBlock = strongSelf->_completionBlock;
                    [strongSelf clean];
                    if (completionBlock) {
                        completionBlock(strongSelf, GYDSimpleHttpConnectResultCodeCreateFileError, nil, nil);
                    }
                }
                
                break;
            default:
                break;
        }
    };
    
    if (_responseHandleBlock) {
        _responseHandleBlock(self, response, _downloadDataLength, responseHandle);
    } else {
        responseHandle(GYDSimpleHttpConnectResponseHandleTypeAllowAndSaveAsData);
    }
}



- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (_downloadData) {
        [_downloadData appendData:data];
    } else if (_downloadFileHandle) {
        [_downloadFileHandle writeData:data];
    }
    _downloadDataDidReceiveLength += data.length;
    if (_downloadProgressBlock) {
        self.downloadProgressBlock(self, _downloadDataDidReceiveLength, _downloadDataLength, data);
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    GYDSimpleHttpConnectCompletionBlock completionBlock = _completionBlock;
    NSData *data = _downloadData;
    NSString *filePath = _downloadFilePath;
    [self clean];
    if (completionBlock) {
        NSUInteger resultCode;
        if (_httpStatusCode >= 400) {
            resultCode = GYDSimpleHttpConnectResultCodeResponseError;
        } else if (error) {
            resultCode = GYDSimpleHttpConnectResultCodeCompletedError;
        } else {
            resultCode = GYDSimpleHttpConnectResultCodeSuccess;
        }
        completionBlock(self, resultCode, data, filePath);
    }
}


#pragma mark - 创建临时文件

- (BOOL)createDownloadFilePathAndHandle {
    NSString *dirPath   = NSTemporaryDirectory();
    
    for (int i = 0; i < 100; i ++) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"tmpfile_%lld_%d", (long long)[NSDate timeIntervalSinceReferenceDate], rand()]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            continue;
        }
        
        if (![[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
            GYDFoundationError(@"文件创建失败：%@", _downloadFilePath);
            return NO;
        }
        
        _downloadFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        
        if (!_downloadFileHandle) {
            GYDFoundationError(@"文件打开失败：%@", _downloadFilePath);
            return NO;
        }
        
        _downloadFilePath   = filePath;
        return YES;
    }
    GYDFoundationError(@"找不到有效路径");
    return NO;
}

@end
