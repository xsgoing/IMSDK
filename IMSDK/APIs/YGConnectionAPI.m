//
//  YGConnectionAPI.m
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGConnectionAPI.h"
#import "YGTimeUtils.h"

//#import "YGDataBaseManager.h"

@implementation YGConnectionAPI

//- (id)sendDataWithObject:(id)object {
//    id data = [super sendDataWithObject:object];
//    if ([data isKindOfClass:[NSError class]]) {
//        return data;
//    }
//    //登录加包 格式:时间戳,4位数版本,md5签名{json数据} md5签名(时间戳+密钥+4位数版本)
//    NSMutableData *returnData = [[NSMutableData alloc] initWithData:data];
//    //时间戳
//    NSString *timeString = [YGTimeUtils messageIDForSecond];
//    //签名
//    NSString *keyString = nil;
//    //版本号
//    NSString *versionStr = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
//    while (versionStr.length < 4) {
//        versionStr = [NSString stringWithFormat:@"0%@",versionStr];
//    }
//    if ([YGUtilities jugdeCurrentEvironment]==1) { //外网测试
//        keyString = IM_OutsideNetTestToken;
//    }else if ([YGUtilities jugdeCurrentEvironment]==2) { //正式
//        keyString = IM_OfficialToken;
//    }else {
//        //return returnData;
//        keyString = IM_LocalToken; //内网
//        versionStr = @"6666";
//    }
////    if (TARGET_YG == YGTargetVersionOutsideNetTest) {
////        keyString = IM_OutsideNetTestToken;
////    } else if (TARGET_YG == YGTargetVersionOfficial) {
////        keyString = IM_OfficialToken;
////    } else {
////        return returnData;
////    }
//    
//    //合并
//    NSString *MD5Str = [NSString stringWithFormat:@"%@%@",timeString,keyString];
//    //服务器标识
//    NSString *server = object[0];
//    if ([server length] != 8) {
//        server = @"000.0000";
//    }
//    MD5Str = [NSString stringWithFormat:@"%@%@",MD5Str,server];
//    NSString *requestString = [NSString stringWithFormat:@"%@,%@,%@,%@",timeString,versionStr,server,[MD5Str md5String]];
//
//    NSData *addData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
//    [returnData replaceBytesInRange:NSMakeRange(0, 0) withBytes:addData.bytes length:addData.length];
//    
//    return returnData;
//}

#pragma mark -

- (id)analysisReturnDataWithDictionary:(NSDictionary *)dictionary {
    NSInteger code = [dictionary[MESSAGEPROTOCOL_CODE] integerValue];
    if (code == 0) {
        return dictionary[@"data"][@"session"];
    } else {
        return [NSError errorWithDomain:dictionary[MESSAGEPROTOCOL_CODE] code:code userInfo:nil];
    }
    
    
//    NSInteger code = [dictionary[@"stream"][@"errorcode"] integerValue];
//    if (code > 0) {
//        return dictionary[@"stream"][@"session"];
//    } else {
//        return [NSError errorWithDomain:dictionary[@"stream"][@"session"] code:code userInfo:nil];
//    }
}

/**
 api    Connect
 apiId    1001
 data.deviceId    设备ID
 data. version    版本号
 data. time    当前时间
 */
- (NSDictionary*)creatPackageDictionaryWithObject:(id)object {
    NSString *time = nil;
    if ([UserDefaultsObj objectForKey:KUD_SystemMessageLastTime] != nil) {
        time = [YGTimeUtils getDateToStr:[UserDefaultsObj objectForKey:KUD_SystemMessageLastTime]];
    } else {
        time = [YGTimeUtils getDateToString:[NSDate date]];
    }
    
    NSDictionary *dic =  @{
                           @"api": @"Connect",
                           @"apiId": @"1001",
                           @"from": object[1],
                           @"to":@"",
                        @"appName":[IMClient sharedClient].appName,
                           @"id": self.randomID,
                           @"data": @{
                                   @"deviceId":object[2],
                                   @"version":@"1.0",
                                   @"time":time,
                                   
                                   }
                           };
    
    
    return dic;
}

- (NSString*)randomID{//此接口无id参数，复写get方法设置id为自定义id
    return NSStringFromClass([self class]);
}

- (NSInteger)requestTimeOutTimeInterval{
    return 15;
}

@end
