//
//  YGConfirmMessageAPI.m
//  IM
//
//  Created by jiangxincai on 15/4/17.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGConfirmMessageAPI.h"
#import "IMClient.h"
@implementation YGConfirmMessageAPI

- (id)analysisReturnDataWithDictionary:(NSDictionary *)dictionary{
    return dictionary;
}
/*
 api    MessageConfirm
 apiId    1045
 */
- (NSDictionary*)creatPackageDictionaryWithObject:(id)object{
    self.randomID = object[0];
    NSDictionary *dic = @{
                          @"api":@"MessageConfirm",
                          @"apiId":@"1045",
                          @"from":[IMClient sharedClient].userID?:@"",
                          @"id":object[0],
                          @"to":@"",
                          @"appName":[IMClient sharedClient].appName
                          };
    return dic;
}

- (NSInteger)requestTimeOutTimeInterval {
    return 0;
    
}

@end
