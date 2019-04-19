//
//  YGTcpClientManager.h
//  IM
//
//  Created by jiangxincai on 15/4/10.
//  Copyright (c) 2015年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGCommon.h"
@class YGSuperAPI;

@interface YGSocketManager : NSObject

/**
 *  Socket连接状态
 */
@property (nonatomic, assign, readonly) BOOL isConnected;

+ (instancetype)sharedManager;

/**
 *  连接即时通讯服务器
 *
 *  @return 连接即时通讯服务器结果
 */
- (void)connectWithServerHost:(NSString *)host ServerPort:(NSString *)serverPort:(void(^)(BOOL object))result;

/**
 *  断开服务器连接
 */
- (void)disconnect:(ResultBlock)resultBlock;


/**
 *  将数据写入socket流
 *
 *  @param data 需要写入socket的数据
 */
- (void)sendData:(NSData*)data;
- (void)sendData:(NSData*)data withAPI:(YGSuperAPI *)api;


@end
