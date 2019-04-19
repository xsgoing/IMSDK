
//  YGSuperApi.m
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGSuperAPI.h"
#import "YGAPIHandleManager.h"
#import "IMClient.h"
#import "YGSocketManager.h"

#import "YGTimeUtils.h"
#import "YGUtilities.h"
#import "YGSocketOutputSteam.h"

@implementation YGSuperAPI

- (void)dealloc {
    self.completion = nil;
    self.randomID = nil;
    self.saveData = nil;
    self.delegate = nil;
}

#pragma mark - Public

- (void)requestWithObject:(id)object completion:(RequestCompletion)completion {
    @autoreleasepool {
        //保存完成块
        self.completion = completion;
        
        id returnObject = [self sendDataWithObject:object];
        
        if ([returnObject isKindOfClass:[NSError class]]) {
            completion(nil,returnObject);
        } else {
            //保存发送数据
            self.saveData = returnObject;
            self.retryNumbers = 0;
            //发送
            [[YGSocketManager sharedManager] sendData:returnObject withAPI:self];
        }
    }
}

- (void)requestWithObject:(id)object delegate:(id<YGAPIDelegate>)delegate {
    self.delegate = delegate;
    
    id returnObject = [self sendDataWithObject:object];
    
    if ([returnObject isKindOfClass:[NSError class]]) {
        [delegate api:self didReceiveResponse:nil error:returnObject];
    } else {
        //保存发送数据
        self.saveData = returnObject;
        self.retryNumbers = 0;
        //发送
        [[YGSocketManager sharedManager] sendData:returnObject withAPI:self];
    }
}

- (void)retrySendData{
    self.retryNumbers++;
    [[YGSocketManager sharedManager] sendData:self.saveData withAPI:self];
    NSLog(@"接口:%@第%@次重发数据:\n",NSStringFromClass([self class]),@(self.retryNumbers));
}

- (void)callBackWithError:(NSError *)error {
    dispatch_main_async(^{
        if (self.completion) {
            self.completion(nil,error);
        } else {
            [self.delegate api:self didReceiveResponse:nil error:error];
        }
    });
}

+ (NSError*)judgeRequestErrorWithString:(NSString*)string{
    if ([string isEqualToString:@"error"]) {
        NSError *error = [NSError errorWithDomain:TCPAPI_ERROR_FAILURE code:TCPAPIErrorCodeRequestFailure userInfo:nil];
        return error;
    }
    return nil;
}

+ (void)requestWithObject:(id)object completion:(RequestCompletion)completion{
    id api = [[NSClassFromString(NSStringFromClass([self class])) alloc] init];
    [api requestWithObject:object completion:^(id response, NSError *error) {
        if (completion) {
            completion(response,error);
        }
    }];
}

#pragma mark - 子类方法

- (id)sendDataWithObject:(id)object {
    if (![YGSocketManager sharedManager].isConnected) {
        if (![IMReachabilityManager sharedManager].isReachable) {
            return [NSError errorWithDomain:TCPAPI_ERROR_DISCONNECT code:TCPAPIErrorCodeNOconnect userInfo:nil];
        } else {
            return [NSError errorWithDomain:TCPAPI_ERROR_SERVERNNOCONNECT code:TCPAPIErrorCodeServerNOConnect userInfo:nil];
        }
    }
//    if (!([self isKindOfClass:[YGConnectionAPI class]] || [self isKindOfClass:[YGUserVerificationAPI class]])) {
        //        if (![YGCheckUpdate sharedYGCheckUpdate].imSwitch) {
        //            return [NSError errorWithDomain:TCPAPI_ERROR_IMCLOSE code:TCPAPIErrorCodeIMClose userInfo:nil];
        //        }
        //        if (![YGTCPUserManager sharedManager].userJID) {
        //            return [NSError errorWithDomain:TCPAPI_ERROR_NOCONNECT code:TCPAPIErrorCodeNOconnect userInfo:nil];
        //        }
//    }
    
    //随机ID
    self.randomID = [YGUtilities randomID];
    //数据打包
    NSDictionary *package = [self creatPackageDictionaryWithObject:object];
    if ([self isNeedPartPackage]) {
//        package = [self addPartTextWithPackageDictionary:package];
    }
    
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:package options:NSJSONWritingPrettyPrinted error:&error];

    //判断打包是否成功，失败为参数为nil或者不是字符串
    if (!package || error || !requestData) {//
        error = [NSError errorWithDomain:TCPAPI_ERROR_PACKAGE code:TCPAPIErrorCodeRequestPackage userInfo:nil];
    }
    
    if (error) {
        return error;
    }
    YGSocketOutputSteam *outputSteam = [[YGSocketOutputSteam alloc] initWithData:requestData];
    return [outputSteam socketSendData];
}

#pragma mark - YGAPIProtocol

- (id)analysisReturnDataWithDictionary:(NSDictionary*)dictionary{
    self.isCompletion = YES;
    return dictionary;
}

- (NSDictionary*)creatPackageDictionaryWithObject:(id)object{
    self.isCompletion = NO;
    return object;
}

- (NSInteger)requestTimeOutTimeInterval{
    return 10;
}

- (NSInteger)numberOfTimeOutRetries{
    return 0;
}

- (BOOL)isNeedPartPackage {
    return NO;
}

- (NSDictionary *)addPartTextWithPackageDictionary:(NSDictionary *)dictionary {
    NSString *key = [dictionary allKeys][0];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary[key]];
    dict[@"part_name"] = [self partName];
    dict[@"part_order"] = @([self partOrder]).stringValue;
    dict[@"part_total"] = @([self partTotal]).stringValue;
    return @{key:dict};
}

+ (NSString *)className {
    
    return NSStringFromClass([self class]);
}
@end
