//
//  YGOfflineAPI.m
//  mobile
//
//  Created by jiangxincai on 15/12/8.
//  Copyright © 2015年 1yyg. All rights reserved.
//

#import "YGOfflineAPI.h"

@implementation YGOfflineAPI

- (id)analysisReturnDataWithDictionary:(NSDictionary *)dictionary{
    NSInteger code = [dictionary[@"code"] integerValue];
    if (code == 0) {
        
        return dictionary;
    }
    return [NSError errorWithDomain:dictionary[@"error"] code:code userInfo:nil];
    
}

/*
 74.    退出IM
 请求样例
 序号    参数
 1    api    Logout
 2    apiId    1074
 3    data    status: 0-离线（退出到后台）  1-退出应用
 unreadNum  未读消息数
 */
- (NSDictionary*)creatPackageDictionaryWithObject:(id)object{
    NSDictionary *dic = @{
                          @"api": @"Logout",
                          @"apiId": @"1074",
                          @"from": [IMClient sharedClient].userID,
                          @"to":@"",
                          @"id": self.randomID,
                          @"appName":[IMClient sharedClient].appName,
                          @"data":@{
                                  @"status":object[0],
                                  @"unreadNum":object[1]
                                  }
                          }
    ;
    return dic;
}

- (NSInteger)requestTimeOutTimeInterval {
    return 0;
}

@end

