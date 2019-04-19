//
//  CustomerServiceAPI.m
//  IMKit
//
//  Created by Season on 2018/5/17.
//  Copyright © 2018年 Season. All rights reserved.
//

#import "CustomerServiceAPI.h"

@implementation CustomerServiceAPI
- (id)analysisReturnDataWithDictionary:(NSDictionary *)dictionary{
    NSInteger code = [dictionary[@"code"] integerValue];
    if (code == 0) {
        
        return dictionary;
    }
    return [NSError errorWithDomain:dictionary[@"error"] code:code userInfo:nil];
    
}

/*
 请求标识    id    yes    String    每个请求的唯一标识
 应用名称    appName    yes    String    MJD.IM
 API名称    apiName    yes    String    CustomerService
 API标识    apiId    yes    int    1075
 发送者    from    yes    String    发送者的用户ID
 接收者    to    yes    String    接收者的用户ID
 请求数据    data    yes    RequestData    请求业务数据
 
 RequestData
 消息类型    type    yes    String    1-发起请求 2-结束会话 3-客服端确认收到会话请求 4-用户端确认收到结束会话通知
 会话标识    sessionId    yes    String
 手机号    mobile    no    String    type=1时必填
 用户头像    photo    no    String    type=1时必填

 */
- (NSDictionary*)creatPackageDictionaryWithObject:(id)object{
    NSDictionary *dic = @{
                          @"api": @"CustomService",
                          @"apiId": @"1075",
                          @"from": [IMClient sharedClient].userID,
                          @"to":object[0],
                          @"id": self.randomID,
                          @"appName":[IMClient sharedClient].appName,
                          @"data":@{
                                  @"sessionId":object[1],
                                  @"mobile":object[2],
                                  @"photo":object[3],
                                  @"type":object[4]
                                  }
                          }
    ;
    return dic;
}

- (NSInteger)requestTimeOutTimeInterval {
    return 10;
}
@end
