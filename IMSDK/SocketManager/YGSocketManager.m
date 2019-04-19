//
//  YGTcpClientManager.m
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGSocketManager.h"
#import "GCDAsyncSocket.h"
#import "YGAPIHandleManager.h"
#import "IMClient.h"
#import "YGSuperAPI.h"
#import "YGClientStateManager.h"
#import "YGSocketInputSteam.h"
#import "YGSocketOutputSteam.h"
#import "YGConnectionAPI.h"
#import "YGConfirmMessageAPI.h"
#import "YGCommon.h"
#import "YGUtilities.h"

static CGFloat const  YGSocketSendDelayTime = 0.01;
static CGFloat const  YGSocketReturnDelayTime = 0.01;

@interface YGSocketManager ()

@property (nonatomic, assign, readwrite) BOOL isConnected;

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@property (nonatomic, strong) dispatch_queue_t socketDelegateQueue;
@property (nonatomic, strong) dispatch_queue_t socketSendQueue;
@property (nonatomic, strong) dispatch_queue_t socketReplyQueue;

@property (nonatomic, strong) dispatch_semaphore_t socketSemaphore;

@property (nonatomic, assign) NSRange beginRange;

@property (nonatomic, strong) NSData *beginData;
@property (nonatomic, strong) NSData *endData;
@property (nonatomic, strong) NSData *heartbeatData;
@property (nonatomic, strong) NSData *serverHeartbeatData;
@property (nonatomic, strong) NSData *recServerHeartbeatData;

@property (nonatomic, strong) NSMutableData *receiveData;

@property (nonatomic, assign) long writeTag;
@property (nonatomic, assign) long readTag;

@end

@implementation YGSocketManager {
    ResultBlock connectResultBlock;
    ResultBlock disconnectResultBlock;
    
    double lastTime;
}

#pragma mark - Lifecycle

+ (instancetype)sharedManager{
    static YGSocketManager* socketManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketManager = [[YGSocketManager alloc] init];
    });
    return socketManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _socketDelegateQueue = dispatch_queue_create("socketDelegateQueue", DISPATCH_QUEUE_SERIAL);
        _socketSendQueue = dispatch_queue_create("socketSendQueue", DISPATCH_QUEUE_SERIAL);
        _socketReplyQueue = dispatch_queue_create("socketReplyQueue", DISPATCH_QUEUE_SERIAL);
        
        _socketSemaphore = dispatch_semaphore_create(1);
        
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketDelegateQueue];
        
        _isConnected = NO;
        
        _writeTag = 0;
        _beginRange = NSMakeRange(0, 2);
        
        int8_t ch[2];
        ch[0] = (0xFFFF & 0x0ff00)>>8;
        ch[1] = (0xFFFF & 0x0ff);
        _beginData = [NSData dataWithBytes:ch length:2];
        
        int8_t ch1[2];
        ch1[0] = (0xFFFE & 0x0ff00)>>8;
        ch1[1] = (0xFFFE & 0x0ff);
        _endData = [NSData dataWithBytes:ch1 length:2];
        
        _heartbeatData = [@" " dataUsingEncoding:NSUTF8StringEncoding];
        _serverHeartbeatData = [@"  " dataUsingEncoding:NSUTF8StringEncoding];
        NSData *requestData = [@" " dataUsingEncoding:NSUTF8StringEncoding];
        YGSocketOutputSteam *outputSteam = [[YGSocketOutputSteam alloc] initWithData:requestData];
        _recServerHeartbeatData = [NSData dataWithData:[outputSteam socketSendData]];
    }
    return self;
}

#pragma mark - Public
- (void)connectWithServerHost:(NSString *)host ServerPort:(NSString *)serverPort :(void (^)(BOOL))result {
    @synchronized(self) {
        if (result) {
            connectResultBlock = result;
        }
    }
    
    WS(ws)
    uint16_t port = (uint16_t)[serverPort intValue];
    NSString *IMhost;

    IMhost = host;
    

    NSError *error = nil;
    [self.asyncSocket setDelegate:ws];
    if (![ws.asyncSocket connectToHost:IMhost onPort:port withTimeout:5 error:&error]){
        [ws connectFailureHandleWithError:error];
    }
}

- (void)disconnect:(ResultBlock)resultBlock {
    if (self.asyncSocket.delegate) {
        @synchronized(self) {
            if (resultBlock) {
                disconnectResultBlock = resultBlock;
            }
        }
        [self.asyncSocket disconnect];
        [self.asyncSocket setDelegate:nil];
    } else {
        NSLog(@"多余disconnect");
    }
    
    [[YGAPIHandleManager sharedManager] removeAllApi];
}

- (void)sendData:(NSData*)data {
    dispatch_async(self.socketSendQueue, ^{
        if (self.asyncSocket.isDisconnected) {
            return;
        }
        [self.asyncSocket writeData:data withTimeout:-1 tag:self.writeTag];
        //信号量锁
        dispatch_semaphore_wait(self.socketSemaphore, DISPATCH_TIME_FOREVER);
    });
}

- (void)sendData:(NSData *)data withAPI:(YGSuperAPI *)api {
    [[NSThread currentThread] setName:@"socketDelegateQueue"];
    
    dispatch_queue_t queue = [api isKindOfClass:[YGConfirmMessageAPI class]] ? self.socketReplyQueue : self.socketSendQueue;
    dispatch_async(queue, ^{
        if (queue == self.socketReplyQueue) {
            [[NSThread currentThread] setName:@"socketReplyQueue"];
        } else {
            [[NSThread currentThread] setName:@"socketSendQueue"];
        }

        NSInteger timeout = [api requestTimeOutTimeInterval];
        
        //消息之间间隔YGSocketDelayTime以上
        double curTime = CACurrentMediaTime();
        double interval = (curTime - lastTime) ;
        if (interval < YGSocketSendDelayTime) {
            double sleepTime = (YGSocketSendDelayTime - interval);
            NSLog(@"sleepTime = %f",sleepTime);
            [NSThread sleepForTimeInterval:sleepTime];
        }
        
        if (self.asyncSocket.isDisconnected) {
            if (timeout > 0){
                //注册接口
                if (![[YGAPIHandleManager sharedManager] registerApi:api]) {
                    NSError *error = [NSError errorWithDomain:TCPAPI_ERROR_PACKAGE code:TCPAPIErrorCodeRequestPackage userInfo:nil];
                    dispatch_main_async(^{
                        api.completion(nil, error);
                    });
                    return;
                }
                [[YGAPIHandleManager sharedManager] registerTimeoutWithTime:timeout randomID:api.randomID];
            } else {
                [NSThread sleepForTimeInterval:YGSocketReturnDelayTime];//无超时时间api无返回，延时YGSocketDelayTime秒发送
            }
            return;
        }
        
        //发送消息
        [self.asyncSocket writeData:data withTimeout:-1 tag:self.writeTag];
        
        //发送完毕时间
        lastTime = CACurrentMediaTime();
        
        //注册请求超时
        if (timeout > 0){
            //注册接口
            if (![[YGAPIHandleManager sharedManager] registerApi:api]) {
                NSError *error = [NSError errorWithDomain:TCPAPI_ERROR_PACKAGE code:TCPAPIErrorCodeRequestPackage userInfo:nil];
                dispatch_main_async(^{
                    api.completion(nil, error);
                });
                return;
            }
            [[YGAPIHandleManager sharedManager] registerTimeoutWithTime:timeout randomID:api.randomID];
        } else {
            [NSThread sleepForTimeInterval:YGSocketReturnDelayTime];//无超时时间api无返回，延时YGSocketDelayTime秒发送
        }
        
//#if YGLogState
        YGSocketInputSteam *inputSteam = nil;
        if ([api isKindOfClass:[YGConnectionAPI class]]) {
            NSRange range = [data rangeOfData:self.beginData options:0 range:NSMakeRange(0, data.length)];
            inputSteam = [[YGSocketInputSteam alloc] initWithData:[data subdataWithRange:NSMakeRange(range.location, data.length - range.location)]];
        } else {
            inputSteam = [[YGSocketInputSteam alloc] initWithData:data];
        }
        [inputSteam decodeOriginaData];
        NSString *string = [[NSString alloc] initWithData:inputSteam.decodeData encoding:NSUTF8StringEncoding];
        NSLog(@"发送数据:\n%@",string);
//#endif
        //信号量锁
        dispatch_semaphore_wait(self.socketSemaphore, DISPATCH_TIME_FOREVER);
    });
}

#pragma mark - Private

//61 连接拒绝   Connection refused
//未连接 57    Socket is not connected
//无网络 51    Network is unreachable
//超时 60      Operation timed out
//手动超时 3    Attempt to connect to host timed out
//服务器踢掉我 7     Socket closed by remote peer

- (void)connectFailureHandleWithError:(NSError*)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([YGClientStateManager sharedManager].userState == YGUserOnline && error) {
            [YGClientStateManager sharedManager].userState = YGUserBeDisconnect;
        } else {
            if (!error) {
                NSLog(@"手动断开连接");
            } else {
                if ([YGClientStateManager sharedManager].userState != YGUserKickout || [YGClientStateManager sharedManager].userState != YGUserOffLineBackground) {
                    [YGClientStateManager sharedManager].userState = YGUserOffLine;
                }
            }
        }
        @synchronized(self) {
            if (connectResultBlock) {
                connectResultBlock(NO);
                connectResultBlock = nil;
            }
            if (disconnectResultBlock) {
                disconnectResultBlock(YES);
                disconnectResultBlock = nil;
            }
        }
    });
}

#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"socket连接成功Host:%@ port:%hu", host, port);
    self.isConnected = YES;
    [self.asyncSocket readDataWithTimeout:-1 tag:self.readTag];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (connectResultBlock) {
                connectResultBlock(YES);
                connectResultBlock = nil;
            }
        }
    });
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"Socket确认发送,WriteTag = %ld",tag);
    dispatch_semaphore_signal(self.socketSemaphore);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"\nSocket断开连接:\n%@",err);
    self.isConnected = NO;
    [self connectFailureHandleWithError:err];
    //断开连接
//    [[YGTCPUserManager sharedManager] disconnectHandle];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"socket收到,ReadTag = %ld",tag);
    
    [self.asyncSocket readDataWithTimeout:-1 tag:self.readTag];
    
    if (data.length > 2) {
        if ([self.recServerHeartbeatData isEqualToData:data]) {
            NSLog(@"收到服务器发送心跳 new");//new 2018.2.23
            return;
        }
        //判断头尾能直接解析的直接解析
        NSData *beginData = [data subdataWithRange:self.beginRange];
        NSData *endData = [data subdataWithRange:NSMakeRange(data.length-2, 2)];
        
        if ([beginData isEqualToData:self.beginData] && [endData isEqualToData:self.endData]) {
            BOOL result = [YGSocketManager analysisJsonWithData:data];
            if (!result) {
                [self iterateReceiveDataWithData:data beginData:beginData endData:endData];
            }
        } else {
            [self iterateReceiveDataWithData:data beginData:beginData endData:endData];
        }
    } else {
        if ([self.heartbeatData isEqualToData:data]) {
            NSLog(@"收到返回心跳");
            return;
        } else if ([self.serverHeartbeatData isEqualToData:data]) {
            NSLog(@"收到服务器发送心跳");
            return;
        }
        [self iterateReceiveDataWithData:data beginData:nil endData:nil];
    }
}


#pragma mark - 检索头尾

- (void)iterateReceiveDataWithData:(NSData *)data beginData:(NSData *)beginData endData:(NSData *)endData {
    if (self.receiveData) {
        [self.receiveData appendData:data];
    } else {
        self.receiveData = [NSMutableData dataWithData:data];
    }
    
    if (endData && beginData) {//拼装是头尾
        if ([endData isEqualToData:self.endData] && [beginData isEqualToData:self.beginData]) {
            BOOL result = [YGSocketManager analysisJsonWithData:self.receiveData];
            if (result) {
                self.receiveData = nil;
                return;
            }
        }
    }
    [self loopReceiveData];
}

- (void)loopReceiveData {
    //检索到结束符，前后十个不检索，防止可能出现手动数字为254,255出现的不能读的bug
    if (self.receiveData.length < 10) {
        return;
    }
    //检索头
    NSRange beginRange = [self.receiveData rangeOfData:self.beginData options:0 range:NSMakeRange(0, self.receiveData.length)];
    NSUInteger beginTag = NSMaxRange(beginRange);
    if (beginTag == NSNotFound) {
        NSLog(@"无头消息，清空data缓存");
        [self.receiveData replaceBytesInRange:NSMakeRange(0, self.receiveData.length) withBytes:NULL length:0];
        return;
    }
    //去除头前端多余数据
    if (beginRange.location != 0) {
        NSRange range = NSMakeRange(0, beginRange.location);
        //删去头
        NSLog(@"多余头消息: %@ ",[self.receiveData subdataWithRange:range]);
        [self.receiveData replaceBytesInRange:range withBytes:NULL length:0];
    }
    //检索尾部
    NSRange endRange = [self.receiveData rangeOfData:self.endData options:0 range:NSMakeRange(10, self.receiveData.length-10)];
    NSUInteger endTag = NSMaxRange(endRange);
    if (endTag == NSNotFound) {
        NSLog(@"无结尾标识符，不处理，等待下个包");
        return;
    }
    //提取尾部消息
    NSRange subRange = NSMakeRange(0, endTag);
    NSData *subdata = [self.receiveData subdataWithRange:subRange];
    [self.receiveData replaceBytesInRange:subRange withBytes:NULL length:0];
    
    BOOL result = [YGSocketManager analysisJsonWithData:subdata];
    if (!result) {
        NSLog(@"错误消息");
    }
    //递归查找头尾消息
    if (self.receiveData.length > 20 ) {
        [self loopReceiveData];
    }
}

+ (BOOL)analysisJsonWithData:(NSData *)data {
    if (!data.length) {
        return NO;
    }
    BOOL result = NO;
    
    YGSocketInputSteam *inputSteam = [[YGSocketInputSteam alloc] initWithData:data];
    NSDictionary *jsonDic = [inputSteam json];
    
    if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
        result = YES;
        
        NSLog(@"socket收到数据:\n%@",[[NSString alloc] initWithData:inputSteam.decodeData encoding:NSUTF8StringEncoding]);
        [[YGAPIHandleManager sharedManager] receiveServerDictionary:jsonDic];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"receiveMessage" object:jsonDic];
//        });
    } else {
        result = NO;
    }
    return result;
}


#pragma mark - getter

- (long)readTag {
    _readTag++;
    return _readTag;
}

- (long)writeTag {
    _writeTag++;
    return _writeTag;
}



@end
