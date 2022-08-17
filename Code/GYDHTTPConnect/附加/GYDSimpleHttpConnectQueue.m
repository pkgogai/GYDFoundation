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
    NSMutableArray *_waitingConnectArray;
    NSMutableArray *_sendingConnectArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sendingConnectArray = [NSMutableArray array];
        _waitingConnectArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)connectArray {
    return [_sendingConnectArray arrayByAddingObjectsFromArray:_waitingConnectArray];
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
    _pause = pause;
    if (!_pause) {
        [self checkForSend];
    }
}

- (BOOL)containsWaitingConnect:(GYDSimpleHttpConnect *)connect {
    return [_waitingConnectArray containsObject:connect];
}
- (BOOL)containsSendingConnect:(GYDSimpleHttpConnect *)connect {
    return [_sendingConnectArray containsObject:connect];
}

/** 取消所有的请求 */
- (void)cancelAll {
    NSArray *array = [self connectArray];
    [_waitingConnectArray removeAllObjects];
    [_sendingConnectArray removeAllObjects];
    //开始调用取消后新增加的请求就不应该被一起取消了
    for (GYDSimpleHttpConnect *connect in array) {
        [connect cancel];
    }
}

- (void)addConnect:(GYDSimpleHttpConnect *)connect {
    if (!_pause && (_maxLoadCount < 1 || _sendingConnectArray.count < _maxLoadCount)) {
        [_sendingConnectArray addObject:connect];
        [connect start];
    } else {
        [_waitingConnectArray addObject:connect];
    }
}
- (void)removeConnect:(GYDSimpleHttpConnect *)connect {
    [_sendingConnectArray removeObject:connect];
    [_waitingConnectArray removeObject:connect];
    
    if (_waitingConnectArray.count > 0) {
        [self checkForSend];
    }
}

- (void)checkForSend {
    while (!_pause && _waitingConnectArray.count > 0 && (_maxLoadCount < 1 || _sendingConnectArray.count < _maxLoadCount)) {
        GYDSimpleHttpConnect *con = _waitingConnectArray[0];
        [_waitingConnectArray removeObjectAtIndex:0];
        [_sendingConnectArray addObject:con];
        [con start];
    }
}




@end
