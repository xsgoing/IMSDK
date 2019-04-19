//
//  YGClientStateManager.h
//  mobile
//
//  Created by jiangxincai on 15/12/21.
//  Copyright © 2015年 1yyg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户状态
 */
typedef NS_ENUM(NSUInteger, YGUserState){
    YGUserOffLine = 0,//用户离线
    YGUserLogining,//用户正在连接
    YGUserOnline,//用户在线
    YGUserKickout,//用户被挤下线
    YGUserOffLineInitiative,//用户主动下线
    YGUserOffLineBackground,//用户退到后台
    YGUserBeDisconnect,//用户被断开连接
    YGUserTcpConnectUnLogin,//用户tcp连接 但是未登录
};

@interface YGClientStateManager : NSObject

/**
 *  重连次数
 */
@property (nonatomic, assign) NSInteger reconnectCount;

/**
 *  当前登录用户的状态
 */
@property (nonatomic,assign) YGUserState userState;

+ (instancetype)sharedManager;

@end
