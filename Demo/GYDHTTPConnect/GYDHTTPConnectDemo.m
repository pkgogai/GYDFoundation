//
//  GYDHTTPConnectDemo.m
//  FMDB
//
//  Created by 宫亚东 on 2020/5/20.
//

#import "GYDHTTPConnectDemo.h"
#import "GYDSimpleHttpConnect.h"
#import "GYDHttpFormDataMaker.h"
#import "GYDJSONSerialization.h"

#if TARGET_OS_IPHONE
#import "GYDDemoMenu.h"
#endif

@implementation GYDHTTPConnectDemo

#if TARGET_OS_IPHONE
+ (void)load {
    GYDDemoMenu *menu = [GYDDemoMenu menuWithName:@"GYDSimpleHttpConnect" desc:@"简陋的http请求，连304都没处理，初衷是按流程将每一步回调出来" order:45 vcClass:self];
    [menu addToMenu:GYDDemoMenuRootName];
}
#endif

- (void)testConnect {
    GYDSimpleHttpConnect *connect = [[GYDSimpleHttpConnect alloc] init];
    connect.url = @"";

    __block NSDictionary *headerDic = nil;
    
    //json格式的数据
    headerDic = @{@"Content-Type" : @"application/json"};
    connect.postData = [GYDJSONSerialization dataWithJSONObject:@{@"name" : @"张三"}];
    
    //form表单格式的数据
    GYDHttpFormDataMaker *formDataMaker = [[GYDHttpFormDataMaker alloc] init];
    [formDataMaker.formDataArray addObject:[GYDHttpFormDataItem formDataWithName:@"name" stringValue:@"张三"]];
    [formDataMaker buildFormData:^(NSString * _Nonnull headerKey, NSString * _Nonnull headerValue, NSData * _Nonnull body) {
        headerDic = @{headerKey: headerValue};//Content-Type: multipart/form-data; boundary=xxx
        connect.postData = body;
    }];
    
    //整个请求流程
    [connect startInConnectQueue:nil withSession:nil requestConfig:^(GYDSimpleHttpConnect * _Nonnull connect, NSMutableURLRequest * _Nonnull request) {
        //请求前配置request
        [headerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    } uploadProgress:^(GYDSimpleHttpConnect * _Nonnull connect, NSInteger didUploadDataLength, NSInteger allUploadDataLength) {
        //上传进度
    } response:^(GYDSimpleHttpConnect * _Nonnull connect, NSURLResponse * _Nonnull response, NSInteger contentLength, void (^ _Nonnull responseHandle)(GYDSimpleHttpConnectResponseHandleType)) {
        //响应处理
    } downloadProgress:^(GYDSimpleHttpConnect * _Nonnull connect, NSInteger didDownloadDataLength, NSInteger allDownloadDataLength, NSData * _Nullable appendData) {
        //下载进度
    } completion:^(GYDSimpleHttpConnect * _Nonnull connect, GYDSimpleHttpConnectResultCode resultCode, NSData * _Nullable data, NSString * _Nullable filePath) {
        //结果处理
    }];
}
@end
