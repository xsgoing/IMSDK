 //
//  YGAPIHandleManager.m
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGAPIHandleManager.h"
#import "YGSocketManager.h"
#import "YGSuperAPI.h"
#import "YGConfirmMessageAPI.h"
//#import "YGIMDataBaseManager.h"
#import "YGConnectionAPI.h"
#import "IMClient.h"
#import "IMUUID.h"
//#import "NSString+YGCommon.h"


@interface YGAPIHandleManager ()


@property (nonatomic, strong) NSMutableDictionary *partMap;

@property (nonatomic, strong) dispatch_queue_t apiHandleQueue;
@property (nonatomic, strong) dispatch_queue_t replyQueue;

@end

@implementation YGAPIHandleManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static YGAPIHandleManager* apiHandleManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiHandleManager = [[YGAPIHandleManager alloc] init];
    });
    return apiHandleManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _apiResponseMap = [NSMutableDictionary new];
        _partMap = [NSMutableDictionary new];
//        _delegate = [YGPushMessageModule sharedModule];
        
        _apiHandleQueue = dispatch_queue_create("APIHandle", DISPATCH_QUEUE_SERIAL);//创建串行队列
        _replyQueue = dispatch_queue_create("replyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Public

- (BOOL)registerApi:(YGSuperAPI*)api {
    __block BOOL registSuccess = NO;
    
    dispatch_sync(self.apiHandleQueue, ^{
        //注册返回数据处理
        if (!self.apiResponseMap[api.randomID]){
            [self.apiResponseMap setObject:api forKey:api.randomID];
            registSuccess = YES;
        }else{
            registSuccess = NO;
        }
    });
    
    return registSuccess;
}

- (void)registerTimeoutWithTime:(double)delayInSeconds randomID:(NSString *)randomID {
    if (delayInSeconds == 0){
        return;
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, self.apiHandleQueue, ^(void){
        if (self.apiResponseMap[randomID]) {
            @autoreleasepool {
                YGSuperAPI *api = self.apiResponseMap[randomID];
//                NSLog(@"%@超时后添加信号量:\nID:%@",[api className],api.randomID);
                if (api.retryNumbers < [api numberOfTimeOutRetries]) {
                    [api retrySendData];
                } else {
                    [self.apiResponseMap removeObjectForKey:randomID];//删除缓存类
                    NSError* error = [NSError errorWithDomain:TCPAPI_ERROR_TIMEOUT code:TCPAPIErrorCodeRequestTimeOut userInfo:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (api.completion) {
                            api.completion(nil,error);
                        } else {
                            [api.delegate api:api didReceiveResponse:nil error:error];
                        }
                    });
                }
            }
        }
    });
}

- (void)removeApiWithRandomID:(NSString*)randomID {
    dispatch_async(self.apiHandleQueue, ^{
        [self.apiResponseMap removeObjectForKey:randomID];
    });
    
}

- (void)removeAllApi {
    dispatch_async(self.apiHandleQueue, ^{
        [self.apiResponseMap removeAllObjects];
    });
}

- (void)receiveServerDictionary:(NSDictionary*)jsonDictionary {
    dispatch_async(self.apiHandleQueue, ^{
        @autoreleasepool {
            [[NSThread currentThread] setName:@"apiHandleQueue"];

            
            //返回数据格式:api,appid,from,to,data{},code,time。START TODO
//            NSString *apiId = [[jsonDictionary objectForKey:MESSAGEPROTOCOL_APIID] stringValue];
//            if ([apiId isEqualToString:@"1001"]) {
//                [self handleJson:jsonDictionary returnID:[YGConnectionAPI className]];
//            } else if ([apiId isEqualToString:@"file"]) {
//                NSString *returnID = jsonDictionary[@"id"];
//                //这个类当做取消息
//                if ([self.apiResponseMap[returnID] isKindOfClass:[YGQueryFileExistAPI class]]) {
//                    [self handleJson:jsonDictionary returnID:returnID];
//                } else {//其他当做推送消息
//                    [self handleJson:jsonDictionary returnID:nil];
//                }
//            } else if ([apiId isEqualToString:@""]) { //无需返回的类型请求
//                [self handleJson:jsonDictionary returnID:jsonDictionary[@"id"]];
//
//            } else {
//
//            }
            
            //END//
            
            
//            NSString *firstKey = [[jsonDictionary allKeys] firstObject];
           
             if ([jsonDictionary[@"api"] isEqualToString:@"Connect"]) {//判断是连接请求
                [self handleJson:jsonDictionary returnID:[YGConnectionAPI className]];
            }
            
//            else if ([jsonDictionary[@"api"] isEqualToString:@"Message"] && jsonDictionary[@"data"]) {
//                [self handleJson:jsonDictionary returnID:nil];
//            }
//            else if([jsonDictionary[@"api"] isEqualToString:@"AddFriend"]){
//                [self handleJson:jsonDictionary returnID:nil];
//            }
            else {
                NSString *returnID = jsonDictionary[@"id"];
                if (self.apiResponseMap[returnID]) {//如果存在是自己发送的响应
                    [self handleJson:jsonDictionary returnID:returnID];
                }else  {//当做推送消息
                    [self handleJson:jsonDictionary returnID:nil];
                }
            }
        }
    });
}

- (void)handleJson:(NSDictionary*)dictionary returnID:(NSString*)returnID {

    if (returnID) {
        [self requstAPIHandelWithDictionary:dictionary returnID:returnID];


       
    } else {
        [self unrequestAPIHandelWithDictionary:dictionary firstKey:nil];
    }
}

#pragma mark - reply

- (void)replyMessageToServerWithDictionary:(NSDictionary *)dictionary {
    
    NSString *ids = dictionary[@"id"];
    if (ids.length < 3) {
        return;
    }
    
    YGConfirmMessageAPI *api = [YGConfirmMessageAPI new];
    [api requestWithObject:@[ids] completion:^(id response, NSError *error) { }];
    
    
}

#pragma mark -errorTarget back to server

#pragma mark - Private

- (void)requstAPIHandelWithDictionary:(NSDictionary *)jsonDictionary returnID:(NSString*)returnID{
    if (!returnID) {
        NSLog(@"returnID为空");
        return;
    }
    YGSuperAPI *api = self.apiResponseMap[returnID];
    if (api) {//为nil，就是unquest
        id response = [api analysisReturnDataWithDictionary:jsonDictionary];//处理数据
        if (response) {
            [self.apiResponseMap removeObjectForKey:returnID];//删除缓存类
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    if (response && ![response isKindOfClass:[NSError class]]) {
                        if (api.completion) {
                            api.completion(response,nil);//回调处理后的数据
                        } else {
                            if (api.delegate &&[api.delegate respondsToSelector:@selector(api:didReceiveResponse:error:)]) {
                                [api.delegate api:api didReceiveResponse:response error:nil];
                            }
                        }
                    } else if ([response isKindOfClass:[NSError class]]){
                        if (api.completion) {
                            api.completion(nil,response);
                        } else {
                            if (api.delegate &&[api.delegate respondsToSelector:@selector(api:didReceiveResponse:error:)]) {
                                [api.delegate api:api didReceiveResponse:nil error:response];
                            }
                        }
                    } else{
                        NSError* error = [NSError errorWithDomain:TCPAPI_ERROR_ANALYSI code:TCPAPIErrorCodeAnalysisMistake userInfo:nil];
                        if (api.completion) {
                            api.completion(nil,error);
                        } else {
                            if (api.delegate &&[api.delegate respondsToSelector:@selector(api:didReceiveResponse:error:)]) {
                                [api.delegate api:api didReceiveResponse:nil error:error];
                            }
                        }
                    }
                }
            });
        } else {
            NSLog(@"消息处理为空\n%@",jsonDictionary);
        }
    } else {
        NSLog(@"回调消息没有找到回调API\n%@",jsonDictionary);
    }
}


/**
 处理非主动请求返回的数据
 */
- (void) unrequestAPIHandelWithDictionary:(NSDictionary *)jsonDictionary firstKey:(NSString*)firstKey {
//   
//#ifdef DEBUG
//     [self replyMessageToServerWithDictionary:jsonDictionary];
//#endif
    //判断字段，调用合适的回调
    NSString *api = jsonDictionary[@"api"];
    

    
    // 撤回消息
   if ([api isEqualToString:@"Message"] && [jsonDictionary[@"data"][@"subType"] isEqualToString:@"retract"])
    {
        [self judgeAndSendDelegateWithDictionary:jsonDictionary type:YGHandlePushMessageType_RetractMessage];
    }
    // 聊天消息
    else if ([api isEqualToString:@"Message"]) {
        // from和to相同的消息不处理
        if ([jsonDictionary[@"from"] isEqualToString:jsonDictionary[@"to"]]) {
            
            [self replyMessageToServerWithDictionary:jsonDictionary];
            return;
        }
        // 长文本
        if ([jsonDictionary[MESSAGEPROTOCOL_DATA][@"subType"] isEqualToString:@"bigtxt"]) {
             [self replyMessageToServerWithDictionary:jsonDictionary];
            [self partHandleWithDictionary:jsonDictionary];
            return;
        }
       
        
        [self judgeAndSendDelegateWithDictionary:jsonDictionary type:YGHandlePushMessageType_ReceiveChatMessage];
        
    }
   
    
    // 被踢下线
   else if ([api isEqualToString:@"Auth"] && [jsonDictionary[@"code"] intValue]==403) {
       
       [self judgeAndSendDelegateWithDictionary:jsonDictionary type:YGHandlePushMessageType_ServerKickOff];
   }
   


    //==========================系统消息====================================================
     //type 1-IM官方消息 2-社交消息推送 3-满金店消息, 4-红包系统消息
    //subType 301-下单成功 302-支付成功 303-已发货 304-被分享人开店 305-店主获得收益

     
    else if ([api isEqualToString:@"SysNotify"]) {

        NSInteger type = [jsonDictionary[MESSAGEPROTOCOL_DATA][@"type"] integerValue];
        NSInteger subType = [jsonDictionary[MESSAGEPROTOCOL_DATA][@"subType"] integerValue];
        
        if (type == 3) {
            
            [self judgeAndSendDelegateWithDictionary:jsonDictionary type:subType];
        }
        
    }
    else if ([api isEqualToString:@"CustomerService"]) {    // 客服服务
        [self judgeAndSendDelegateWithDictionary:jsonDictionary type:YGHandlePushMessageType_CustomerService];
    }
    else {
         [self judgeAndSendDelegateWithDictionary:jsonDictionary type:YGHandlePushMessageType_Unknow];
    }

}

- (void)judgeAndSendDelegateWithDictionary:(NSDictionary*)dictionary type:(YGHandlePushMessageType)type {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(handlePushMessageJsonDictionary:withType:)]) {
//        [self.delegate handlePushMessageJsonDictionary:dictionary withType:type];
//    }
    if([[IMClient sharedClient].receiveMessageDelegate respondsToSelector:@selector(onReceived:PushMessageType:)]) {
        
        [[IMClient sharedClient].receiveMessageDelegate onReceived:dictionary PushMessageType:type];
        [self replyMessageToServerWithDictionary:dictionary];
    }
}

- (void)partHandleWithDictionary:(NSDictionary *)dictionary {

    NSDictionary *body = dictionary[MESSAGEPROTOCOL_DATA][@"body"];
    NSString *name = body[@"partName"];
    NSNumber *order = body[@"partOrder"];
    NSUInteger total = [body[@"partTotal"] unsignedIntegerValue];
    
    if (!name || !total) {
        return;
    }
    
    NSMutableDictionary *orderDict = self.partMap[name];
    if (orderDict) {
        orderDict[order] = dictionary;
    } else {
        orderDict = [NSMutableDictionary dictionaryWithDictionary:@{order:dictionary}];
        self.partMap[name] = orderDict;
    }
    
    if (orderDict.count == total) {
        
        NSMutableString *text = [NSMutableString new];
        for (long i = 0 ; i < total ; i++) {
            NSDictionary *json = orderDict[@(i)];
            [text appendString:json[@"data"][@"body"][@"text"]];
        }
        NSMutableDictionary *messageDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dictionary[@"data"]];
        NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:dictionary[@"data"][@"body"]];
        body[@"text"] = text;
        result[@"subType"] = @"txt";
        result[@"body"] = body;
        
        messageDic[@"data"] = result;
        [self handleJson:messageDic returnID:nil];
        [self.partMap removeObjectForKey:name];
        
    }
 
}


@end
