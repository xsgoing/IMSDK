//
//  YGClientStateManager.m
//  mobile
//
//  Created by jiangxincai on 15/12/21.
//  Copyright © 2015年 1yyg. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YGClientStateManager.h"
#import "IMClient.h"
#import "YGSocketManager.h"
//#import "YGIMDataBase.h"
#import "YGSocketOutputSteam.h"
#import "IMReachabilityManager.h"
static NSInteger const YGHeartBeatTimeinterval = 30;
static NSInteger const YGReloginTimeinterval = 15;
static NSInteger const YGLoginTimeoutTimeinterval = 30;

static NSString * const YGUserStateKeyPath = @"userState";

@interface YGClientStateManager ()

@property (strong, nonatomic) NSTimer *sendHeartTimer;
@property (strong, nonatomic) NSTimer *reloginTimer;
@property (nonatomic, strong) NSTimer *loginTimeoutTimer;

@property (nonatomic, assign) BOOL isFirstNetCallback;//第一次回调
@property (nonatomic, assign) AFNetworkReachabilityStatus lastStatus;

@end

@implementation YGClientStateManager

#pragma mark - INIT

+ (instancetype)sharedManager {
    static YGClientStateManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YGClientStateManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isFirstNetCallback = YES;
        
        [self registerUserStateObserver];
        [self registerNetworkState];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:YGUserStateKeyPath];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //用户状态变化
    if ([keyPath isEqualToString:YGUserStateKeyPath]) {
        switch (self.userState) {
            case YGUserKickout:
                NSLog(@"======================YGUserKickout");
                [self stopHeartBeat];
                break;
                
            case YGUserOffLine:
                NSLog(@"======================YGUserOffLine");
                [self stopHeartBeat];
                UIApplicationState state = [UIApplication sharedApplication].applicationState;
                if (state != UIApplicationStateBackground) {
                    if (!_reloginTimer && self.userState == YGUserOffLine &&  [IMClient sharedClient].userID /*&& self.lastStatus == AFNetworkReachabilityStatusNotReachable*/) {
                        NSLog(@"进入重连");
//                        [[IMClient sharedClient] disconnectHandle];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self stopRelogin];
                            [self startRelogin];
                        });
                    }
                    if (self.reconnectCount == 3) {
                        self.reconnectCount = 0;
//                        [self isIMLogin];
                    }
                }
                break;
                
            case YGUserOffLineInitiative:
                NSLog(@"======================YGUserOffLineInitiative");
                [self stopHeartBeat];
                break;
               
            case YGUserOffLineBackground:
                NSLog(@"======================YGUserOffLineBackground");
                [self stopHeartBeat];
                break;
                
            case YGUserOnline:
                NSLog(@"======================YGUserOnline");
                self.reconnectCount = 0;
                [self stopLoginTimeout];
                [self startHeartBeat];
                break;
                
            case YGUserBeDisconnect:
                NSLog(@"======================YGUserBeDisconnect");
                [self stopHeartBeat];
                if ([IMClient sharedClient].userID) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self startRelogin];
                    });
                }
                break;
                
            case YGUserLogining: {
                NSLog(@"======================YGUserLogining");
                [self startLoginTimeout];
                
            }
                break;
            case YGUserTcpConnectUnLogin: {
                NSLog(@"======================YGUserTcpConnectUnLogin");
               // [self startLoginTimeout];
                [self startHeartBeat];
            }
                break;
        }
    }
}

#pragma mark - Private

//注册KVO
- (void)registerUserStateObserver {
    //用户状态
    [self addObserver:self forKeyPath:YGUserStateKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)registerNetworkState {
    [[IMReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        if (self.isFirstNetCallback) {
            self.isFirstNetCallback = NO;
            return;
        }

        self.reconnectCount = 0;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                self.userState = YGUserOffLine;
                self.reconnectCount = 0;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"有网络");
                [[YGSocketManager sharedManager] disconnect:^(BOOL result) {

                    [[IMClient sharedClient] reconnect:^(BOOL reconnectIsSuccess) {}];
                    if (!_reloginTimer && self.userState == YGUserOffLine && [IMClient sharedClient].userID && self.lastStatus == AFNetworkReachabilityStatusNotReachable) {
                        NSLog(@"进入重连");
//                        [[IMClient sharedClient] disconnectHandle];
                        [self stopRelogin];
                        [self startRelogin];
                    }
                }];
                break;
            }

            case AFNetworkReachabilityStatusUnknown:{
                NSLog(@"未知");
            }
                break;
        }
        self.lastStatus = status;
    }];
}

- (void)onSendHeartBeatTimer:(NSTimer*)timer {
    NSLog(@"\n*********砰*********");
//    NSError *error = nil;
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:@{@"a":@" "} options:NSJSONWritingPrettyPrinted error:&error];
//
//    //判断打包是否成功，失败为参数为nil或者不是字符串
//    if (error || !requestData) {//
//        error = [NSError errorWithDomain:TCPAPI_ERROR_PACKAGE code:TCPAPIErrorCodeRequestPackage userInfo:nil];
//    }
//
//    if (error) {
//        return;
//    }
//    YGSocketOutputSteam *outputSteam = [[YGSocketOutputSteam alloc] initWithData:requestData];
//
//    [[YGSocketManager sharedManager] sendData:[outputSteam socketSendData]];
    NSData *requestData = [@" " dataUsingEncoding:NSUTF8StringEncoding];
    YGSocketOutputSteam *outputSteam = [[YGSocketOutputSteam alloc] initWithData:requestData];
    [[YGSocketManager sharedManager] sendData:[outputSteam socketSendData]];
}

//运行在断线重连的Timer上
- (void)onReloginTimer:(NSTimer*)timer {
    if (self.userState == YGUserLogining) {
        [self stopRelogin];
        return;
    }
    self.reconnectCount++;
    NSLog(@"重连 count:%ld",(long)self.reconnectCount);
    [[IMClient sharedClient] reconnect:^(BOOL reconnectIsSuccess) {
        if (reconnectIsSuccess) {
            NSLog(@"重连成功");
          
            self.reconnectCount = 0;
        }
        [self stopRelogin];
    }];
}

- (void)loginTimeoutTime:(NSTimer *)timer {
    if (self.userState == YGUserLogining) {
        self.userState = YGUserOffLine;
    }
}

#pragma mark - Timer

//开启发送心跳的Timer
- (void)startHeartBeat {
    if (!_sendHeartTimer && ![_sendHeartTimer isValid]) {
        _sendHeartTimer = [NSTimer scheduledTimerWithTimeInterval:YGHeartBeatTimeinterval target:self selector:@selector(onSendHeartBeatTimer:) userInfo:nil repeats:YES];
    }
}

//关闭发送心跳的Timer
- (void)stopHeartBeat {
    if (_sendHeartTimer) {
        [_sendHeartTimer invalidate];
        _sendHeartTimer = nil;
    }
}

//开启重连Timer
- (void)startRelogin {
    if (!_reloginTimer) {
        _reloginTimer = [NSTimer scheduledTimerWithTimeInterval:YGReloginTimeinterval target:self selector:@selector(onReloginTimer:) userInfo:nil repeats:YES];
        [_reloginTimer fire];
    }
}

//关闭发送心跳的Timer
- (void)stopRelogin {
    if (_reloginTimer) {
        [_reloginTimer invalidate];
        _reloginTimer = nil;
    }
}

#pragma mark - 登录超时

- (void)startLoginTimeout {
    if (!_loginTimeoutTimer) {
        _loginTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:YGLoginTimeoutTimeinterval target:self selector:@selector(loginTimeoutTime:) userInfo:nil repeats:NO];
    }
}

- (void)stopLoginTimeout {
    if (_loginTimeoutTimer) {
        [_loginTimeoutTimer invalidate];
        _loginTimeoutTimer = nil;
    }
}

#pragma mark ---IMLogin
//- (void)isIMLogin {
//    if (!UserModelObj.userID) {//未登录
//        [[IMClient sharedClient] imConnectSuccess:^(id user) {
//            NSLog(@"%s======tcp连接成功=====",__FUNCTION__);
//        } failure:^(NSError *error) {
//            NSLog(@"%s======tcp连接失败=%@=====",__FUNCTION__,error);
//        }];
//    }else {
//        [IMClient sharedClient].userID = [NSString stringWithFormat:@"%d",UserModelObj.userID];
//        [IMClient sharedClient].avatar = [NSString stringWithFormat:@"%@",UserModelObj.userPhoto];
//        if (![IMClient sharedClient].userJID) {
//            if ([YGClientStateManager sharedManager].userState != YGUserLogining) {
//                [[IMClient sharedClient] connectWithVerifyCode:UserModelObj.verifyCode isReconnect:NO success:^(id user) {
//                    NSLog(@"%s======-登录成功=====",__FUNCTION__);
//                } failure:^(NSError *error) {
//                    NSLog(@"%s======-登录失败==%@===",__FUNCTION__,error);
//                }];
//            } else {
//                [[IMClient sharedClient] connectResult:^(BOOL result) {
//
//                }];
//            }
//        }
//        [[YGIMDataBase shareIMDataBase] creatUserDBWithUserWithUserID:[IMClient sharedClient].userID];
//    }
//}


@end
