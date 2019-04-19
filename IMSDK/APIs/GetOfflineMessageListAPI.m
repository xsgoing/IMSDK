//
//  GetOfflineMessageListAPI.m
//  Manjinba
// 获取离线消息
//  Created by Season on 2017/12/1.
//  Copyright © 2017年 com.manjinba.im. All rights reserved.
//

#import "GetOfflineMessageListAPI.h"

@implementation GetOfflineMessageListAPI


- (id)analysisReturnDataWithDictionary:(NSDictionary *)dictionary {
    
    return dictionary;
}

//api    GetOfflineMessageList
//apiId    1030
/*
 data.time: 消息起始时间(首次传空值)
 data.count: 每次获取记录条数
 data.devType: 设备类型 1-pc 2-android 3 -ios"
 */
- (NSDictionary *)creatPackageDictionaryWithObject:(id)object {
    
    NSDictionary *dic = @{ @"api":@"GetOfflineMessageList",
                           @"apiId":@"1030",
                           @"from": [IMClient sharedClient].userID,
                           @"to": @"",
                           @"id": self.randomID,
                           @"appName":[IMClient sharedClient].appName,
                           @"data":@{
                                   @"time":object[0],
                                   @"count":object[1],
                                   @"devType":@(3)
                                   }
                           };
    return dic;
}
@end
