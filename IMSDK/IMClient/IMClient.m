//
//  YGTCPUserStateManager.m
//  IM
//
//  Created by jiangxincai on 15/4/20.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//



#import "IMClient.h"
#import "YGSocketManager.h"
#import "YGConnectionAPI.h"
#import "YGUserVerificationAPI.h"
#import "CustomerServiceAPI.h"
#import "YGCommon.h"
#import "YGTimeUtils.h"
#import "YGUtilities.h"

//#import "YGIMDataBaseManager.h"
//
//#import "YGIMDataBase.h"
#import "YGAPIHandleManager.h"


#import "YGOfflineAPI.h"

#import "YGClientStateManager.h"



#import "GetOfflineMessageListAPI.h"

#import "YGSocketOutputSteam.h"

#import "YGSendMessageChatAPI.h"

typedef void (^sessionBlock)(NSString *userSession, NSError *error);

static NSInteger const getInfoTimeinterval = 300;
static NSInteger const offlineMessagePagesize = 50;

@interface IMClient () <CLLocationManagerDelegate>

@property (nonatomic, strong ,readwrite) NSString *deviceID;//设备id（应用不卸载只有一个）

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *getInfoTimer;

@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, copy) ResultBlock loginBlock;

@property (nonatomic, copy) sessionBlock connectServerBlock;
@property (nonatomic, copy) NSString *userSession;

@property (nonatomic, assign) BOOL isRequestFriends;

@property (nonatomic, assign) NSUInteger reLoginCount;
@property (nonatomic, assign) NSUInteger *tcpCount;

@end

@implementation IMClient
{
    BOOL needReconnect;
}
+ (instancetype)sharedClient{
    static IMClient* userManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[IMClient alloc] init];
    });
    return userManager;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [YGClientStateManager sharedManager];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)imConnectWithUserId:(NSString *)userId
                      Token:(NSString *)token
                 ServerHost:(NSString *)host
                 ServerPort:(NSString *)port
                    Success:(void(^)(id user))success
                    failure:(void(^)(NSError* error))failure {
    self.userID = userId;
    self.host = host;
    self.port = port;
    self.token = token;
   
    if ([self hasPropertyIsNull:@[@"userID",@"host",@"port",@"token",@"appName"] failure:failure]) {
        
        return;
    }
    dispatch_main_async(^{
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            failure([NSError errorWithDomain:@"程序后台" code:1002 userInfo:nil]);
            [self returnResultBlockWithResult:NO];
            return;
        }
        if ([YGClientStateManager sharedManager].userState == YGUserLogining) {
            failure([NSError errorWithDomain:@"正在连接" code:1002 userInfo:nil]);
            [self returnResultBlockWithResult:NO];
            return;
        }
        if ([YGClientStateManager sharedManager].userState == YGUserOnline) {
            failure([NSError errorWithDomain:@"已经登录" code:1002 userInfo:nil]);
            [self returnResultBlockWithResult:NO];
            return;
        }
        if ([YGClientStateManager sharedManager].userState == YGUserTcpConnectUnLogin) {
            failure([NSError errorWithDomain:@"已经连接" code:1002 userInfo:nil]);
            [self returnResultBlockWithResult:NO];
            return;
        }
        [YGClientStateManager sharedManager].userState = YGUserLogining;

        kWeakSelf(self);
        [self connectSocketWithResult:^(BOOL result) {
            if (result) {
                NSLog(@"连接成功");
                //连接服务器
//                [weakself connectServerWithUserID:weakself.userID server:@"" result:^(NSString *userSession, NSError *error) {
//                    if (userSession) {
                
                        
                        [YGUserVerificationAPI requestWithObject:@[token,weakself.appName] completion:^(id response, NSError *error) {
                            if (response && [response[MESSAGEPROTOCOL_CODE] integerValue] == 0) {
                                 NSLog(@"服务器登录成功");
                                //                             获取离线消息
                                [[IMClient sharedClient] getOfflineMessages];
                                [YGClientStateManager sharedManager].userState = YGUserOnline;
                                //                            weakself.userID = [response[@"data"][@"userId"] stringValue];
                                success(weakself.userID);
                            }
                            else {
                                failure(error);
                            }
                        }];
                    }
//                    else {
//                        if (error.code == TCPAPIErrorCodeRequestTimeOut) {
//                            weakself.tcpCount++;
//                            if (weakself.reLoginCount > 3) {
//                                failure(error);
//                                [weakself returnResultBlockWithResult:NO];
//                                [YGClientStateManager sharedManager].userState = YGUserOffLineInitiative;
//                                return;
//                            }
//                            [[YGSocketManager sharedManager] disconnect:^(BOOL result) {
//                                [YGClientStateManager sharedManager].userState = YGUserOffLineInitiative;
//                                //[self imConnectSuccess:nil failure:nil];
//                                [weakself imConnectWithUserId:self.userID Token:self.token ServerHost:self.host ServerPort:self.port Success:^(id user) {
//
//                                } failure:^(NSError *error) {
//
//                                }];
//                            }];
//                        } else {
//                            failure(error);
//                            [weakself returnResultBlockWithResult:NO];
//                            [YGClientStateManager sharedManager].userState = YGUserOffLineInitiative;
//                        }
//                    }
//                }];
            
//            }
         else {
                failure([NSError errorWithDomain:@"连接失败" code:1002 userInfo:nil]);
                NSLog(@"连接失败");
                [weakself returnResultBlockWithResult:NO];
                [YGClientStateManager sharedManager].userState = YGUserOffLine;
                return;
            }
        }];
        
      
    });
}


- (void)reconnect:(void (^)(BOOL))block {
    dispatch_main_async(^{
        
        if ([YGClientStateManager sharedManager].userState == YGUserOnline || [YGClientStateManager sharedManager].userState == YGUserLogining)
        {
            // 获取离线消息
            [[IMClient sharedClient] getOfflineMessages];
            block(YES);
            return ;
        }
        
        [self imConnectWithUserId:self.userID Token:self.token ServerHost:self.host ServerPort:self.port Success:^(id user) {
            
        } failure:^(NSError *error) {
            
        }];
    });
}

- (void)connectResult:(ResultBlock)block {
    if (self.resultBlock) {
        self.resultBlock(NO);
    }
    self.resultBlock = block;
}

//- (void)logoutHandle:(int)type {
//    dispatch_main_async(^{
//
////        [YGIMDataBase shareIMDataBase].isOpenDataBase = NO;
//
//
//        if(type == 1){
//            [self sendOfflineWithUnreadCount:0];
//        }
//        [self disconnectHandle];
//        [YGClientStateManager sharedManager].userState = YGUserOffLineInitiative;
//
//
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//        self.userID = nil;
//        self.avatar = nil;
//        self.name = nil;
//        self.level = nil;
//    });
//}

- (void)disconnectHandle {
    dispatch_main_async(^{
        self.userID = nil;
        [self stopGetInfoTimer];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNC_DisconnectIM object:@NO];
    });
}

/**
 *  发送退出登录消息给服务器
 */
- (void)sendOfflineWithUnreadCount:(NSInteger)count {
    
        //        [YGIMDataBase shareIMDataBase].isOpenDataBase = NO;
   
    
    [YGClientStateManager sharedManager].userState = YGUserOffLineInitiative;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
   
//    NSInteger unreadCount = 0/*[[YGSessionModule sharedModule] getAllUnreadMessageCount]*/;
    if (self.userID.length) {
        
        
        [YGOfflineAPI requestWithObject:@[@(1),@(count)] completion:^(id response, NSError *error) {
        }];
    }
    [self disconnectHandle];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YGSocketManager sharedManager] disconnect:^(BOOL result) {
        }];
    });
    self.userID = nil;
    self.avatar = nil;
    self.name = nil;
    
}


/**
 *  发送应用退到后台消息给服务器
 */
- (void)sendOfflineBackgroundWithUnreadCount:(NSInteger)count {
   
 
    if (self.userID.length) {
        [YGOfflineAPI requestWithObject:@[@(0),@(count)] completion:^(id response, NSError *error) {
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YGSocketManager sharedManager] disconnect:^(BOOL result) {
        }];
    });
    
    
}

#pragma mark - Private

- (void)returnResultBlockWithResult:(BOOL)result {
    if (self.resultBlock) {
        self.resultBlock(result);
        self.resultBlock = nil;
    }
}


/**
 Tcp连接

 @param resultBlock 结果回调
 */
- (void)connectSocketWithResult:(void(^)(BOOL))resultBlock {
    if ([YGSocketManager sharedManager].isConnected) {
        [[YGSocketManager sharedManager] disconnect:^(BOOL result) {
            [[YGSocketManager sharedManager] connectWithServerHost:self.host ServerPort:self.port :^(BOOL object) {
                if (object) {
                    resultBlock(YES);
                } else {
                    resultBlock(NO);
                }
            }];
        }];
    } else {
        [[YGSocketManager sharedManager] connectWithServerHost:self.host ServerPort:self.port:^(BOOL object) {
            if (object) {
                resultBlock(YES);
            } else {
                resultBlock(NO);
            }
        }];
    }
}


/**
 IM登录

 @param userID 用户ID
 @param server 服务器地址，目前可不传
 @param result 结果回调
 */
- (void)connectServerWithUserID:(NSString *)userID server:(NSString *)server result:(sessionBlock)result {
    if (!userID) {
        result(nil, [NSError errorWithDomain:@"无userid" code:111 userInfo:nil]);
        return;
    }
    NSArray *array = @[server, userID,STR_IS_NULL([[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICE_TOKEN"])];
    [YGConnectionAPI requestWithObject:array completion:^(id response, NSError *error) {
        if (response) {
            
            result(response, nil);
        } else {
           
            result(nil, error);
        }
    }];
}


/**
 获取离线消息
 */
- (void)getOfflineMessages {
    
    kWeakSelf(self);
    if (!self.userID) {
        return;
    }
    NSString *getOfflineMsgStartTime = [UserDefaultsObj objectForKey:self.userID];
    if (!getOfflineMsgStartTime) {

        getOfflineMsgStartTime = [YGTimeUtils getDateToServerString: [YGTimeUtils getDaysAgo:7 FromDate:[NSDate date]]];
    }
    [GetOfflineMessageListAPI requestWithObject:@[getOfflineMsgStartTime,@(offlineMessagePagesize)] completion:^(id response, NSError *error) {
        if (response) {
            
            [UserDefaultsObj setObject:response[MESSAGEPROTOCOL_DATA][@"time"] forKey:self.userID];
            [UserDefaultsObj synchronize];
            for (NSDictionary *dic in response[MESSAGEPROTOCOL_DATA][@"items"]) {
                
                NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
                [mDic setValue:@(1) forKey:@"isOfflineMsg"];
                [[YGAPIHandleManager sharedManager] receiveServerDictionary:mDic];
                
            }
            // 还有新的
            if ([response[MESSAGEPROTOCOL_DATA][@"items"] count]) {
                
                [weakself getOfflineMessages];
            }
            else {
//                KPostNotification(kNC_offlineMsgLoaded, nil);
            }
        }

    }];
}



//关闭发送心跳的Timer
- (void)stopGetInfoTimer {
    if (_getInfoTimer) {
        [_getInfoTimer invalidate];
        _getInfoTimer = nil;
    }
}



#pragma mark - getter

- (NSString *)deviceID {
    if (!_deviceID) {
        _deviceID = [[NSUserDefaults standardUserDefaults] objectForKey:kUD_DeviceID];
        if (!_deviceID.length) {
            _deviceID = [NSProcessInfo processInfo].globallyUniqueString;
            [[NSUserDefaults standardUserDefaults] setObject:_deviceID forKey:kUD_DeviceID];
        }
    }
    return _deviceID;
}



/**
 发送消息
 @param message 消息体
 @param success 成功回调，返回消息实际到达服务器的时间
 @param failure 失败回调
 */
- (void)sendMessage:(IMMessage *)message Success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
  
    NSAssert(message.senderID != nil, @"消息发送者不能为空");
    NSAssert(message.recevierID != nil, @"消息接收者不能为空");
    NSAssert(message.messageID != nil, @"构造消息失败");
    YGSendMessageChatAPI *api = [[YGSendMessageChatAPI alloc] init];
    api.appName = self.appName;
    if (message.contentType == YGMessageContentTypeLongText && message.text.length > IMServiceMostSendTextLength) {
        
        NSString *sendText = message.text;
        NSMutableArray *textArray = [NSMutableArray new];
        NSInteger count = sendText.length/IMServiceMostSendTextLength + 1;
        message.part_total = (int)count;
        api.message = message;
        
        message.contentType = YGMessageContentTypeLongText;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSInteger i = 0; i < count ; i++) {
                NSInteger remainder = 0;
                if (i == count - 1) {
                    remainder = sendText.length%IMServiceMostSendTextLength;
                    if (remainder == 0) {
                        break;
                    }
                } else {
                    remainder = IMServiceMostSendTextLength;
                }
                [textArray addObject:[sendText substringWithRange:NSMakeRange(i*IMServiceMostSendTextLength, remainder)]];
            }
            
            
            api.textArray = textArray;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sendLongTextWithAPI:api count:0 Success:success failure:failure];
            });
        });
        
    }
    else {
        
            [YGSendMessageChatAPI requestWithObject:message completion:^(id response, NSError *error) {
        
                if (error) {
        
                    failure(error);
                }
                else {
                    success(response);
                }
            }];
    }
}


- (void)sendLongTextWithAPI:(YGSendMessageChatAPI *)api count:(NSUInteger)count Success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{

    api.message.text = api.textArray[count];
    api.message.part_order = count;
    [api requestWithObject:api.message completion:^(id response, NSError *error) {
        if (response) {

            
            if (count+1 >= api.textArray.count) {
                success(response);
            }
            else {
                
                [self sendLongTextWithAPI:api count:count+1 Success:success failure:failure];
            }
            
        } else {
            failure(error);
        }
    }];
}

/**
 连接客服
 
 @param Id 客服ID
 @param sessionId 会话ID
 @param mobile 手机号
 @param photo 用户头像
 @param type 1-发起请求 2-结束会话 3-客服端确认收到会话请求 4-用户端确认收到结束会话通知
 */
- (void)connectCustomerServiceWithID:(NSString *)Id SesssionId:(NSString *)sessionId Mobile:(NSString *)mobile Photo:(NSString *)photo Type:(NSInteger)type Success:(void (^)(void))success failure:(void (^)(NSError *))failure{
    NSAssert(Id!= nil, @"客服ID不能为空");
    NSAssert(sessionId!= nil, @"会话ID不能为空");
    NSAssert(mobile!= nil, @"mobile不能为空");
    NSAssert(photo!= nil, @"photo不能为空");
    if (!self.userID || !self.appName) {
        failure([NSError errorWithDomain:@"发送者ID或AppName为空" code:9527 userInfo:nil]);
        return;
    }
    [CustomerServiceAPI requestWithObject:@[Id,sessionId,mobile,photo,@(type)] completion:^(id response, NSError *error) {
        if (error) {
            
            failure(error);
        }
        else {
            success();
        }
    }];
}

/**
 接收消息监听

 @param receiveMessageDelegate <#receiveMessageDelegate description#>
 */
- (void)setReceiveMessageDelegate:(id<ReceiveMessageDelegate>)receiveMessageDelegate {
    
    _receiveMessageDelegate = receiveMessageDelegate;
}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application UnreadCount:(NSInteger)count{
    
    if ([IMClient sharedClient].userID) {
        
        [[IMClient sharedClient] sendOfflineBackgroundWithUnreadCount:count];
    }
    if ([YGClientStateManager sharedManager].userState != YGUserKickout) {
        [YGClientStateManager sharedManager].userState = YGUserOffLineBackground;
    }
    
    needReconnect = YES;
    //退到后台取消重连
    [YGClientStateManager sharedManager].reconnectCount = 0;
    
}


// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"APPDidBecomeActive"object:nil];
    if (![IMClient sharedClient].userID) {
        return;
    }
    
    if(!needReconnect) {
        return;
    }
    if (([YGClientStateManager sharedManager].userState != YGUserOffLineBackground) && [YGClientStateManager sharedManager].userState != YGUserOffLine) {
        return;
    }
    needReconnect = NO;
    [[IMClient sharedClient] reconnect:^(BOOL reconnectIsSuccess) {
        if (reconnectIsSuccess) {
            NSLog(@"%s------重连成功",__FUNCTION__);
            
        }else {
            
        }
    }];
}





/**
 注册推送
 */
- (void)registerAppName:(NSString *)appName {
    
   
    self.appName = appName;
    
}


/**
 绑定deviceToken，用于APNS
 
 @param deviceToken 推送token
 */
- (void)bindDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *dt = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *dn = [dt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *saveToken = [dn stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:saveToken forKey:@"DEVICE_TOKEN"];
    NSLog(@"devicetoken......%@",saveToken);
}

- (BOOL)hasPropertyIsNull:(NSArray *)properties failure:(void(^)(NSError* error))failure {
    
    for (NSString *property in properties) {
        
        NSString *value = [self valueForKey:property];
        if (!value || !value.length) {
          
            failure([NSError errorWithDomain:[NSString stringWithFormat:@"%@不能为空",property] code:520 userInfo:nil]);
            return YES;
            
        }
    }
    return NO;
}
@end

