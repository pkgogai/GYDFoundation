//
//  GYDSimpleHttpConnectQueue.m
//  GYDHttpConnect
//
//  Created by 宫亚东 on 2017/11/28.
//  Copyright © 2017年 宫亚东. All rights reserved.
//

#import "GYDSimpleHttpConnectQueue.h"
#import "GYDSimpleHttpConnectPrivateHeader.h"

@implementation GYDSimpleHttpConnectQueue
{
    NSMutableArray *_connectArray;
    BOOL            _isPause;
}

- (NSArray *)connectArray {
    return [_connectArray copy];
}
- (void)setMaxLoadCount:(NSInteger)maxLoadCount {
    if ((_maxLoadCount > 0 && maxLoadCount > _maxLoadCount) || maxLoadCount < 1) {
        _maxLoadCount = maxLoadCount;
        [self checkForSend];
    } else {
        _maxLoadCount = maxLoadCount;
    }
}

- (void)setPause:(BOOL)pause {
    _isPause = pause;
    if (!_isPause) {
        [self checkForSend];
    }
}

- (BOOL)isPause {
    return _isPause;
}

/** 取消所有的请求 */
- (void)cancelAll {
    while (_connectArray.count > 0) {
        GYDSimpleHttpConnect *connect = [_connectArray firstObject];
        if (connect) {
            [connect cancel];
        }
    }
}

- (void)addConnect:(GYDSimpleHttpConnect *)connect {
    if (!_connectArray) {
        _connectArray = [NSMutableArray array];
    }
    [_connectArray addObject:connect];
    
    [self checkForSend];
}
- (void)removeConnect:(GYDSimpleHttpConnect *)connect {
    [_connectArray removeObject:connect];
    if (_connectArray.count > 0) {
        [self checkForSend];
    }
}

- (void)checkForSend {
    if (_isPause) {
        return;
    }
    NSInteger i = self.maxLoadCount;
    if (i < 1 || i > _connectArray.count) {
        i = _connectArray.count;
    }
    for (i = i - 1; i >= 0; i --) {
        GYDSimpleHttpConnect *con = _connectArray[i];
        if ([con isWaitingByQueue]) {
            [con start];
        }
    }
}




@end
