//
//  GYDSimpleHttpConnect.h
//  GYDHttpConnect
//
//  Created by 宫亚东 on 2017/11/28.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDSimpleHttpConnectQueue.h"
#import "GYDSimpleHttpConnectSession.h"
#import "GYDHttpFormDataMaker.h"

/** 处理响应的方式 */
typedef NS_ENUM(NSUInteger, GYDSimpleHttpConnectResponseHandleType) {
    /** 不允许继续响应，等同于cancel */
    GYDSimpleHttpConnectResponseHandleTypeCancel,
    /** 继续响应，结果不保存，GYDHttpSimpleConnectCompletionBlock 中不提供 data 参数，只会在下载进度中每次提供一小段，以提供自己处理数据如何保存 */
    GYDSimpleHttpConnectResponseHandleTypeAllowAndSaveAsNil,
    /** 继续响应，结果保存为NSData，GYDHttpSimpleConnectCompletionBlock 中提供 data 参数 */
    GYDSimpleHttpConnectResponseHandleTypeAllowAndSaveAsData,
    /** 继续响应，结果保存为文件，GYDHttpSimpleConnectCompletionBlock 中提供 filePath 参数 */
    GYDSimpleHttpConnectResponseHandleTypeAllowAndSaveAsFile,
    
};

typedef NS_ENUM(NSUInteger, GYDSimpleHttpConnectResultCode) {
    GYDSimpleHttpConnectResultCodeSuccess       = 0,
    GYDSimpleHttpConnectResultCodeResponseError = 1,
    GYDSimpleHttpConnectResultCodeCreateFileError = 2,
    GYDSimpleHttpConnectResultCodeCompletedError = 3,
};


@class GYDSimpleHttpConnect;

/** 配置请求 */
typedef void(^GYDSimpleHttpConnectRequestConfigBlock)(GYDSimpleHttpConnect * _Nonnull connect, NSMutableURLRequest * _Nonnull request);
/** 响应处理 responseHandle 参数 allow表示是否接受响应，NO的话等同于调用cancel，saveData表示是否记录数据，如果NO，则GYDSimpleHttpConnectCompletionBlock中不提供data参数，只在下载进度中每次提供一小段 */
typedef void(^GYDSimpleHttpConnectResponseHandleBlock)(GYDSimpleHttpConnect * _Nonnull connect, NSURLResponse * _Nonnull response, NSInteger contentLength, void(^ _Nonnull responseHandle)(GYDSimpleHttpConnectResponseHandleType responseType));
/** 上传进度，百分比=didUploadDataLength * 100.0f /allUploadDataLength */
typedef void(^GYDSimpleHttpConnectUploadProgressBlock)(GYDSimpleHttpConnect * _Nonnull connect, NSInteger didUploadDataLength, NSInteger allUploadDataLength);
/** 下载进度，appendData是每次下载的那一小段数据。需要注意，有时因为gzip压缩导致传输长度与实际长度不同，allDownloadDataLength会是-1 */
typedef void(^GYDSimpleHttpConnectDownloadProgressBlock)(GYDSimpleHttpConnect * _Nonnull connect, NSInteger didDownloadDataLength, NSInteger allDownloadDataLength, NSData * _Nullable appendData);
/** 请求结束，data是响应数据，根据responseHandle的参数决定是否有 data 或者 filePath 参数 */
typedef void(^GYDSimpleHttpConnectCompletionBlock)(GYDSimpleHttpConnect * _Nonnull connect, GYDSimpleHttpConnectResultCode resultCode, NSData * _Nullable data, NSString * _Nullable filePath);
/** 取消，取消可能有各种原因，不一定都是用户手动调用的，还是给个回调好一点 */
typedef void(^GYDSimpleHttpConnectCancelledBlock)(GYDSimpleHttpConnect * _Nonnull connect);




/**
 一个很单纯的http请求，结构简单，流程单一，并且每个只使用一次
 */
@interface GYDSimpleHttpConnect : NSObject

/** 请求的url */
@property (nonatomic, nonnull) NSString  *url;

/** 设置超时时间 */
@property (nonatomic)           NSTimeInterval timeoutInterval;

/** 设置请求方式"GET|POST|PUT|DELETE"，默认为nil，按有post数据或文件路径为post请求，否则为get */
@property (nonatomic, nullable) NSString *HTTPMethod;
/** 设置为post请求，并需要发送的数据 */
@property (nonatomic, nullable) NSData *postData;
/** 设置为post请求，并从文件读取需要发送的数据，发送期间不要再修改文件。一旦 postData != nil，将忽略 postFilePath */
@property (nonatomic, nullable) NSString *postFilePath;

/** 状态是否已经start了，cancel或completion后置为NO，responseBlock 中的 allowResponse(NO) 等同于cancel */
@property (nonatomic, readonly) BOOL isLoading;

/** 在 isLoading 的状态下，如果设置了请求数量限制，则可能被暂时等待 */
@property (nonatomic, readonly) BOOL isWaitingByQueue;

/** 从Response开始有效 */
@property (nonatomic, readonly) NSInteger httpStatusCode;

/** 相当于alloc init  .url=url */
+ (nonnull instancetype)connectWithUrl:(nonnull NSString *)url;

/** 发起请求
 connectQueue 是用来限制同时发起的请求数量，nil则是不限制
 requestConfigBlock 是用来追加设置 NSMutableURLRequest 的其它信息，默认使用缓存策略 NSURLRequestReloadIgnoringLocalCacheData，默认超时30秒
 session 来自同一个域名的请求可以使用同一个session，以减少链接次数，默认是[[GYDSimpleHttpConnectSession alloc] init]。
 uploadProgressBlock 上传进度
 responseHandleBlock 用来设置响应方式，responseHandle(GYDSimpleHttpConnectResponseHandleTypeCancel) 等同于调用 - (void)cancel; 方法
 downloadProgressBlock 下载进度，包含每次的那一小段数据，但是要注意，有些不完善的http服务没提供长度信息，allDownloadDataLength可能是-1
 completionBlock 请求完结
 cancelledBlock  请求被取消，cancel或responseHandle(GYDSimpleHttpConnectResponseHandleTypeCancel)后回调
 
 ---------
 在isLoading时再次start无任何效果，
 非isLoading状态下，start后进入isLoading状态，并在最后一定会回调一次 completionBlock 或 cancelledBlock。
 在真正的网络发送前，如果设置了connectQueue并且数量已达上限，则会暂时处于isWaitingByQueue状态。
 */
- (void)startInConnectQueue:(nullable GYDSimpleHttpConnectQueue *)connectQueue
                withSession:(nullable GYDSimpleHttpConnectSession *)session
              requestConfig:(nullable GYDSimpleHttpConnectRequestConfigBlock)requestConfigBlock
             uploadProgress:(nullable GYDSimpleHttpConnectUploadProgressBlock)uploadProgressBlock
                   response:(nullable GYDSimpleHttpConnectResponseHandleBlock)responseHandleBlock
           downloadProgress:(nullable GYDSimpleHttpConnectDownloadProgressBlock)downloadProgressBlock
                 completion:(nullable GYDSimpleHttpConnectCompletionBlock)completionBlock;

/** 取消，会回调 cancelledBlock */
- (void)cancel;

@end
