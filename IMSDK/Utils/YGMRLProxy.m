//
//  YGMRLProxy.m
//  mobile
//
//  Created by 1yyg.com on 2017/3/15.
//  Copyright © 2017年 1yyg. All rights reserved.
//

#import "YGMRLProxy.h"

#import "GCDAsyncUdpSocket.h"
#import "YGSocketInputSteam.h"
#import "YGSocketOutputSteam.h"
#import "IMClient.h"


#define BUFFERSIZE 1024

@interface YGMRLProxy() <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) dispatch_queue_t socketDelegateQueue;
@property (nonatomic, strong) dispatch_queue_t socketSendQueue;
@property (nonatomic, strong) dispatch_queue_t socketDataPlayQueue;

@property (nonatomic, assign) long tag;
//@property (nonatomic, copy) RequestCompletion block;
@property (nonatomic, copy) NSString* localIp;
@property (nonatomic, assign) UInt16 localPort;

@property (nonatomic, copy) NSString* mrlProtocal;
@property (nonatomic, copy) NSString* mrlIp;
@property (nonatomic, assign) UInt16 mrlPort;
@property (nonatomic, strong) NSMutableData* receivedBufferData;


@end

@implementation YGMRLProxy
{
    ResultBlock connectResultBlock;
    ResultBlock disconnectResultBlock;
}

+ (instancetype)sharedManager{
    static YGMRLProxy* proxy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[YGMRLProxy alloc] init];
    });
    return proxy;
}

- (void)initWithMRL:(NSString*) mrl updSocket:(GCDAsyncUdpSocket*) socket{

        _socketDelegateQueue = dispatch_queue_create("UDPGCDQueue", DISPATCH_QUEUE_SERIAL);
        _socketSendQueue = dispatch_queue_create("UDPGCDSendQueue", DISPATCH_QUEUE_SERIAL);
        _socketDataPlayQueue = dispatch_queue_create("UDPGCDDataPlayQueue", DISPATCH_QUEUE_SERIAL);
        _tag = 0;
        _localIp = @"127.0.0.1";
        _receivedBufferData = [[NSMutableData alloc] init];
        
        [self getMRLProtocal:mrl];
        [self setupSocket];
    
}

- (void)initWithMRL:(NSString*) mrl {
    
        _socketDelegateQueue = dispatch_queue_create("UDPGCDQueue", DISPATCH_QUEUE_SERIAL);
        _socketSendQueue = dispatch_queue_create("UDPGCDSendQueue", DISPATCH_QUEUE_SERIAL);
        _socketDataPlayQueue = dispatch_queue_create("UDPGCDDataPlayQueue", DISPATCH_QUEUE_SERIAL);
        _tag = 0;
        _localIp = @"127.0.0.1";
        _receivedBufferData = [[NSMutableData alloc] init];
        
        [self getMRLProtocal:mrl];
        [self setupSocket];
    
}

- (void)setupSocket {

    GCDAsyncUdpSocket* sock = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:self.socketDelegateQueue];
    self.udpSocket = sock;
    NSError *error = nil;
    NSLog(@"333=====bind====%ld",_mrlPort);
    if (![self.udpSocket bindToPort:_mrlPort error:&error]) {
        NSLog(@"Error binding: %@", error);
        return;
    }
    [self.udpSocket enableBroadcast:YES error:&error];
    
    [self.udpSocket joinMulticastGroup:@"255.255.255.255" error:&error];
    if (![self.udpSocket beginReceiving:&error]) {
        NSLog(@"Error receiving: %@", error);
        return;
    }
}

-(NSString*) getMRLProtocal:(NSString*) mrl
{
    //格式 RTP://IP:PORT
    if (mrl!=NULL) {
        NSArray* mrls = [mrl componentsSeparatedByString:@":"];
        if (mrls!=nil && mrls.count==3) {
            _localPort = arc4random() % (65534 - 1025) + 1025;
            _mrlProtocal = [NSString stringWithFormat:@"%@://",mrls[0]];
            _mrlIp = [mrls[1] substringFromIndex:2];
            _mrlPort = [mrls[2] integerValue];
            
        }
        
    }
    NSLog(@"MRL:%@,%@,%d",_mrlProtocal,_mrlIp,_mrlPort);
    return [NSString stringWithFormat:@"%@%@%d",_mrlProtocal,_mrlIp,_mrlPort];
}

- (void)sendData:(NSData*)data {
    
//    dispatch_async(self.socketSendQueue, ^{
        [self.udpSocket sendData:data toHost:@"127.0.0.1" port:2345 withTimeout:-1 tag:self.tag];
//    });
    
//    self.tag++;
}

- (void)testPlay {
    
    dispatch_async(self.socketDataPlayQueue, ^{
        
    });
}

-(void) write {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//程序文件夹主目录
    NSString *documentsDirectory = [paths objectAtIndex:0];//Document目录
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"aaa.mp4"];
    
    NSString *temp = @"";
    int data0 = 100000;
    float data1 = 23.45f;
    NSMutableData *writer = [[NSMutableData alloc] init];
    
    [writer appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
    [writer appendBytes:&data0 length:sizeof(data0)];
    [writer appendBytes:&data1 length:sizeof(data1)];
    
    [writer writeToFile:path atomically:YES];
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
//    NSLog(@"===didReceiveData=== length:%ld",data.length);
//    if (data.length>50) {
//        [_receivedBufferData appendData:data];
//    }
//    if (_receivedBufferData.length>1024*64) {
//        
//    }
    if (data.length>50) {
        [self sendData:data];
    }
//    [self testPlay];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
//    YGNLog(@"==didConnectToAddress==");
}

//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
//    YGNLog(@"===didNotConnect==");
//    if (self.block) {
//        self.block(nil, error);
//        self.block = nil;
//    }
//}
//
//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
//    YGNLog(@"didSendDataWithTag %ld ",tag);
//}
//
//- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
//    YGNLog(@"didNotSendDataWithTag %ld ",tag);
//    if (self.block) {
//        self.block(nil, error);
//        self.block = nil;
//    }
//}
//
//- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
//    YGNLog(@"udpSocketDidClose");
//    if (self.block) {
//        self.block(nil, error);
//        self.block = nil;
//    }
//}


@end
