//
//  YGSendMessageChatAPI.h
//  IM
//
//  Created by jiangxincai on 15/4/15.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import "YGSuperAPI.h"
#import "YGChatConstant.h"

@class IMMessage;


/**
 *  发送聊天消息接口
 */
@interface YGSendMessageChatAPI : YGSuperAPI

@property (strong, nonatomic) NSString *messageID;
@property (nonatomic, strong) IMMessage *message;

@property (nonatomic, strong) NSDate *returnTime;

@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, copy) NSString *appName;

@end
