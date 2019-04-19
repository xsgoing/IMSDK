//
//  YGUserVerificationAPI.m
//  IM
//
//  Created by jiangxincai on 15/4/13.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGUserVerificationAPI.h"
#import "YGUtilities.h"
#import "IMUUID.h"
@implementation YGUserVerificationAPI

- (id)analysisReturnDataWithDictionary:(NSDictionary *)dictionary{
    NSInteger code = [dictionary[MESSAGEPROTOCOL_CODE] integerValue];
    if (code == 0) {
        return dictionary;
    } else {
        return [NSError errorWithDomain:dictionary[MESSAGEPROTOCOL_ERROR] code:code userInfo:nil];
    }
    
    return dictionary;
}

/**
 api    Auth
 apiId    1002
 data    mobile 用密码登录时为必填项
         password 用密码登录时为必填项
         ipArea  登录IP归属地
         ip 登录ip
         deviceModel 设备型号
         deviceOs  设备操作系统
         imei  设备标识
         idfa
         iosToken  ios令牌
         session  会话标识
         resourceType  设备类型
         imVersion im版本号
         keyVersion 过滤关键词版本号
         token 用短效串登录时为必填项
 */
- (NSDictionary*)creatPackageDictionaryWithObject:(id)object{
    NSDictionary *dic = @{
                          @"api": @"Auth",
                          @"apiId": @"1002",
                          @"from": [IMClient sharedClient].userID,
                          @"appName" : object[1],
                          @"to":@"",
                          @"id":self.randomID,
                          @"data": @{
                                  
                                  @"deviceID": [IMUUID getUUID],
                                  @"imei":[IMUUID getUUID],
                                  //                                  @"session":object[0],
                                  @"resourceType":@(3),//1. pc 2.android 3.ios
                                  @"userType":@(1), //0-IM用户 1-满金店用户 2-满金店客服
                                  @"keyVersion":@"0",
                                  @"token":object[0],
                                  @"iosToken":STR_IS_NULL([UserDefaultsObj objectForKey:@"DEVICE_TOKEN"])
                                  }
                          };
    return dic;
}

- (NSInteger)requestTimeOutTimeInterval{
    return 10;
}

@end
